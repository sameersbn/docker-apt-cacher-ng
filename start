#!/bin/bash
set -e

mkdir -p -m 755 /var/run/apt-cacher-ng
chown ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} /var/run/apt-cacher-ng

chown -R ${APT_CACHER_NG_USER}:root ${APT_CACHER_NG_CACHE_DIR}
chmod 777 ${APT_CACHER_NG_CACHE_DIR}

if [ -z "$@" ]; then
  exec start-stop-daemon --start --chuid ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} \
    --exec /usr/sbin/apt-cacher-ng -- -c /etc/apt-cacher-ng
else
  exec "$@"
fi
