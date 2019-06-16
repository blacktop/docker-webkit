# FROM ubuntu:bionic as cloner

# RUN apt-get update && apt-get install -y git-core git-svn
# RUN git clone git://git.webkit.org/WebKit.git /WebKit

#####################################################################################
FROM ubuntu:bionic as builder

RUN apt-get update && apt-get install -y wget

WORKDIR /tmp

RUN wget --progress=bar:force https://s3-us-west-2.amazonaws.com/archives.webkit.org/WebKit-SVN-source.tar.bz2
RUN tar jxvf WebKit-SVN-source.tar.bz2

WORKDIR /tmp/webkit

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

RUN DEBIAN_FRONTEND=noninteractive Tools/gtk/install-dependencies
RUN DEBIAN_FRONTEND=noninteractive Tools/Scripts/update-webkitgtk-libs
RUN Tools/Scripts/set-webkit-configuration --debug
RUN Tools/Scripts/build-webkit --gtk --cmakeargs="-GNinja" MiniBrowser

#####################################################################################
FROM ubuntu:bionic

LABEL maintainer "https://github.com/blacktop"

RUN apt-get update && apt-get install -y bubblewrap \
  && echo "===> Clean up unnecessary files..." \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/*

COPY --from=builder /tmp/webkit/WebKitBuild/Debug/bin /webkit/WebKitBuild/Debug/bin
COPY --from=builder /tmp/webkit/WebKitBuild/Debug/bin /webkit/WebKitBuild/Debug/bin
COPY --from=builder /tmp/webkit/Tools/Scripts /webkit/Tools/Scripts

ENV LD_LIBRARY_PATH=/webkit/WebKitBuild/Debug/lib

WORKDIR /webkit/WebKitBuild/Debug

ENTRYPOINT ["/webkit/Tools/Scripts"]
CMD ["--help"]

LABEL Name=docker-webkit Version=0.0.1
