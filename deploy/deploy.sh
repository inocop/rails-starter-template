#!/bin/bash

set -eux

source ./config

git clone --depth 1 --single-branch -b $BRANCH $REPOSITORY rails_app
# .gitとdeployフォルダは不要なので削除
rm -rf rails_app/.git deploy

# tar.gzに圧縮して転送
tar -zcvf rails_app.tar.gz rails_app
scp -i ${SECRET_KEY} rails_app.tar.gz ${REMOTE_USER}@${REMOTE_SERVER}:/tmp/

# デプロイタスクのshellをsshで流し込み
ssh -i ${SECRET_KEY} ${REMOTE_USER}@${REMOTE_SERVER} bash -s < update_app.sh

# 後処理のファイル削除
rm -f rails_app.tar.gz
