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
          <img src="https://img.shields.io/badge/docker%20image-946MB-blue.svg" /></a>
</p>

---

## Dependencies

- [ubuntu:bionic](https://hub.docker.com/_/ubuntu/)

## Image Tags

```bash
$ docker images

REPOSITORY           TAG               SIZE
blacktop/webkit      minibrowser       946MB
blacktop/webkit      jsc               946MB
```

## Getting Started

```bash
$ docker run --init -it --rm blacktop/webkit:jsc

>>> print("HALP!");
HALP!
```

### Run a javascript file

```bash
$ cat test.js

print(1+1);
```

```bash
$ docker run --init -it --rm -v `pwd`:/data blacktop/webkit:jsc /data/test.js

2
```

### Debugging

> ⚠️ You shouldn't run docker containers from the internet with these `--cap` and `--security-opt` unless you know what you are doing. ⚠️

```bash
$ docker run --init -it --rm \
             --cap-add=SYS_PTRACE \
             --security-opt seccomp:unconfined \
             --entrypoint=bash \
             blacktop/webkit:jsc

root@f7516eaa387a:/webkit/WebKitBuild/Debug# gdb bin/jsc

pwndbg> r
Starting program: /webkit/WebKitBuild/Debug/bin/jsc
warning: Error disabling address space randomization: Operation not permitted
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[New Thread 0x7ff0edf52700 (LWP 18)]
>>> describe([1,2,3,4])
Object: "0x7ff0acec01b0" with butterfly "0x7fe806be4010"
(Structure 0x7ff0acefe370:
      [Array, {}, CopyOnWriteArrayWithInt32, Proto:0x7ff0acec0010, Leaf]), StructureID: 64910
>>> ^C
```

#### Telecope the `Object`

```bash
pwndbg> tele 0x7ff0acec01b0
00:0000│   0x7ff0acec01b0 ◂— 0x10822150000fd8e
01:0008│   0x7ff0acec01b8 —▸ 0x7fe806be4010 ◂— 0xffff000000000001 <--------- 🦋
02:0010│   0x7ff0acec01c0 ◂— 0xbadbeef0
... ↓
```

#### Telecope the `butterfly` *(minus 8 to see the length)*

```bash
pwndbg> tele 0x7fe806be4010-8
00:0000│   0x7fe806be4008 ◂— 0x400000004         <--------- LENGTH
01:0008│   0x7fe806be4010 ◂— 0xffff000000000001  <--------- array values
02:0010│   0x7fe806be4018 ◂— 0xffff000000000002
03:0018│   0x7fe806be4020 ◂— 0xffff000000000003
04:0020│   0x7fe806be4028 ◂— 0xffff000000000004
05:0028│   0x7fe806be4030 ◂— 0xbadbeef0
```