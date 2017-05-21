#!/usr/bin/env bash

source ./functions.sh

SESS_SOCK=/var/run/docker-connect/memcached/php-session.sock

docker_init
name "memcached-session"
image "memcached:alpine"
connect_folder memcached
commands memcached -u root -m 512m -D ':' -s "${SESS_SOCK}" -a 0777 -o modern
fs_operation "$(fs_socks php-session.sock)"
docker_run remove
