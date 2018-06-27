# Ruby on Rails Starter Project on Docker

### 構成

|#  |version|
|---|---|
|Ruby|2.4.4|
|Rails|5.1.6|
|Web Server|Apache + Passenger|


### Dockerコンテナ setup

環境変数ファイルの設定
```
$ cd docker/dockerfiles/
$ cp .env.sample .env
```
production環境の場合、本番用のMYSQL_HOSTやSECRET_KEY_BASEなどをセット。


コンテナビルド
```
$ cd {~/docker/dev | ~/docker/prd}
$ docker-compose build
$ docker-compose up -d
$ docker cp ../dockerfiles/web/setup.sh {dev_web_1 | prd_web_1}:/tmp/setup.sh
$ docker exec -it {dev_web_1 | prd_web_1} bash -c 'sh /tmp/setup.sh'
```

rails_apps  
http://localhost:8888

adminer  
http://localhost:8888/tools


### ホスト（CentOS7）での環境構築手順
Dockerのインストール
```
$ yum install -y yum-utils device-mapper-persistent-data lvm2
$ yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
$ yum install -y docker-ce
$ systemctl start docker
$ systemctl enable docker
$ curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

コンテナのrailsuserをホストでも作成しておく（一応）
```
$ useradd -s /sbin/nologin railsdev
$ usermod -u 1000 railsdev && groupmod -g 1000 railsdev
$ cd /home/railsdev && git clone xxx
```
