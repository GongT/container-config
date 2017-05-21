#!/usr/bin/env bash

set -e

cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

function create {
	local UPSTREAM="$1"
	cat << XXX > "../${UPSTREAM}.conf"
location ~ \.php$ {
	fastcgi_pass unix:/var/run/docker-connect/php-fpm/${UPSTREAM}.sock;
    include fastcgi_params;
	break;
}
	
location ~ \.php/ {
	fastcgi_split_path_info ^(/index.php)(/?.+|)$;
	fastcgi_param PATH_INFO \$fastcgi_path_info;
    fastcgi_param PATH_TRANSLATED \$document_root\$fastcgi_path_info;
	fastcgi_pass unix:/var/run/docker-connect/php-fpm/${UPSTREAM}.sock;
    include fastcgi_params;
	break;
}
XXX
}

create www
create dev
