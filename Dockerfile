FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    git \
    build-base \
    autoconf \
    automake \
    tcl-dev \
    tk-dev \
    gperf \
    xz-dev \
    gtk+2.0-dev

RUN git clone --depth=1 https://github.com/gtkwave/gtkwave /gtkwave

WORKDIR /gtkwave/gtkwave3

RUN ./autogen.sh

RUN ./configure --prefix=/opt/gtkwave/
RUN make
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/gtkwave/ /opt/gtkwave/

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    gtk+2.0 \
    xf86-video-dummy \
    xorg-server

COPY ./xorg.conf /xorg.conf
#Xorg -noreset +extension GLX +extension RANDR +extension RENDER -logfile ./0.log -config ./xorg.conf :0
#ENV DISPLAY :0

ENV PATH $PATH:/opt/gtkwave/bin/

