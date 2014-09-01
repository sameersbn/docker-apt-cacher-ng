FROM sameersbn/ubuntu:14.04.20140818
MAINTAINER sameer@damagehead.com

RUN apt-get update && \
    apt-get install -y apt-cacher-ng && \
    sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf && \
    mkdir -p -m 755 /var/run/apt-cacher-ng && \
    chown apt-cacher-ng:apt-cacher-ng /var/run/apt-cacher-ng && \
    rm -rf /var/lib/apt/lists/* # 20140818

ADD start /start
RUN chmod 755 /start

EXPOSE 3142
VOLUME ["/var/cache/apt-cacher-ng"]
CMD ["/start"]
