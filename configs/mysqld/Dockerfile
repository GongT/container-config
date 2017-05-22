FROM alpine:latest

WORKDIR /

RUN addgroup -g 1000 mysql \
 && adduser -h /home/mysql -s /sbin/nologin -G mysql -D -u 1000 mysql \
 && mkdir -p /data/db /var/run/docker-connect/mysqld \
 && chown mysql:mysql /data/db /var/run/docker-connect/mysqld

RUN apk -U add mariadb

ENV DEFAULT_PASSWORD="password"

COPY etc/* /etc/mysql/
COPY start.sh /usr/bin/
CMD start.sh
VOLUME /data/db
