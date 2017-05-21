#!/usr/bin/env bash

source ./functions.sh


docker_init
name "php-fpm"
image_build "./configs/php/build"
image "php-fpm"
volume "/data" "/data"
volume "/data/php" "/etc/php7" ro
connect_folder "php-fpm"
fs_operation "$(fs_socks dev.sock www.sock)"
docker_run remove
