#!/usr/bin/env bash

cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")" )"
pwd

source ./functions.sh

set -e

source ./dnsmasq.sh
source ./mongodb.sh
source ./mysql.sh
source ./memcached.sh
source ./php-fpm.sh
source ./nginx.sh
