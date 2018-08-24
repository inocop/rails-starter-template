set -eux

sudo su


# 転送した圧縮ファイルを展開
cd /home/railsdev
if [ -e rails_app ]; then 
  mv rails_app rails_app_$(date +%Y%m%d_%H%M%S)
fi
tar -zxvf /tmp/rails_app.tar.gz
chown -R railsdev:railsdev rails_app


# dockerをリスタートして共有フォルダを再マウント
cd /home/railsdev/rails_app/docker/rails_prd
docker-compose restart web


# db、パッケージマネージャを更新
docker exec rails_prd_web_1 bash -l -c 'cd public && npm install'
docker exec rails_prd_web_1 bash -l -c 'bundle install'
docker exec rails_prd_web_1 bash -l -c 'bundle exec rake db:migrate RAILS_ENV=production'
#docker exec rails_prd_web_1 bash -l -c 'bundle exec rake assets:precompile'


# 5世代分残して削除
ls -t | grep rails_app | tail -n+6 | xargs rm -rf
