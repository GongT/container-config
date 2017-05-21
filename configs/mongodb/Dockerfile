FROM mongo:latest

ENV DEFAULT_PASSWORD="password"
ENTRYPOINT ["/bin/bash"]
CMD [ \
	"server.sh", \
	"--storageEngine", "wiredTiger", "--journal", \
	"--dbpath", "/data/db", "--directoryperdb", "--sslMode", "disabled", \
	"--unixSocketPrefix", "/var/run/docker-connect/mongodb", "--filePermissions", "0777", \
	"--ipv6" \
	]

COPY entry.sh /usr/bin/server.sh
