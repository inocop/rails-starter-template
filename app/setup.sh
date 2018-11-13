#!/usr/bin/env bash

if [ "$1" = "production" ]; then
  RAILS_ENV=production
else
  RAILS_ENV=development
fi
RAILS_APP_DIR=/var/my_dir/app/rails_app
NODE_APP_DIR=/var/my_dir/app/node_app


set -eux
cd ${RAILS_APP_DIR}


###########################
#  create project         #
###########################
# gem install rails -v '5.1.6'
# rails _5.1.6_ new . --database=mysql --skip-bundle --skip-coffee --skip-turbolinks --skip-sprockets

###########################
#  change file            #
###########################
# edit config/database.yml
#        use myconf.yml
#
# edit config/secrets.yml
#        use myconf.yml
#
# edit config/application.rb
#        use myconf.yml


# package install
bundle config --local build.nokogiri --use-system-libraries
bundle install --path vendor/bundle

npm install --prefix ${RAILS_APP_DIR}/public
sudo npm install --prefix ${NODE_APP_DIR}


# db create
bundle exec rake db:create          RAILS_ENV=${RAILS_ENV}
bundle exec rake db:schema:load     RAILS_ENV=${RAILS_ENV} DISABLE_DATABASE_ENVIRONMENT_CHECK=1 # or bundle exec rake db:migrate
bundle exec rake db:seed            RAILS_ENV=${RAILS_ENV}
bundle exec rake db:environment:set RAILS_ENV=${RAILS_ENV}

bundle exec rake db:create          RAILS_ENV=test
bundle exec rake db:environment:set RAILS_ENV=test


# passenger
passenger-config restart-app ${RAILS_APP_DIR}

# puma
# $ bundle exec rails s -b 0.0.0.0 -p 8888
