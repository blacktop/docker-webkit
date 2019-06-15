FROM ubuntu:bionic as builder

LABEL maintainer "https://github.com/blacktop"

RUN apt-get update && apt-get install -y git-core git-svn cmake build-essential
RUN git clone git://git.webkit.org/WebKit.git /WebKit \
    && cd /WebKit \
    && Tools/Scripts/webkit-patch setup-git-clone \
    && Tools/gtk/install-dependencies \
    && Tools/Scripts/update-webkitgtk-libs \
    && Tools/Scripts/set-webkit-configuration --debug \
    && Tools/Scripts/build-webkit --gtk --cmakeargs="-GNinja" MiniBrowser

####################################################################################################
FROM ubuntu:bionic

RUN apt-get update && apt-get install -y bubblewrap

COPY --from=builder /WebKit /WebKit

WORKDIR /WebKit

ENTRYPOINT ["Tools/Scripts/run-minibrowser"]
CMD ["--gtk"]

LABEL Name=docker-webkit Version=0.0.1
