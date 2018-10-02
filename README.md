# Ruby on Rails Starter Project on Docker

## 構成

#### アーキテクチャ
|#    |name / version|
|:----|--------------|
|Lang |Ruby 2.4.4    |
|Web  |Apache 2.4 + Passenger 5.3.2|
|DB   |MySQL 5.6     |


#### 追加ライブラリ

**gem**
- rails 5.1.6
- devise 4.4.3
- devise-i18n 1.6.4
- kaminari
- carrierwave
- delayed_job

**gem-development**
- ruby-debug-ide
- debase

**npm**
- bootstrap 4.1.3
- jquery 3.3.1
- chart.js 2.7.2
- rails-ujs 5.1.6
- flatpickr
- fontawesome-free


## アプリ名

アプリ名を変更する場合は以下を編集
- docker-ror/source/current/config/application.rb
  - module RailsApp -> module XxxYyy
- docker-ror/docker/  （コンテナ名が重複する場合）
  - rails_dev/ -> xxx_dev/
  - rails_prd/ -> xxx_prd/

## 環境構築(development)

#### 設定ファイル編集
```
$ git clone https://github.com/inocop/docker-ror
$ cd docker-ror/source/current/config
$ cp myconf.yml.sample myconf.yml

# myconf.ymlの値を編集
```

#### コンテナビルド

```
$ cd docker-ror/docker/rails_dev
$ docker-compose build
$ docker-compose up -d
$ docker exec -it rails_dev_web_1 bash -c 'sh /tmp/setup.sh'
```

#### アクセス

http://localhost:8888


開発用初期ユーザ

|key |value|
|:---|:----|
|id  |admin@example.com|
|pw  |password|


#### DBツール(adminer)

http://localhost:8888/tools

#### メールツール(MailCatcher)

http://localhost:1080


#### デバッグ

not yet


#### テスト

not yet


## 環境構築(production)

#### Docker、docker-composeのインストール(CentOS7)
```
$ yum install -y yum-utils device-mapper-persistent-data lvm2
$ yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
$ yum install -y docker-ce
$ systemctl enable docker
$ systemctl start docker
$ curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
$ chmod +x /usr/bin/docker-compose
```

**参考**
* https://docs.docker.com/install/linux/docker-ce/centos/
* https://docs.docker.com/compose/install/


#### ホスト & コンテナ間の共通ユーザー作成

railsdev(uid:gid 1000:1000)
```
$ useradd railsdev
$ usermod -u 1000 railsdev && groupmod -g 1000 railsdev
```

#### 設定ファイル編集

developmentと同様
※secret_key_baseの値はdevelopmentと同じにしないこと

SECRET_KEY_BASEにはsha512のハッシュ値をセットする。
開発環境等で以下コマンドからSECRET_KEY_BASEを生成可能。
```
$ bin/rake secret
```

#### コンテナビルド

```
$ cd /home/railsdev
$ git clone https://github.com/inocop/docker-ror rails_app
$ cd rails_app/docker/rails_prd
$ docker-compose build
$ docker-compose up -d
$ docker exec -it rails_prd_web_1 bash -c 'sh /tmp/setup.sh'
```

※メモリ1GB以下の環境だとbuildに失敗するのでswapで対応。


## デプロイ

config.sampleをコピー
```
$ cd deploy
$ cp config.sample config
```

configの以下パラメータを設定
* BRANCH
* REPOSITORY
* REMOTE_USER
* REMOTE_SERVER
* SECRET_KEY

デプロイ実行
```
$ ./deploy.sh
```
