FROM ubuntu:latest

COPY 01proxy /etc/apt/apt.conf.d/
COPY apt-proxy-detect.sh /usr/local/bin/

RUN apt-get update && \
    apt-get install -y netcat && \
    apt-get upgrade -y
