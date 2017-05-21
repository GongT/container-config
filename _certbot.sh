#!/usr/bin/env bash


function certbot {
	docker run --rm -it \
		-v /data/letsencrypt:/etc/letsencrypt \
		-v /var/log/letsencrypt:/var/log/letsencrypt \
		docker.io/certbot/certbot "$@"
}

certbot certonly --manual --preferred-challenges dns -d "$@"
