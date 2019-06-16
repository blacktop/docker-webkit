<p align="center">
  <a href="https://github.com/blacktop/docker-webkit"><img alt="Logo" src="https://github.com/blacktop/docker-webkit/raw/master/docs/logo.png" height="140" /></a>
  <a href="https://github.com/blacktop/docker-webkit"><h3 align="center">docker-webkit</h3></a>
  <p align="center">Dockerized WebKit Dev/Research Environment</p>
  <p align="center">
    <a href="https://hub.docker.com/r/blacktop/webkit/" alt="Docker Stars">
          <img src="https://img.shields.io/docker/stars/blacktop/webkit.svg" /></a>
    <a href="https://hub.docker.com/r/blacktop/webkit/" alt="Docker Pulls">
          <img src="https://img.shields.io/docker/pulls/blacktop/webkit.svg" /></a>
    <a href="https://hub.docker.com/r/blacktop/webkit/" alt="Docker Image">
          <img src="https://img.shields.io/badge/docker%20image-10GB-blue.svg" /></a>
</p>

---

## Dependencies

- [ubuntu:bionic](https://hub.docker.com/_/ubuntu/)

## Image Tags

```bash
$ docker images

REPOSITORY           TAG               SIZE
blacktop/webkit      minibrowser       40.1MB
blacktop/webkit      jsc               40.1MB
```

## Getting Started

> :warning: You shouldn't run docker containers from the internet with these `--cap` and `--security-opt` unless you know what you are doing.

```bash
$ docker run --init -it --rm \
             --cap-add=SYS_PTRACE \
             --security-opt seccomp:unconfined \
             blacktop/webkit:jsc

>>> print("HALP!");
HALP!
```
