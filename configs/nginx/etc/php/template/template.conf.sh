#!/usr/bin/env bash

set -e

cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

function create {
	local UPSTREAM="$1"
	cat << XXX > "../${UPSTREAM}-pass.conf"
fastcgi_pass unix:/var/run/docker-connect/php-fpm/${UPSTREAM}.sock;
include fastcgi_params;
XXX
	cat << XXX > "../${UPSTREAM}-pathinfo.conf"
location ~ \.php/ {
	fastcgi_split_path_info ^(/index.php)(/?.+|)$;
	fastcgi_param PATH_INFO \$fastcgi_path_info;
	fastcgi_param PATH_TRANSLATED \$document_root\$fastcgi_path_info;
	include php/${UPSTREAM}-pass.conf;
}
XXX

	cat << XXX > "../${UPSTREAM}.conf"
location ~ \.php$ {
	include php/${UPSTREAM}-pass.conf;
}

include php/${UPSTREAM}-pathinfo.conf;
XXX
}

create www
create dev
