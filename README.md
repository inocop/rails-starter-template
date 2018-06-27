# Ruby on Rails Starter Project on Docker

## 構成

|#  |version|
|:--|---|
|Ruby|2.4.4|
|Rails|5.1.6|
|Web|Apache2.4 + Passenger5.3.2|
|MySQL|5.6|

## 環境構築(development)

#### コンテナビルド
```
$ cd docker/rails_dev
$ docker-compose build
$ docker-compose up -d
$ docker exec -it rails_dev_web_1 bash -c 'sh /tmp/setup.sh'
```

#### アクセス
rails_apps  
http://localhost:8888

adminer  
http://localhost:8888/tools


## 環境構築(production)

#### Dockerのインストール（CentOS7）
```
$ yum install -y yum-utils device-mapper-persistent-data lvm2
$ yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
$ yum install -y docker-ce
$ systemctl start docker
$ systemctl enable docker
$ curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

#### コンテナ内ユーザーのrailsdev(uid:1000)をホストにも作成
ユーザーマッピングで対応した方が良いかも。。。
```
$ useradd -s /sbin/nologin railsdev
$ usermod -u 1000 railsdev && groupmod -g 1000 railsdev
$ cd /home/railsdev
$ git clone https://github.com/inocop/docker-ror
```

#### コンテナビルド

[rails_dev] を [rails_prd] に置き換えてdevelopmentのコマンド実行。

/etc/sysconfig/httpdのSECRET_KEY_BASEの値を更新。
以下のコマンドでKEYを生成。
```
$ bin/rake secret
```
