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

ENV DUMP /workspace/dump.vcd

COPY --from=builder /opt/gtkwave/ /opt/gtkwave/

RUN apk add --no-cache --virtual gtkwave-runtime-dependencies \
    tcl \
    tk \
    ttf-freefont \
    gnome-icon-theme

ENV PATH $PATH:/opt/gtkwave/bin/

EXPOSE 10000

VOLUME /workspace
WORKDIR /workspace

CMD /usr/bin/xpra start --bind-tcp=0.0.0.0:10000 --html=on --start-child="gtkwave --dump=$DUMP" --exit-with-children --daemon=no --xvfb="/usr/bin/Xvfb +extension  Composite -screen 0 1280x720x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no --mdns=no

