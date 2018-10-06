#!/usr/bin/env bash

set -eux
cd `dirname $0`
source ./config


# 前処理
rm -rf rails_app \
       rails_app.tar.gz


git clone --depth 1 --single-branch -b $BRANCH $REPOSITORY rails_app
rm -rf rails_app/.git \
       rails_app/deploy


# 本番用のmyconf.ymlをセット
cp $MYCONF_YML rails_app/source/current/config/myconf.yml


# 所有者情報を含まないtar.gzを作成して転送
tar -zcvf rails_app.tar.gz --no-same-owner --no-same-permissions rails_app
scp -i ${SECRET_KEY} rails_app.tar.gz ${REMOTE_USER}@${REMOTE_SERVER}:/tmp/


# デプロイ
ssh -i ${SECRET_KEY} ${REMOTE_USER}@${REMOTE_SERVER} \
       OPTION=$1 \
       bash < update_app.sh