[![Circle CI](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng.svg?style=svg)](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng)

# Table of Contents
- [Introduction](#introduction)
- [Contributing](#contributing)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Data Store](#data-store)
- [Shell Access](#shell-access)
- [Upgrading](#upgrading)

# Introduction
Dockerfile to build a apt-cacher-ng container.

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/sameersbn/docker-apt-cacher-ng/issues) they may encounter
- Send me a tip via [Bitcoin](https://www.coinbase.com/sameersbn) or using [Gratipay](https://gratipay.com/sameersbn/)

# Installation
Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```
docker pull sameersbn/apt-cacher-ng:latest
```

Alternately you can build the image yourself.

```
git clone https://github.com/sameersbn/docker-apt-cacher-ng.git
cd docker-apt-cacher-ng
docker build -t="$USER/apt-cacher-ng" .
```

# Quick Start
Run the image

```
docker run --name='apt-cacher-ng' -d -p 3142:3142 \
sameersbn/apt-cacher-ng:latest
```

To enabling caching on the host create the file `/etc/apt/apt.conf.d/01proxy` with the following content:
```
Acquire::http { Proxy "http://127.0.0.1:3142"; };
```

Similarly to enable caching in your docker containers you can add the following line in your Dockerfile so that the cache is made use of during package installation.

```dockerfile
RUN echo 'Acquire::http { Proxy "http://172.17.42.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy
```

# Data Store
You should mount a volume at `/var/cache/apt-cacher-ng` so that you can reuse the existing cache if the container is stopped and started.

```
docker run --name='apt-cacher-ng' -d -p 3142:3142 \
-v /opt/apt-cacher-ng:/var/cache/apt-cacher-ng \
sameersbn/apt-cacher-ng:latest
```

# Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using docker version `1.3.0` or higher you can access a running containers shell using `docker exec` command.

```bash
docker exec -it apt-cacher-ng bash
```

If you are using an older version of docker, you can use the [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html) linux tool (part of the util-linux package) to access the container shell.

Some linux distros (e.g. ubuntu) use older versions of the util-linux which do not include the `nsenter` tool. To get around this @jpetazzo has created a nice docker image that allows you to install the `nsenter` utility and a helper script named `docker-enter` on these distros.

To install `nsenter` execute the following command on your host,

```bash
docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
```

Now you can access the container shell using the command

```bash
sudo docker-enter apt-cacher-ng
```

For more information refer https://github.com/jpetazzo/nsenter

# Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Update the docker image.

```
docker pull sameersbn/apt-cacher-ng:latest
```

- **Step 2**: Stop the currently running image

```
docker stop bind
```

- **Step 3**: Start the image

```
docker run -name bind -d [OPTIONS] sameersbn/apt-cacher-ng:latest
```
