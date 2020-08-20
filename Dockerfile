FROM alpine as builder

RUN apk add --no-cache --virtual gtkwave-build-dependencies \
    git \
    build-base \
    autoconf \
    automake \
    tcl-dev \
    tk-dev \
    gperf \
    xz-dev \
    gtk+3.0-dev

RUN git clone --depth 1 https://github.com/gtkwave/gtkwave /gtkwave

WORKDIR /gtkwave/gtkwave3-gtk3

RUN ./autogen.sh

RUN ./configure --prefix=/opt/gtkwave/ --enable-gtk3
RUN make
RUN make install

FROM 0x01be/xpra

COPY --from=builder /opt/gtkwave/ /opt/gtkwave/

RUN apk add --no-cache --virtual gtkwave-runtime-dependencies \
    libstdc++ \
    tcl \
    tk \
    ttf-freefont \
    gnome-icon-theme

ENV PATH $PATH:/opt/gtkwave/bin/

VOLUME /workspace
WORKDIR /workspace

ENV COMMAND "gtkwave"

