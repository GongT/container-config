FROM nginx:alpine

ENV PATH="/usr/bin:/bin:/usr/local/bin:/usr/sbin:/sbin"

RUN ln -s /data/letsencrypt /etc \
 && echo "del user" \
 && deluser nginx \
 && rm -rf /var/cache/nginx \
 && echo "add group" \
 && addgroup -g 1000 nginx \
 && echo "add user" \
 && adduser -h /var/cache/nginx -s /sbin/nologin -G nginx -D -u 1000 nginx
 
COPY scripts/* /usr/bin/
