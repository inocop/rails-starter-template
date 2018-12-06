#!/usr/bin/env bash

set -eux

############################
#  変数定義                #
############################
SOURCE_DIR_NAME="source"

# リリースディレクトリ
RELEASE_DIR="/release/${SOURCE_DIR_NAME}"
# 共有ディレクトリ
SHARED_DIR="/release/shared"
# デプロイ用の一時ディレクトリ
DEPLOY_DIR="/release/deploy"
# コンテナ内のRails.root
DOCKER_RAILS_ROOT="/var/www/app/${SOURCE_DIR_NAME}/rails_app"


# ホスト、コンテナの両方でシンボリックリンクが効くように相対パス指定
declare -A LINK_DIRS
LINK_DIRS["rails_app/tmp"]="../../shared"
LINK_DIRS["rails_app/log"]="../../shared"
LINK_DIRS["rails_app/vendor"]="../../shared"
LINK_DIRS["rails_app/public/node_modules"]="../../../shared"
LINK_DIRS["rails_app/lib/nodejs/node_modules"]="../../../../shared"


############################
# docker_cmd用の関数      #
############################
function docker_cmd() {
  if [ "$1" = "exec" ]; then
    WEB_CONTAINER_ID=`sudo docker ps -f name=rails_prd_web_1 -q`
    sudo docker exec $WEB_CONTAINER_ID bash -c "$2"
  elif [ "$1" = "build" ]; then
    pushd ${RELEASE_DIR}/docker/rails_prd/
      sudo docker image prune -f # 不要なimageを削除
      sudo docker-compose up -d --build
    popd
  else
    exit
  fi
}

############################
#  前処理                   #
############################
# 前回のデプロイデータがあれば削除
sudo rm -rf ${DEPLOY_DIR}

# ディレクトリ作成
sudo mkdir -p ${RELEASE_DIR}
sudo mkdir -p ${SHARED_DIR}
sudo mkdir -p ${DEPLOY_DIR}

# source.tar.gzをデプロイ用ディレクトリに展開
sudo tar -zxf /tmp/source.tar.gz -C ${DEPLOY_DIR} --strip-components 1

# sharedディレクトリにシンボリックリンクを設定
for key in "${!LINK_DIRS[@]}"; do
  sudo rm    -rf  ${DEPLOY_DIR}/${key} # 既存フォルダを削除
  sudo mkdir -p   ${SHARED_DIR}/${key}
  sudo ln    -snf ${LINK_DIRS[$key]}/${key} ${DEPLOY_DIR}/${key}
done

sudo chown -R 1000:1000 ${DEPLOY_DIR}
sudo chown -R 1000:1000 ${SHARED_DIR}


############################
#  初回デプロイ             #
############################
if [ "$OPTION" = "init" ]; then
  sudo chown -R 1000:1000 ${RELEASE_DIR}/../
  rm -rf ${RELEASE_DIR}
  mv ${DEPLOY_DIR} ${RELEASE_DIR}

  docker_cmd "build"
  docker_cmd "exec" "bash ${DOCKER_RAILS_ROOT}/../setup.sh production"
  echo "Successfully init deployed"
  exit # 初回デプロイはここで終了
fi


############################
#  コンテナ内処理           #
############################
# gem、npmの更新
docker_cmd "exec" "cd ${DOCKER_RAILS_ROOT} \
                   && su -s /bin/bash railsdev -c \"npm install --prefix ./lib/nodejs\" \
                   && su -s /bin/bash railsdev -c \"npm install --prefix ./public\" \
                   && su -s /bin/bash railsdev -c \"bundle install\""

# テスト実行
docker_cmd "exec" "cd ${DOCKER_RAILS_ROOT} \
                   && bin/rails db:migrate RAILS_ENV=test"
                    #&& bin/rails test:system test

#  DBマイグレーション
docker_cmd "exec" "cd ${DOCKER_RAILS_ROOT} \
                   && bin/rails db:migrate RAILS_ENV=production"


############################
#  source切り替え           #
############################
mv ${RELEASE_DIR} ${RELEASE_DIR}_$(date +%Y%m%d_%H%M%S)
mv ${DEPLOY_DIR}  ${RELEASE_DIR}


############################
#  再起動                  #
############################
if [ "$OPTION" = "build" ]; then
  docker_cmd "build"
else
  docker_cmd "exec" "passenger-config restart-app ${DOCKER_RAILS_ROOT} \
                     && systemctl reload delayed_job"
fi


#############################
#  sourceを5世代分残して削除  #
#############################
pushd ${RELEASE_DIR}/../
  ls | grep ${SOURCE_DIR_NAME}_ | head -n -5 | xargs rm -rf
popd


echo "Successfully deployed"
