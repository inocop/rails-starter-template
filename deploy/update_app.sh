#!/usr/bin/env bash

#sudo su
set -eux


############################
#  変数定義                #
############################
DEPLOY_DIR=/release
DOCKER_APP_DIR=/var/www/app


declare -A SHARED_DIRS
SHARED_DIRS["tmp"]="../shared"
SHARED_DIRS["log"]="../shared"
SHARED_DIRS["vendor"]="../shared"
SHARED_DIRS["public/node_modules"]="../../shared"


############################
# docker exec用の関数      #
############################
function docker_exec() {
  sudo docker exec rails_prd_web_1 bash -l -c "$1"
}


############################
# deployフォルダ           #
############################
mkdir -p ${DEPLOY_DIR}/source/rails_app
mkdir -p ${DEPLOY_DIR}/source/shared
mkdir -p ${DEPLOY_DIR}/docker
sudo chown -R 1000:1000 ${DEPLOY_DIR}
sudo chmod 2755 ${DEPLOY_DIR}


############################
# 前回のフォルダ削除       #
############################
rm -rf /tmp/my_app \
       ${DEPLOY_DIR}/source/deploying \
       ${DEPLOY_DIR}/docker


############################
# my_app.tar.gzを展開      #
############################
tar -zxf /tmp/my_app.tar.gz -C /tmp
sudo chown -R 1000:1000 /tmp/my_app

# マイグレーション等が完了するまでdeployingに展開
mv /tmp/my_app/source/rails_app ${DEPLOY_DIR}/source/deploying
mv /tmp/my_app/docker           ${DEPLOY_DIR}/docker

# sharedフォルダへのシンボリックリンクを設定
for key in "${!SHARED_DIRS[@]}"; do
  mkdir -p   ${DEPLOY_DIR}/source/shared/${key}
  rm    -rf  ${DEPLOY_DIR}/source/deploying/${key}
  ln    -snf ${SHARED_DIRS[$key]}/${key} ${DEPLOY_DIR}/source/deploying/${key}
done


############################
#  dockeビルド(オプション)  #
############################
if [ $OPTION = "docker" ]; then
  pushd ${DEPLOY_DIR}/docker/rails_prd/
    sudo docker-compose build
    sudo docker-compose up --no-start
  popd
fi


############################
#  gem、npmの更新          #
############################
docker_exec "cd ${DOCKER_APP_DIR}/deploying/public && npm    install"
docker_exec "cd ${DOCKER_APP_DIR}/deploying        && bundle install"


############################
#  テスト実行               #
############################
docker_exec "cd ${DOCKER_APP_DIR}/deploying && bin/rails db:migrate RAILS_ENV=test"
docker_exec "cd ${DOCKER_APP_DIR}/deploying && bin/rails test"


############################
#  DBマイグレーション       #
############################
docker_exec "cd ${DOCKER_APP_DIR}/deploying && bin/rails db:migrate RAILS_ENV=production"


############################
#  source切り替え          #
############################
mv ${DEPLOY_DIR}/source/rails_app ${DEPLOY_DIR}/source/rails_app_$(date +%Y%m%d_%H%M%S)
mv ${DEPLOY_DIR}/source/deploying ${DEPLOY_DIR}/source/rails_app


############################
#  passenger再起動         #
############################
#docker_exec "passenger-config restart-app ${DOCKER_APP_DIR}/rails_app"
pushd ${DEPLOY_DIR}/docker/rails_prd/
  sudo docker-compose restart
popd

#############################
#  sourceを5世代分残して削除  #
#############################
pushd ${DEPLOY_DIR}/source
  ls | grep rails_app_ | head -n -5 | xargs rm -rf
popd

set +x
echo "Successfully deployed"