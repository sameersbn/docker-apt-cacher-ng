# Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Data Store](#data-store)
- [Upgrading](#upgrading)

# Introduction
Dockerfile to build a apt-cacher-ng container.

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

Create a file named `/etc/apt/apt.conf.d/01proxy` on your host with the following content:
```
Acquire::http { Proxy "http://127.0.0.1:3142"; };
```

Similarly you can add the following line in your dockerfiles so that the cache is made use of during package installation.

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
