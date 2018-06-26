# Ruby on Rails Starter Project on Docker

### 構成

|#  |version|
|---|---|
|Ruby|2.4.4|
|Rails|5.1.6|
|Web Server|Apache + Passenger|


### コンテナ起動

setup
```
$ cd {~/docker/dev | ~/docker/prd}
$ docker-compose build
$ docker-compose up -d
$ docker cp ../dockerfiles/web/setup.sh {dev_web_1 | prd_web_1}:/tmp/setup.sh
$ docker exec -it {dev_web_1 | prd_web_1} bash -c 'sh /tmp/setup.sh'
```


### Dockerインストール（CentOS7）

```
$ yum install -y yum-utils device-mapper-persistent-data lvm2
$ yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
$ yum install -y docker-ce
$ systemctl start docker
$ systemctl enable docker
$ curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
$ chmod +x /usr/bin/docker-compose
```
