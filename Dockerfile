FROM sameersbn/ubuntu:14.04.20150504
MAINTAINER sameer@damagehead.com

RUN apt-get update && \
    apt-get install -y apt-cacher-ng \
 && sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
 && rm -rf /var/lib/apt/lists/* # 20150504

ADD start /start
RUN chmod 755 /start

EXPOSE 3142
VOLUME ["/var/cache/apt-cacher-ng"]
CMD ["/start"]
