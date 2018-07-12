FROM ubuntu:xenial-20180525
LABEL maintainer="sameer@damagehead.com"

ENV APT_CACHER_NG_VERSION=0.9.1 \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    TINI_VERSION=v0.18.0

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-cacher-ng=${APT_CACHER_NG_VERSION}* wget \
 && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
 && gpg --fingerprint 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 | grep -q "Key fingerprint = 6380 DC42 8747 F6C3 93FE  ACA5 9A84 159D 7001 A4E5" \
 && wget -nv https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc -O tini.asc \
 && wget -nv https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini -O /usr/local/bin/tini \
 && gpg --verify tini.asc /usr/local/bin/tini \
 && chmod +x /usr/local/bin/tini \
 && rm tini.asc \
 && sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
 && sed 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' -i /etc/apt-cacher-ng/acng.conf \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3142/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/apt-cacher-ng"]
