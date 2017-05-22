#!/usr/bin/env bash

source ./functions.sh

docker_init
name "mysqld"
image_build ./configs/mysqld
volume "/data/mysql" "/data/db"
environment DEFAULT_PASSWORD "920223"
port 3306
connect_folder mysqld
user 1000
fs_operation "$(fs_fix /data/mysql) ; $(fs_socks mysql.sock)"
user 0
docker_run remove
