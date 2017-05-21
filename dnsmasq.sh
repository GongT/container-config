#!/usr/bin/env bash

source ./functions.sh

docker_init
name "dnsmasq"
image_build ./configs/dnsmasq/build/
volume "/data/dnsmasq/dnsmasq.d" "/etc/dnsmasq.d" ro
volume "/data/dnsmasq/dnsmasq.conf" "/etc/dnsmasq.conf" ro
port 53 tcp
port 53 udp
configure "cap-add" "NET_ADMIN"
docker_run restart
