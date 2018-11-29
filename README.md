# Ruby on Rails Starter Template

## 構成

#### アーキテクチャ
|#    |name / version|
|:----|--------------|
|Lang |Ruby 2.4.5    |
|Web  |Apache 2.4 + Passenger 5.3.6|
|DB   |MySQL 5.7     |


#### 追加ライブラリ

**gem**
- rails
- devise
- devise-i18n
- kaminari
- carrierwave
- delayed_job

**gem-development**
- ruby-debug-ide
- debase

**npm**
- bootstrap
- jquery
- chart.js
- rails-ujs
- flatpickr
- fontawesome-free


## アプリ名

アプリ名を変更する場合は以下を編集
- rails-starter-template/app/rails_app/config/application.rb
```
- module RailsApp
+ module MyAppName
```

## 環境構築(development)

#### コンテナビルド

```
$ git clone https://github.com/inocop/rails-starter-template.git
$ cd rails-starter-template/app/docker/rails_dev
$ ./dev_build.sh
```

#### アクセス

http://localhost:8081


開発用初期ユーザ

|key |value|
|:---|:----|
|id  |admin@example.com|
|pw  |password|


#### DBツール(adminer)

http://localhost:8081/tools

#### メールツール(MailCatcher)

http://localhost:1081


#### デバッグ

1. Visual Studio Codeをインストール

    https://code.visualstudio.com/

    拡張機能: ruby を追加

1. vscodeツールバーの[ターミナル] > [タスクの実行] > [exec-rdebug-ide]
1. vscodeツールバーの[デバッグ] > [デバッグの開始]


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
$ curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
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

※既に1000:1000のユーザーがいれば作成不要。

※メモリ1GB以下の環境だとdocker buildに失敗するのでswapを作成しておく。


#### 設定ファイル編集

myconf.ymlのproductionを編集。

* secret_key_baseの変更は必須

  以下コマンドでハッシュ値(sha512)を生成
  ```
  $ ./bin/rake secret
  ```


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
* MYCONF_YML (本番用のmyconf.yml)


デプロイ実行
```
# 初回デプロイ
$ ./deploy.sh init

# デプロイ & Docker build（ダウンタイム有り）
$ ./deploy.sh build

# デプロイ
$ ./deploy.sh
```
