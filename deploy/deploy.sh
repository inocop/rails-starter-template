#!/usr/bin/env bash

set -eux
cd `dirname $0`

# configをロード
source ./config

# 前処理
rm -rf repository \
       source.tar.gz

# ソースコードclone
git clone --depth 1 --single-branch -b $BRANCH $REPOSITORY repository

# 本番用のmyconf.ymlをセット
cp $MYCONF_YML repository/source/rails_app/config/myconf.yml

# repository/sourceを所有者情報を含めずにtar.gzにして転送
tar -zcvf source.tar.gz --no-same-owner --no-same-permissions -C repository 'source'
scp -i ${SECRET_KEY} source.tar.gz ${REMOTE_USER}@${REMOTE_SERVER}:/tmp/

# デプロイ
set +u
ssh -i ${SECRET_KEY} ${REMOTE_USER}@${REMOTE_SERVER} \
       OPTION="$1" MY_DOMAIN="$REMOTE_SERVER" bash < update_app.sh
