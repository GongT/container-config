FROM alpine:edge
RUN set -e && set -x \
	&& apk -U add \
		php7-fpm \
		php7-sockets \
		php7-ctype \
		php7-curl \
		php7-openssl \
		php7-gd \
		php7-iconv \
		php7-mbstring \
		php7-opcache \
		php7-imap \
		php7-sockets \
		php7-pdo \
		php7-dom \
		php7-ctype \
		php7-json \
		php7-xml \
		php7-simplexml \
		php7-xmlreader \
		php7-xmlwriter \
		php7-xmlrpc \
		php7-ldap \
		php7-bz2 \
		php7-zlib \
		php7-tokenizer \
		php7-session \
		php7-fileinfo \
		php7-mcrypt \
		php7-pdo_mysql \
		php7-xdebug \
		php7-apcu \
		php7-memcached \
		php7-pdo_pgsql \
		php7-mysqli \
		php7-mysqlnd \
		php7-redis

WORKDIR "/data"
USER 0
CMD ["/usr/sbin/php-fpm7", "--nodaemonize", "--force-stderr", "--allow-to-run-as-root"]
