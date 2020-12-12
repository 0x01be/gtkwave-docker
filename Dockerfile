FROM 0x01be/base as build

ENV REVISION=master
RUN apk add --no-cache --virtual gtkwave-build-dependencies \
    git \
    build-base \
    autoconf \
    automake \
    tcl-dev \
    tk-dev \
    gperf \
    xz-dev \
    gtk+3.0-dev &&\
    git clone --depth 1 --branch ${REVISION} https://github.com/gtkwave/gtkwave /gtkwave

WORKDIR /gtkwave/gtkwave3-gtk3

RUN ./autogen.sh &&\
    ./configure --prefix=/opt/gtkwave/ --enable-gtk3 &&\
     make
RUN make install

FROM 0x01be/xpra

COPY --from=build /opt/gtkwave/ /opt/gtkwave/

RUN apk add --no-cache --virtual gtkwave-runtime-dependencies \
    libstdc++ \
    tcl \
    tk 

USER ${USER}
ENV PATH=${PATH}:/opt/gtkwave/bin/ \
    COMMAND=gtkwave

