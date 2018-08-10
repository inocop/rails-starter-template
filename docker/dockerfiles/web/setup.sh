#!/bin/bash

set -eux

cd /var/rails_app

###########################
#  create project         #
###########################
# gem install rails -v '5.1.6'
# rails _5.1.6_ new . --database=mysql --skip-bundle --skip-coffee --skip-turbolinks --skip-sprockets

###########################
#  change file            #
###########################
# config/database.yml -> use .env params


bundle config --local build.nokogiri --use-system-libraries
bundle install --path vendor/bundle
bundle exec rake db:create:all
bundle exec rake db:schema:load # bundle exec rake db:migrate
bundle exec rake db:seed


###########################
#  settting devise        #
###########################
# bundle exec rails g devise:install
# bundle exec rails g controller Dashboards index --skip-assets
# bundle exec rails g devise User users
# bundle exec rails g devise:views


cd /var/rails_app/public
npm install



# puma (rails defautl)
# $ cd /var/rails_app
# $ bundle exec rails s -b 0.0.0.0 -p 8888

# passenger
# $ passenger-config restart-app
