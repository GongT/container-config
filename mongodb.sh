#!/usr/bin/env bash

source ./functions.sh

docker_init
name "mongodb"
image_build ./configs/mongodb/
volume "/data/mongodb" "/data/db"
environment DEFAULT_PASSWORD 920223
port 27017
connect_folder mongodb
fs_operation "$(fs_fix /data/mongodb) ; $(fs_socks mongodb-27017.sock)"
docker_run
