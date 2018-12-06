#!/usr/bin/env bash

if [ "$1" = "production" ]; then
  RAILS_ENV=production
else
  RAILS_ENV=development
fi

set -eux
RAILS_APP_DIR=/var/www/app/source/rails_app


# package install(railsdevユーザでinstall)
cd ${RAILS_APP_DIR}
su -s /bin/bash railsdev -c "bundle config --local build.nokogiri --use-system-libraries"
su -s /bin/bash railsdev -c "bundle install --path vendor/bundle"
su -s /bin/bash railsdev -c "npm install --prefix ./public"
su -s /bin/bash railsdev -c "npm install --prefix ./lib/nodejs"


# db create
bundle exec rake db:create          RAILS_ENV=${RAILS_ENV}
bundle exec rake db:migrate:reset   RAILS_ENV=${RAILS_ENV} DISABLE_DATABASE_ENVIRONMENT_CHECK=1 # or bundle exec rake db:schema:load
bundle exec rake db:seed            RAILS_ENV=${RAILS_ENV}
bundle exec rake db:environment:set RAILS_ENV=${RAILS_ENV}

bundle exec rake db:create          RAILS_ENV=test
bundle exec rake db:environment:set RAILS_ENV=test


# passenger
passenger-config restart-app ${RAILS_APP_DIR}
systemctl reload delayed_job

