#!/usr/bin/env bash

set -eux
cd $(dirname $0)


MYCONF_YML="../../rails_app/config/myconf.yml"
if [ ! -f $MYCONF_YML ]; then
  cp "${MYCONF_YML}.sample" $MYCONF_YML
fi


docker-compose build
docker-compose up -d
docker-compose exec web bash -c 'bash /var/www/app/source/setup.sh'
