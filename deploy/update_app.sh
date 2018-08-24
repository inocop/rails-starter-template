set -eux

sudo su

# 転送した圧縮ファイルを展開
cd /home/railsdev
if [ -e rails_app ]; then 
  mv rails_app rails_app_$(date +%Y%m%d_%H%M%S) 
fi
tar -zxvf /tmp/rails_app.tar.gz

# デプロイタスクを実行
cd /home/railsdev/rails_app/docker/rails_prd
#docker-compose build
docker exec rails_prd_1 bash -c    'cd public && npm install'
docker exec rails_prd_1 bash -l -c 'bundle install'
docker exec rails_prd_1 bash -l -c 'bundle exec rake db:migrate RAILS_ENV=production'
#docker exec rails_prd_1 bash -l -c 'bundle exec rake assets:precompile'
docker-compose restart

# 5世代以上前を削除
ls -lt | tail -n +5 | xargs rm -rf
