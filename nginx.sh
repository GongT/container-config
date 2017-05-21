#!/usr/bin/env bash

source ./functions.sh

docker_init
name "nginx"
image_build ./configs/nginx/build
volume "/data" "/data" ro
port 80
port 443
user root
docker_run remove
