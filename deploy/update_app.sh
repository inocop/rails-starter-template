#!/usr/bin/env bash

set -eux

############################
#  変数定義                #
############################
RELEASE_ROOT="/release"

RELEASE_DIR="${RELEASE_ROOT}/source"  # リリースディレクトリ
SHARED_DIR="${RELEASE_ROOT}/shared"   # 共有ディレクトリ
DEPLOY_DIR="${RELEASE_ROOT}/deploy"   # デプロイ用ディレクトリ

# Dockerコンテナ内のディレクトリ
DOCKER_DEPLOY_DIR="/var/www/app/deploy/rails_app"
DOCKER_RELEASE_DIR="/var/www/app/source/rails_app"

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
      sudo docker image prune -f  # 不要なimageを削除
      sudo bash -c "MY_DOMAIN=${MY_DOMAIN} docker-compose up -d --build"
    popd
  else
    exit
  fi
}

############################
#  前処理                  #
############################
# ディレクトリ作成
sudo mkdir -p ${RELEASE_DIR}
sudo mkdir -p ${SHARED_DIR}
sudo mkdir -p ${DEPLOY_DIR}

# source.tar.gzをデプロイ用ディレクトリに展開
sudo rm -rf ${DEPLOY_DIR}/*
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
  sudo chown -R 1000:1000 ${RELEASE_ROOT}
  sudo rm -rf           ${RELEASE_DIR}
  sudo mv ${DEPLOY_DIR} ${RELEASE_DIR}

  docker_cmd "build"
  docker_cmd "exec" "bash /var/www/app/source/setup.sh production"
  echo "Successfully init deployed"
  exit # 初回デプロイはここで終了
fi


############################
#  コンテナ内処理           #
############################
# gem、npmの更新
docker_cmd "exec" "cd ${DOCKER_DEPLOY_DIR} \
                   && su -s /bin/bash railsdev -c \"npm install --prefix ./lib/nodejs\" \
                   && su -s /bin/bash railsdev -c \"npm install --prefix ./public\" \
                   && su -s /bin/bash railsdev -c \"bundle install\""
# テスト実行
docker_cmd "exec" "cd ${DOCKER_DEPLOY_DIR} \
                   && RAILS_ENV=test  bin/rails db:migrate"
                    #&& bin/rails test:system test
#  DBマイグレーション
docker_cmd "exec" "cd ${DOCKER_DEPLOY_DIR} \
                   && RAILS_ENV=production  bin/rails db:migrate"
# cron設定
docker_cmd "exec" "cd ${DOCKER_DEPLOY_DIR} \
                   &&  RAILS_ENV=production  bundle exec whenever --update-crontab"


############################
#  source切り替え           #
############################
sudo mv ${RELEASE_DIR} ${RELEASE_DIR}_$(date +%Y%m%d_%H%M%S)
sudo mv ${DEPLOY_DIR}  ${RELEASE_DIR}


############################
#  再起動                  #
############################
if [ "$OPTION" = "build" ]; then
  docker_cmd "build"
else
  docker_cmd "exec" "passenger-config restart-app ${DOCKER_RELEASE_DIR} \
                     && systemctl reload delayed_job"
fi


#############################
#  sourceを5世代分残して削除  #
#############################
pushd ${RELEASE_ROOT}
  ls | grep source_ | head -n -5 | xargs sudo rm -rf
popd

echo "Successfully deployed"
