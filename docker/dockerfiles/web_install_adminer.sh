#!/bin/bash

set -eux

# add db tools
yum install -y wget unzip php php-mysqli php-mbstring mysql
mkdir -p /var/www/html/tools
cd /var/www/html/tools && wget https://github.com/vrana/adminer/releases/download/v4.6.2/adminer-4.6.2.php
mv /var/www/html/tools/adminer-4.6.2.php /var/www/html/tools/index.php
