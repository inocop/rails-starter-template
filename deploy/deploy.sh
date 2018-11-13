#!/usr/bin/env bash

set -eux
cd `dirname $0`

# configをロード
source ./config

# 前処理
rm -rf src app.tar.gz

# ソースコードclone
git clone --depth 1 --single-branch -b $BRANCH $REPOSITORY src

# 本番用のmyconf.ymlをセット
cp $MYCONF_YML src/app/rails_app/config/myconf.yml

# 所有者情報を含まないtar.gzを作成して転送
tar -zcvf app.tar.gz --no-same-owner --no-same-permissions -C src app
scp -i ${SECRET_KEY} app.tar.gz ${REMOTE_USER}@${REMOTE_SERVER}:/tmp/

# デプロイ
set +u
ssh -i ${SECRET_KEY} ${REMOTE_USER}@${REMOTE_SERVER} \
       OPTION="$1" \
       bash < update_app.sh
