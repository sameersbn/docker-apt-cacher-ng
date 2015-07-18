#!/bin/bash
set -e

# finalize file ownership and permissions
mkdir -p -m 755 /var/run/apt-cacher-ng
chown ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} /var/run/apt-cacher-ng

chown -R ${APT_CACHER_NG_USER}:root ${APT_CACHER_NG_CACHE_DIR}
chmod 777 ${APT_CACHER_NG_CACHE_DIR}

# allow arguments to be passed to apt-cacher-ng
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == apt-cacher-ng || ${1} == /usr/sbin/apt-cacher-ng ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch apt-cacher-ng
if [[ -z ${1} ]]; then
  exec start-stop-daemon --start --chuid ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} \
    --exec /usr/sbin/apt-cacher-ng -- -c /etc/apt-cacher-ng ${EXTRA_ARGS}
else
  exec "$@"
fi
