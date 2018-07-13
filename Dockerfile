FROM ubuntu:bionic-20180526 AS tini-installer

ENV TINI_VERSION=v0.18.0

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y wget gnupg \
 && gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
 && gpg --fingerprint 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 | grep -q "6380 DC42 8747 F6C3 93FE  ACA5 9A84 159D 7001 A4E5" \
 && wget --quiet "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc" -O tini.asc \
 && wget --quiet "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini" -O /usr/local/bin/tini \
 && gpg --verify tini.asc /usr/local/bin/tini \
 && chmod +x /usr/local/bin/tini

FROM ubuntu:bionic-20180526

LABEL maintainer="sameer@damagehead.com"

ENV APT_CACHER_NG_VERSION=3.1 \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-cacher-ng=${APT_CACHER_NG_VERSION}* \
 && sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
 && sed 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' -i /etc/apt-cacher-ng/acng.conf \
 && rm -rf /var/lib/apt/lists/*

COPY --from=tini-installer /usr/local/bin/tini /usr/local/bin/tini

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3142/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/apt-cacher-ng"]
