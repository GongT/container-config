#!/usr/bin/env bash

source ./functions.sh

docker_init
name "mysqld"
image "mariadb"
volume "/data/mysql/database" "/var/lib/mysql"
volume "/data/mysql/config" "/etc/mysql/conf.d" ro
environment MYSQL_ROOT_PASSWORD "920223"
port 3306

docker_run
