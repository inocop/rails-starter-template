set -eux
sudo su

cd /home/railsdev
if [ -e rails_app ]; then mv rails_app rails_app_$(date +%Y%m%d_%H%M%S) fi
tar -zxvf /tmp/rails_app.tar.gz

cd /home/railsdev/rails_app/docker/rails_prd
#docker-compose build

docker exec rails_prd_1 bash -c    'cd public && npm install'
docker exec rails_prd_1 bash -l -c 'bundle install'
docker exec rails_prd_1 bash -l -c 'bundle exec rake db:migrate RAILS_ENV=production'
#docker exec rails_prd_1 bash -l -c 'bundle exec rake assets:precompile'

docker-compose restart
