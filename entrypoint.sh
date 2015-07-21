#!/bin/bash
set -e

# create pid directory
mkdir -p /run/apt-cacher-ng
chmod -R 0755 /run/apt-cacher-ng
chown ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} /run/apt-cacher-ng

# create cache dir
mkdir -p ${APT_CACHER_NG_CACHE_DIR}
chmod -R 0755 ${APT_CACHER_NG_CACHE_DIR}
chown -R ${APT_CACHER_NG_USER}:root ${APT_CACHER_NG_CACHE_DIR}

# create log dir
mkdir -p ${APT_CACHER_NG_LOG_DIR}
chmod -R 0755 ${APT_CACHER_NG_LOG_DIR}
chown -R ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} ${APT_CACHER_NG_LOG_DIR}

# allow arguments to be passed to apt-cacher-ng
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == apt-cacher-ng || ${1} == $(which apt-cacher-ng) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch apt-cacher-ng
if [[ -z ${1} ]]; then
  exec start-stop-daemon --start --chuid ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} \
    --exec $(which apt-cacher-ng) -- -c /etc/apt-cacher-ng ${EXTRA_ARGS}
else
  exec "$@"
fi
