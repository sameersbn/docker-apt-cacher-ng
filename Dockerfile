FROM sameersbn/ubuntu:12.04.20140519
MAINTAINER sameer@damagehead.com

RUN apt-get update && \
		apt-get install -y apt-cacher-ng && \
		mkdir -p -m 755 /var/run/apt-cacher-ng && \
		chown apt-cacher-ng:apt-cacher-ng /var/run/apt-cacher-ng && \
		apt-get clean # 20140625

ADD assets/ /app/
RUN chmod 755 /app/init

EXPOSE 3142

VOLUME ["/var/cache/apt-cacher-ng"]

CMD ["/app/init"]
