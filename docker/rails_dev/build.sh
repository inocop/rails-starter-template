#!/usr/bin/env bash

set -eux
cd $(dirname $0)


MYCONF_YML="../../source/rails_app/config/myconf.yml"
if [ ! -f $MYCONF_YML ]; then
  cp "${MYCONF_YML}.sample" $MYCONF_YML
fi


docker-compose build
docker-compose up -d
docker exec -it rails_dev_web_1 bash setup.sh
