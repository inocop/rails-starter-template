#!/usr/bin/env bash

set -eux
cd $(dirname $0)

cp -i ../../source/current/config/myconf.yml.sample \
      ../../source/current/config/myconf.yml

docker-compose build
docker-compose up -d
docker exec -it rails_dev_web_1 bash setup.sh
