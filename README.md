[![Circle CI](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng.svg?style=shield)](https://circleci.com/gh/sameersbn/docker-apt-cacher-ng)

# sameersbn/apt-cacher-ng

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Persistence](#persistence)
  - [Usage](#usage)
  - [Logs](#logs)
- [Maintenance](#maintenance)
  - [Cache expiry](#cache-expiry)
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

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) which provides installation instructions for all supported platforms and distributions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](https://github.com/sameersbn/docker-apt-cacher-ng/issues/new) with the following additional information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Please mask out the sensitive bits.

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

*Alternatively, you can use the sample [docker-compose.yml](docker-compose.yml) file to start the container using [Docker Compose](https://docs.docker.com/compose/)*

## Persistence

For the cache to preserve its state across container shutdown and startup you should mount a volume at `/var/cache/apt-cacher-ng`.

> **Note**: *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/apt-cacher-ng
sudo chcon -Rt svirt_sandbox_file_t /srv/docker/apt-cacher-ng
```

## Usage

To start using Apt-Cacher NG on your Debian (and Debian based) host, create the configuration file `/etc/apt/apt.conf.d/01proxy` with the following content:

```bash
Acquire::http { Proxy "http://172.17.42.1:3142"; };
```

Similarly, to use Apt-Cacher NG in you Docker containers add the following line to your `Dockerfile` before any `apt-get` commands.

```dockerfile
RUN echo 'Acquire::http { Proxy "http://172.17.42.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy
```

## Logs

To access the Apt-Cacher NG logs, located at `/var/log/apt-cacher-ng`, you can use `docker exec`. For example, if you want to tail the logs:

```bash
docker exec -it apt-cacher-ng tail -f /var/log/apt-cacher-ng/apt-cacher.log
```

# Maintenance

## Cache expiry

Arguments specified on the `docker run` command are passed on the `apt-cacher-ng` command. Using this feature, we can specify the `-e` argument to initiate the cache expiry maintenance task.

```bash
docker run --name apt-cacher-ng -it --rm \
  --publish 3142:3142 \
  --volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
  sameersbn/apt-cacher-ng:latest -e
```

The same can also be achieved on a running instance by visiting the url http://172.17.42.1:3142/acng-report.html in the web browser and selecting the **Start Scan and/or Expiration** option.

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
