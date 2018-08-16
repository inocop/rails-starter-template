# Ruby on Rails Starter Project on Docker

## 構成

#### アーキテクチャ
|#  |version|
|:--|-------|
|Lang |Ruby 2.4.4|
|Web  |Apache 2.4 + Passenger 5.3.2|
|DB   |MySQL 5.6|


#### ライブラリ
|#  |name|version|
|:--|----|-------|
|gem|rails       |5.1.6|
|gem|devise      |4.4.3|
|gem|devise-i18n |1.6.4|
|npm|bootstrap   |4.1.3|
|npm|jquery      |3.3.1|
|npm|chart.js    |2.7.2|


## 環境構築(development)

#### コンテナビルド

```
$ git clone https://github.com/inocop/docker-ror
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

#### Dockerのインストール(CentOS7)
```
$ yum install -y yum-utils device-mapper-persistent-data lvm2
$ yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
$ yum install -y docker-ce
$ systemctl start docker
$ systemctl enable docker
$ curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```


#### ホスト & コンテナ間の共通ユーザー作成

railsdev(uid:1000)
```
$ useradd -s /sbin/nologin railsdev
$ usermod -u 1000 railsdev && groupmod -g 1000 railsdev
```

#### production用の変数設定
```
docker/rails_prd/docker-compose.yml
* SECRET_KEY_BASE
* DB_HOST
* DB_USERNAME
* DB_PASSWORD
```

開発環境等で以下コマンドからSECRET_KEY_BASEを生成。
```
$ bin/rake secret
```

コンテナビルド後に、/etc/sysconfig/httpdを変更してもOK。(passenger再起動で変更反映)


#### コンテナビルド
```
$ cd /home/railsdev
$ git clone https://github.com/inocop/docker-ror
$ cd docker/rails_prd
$ docker-compose build
$ docker-compose up -d
$ docker exec -it rails_prd_web_1 bash -c 'sh /tmp/setup.sh'
```





