#!/usr/bin/env bash

set -eux

############################
#  変数定義                #
############################
# リリース用ディレクトリ指定
RELEASE_DIR=/release
APP_NAME=app

APP_DIR=${RELEASE_DIR}/${APP_NAME}
SHARED_DIR=${RELEASE_DIR}/shared

# デプロイ用の一時ディレクトリ
DEPLOY_DIR=/release/deploy

# ホスト、コンテナの両方でシンボリックリンクが効くように相対パス指定
declare -A LINK_DIRS
LINK_DIRS["rails_app/tmp"]="../../shared"
LINK_DIRS["rails_app/log"]="../../shared"
LINK_DIRS["rails_app/vendor"]="../../shared"
LINK_DIRS["rails_app/public/node_modules"]="../../../shared"
LINK_DIRS["node_app/node_modules"]="../../shared"


############################
# docker exec用の関数      #
############################
function docker_exec() {
  sudo docker exec rails_prd_web_1 bash -l -c "$1"
}


############################
#  前処理                   #
############################
# 前回のデプロイデータがあれば削除
sudo rm -rf ${DEPLOY_DIR}

# ディレクトリ作成
sudo mkdir -p ${SHARED_DIR}
sudo mkdir -p ${DEPLOY_DIR}

# app.tar.gzをデプロイ用ディレクトリに展開
sudo tar -zxf /tmp/app.tar.gz -C ${DEPLOY_DIR} --strip-components 1

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
if [ "$OPTION" = "first" ]; then
  sudo chown -R 1000:1000 ${RELEASE_DIR}
  rm -rf ${APP_DIR}
  mv ${DEPLOY_DIR} ${APP_DIR}

  cd ${APP_DIR}/docker/rails_prd/
  sudo docker-compose up -d --build
  docker_exec "bash /var/my_dir/app/setup.sh production"
  echo "Successfully first deployed"
  exit # 初回デプロイはここで終了
fi


############################
#  gem、npmの更新           #
############################
docker_exec "cd /var/my_dir/deploy/rails_app \
             && su -s /bin/bash railsdev -c \"npm install --prefix ./public\" \
             && su -s /bin/bash railsdev -c \"bundle install\""

docker_exec "cd /var/my_dir/deploy/node_app \
             && su -s /bin/bash railsdev -c \"npm install\""


############################
#  テスト実行               #
############################
docker_exec "cd /var/my_dir/deploy/rails_app \
             && bin/rails db:migrate RAILS_ENV=test"
             #&& bin/rails test:system test


############################
#  DBマイグレーション       #
############################
docker_exec "cd /var/my_dir/deploy/rails_app \
             && bin/rails db:migrate RAILS_ENV=production"


############################
#  app切り替え             #
############################
mv ${APP_DIR}    ${APP_DIR}_$(date +%Y%m%d_%H%M%S)
mv ${DEPLOY_DIR} ${APP_DIR}


############################
#  再起動                  #
############################
if [ "$OPTION" = "build" ]; then
  pushd ${APP_DIR}/docker/rails_prd/
    sudo docker image prune -f # 不要なimageを削除
    sudo docker-compose build
    sudo docker-compose restart
  popd
else
  docker_exec "passenger-config restart-app /var/my_dir/app/rails_app \
               && systemctl reload delayed_job"
fi


#############################
#  sourceを5世代分残して削除  #
#############################
pushd ${RELEASE_DIR}
  ls | grep ${APP_NAME}_ | head -n -5 | xargs rm -rf
popd

set +x
echo "Successfully deployed"
