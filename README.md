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

