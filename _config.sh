#!/usr/bin/env bash

set -x
set -e

source ./functions.sh

mkdirp ./docker-storage

if ! mountpoint ./docker-storage &>/dev/null ; then
	mount -t nfs docker:/data ./docker-storage/ || die "can not mount 'docker:/data' to current directory"
fi

mkdirp ./docker-storage/mongodb
datadir ./docker-storage/mongodb
mkdirp ./docker-storage/mysql
datadir ./docker-storage/mysql

mkdirp ./docker-storage/nginx/config/
st_cp -fr ./configs/nginx/etc/* ./docker-storage/nginx/config/

mkdirp ./docker-storage/php
st_cp -fr ./configs/php/config/* ./docker-storage/php

st_cp -fr ./configs/dnsmasq ./docker-storage

mkdirp ./docker-storage/wordpress
pushd ./docker-storage/wordpress
if [ ! -e .git ]; then
	git clone git@github.com:GongT/my-wordpress.git .
else
	git pull
fi
popd

mkdirp ./docker-storage/phpmyadmin
if [ ! -e ./docker-storage/phpmyadmin/index.php ]; then
	pushd /tmp
	wget https://files.phpmyadmin.net/phpMyAdmin/4.7.0/phpMyAdmin-4.7.0-all-languages.tar.xz -O pma.tar.xz
	tar --strip-components=1 -xf pma.tar.xz -C ./docker-storage/phpmyadmin
	rm -f pma.tar.xz
	popd
fi
