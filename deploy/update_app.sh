#sudo su
set -eux


############################
#  変数定義                #
############################
APP_DIR=/home/railsdev/rails_app

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
mkdir -p ${APP_DIR}/source/current
mkdir -p ${APP_DIR}/source/shared
mkdir -p ${APP_DIR}/docker


############################
# rails_app.tar.gzを展開   #
############################
rm -rf /tmp/rails_app \
       ${APP_DIR}/source/deploying \
       ${APP_DIR}/docker

tar -zxf /tmp/rails_app.tar.gz -C /tmp
sudo chown -R railsdev:railsdev /tmp/rails_app

# sourceはマイグレーション等が完了するまでdeployingに展開
mv /tmp/rails_app/source/current ${APP_DIR}/source/deploying
mv /tmp/rails_app/docker         ${APP_DIR}/docker

# sharedフォルダへのシンボリックリンクを設定
for key in "${!SHARED_DIRS[@]}"; do
  mkdir -p   ${APP_DIR}/source/shared/${key}
  rm    -rf  ${APP_DIR}/source/deploying/${key}
  ln    -snf ${SHARED_DIRS[$key]}/${key} ${APP_DIR}/source/deploying/${key}
done


############################
#  dockeビルド(オプション)  #
############################
if [ $OPTION = "docker" ]; then
  pushd ${APP_DIR}/docker/rails_prd/
    sudo docker-compose build
    sudo docker-compose up -d
  popd
fi


############################
#  gem、npmの更新          #
############################
docker_exec 'cd /var/rails_app/deploying/public && npm    install'
docker_exec 'cd /var/rails_app/deploying        && bundle install'


############################
#  テスト実行               #
############################
docker_exec 'cd /var/rails_app/deploying && bin/rails db:migrate RAILS_ENV=test'
docker_exec 'cd /var/rails_app/deploying && bin/rails test'


############################
#  DBマイグレーション       #
############################
docker_exec 'cd /var/rails_app/deploying && bin/rails db:migrate RAILS_ENV=production'


############################
#  source切り替え          #
############################
mv ${APP_DIR}/source/current   ${APP_DIR}/source/release_$(date +%Y%m%d_%H%M%S)
mv ${APP_DIR}/source/deploying ${APP_DIR}/source/current


############################
#  passenger再起動         #
############################
docker_exec 'passenger-config restart-app /var/rails_app/current'


#############################
#  sourceを5世代分残して削除  #
#############################
pushd ${APP_DIR}/source
  ls | grep release_ | head -n -5 | xargs rm -rf
popd

set +x
echo "Successfully deployed"