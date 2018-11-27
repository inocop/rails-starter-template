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

# package install(railsdevユーザでnpm install)
su -s /bin/bash railsdev -c "bundle config --local build.nokogiri --use-system-libraries"
su -s /bin/bash railsdev -c "bundle install --path vendor/bundle"
su -s /bin/bash railsdev -c "npm install --prefix ${RAILS_APP_DIR}/public"
npm install --prefix ${NODE_APP_DIR}

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


# puma
# $ bundle exec rails s -b 0.0.0.0 -p 8081
