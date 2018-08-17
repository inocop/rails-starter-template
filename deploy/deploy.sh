#!/bin/bash

set -eux

BRANCH=master
REPOSITORY=http://xxx/yyy.git

REMOTE_USER=xxx
REMOTE_SERVER=aaa.bbb.ccc.ddd
SECRET_KEY=/z/keystore

git clone --depth 1 --single-branch -b $BRANCH $REPOSITORY rails_app
rm -rf rails_app/.git
tar -zcvf rails_app.tar.gz rails_app

scp -i ${SECRET_KEY} rails_app.tar.gz ${REMOTE_USER}@${REMOTE_SERVER}:/tmp/
ssh -i ${SECRET_KEY} ${REMOTE_USER}@${REMOTE_SERVER} bash -s < update_app.sh

rm -f rails_app.tar.gz
