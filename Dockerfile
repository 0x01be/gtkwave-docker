FROM alpine as build

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

ENV REVISION master
RUN git clone --depth 1 --branch ${REVISION} https://github.com/gtkwave/gtkwave /gtkwave

WORKDIR /gtkwave/gtkwave3-gtk3

RUN ./autogen.sh

RUN ./configure --prefix=/opt/gtkwave/ --enable-gtk3
RUN make
RUN make install

FROM 0x01be/xpra

RUN apk add --no-cache --virtual gtkwave-runtime-dependencies \
    libstdc++ \
    tcl \
    tk 

COPY --from=build /opt/gtkwave/ /opt/gtkwave/

USER xpra
ENV PATH $PATH:/opt/gtkwave/bin/
ENV COMMAND gtkwave

