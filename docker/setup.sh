#!/bin/bash

set -eux

cd /home/railsdev/rails_app

###########################
#  already run            #
###########################
# sudo gem install rails '5.1.6'
# rails _5.1.6_ new . --database=mysql --skip-bundle --skip-coffee --skip-turbolinks --skip-sprockets


bundle install --path vendor/bundle
npm install


###########################
#  built-in server        #
###########################
# cd /home/railsdev/rails_app
# bundle exec rails s -b 0.0.0.0 -p 8080

###########################
#  passenger              #
###########################
# passenger-config restart-app
# http://localhost:8080/
