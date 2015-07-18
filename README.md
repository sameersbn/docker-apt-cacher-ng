[![Circle CI](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng.svg?style=svg)](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng)

# Table of Contents

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Persistence](#persistence)
  - [Usage](#usage)
- [Maintenance](#maintenance)
  - [Upgrading](#upgrading)
  - [Shell Access](#shell-access)

# Introduction

`Dockerfile` to create a Docker container image for [Apt-Cacher NG](https://www.unix-ag.uni-kl.de/~bloch/acng/).

Apt-Cacher NG is a caching proxy, specialized for package files from Linux distributors, primarily for Debian (and Debian based) distributions but not limited to those.

## Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/sameersbn/docker-apt-cacher-ng/issues) they may encounter
- Support the development of this image with a [donation](http://www.damagehead.com/donate/)

## Issues

Before reporting your issue please try updating the Docker version on your Docker host and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) which provides installation instructions for all supported platforms and distributions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](https://github.com/sameersbn/docker-apt-cacher-ng/issues/new) with the following additional information:

- The host distribution and release version.
- Output of the `docker version` command
- Output of the `docker info` command
- The `docker run` command you used to run the image (you may mask out the sensitive bits).

# Getting started

## Installation

This image is available as a [trusted build](//hub.docker.com/u/sameersbn/apt-cacher-ng) on the [Docker hub](//hub.docker.com) and is the recommended method of installation.

```bash
docker pull sameersbn/apt-cacher-ng:latest
```

Alternatively you can build the image yourself.

```bash
git clone https://github.com/sameersbn/docker-apt-cacher-ng.git
cd docker-apt-cacher-ng
docker build --tag $USER/apt-cacher-ng .
```

## Quickstart

Start Apt-Cacher NG using:

```bash
docker run --name apt-cacher-ng -d --restart=always \
  --publish 3142:3142 \
  --volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
  sameersbn/apt-cacher-ng:latest
```

## Persistence

For the cache to preserve its state across container shutdown and startup you should mount a volume at `/var/cache/apt-cacher-ng`.

> **Note**: *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

## Usage

To start using Apt-Cacher NG on your Debian (and Debian based) host, create the configuration file `/etc/apt/apt.conf.d/01proxy` with the following content:

```bash
Acquire::http { Proxy "http://172.17.42.1:3142"; };
```

Similarly, to use Apt-Cacher NG in you Docker containers add the following line to your `Dockerfile` before any `apt-get` commands.

```dockerfile
RUN echo 'Acquire::http { Proxy "http://172.17.42.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy
```

# Maintenance

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull sameersbn/apt-cacher-ng:latest
  ```

  2. Stop the currently running image:

  ```bash
  docker stop apt-cacher-ng
  ```

  3. Remove the stopped container

  ```bash
  docker rm -v apt-cacher-ng
  ```

  4. Start the updated image

  ```bash
  docker run -name apt-cacher-ng -d \
    [OPTIONS] \
    sameersbn/apt-cacher-ng:latest
  ```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it apt-cacher-ng bash
```
