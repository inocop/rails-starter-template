#!/usr/bin/env bash

set -eux
cd `dirname $0`
source ./config


# 前処理
rm -rf my_app \
       my_app.tar.gz


git clone --depth 1 --single-branch -b $BRANCH $REPOSITORY my_app
rm -rf my_app/.git \
       my_app/deploy


# 本番用のmyconf.ymlをセット
cp $MYCONF_YML my_app/source/rails_app/config/myconf.yml


# 所有者情報を含まないtar.gzを作成して転送
tar -zcvf my_app.tar.gz --no-same-owner --no-same-permissions my_app
scp -i ${SECRET_KEY} my_app.tar.gz ${REMOTE_USER}@${REMOTE_SERVER}:/tmp/


# $1が未定義の場合の対応
set +u
# デプロイ
ssh -i ${SECRET_KEY} ${REMOTE_USER}@${REMOTE_SERVER} \
       OPTION="$1" \
       bash < update_app.sh