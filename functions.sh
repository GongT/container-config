#!/usr/bin/env bash

CONNECT_FOLDER=/var/run/docker-connect

function docker_init {
	NAME=""
	IMAGE=""
	COMMANDS=()
	VOLUMES=()
	PORTS=()
	ENV_VARS=()
	RUN_ARGS=()
	LINKS=()
	C_USER=1000
	SOCKS_FOLDER=
	volume "${CONNECT_FOLDER}" "${CONNECT_FOLDER}"
}

function fs_operation {
	docker_machine sh -c "set -x;set -e; $@" \
 		|| die "fix permission failed"
}
function fs_socks {
	local FOLDER="${CONNECT_FOLDER}"
	if [ -n "${SOCKS_FOLDER}" ]; then
		FOLDER+="/${SOCKS_FOLDER}"
	fi
	echo -n "touch "
	for i in "$@"; do
		echo -n "\"${FOLDER}/$i\" "
	done
	echo -n "; chown -R ${C_USER}:${C_USER} ${FOLDER} "
	echo -n "; chmod 0777 "
	for i in "$@"; do
		echo -n "\"${FOLDER}/$i\" "
	done
}
function fs_fix {
	echo -n "mkdir -p "
	for i in "$@"; do
		echo -n "\"$i\" "
	done
	echo -n "; chown -R ${C_USER}:${C_USER} "
	for i in "$@"; do
		echo -n "\"$i\" "
	done
}
function docker_machine {
	docker run --rm -it \
		"-v=/data:/data" \
		"-v=${CONNECT_FOLDER}:${CONNECT_FOLDER}" \
		alpine "$@"
}
function connect_folder {
	SOCKS_FOLDER="${1}"
	docker_machine mkdir -p "${CONNECT_FOLDER}/${1}" || die "can not create folder ${1} on docker machine"
}

function name {
	NAME=$1
}

function configure {
	local CFG="$1"
	if [ -n "$2" ]; then
		CFG+="=$2"
	fi
	RUN_ARGS+=("$CFG")
}

function image {
	IMAGE=$1
}

function commands {
	COMMANDS=("$@")
}

function user {
	C_USER=$1
}

function port {
	local P="$1:$1"
	if [ -n "$2" ]; then
		P+="/$2"
	fi
	PORTS+=("$P")
}

function link {
	local LINK="$1"
	if [ -n "$2" ]; then
		LINK+=":$2"
	fi
	LINKS+=("$LINK")
}

function volume { # from to
	local VOL="$1:$2"
	if [ -n "$3" ]; then
		VOL+=":$3"
	fi
	VOLUMES+=("$VOL")
}

function environment {
	ENV_VARS+=("$1=$2")
}

function image_build {
	pushd "$1"
	docker build . -t "${NAME}" -f ./Dockerfile || die "can not build image: ${NAME}"
	local RET=$?
	popd
	image "${NAME}"
	return ${RET}
}

function docker_run {
	echo "<< ${NAME}"
	if docker inspect --type=container "${NAME}" &>/dev/null ; then
		echo "exists..."
		if echo "$*" | grep -q "remove" ; then
			echo "  stop..."
			docker stop "${NAME}" >/dev/null
			echo "  remove..."
			docker rm "${NAME}" >/dev/null
		elif echo "$*" | grep -q "restart" ; then
			echo "  restart..."
			docker stop "${NAME}" &>/dev/null
			sleep 1
			docker start "${NAME}" &>/dev/null
			return
		else
			echo "  start..."
			docker start "${NAME}" >/dev/null
			return
		fi
	fi
	
	local RUN_ARGUMENTS=()
	for i in "${VOLUMES[@]}"; do
		RUN_ARGUMENTS+=("--volume=$i")
	done
	for i in "${ENV_VARS[@]}"; do
		RUN_ARGUMENTS+=("--env=$i")
	done
	for i in "${PORTS[@]}"; do
		RUN_ARGUMENTS+=("--publish=$i")
	done
	for i in "${RUN_ARGS[@]}"; do
		RUN_ARGUMENTS+=("--$i")
	done
	for i in "${LINKS[@]}"; do
		RUN_ARGUMENTS+=("--link=$i")
	done
	
	echo "  create and run..."
	start docker run \
		"-d" \
		"--restart=always" \
		"--log-driver=journald" \
		"--name=${NAME}" \
		"--user=${C_USER}" \
		"${RUN_ARGUMENTS[@]}" \
		"${IMAGE}" "${COMMANDS[@]}"
	echo "  created..."
	echo ">> ${NAME}"
}

function start {
	echo -ne "\e[38;5;14m"
	echo "${0} ${1} ${2} ${3}"
	local WRAP=/bin/false
	local LAST=${#}
	for i in $( seq 4 ${LAST} ); do
		if "${WRAP}" ; then
			echo -ne "\"${@:$i:1}\" "
		else
			echo -e "\t${@:$i:1} \\"
			if ! echo "${@:$i:1}" | grep -qE "^-" ; then
				WRAP=/bin/true
				LAST=$(( ${LAST} - 1 ))
				echo -en "\t"
			fi
		fi
	done
	if ! "${WRAP}" ; then
		echo -ne "${@: -1}"
	fi
	echo -e "\e[0m"
	"$@"
}

function die {
	echo "$@" >&2
	exit 1
}

function mkdirp {
	if [ ! -e "$1" ]; then
		mkdir -p "$1"
	fi
}
