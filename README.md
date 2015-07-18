[![Circle CI](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng.svg?style=svg)](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng)

# Table of Contents

- [Introduction](#introduction)
- [Contributing](#contributing)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Persistence](#persistence)
- [Shell Access](#shell-access)
- [Upgrading](#upgrading)

# Introduction

Dockerfile to build a [Apt-Cacher NG](https://www.unix-ag.uni-kl.de/~bloch/acng/) container.

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/sameersbn/docker-apt-cacher-ng/issues) they may encounter
- Support the development of this image with a [donation](http://www.damagehead.com/donate/)

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull sameersbn/apt-cacher-ng:latest
```

Alternatively you can build the image yourself.

```bash
git clone https://github.com/sameersbn/docker-apt-cacher-ng.git
cd docker-apt-cacher-ng
docker build --tag $USER/apt-cacher-ng .
```

# Quick Start

Run the image

```bash
docker run --name apt-cacher-ng -d \
    --publish 3142:3142 \
    sameersbn/apt-cacher-ng:latest
```

To enabling caching on the host create the file `/etc/apt/apt.conf.d/01proxy` with the following content:

```bash
Acquire::http { Proxy "http://127.0.0.1:3142"; };
```

Similarly to enable caching in your docker containers you can add the following line in your Dockerfile so that the cache is made use of during package installation.

```dockerfile
RUN echo 'Acquire::http { Proxy "http://172.17.42.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy
```

# Persistence

You should mount a volume at `/var/cache/apt-cacher-ng` so that you can reuse the existing cache if the container is stopped and started.

```bash
docker run --name apt-cacher-ng -d \
    --publish 3142:3142 \
    --volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
    sameersbn/apt-cacher-ng:latest
```

# Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using docker version `1.3.0` or higher you can access a running containers shell using `docker exec` command.

```bash
docker exec -it apt-cacher-ng bash
```

# Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Update the docker image.

```bash
docker pull sameersbn/apt-cacher-ng:latest
```

- **Step 2**: Stop the currently running image

```bash
docker stop bind
```

- **Step 3**: Start the image

```bash
docker run -name bind -d [OPTIONS] sameersbn/apt-cacher-ng:latest
```
