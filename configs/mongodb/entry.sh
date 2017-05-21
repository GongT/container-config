#!/bin/bash
set -m

if [ ! -f /data/db/.mongodb_password_set ]; then
	INFO="\e[38;5;9m"
	INFO_END="\e[0m"
	echo -e "${INFO}>>> start database with: mongod $@ &${INFO_END}" >&2
	mongod "$@" &
	
	RET=1
	while [ ${RET} -ne 0 ]; do
		echo -ne "${INFO}>>> waiting for MongoDB service startup\r${INFO_END}" >&2
		sleep 1
		mongo admin --eval "help" >/dev/null 2>&1
		RET=$?
	done
	
	die () {
		echo -e "$@" >&2
		exit 1
	}
	echo -e "${INFO}>>> creating user: root, password: ${DEFAULT_PASSWORD}${INFO_END}" >&2
	mongo admin --eval "db.createUser({user: 'root', pwd: '${DEFAULT_PASSWORD}', roles:[{role:'root',db:'admin'}]});" \
		|| die "can not create a root user"
	
	echo "${DEFAULT_PASSWORD}" > /data/db/.mongodb_password_set

	mongod --shutdown
fi

echo "======================" >&2
echo " start database with: mongod --auth $@" >&2
echo "======================" >&2
exec mongod "--auth" "$@"
