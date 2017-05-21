#!/usr/bin/env bash

source ./functions.sh

docker_init
name "nginx"
image "nginx:alpine"
volume "/data/nginx/config" "/etc/nginx" ro
volume "/data/letsencrypt" "/etc/letsencrypt" ro
volume "/data" "/data" ro
volume "/var/run/php-fpm" "/var/run/php-fpm"
port 80
port 443
docker_run remove
