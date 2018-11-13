#!/usr/bin/env bash

set -eux

############################
#  変数定義                #
############################
# リリース用ディレクトリ
RELEASE_DIR=/release/app
SHARED_DIR=/release/shared

# デプロイ用の一時ディレクトリ
DEPLOY_DIR=/release/deploy
DOCKER_DEPLOY_DIR=/var/my_dir/deploy

# コンテナ内でもシンボリックリンクが効くように相対パスで指定する
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
# ディレクトリ作成
sudo mkdir -p ${RELEASE_DIR}
sudo mkdir -p ${SHARED_DIR}
sudo mkdir -p ${DEPLOY_DIR}

# 前回のデプロイデータがあれば削除
sudo rm -rf ${DEPLOY_DIR}/*

# app.tar.gzを一時ディレクトリにに展開
sudo tar -zxf /tmp/app.tar.gz -C ${DEPLOY_DIR} --strip-components 1

# sharedディレクトリにシンボリックリンクを設定
for key in "${!LINK_DIRS[@]}"; do
  sudo rm    -rf  ${DEPLOY_DIR}/${key} # 既存フォルダを削除

  sudo mkdir -p   ${SHARED_DIR}/${key}
  sudo ln    -snf ${LINK_DIRS[$key]}/${key} ${DEPLOY_DIR}/${key}
done

# パーミッション変更
sudo chown -R 1000:1000 ${RELEASE_DIR}/../


############################
#  dockeビルド             #
############################
pushd ${DEPLOY_DIR}/docker/rails_prd/
  sudo docker image prune -f # 不要なimageを削除
  sudo docker-compose build
popd


############################
#  初回デプロイ             #
############################
if [ "$OPTION" = "first" ]; then
  rm -rf ${RELEASE_DIR}
  mv ${DEPLOY_DIR} ${RELEASE_DIR}

  cd ${RELEASE_DIR}/docker/rails_prd/
  sudo docker-compose up -d
  docker_exec "bash /var/my_dir/app/setup.sh production"

  sudo chown -R 1000:1000 ${RELEASE_DIR}/../
  echo "Successfully first deployed"
  exit # 初回デプロイはここで終了
fi


############################
#  gem、npmの更新           #
############################
docker_exec "cd ${DOCKER_DEPLOY_DIR}/rails_app \
             && npm install --prefix ./public \
             && bundle install"

docker_exec "cd ${DOCKER_DEPLOY_DIR}/node_app \
             && npm install"


############################
#  テスト実行               #
############################
docker_exec "cd ${DOCKER_DEPLOY_DIR}/rails_app \
             && bin/rails db:migrate RAILS_ENV=test"
             #&& bin/rails test


############################
#  DBマイグレーション       #
############################
docker_exec "cd ${DOCKER_DEPLOY_DIR}/rails_app \
             && bin/rails db:migrate RAILS_ENV=production"


############################
#  app切り替え             #
############################
mv ${RELEASE_DIR} ${RELEASE_DIR}_$(date +%Y%m%d_%H%M%S)
mv ${DEPLOY_DIR}  ${RELEASE_DIR}


############################
#  docker再起動            #
############################
pushd ${RELEASE_DIR}/docker/rails_prd/
  sudo docker-compose restart
popd


#############################
#  sourceを5世代分残して削除  #
#############################
pushd ${RELEASE_DIR}/../
  ls | grep app_ | head -n -5 | xargs rm -rf
popd

set +x
echo "Successfully deployed"
