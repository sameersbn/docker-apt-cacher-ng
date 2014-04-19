# Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Store](#data-store)
    - [Securing the server](#securing-the-server)
    - [Allowing remote access](#allowing-remote-access)
- [Maintenance](#maintenance)
    - [SSH Login](#ssh-login)

# Introduction
Dockerfile to build a redis container image which can be linked to other containers.

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```
docker pull sameersbn/redis:latest
```

Alternately you can build the image yourself.

```
git clone https://github.com/sameersbn/docker-redis.git
cd docker-redis
docker build -t="$USER/redis" .
```

# Quick Start
Run the redis image

```
docker run -name redis -d sameersbn/redis:latest
REDIS_IP=$(docker inspect redis | grep IPAddres | awk -F'"' '{print $4}')
```

To test if the redis server is configured properly, try connecting to the server.

```
redis-cli -h ${REDIS_IP}
```

# Configuration

## Data Store
You should mount a volume at /var/lib/redis.

```
mkdir -p /opt/redis
docker run -name redis -d \
  -v /opt/redis:/var/lib/redis sameersbn/redis:latest
```

This will make sure that the data stored in the database is not lost when the image is stopped and started again.

# Maintenance

## SSH Login
There are two methods to gain root login to the container, the first method is to add your public rsa key to the authorized_keys file and build the image.

The second method is use the dynamically generated password. Every time the container is started a random password is generated using the pwgen tool and assigned to the root user. This password can be fetched from the docker logs.

```
docker logs redis 2>&1 | grep '^User: ' | tail -n1
```
This password is not persistent and changes every time the image is executed.

# Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Stop the currently running image

```
docker stop redis
```

- **Step 2**: Update the docker image.

```
docker pull sameersbn/redis:latest
```

- **Step 3**: Start the image

```
docker run -name redis -d [OPTIONS] sameersbn/redis:latest
```
