[![Circle CI](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng.svg?style=shield)](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng) [![Docker Repository on Quay.io](https://quay.io/repository/sameersbn/apt-cacher-ng/status "Docker Repository on Quay.io")](https://quay.io/repository/sameersbn/apt-cacher-ng)

# sameersbn/apt-cacher-ng:3.1

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Command-line arguments](#command-line-arguments)
  - [Persistence](#persistence)
  - [Docker Compose](#docker-compose)
  - [Usage](#usage)
  - [Logs](#logs)
- [Maintenance](#maintenance)
  - [Cache expiry](#cache-expiry)
  - [Upgrading](#upgrading)
  - [Shell Access](#shell-access)

# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [Apt-Cacher NG](https://www.unix-ag.uni-kl.de/~bloch/acng/).

Apt-Cacher NG is a caching proxy, specialized for package files from Linux distributors, primarily for [Debian](http://www.debian.org/) (and [Debian based](https://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based)) distributions but not limited to those.

## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](../../issues?q=is%3Aopen+is%3Aissue).
- Support the development of this image with a [donation](http://www.damagehead.com/donate/)

## Issues

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](../../issues/new) along with the following information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Boot2Docker](http://www.boot2docker.io), [VirtualBox](https://www.virtualbox.org), etc.

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/sameersbn/apt-cacher-ng) and is the recommended method of installation.

> **Note**: Builds are also available on [Quay.io](https://quay.io/repository/sameersbn/apt-cacher-ng)

```bash
docker pull sameersbn/apt-cacher-ng:3.1
```

Alternatively you can build the image yourself.

```bash
docker build -t sameersbn/apt-cacher-ng github.com/sameersbn/docker-apt-cacher-ng
```

## Quickstart

Start Apt-Cacher NG using:

```bash
docker run --name apt-cacher-ng --init -d --restart=always \
  --publish 3142:3142 \
  --volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
  sameersbn/apt-cacher-ng:3.1
```

*Alternatively, you can use the sample [docker-compose.yml](docker-compose.yml) file to start the container using [Docker Compose](https://docs.docker.com/compose/)*

## Command-line arguments

You can customize the launch command of Apt-Cacher NG server by specifying arguments to `apt-cacher-ng` on the `docker run` command. For example the following command prints the help menu of `apt-cacher-ng` command:

```bash
docker run --name apt-cacher-ng --init -it --rm \
  --publish 3142:3142 \
  --volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
  sameersbn/apt-cacher-ng:3.1 -h
```

## Persistence

For the cache to preserve its state across container shutdown and startup you should mount a volume at `/var/cache/apt-cacher-ng`.

> *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/apt-cacher-ng
chcon -Rt svirt_sandbox_file_t /srv/docker/apt-cacher-ng
```

## Docker Compose

To run Apt-Cacher NG with Docker Compose, create the following `docker-compose.yml` file

```yaml
---
version: '3'

services:
  apt-cacher-ng:
    image: sameersbn/apt-cacher-ng
    container_name: apt-cacher-ng
    ports:
      - "3142:3142"
    volumes:
      - apt-cacher-ng:/var/cache/apt-cacher-ng
    restart: always

volumes:
  apt-cacher-ng:
```

The Apt-Cache NG service can then be started in the background with:

```bash
docker-compose up -d
```

## Usage

To start using Apt-Cacher NG on your Debian (and Debian based) host, create the configuration file `/etc/apt/apt.conf.d/01proxy` with the following content:

```config
Acquire::HTTP::Proxy "http://172.17.0.1:3142";
Acquire::HTTPS::Proxy "false";
```

Similarly, to use Apt-Cacher NG in you Docker containers add the following line to your `Dockerfile` before any `apt-get` commands.

```dockerfile
RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
 && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
```

## Logs

To access the Apt-Cacher NG logs, located at `/var/log/apt-cacher-ng`, you can use `docker exec`. For example, if you want to tail the logs:

```bash
docker exec -it apt-cacher-ng tail -f /var/log/apt-cacher-ng/apt-cacher.log
```

# Maintenance

## Cache expiry

Using the [Command-line arguments](#command-line-arguments) feature, you can specify the `-e` argument to initiate Apt-Cacher NG's cache expiry maintenance task.

```bash
docker run --name apt-cacher-ng --init -it --rm \
  --publish 3142:3142 \
  --volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
  sameersbn/apt-cacher-ng:3.1 -e
```

The same can also be achieved on a running instance by visiting the url http://localhost:3142/acng-report.html in the web browser and selecting the **Start Scan and/or Expiration** option.

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull sameersbn/apt-cacher-ng:3.1
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
  docker run --name apt-cacher-ng --init -d \
    [OPTIONS] \
    sameersbn/apt-cacher-ng:3.1
  ```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it apt-cacher-ng bash
```
