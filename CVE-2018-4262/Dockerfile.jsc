FROM ubuntu:bionic as builder

RUN apt-get update && apt-get install -y git-core

RUN git clone --progress --verbose git://git.webkit.org/WebKit.git /WebKit

WORKDIR /WebKit

ENV COMMIT 3af5ce129e6636350a887d01237a65c2fce77823

RUN git checkout ${COMMIT}

RUN apt-get update && apt-get install -y libxml-libxml-perl \
                                         build-essential \
                                         ninja-build \
                                         libicu-dev \
                                         subversion \
                                         git-core \
                                         git-svn \
                                         python \
                                         bison \
                                         cmake \
                                         gperf \
                                         flex \
                                         ruby

RUN Tools/Scripts/set-webkit-configuration --debug
RUN Tools/Scripts/build-webkit --jsc-only --cmakeargs="-GNinja -DENABLE_UNIFIED_BUILDS=OFF"

#####################################################################################
FROM ubuntu:bionic

LABEL maintainer "https://github.com/blacktop"

ENV GDB_VERSION 8.1-0ubuntu3

RUN buildDeps='ca-certificates git build-essential python3-pip' \
  && dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install -yq $buildDeps \
                         python3 \
                         locales \
                         gdb=$GDB_VERSION \
                         gdb-multiarch=$GDB_VERSION \
  && echo "===> Fix locale..." \
  && locale-gen en_US.UTF-8 \
  && localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && echo "===> Install pwndbg..." \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  && pip3 install --upgrade pip wheel setuptools \
  && cd /root \
  && git clone https://github.com/pwndbg/pwndbg \
  && cd pwndbg \
  && ./setup.sh \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/*

RUN apt-get update && apt-get install -y bubblewrap rlwrap \
  && echo "===> Clean up unnecessary files..." \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/*

COPY --from=builder /WebKit/WebKitBuild/Debug/bin /webkit/WebKitBuild/Debug/bin
COPY --from=builder /WebKit/WebKitBuild/Debug/lib /webkit/WebKitBuild/Debug/lib

WORKDIR /webkit/WebKitBuild/Debug

ENV LD_LIBRARY_PATH=/webkit/WebKitBuild/Debug/lib

ENV LC_ALL en_US.UTF-8
ENV TERM screen-256color
ENV PYTHONIOENCODING UTF-8
ENV RLWRAP_HOME /data

ENTRYPOINT ["bin/jsc"]
CMD ["--help"]

LABEL Name=docker-webkit Version=3af5ce129e6636350a887d01237a65c2fce77823
