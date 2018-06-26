#!/bin/bash

set -eux

cd /var/rails_app

###########################
#  create project         #
###########################
# sudo gem install rails '5.1.6'
# rails _5.1.6_ new . --database=mysql --skip-bundle --skip-coffee --skip-turbolinks --skip-sprockets

###########################
#  change file            #
###########################
# config/database.yml - DB params
# config/secrets.yml  - production : secret_key_base


bundle config --local build.nokogiri --use-system-libraries
bundle install --path vendor/bundle
RAILS_ENV=development bundle exec rake db:create
RAILS_ENV=production  bundle exec rake db:create

npm install
if [ ! -e public/libs ]; then
pushd public
  ln -fs ../node_modules libs
popd
fi

# puma (rails defautl)
# $ cd /var/rails_app
# $ bundle exec rails s -b 0.0.0.0 -p 8888

# passenger
# $ passenger-config restart-app
