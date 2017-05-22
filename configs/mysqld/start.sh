#!/bin/sh

mkdir -p /data/db

mkdir -p /var/run/docker-connect/mysqld
touch /var/run/docker-connect/mysqld/mysql.sock
chmod 0777 /var/run/docker-connect/mysqld/mysql.sock

if [ ! -e /tmp/mysql.log ]; then
	mkfifo -m 0777 /tmp/mysql.log
#	touch /tmp/mysql.log
#	chmod 0666 /tmp/mysql.log
fi
tail -f /tmp/mysql.log >&2 &

if [ ! -e "/data/db/mysql" ]; then
	echo "install default databases"
	mysql_install_db --datadir=/data/db
fi

CMD="mysqld --user=mysql --datadir=/data/db --log-error=/tmp/mysql.log"

if [ ! -e "/data/db/.installed" ]; then
	${CMD} --verbose &
	
	echo "create default password"
	apk add mariadb-client
	
	I=0
	while ! mysqladmin ping --silent; do
		sleep 1
		I=$((I + 1))
		if [ "${I}" -gt 5 ]; then
			echo "database seems not started" >&2
			exit 1
		fi
		echo "waiting ... ${I}/5"
	done

	set -e
	mysql -sfu root << XXX
UPDATE mysql.user SET Password=PASSWORD('${DEFAULT_PASSWORD}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
XXX
	
	echo "${DEFAULT_PASSWORD}" > /data/db/.installed
	
	echo "complete. shutting down server."
	mysqladmin shutdown
	sleep 1
fi

echo "starting mariadb server."

cd /usr
exec ${CMD}
