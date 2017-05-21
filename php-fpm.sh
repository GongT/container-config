#!/usr/bin/env bash

source ./functions.sh


docker_init
name "php-fpm"
image_build "./configs/php/build"
image "php-fpm"
connect_folder "php-fpm"
volume "/data" "/data"
volume "/data/php" "/etc/php7" ro
docker_run remove
