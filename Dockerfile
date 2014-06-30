FROM sameersbn/ubuntu:12.04.20140519
MAINTAINER sameer@damagehead.com

RUN apt-get update && \
		apt-get install -y apt-cacher-ng && \
		apt-get clean # 20140625

ADD assets/ /app/
RUN chmod 755 /app/init /app/setup/install
RUN /app/setup/install

EXPOSE 3142

VOLUME ["/var/cache/apt-cacher-ng"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
