ARG UBUNTU_VERSION=latest
FROM ubuntu:$UBUNTU_VERSION

ARG APT_CACHER_NG_IP
ARG APT_CACHER_NG_PORT=3142

RUN echo "Acquire::HTTP::Proxy \"http://$APT_CACHER_NG_IP:$APT_CACHER_NG_PORT\";" > /etc/apt/apt.conf.d/01proxy \
 && echo "Acquire::HTTPS::Proxy \"false\";" >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && \
    apt-get upgrade -y
