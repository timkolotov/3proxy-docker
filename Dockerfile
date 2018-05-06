FROM alpine:latest
LABEL maintainer="Tim Kolotov <timophey.kolotov@gmail.com>"

RUN echo -e '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update && apk add 3proxy@testing

COPY ./3proxy.cfg.tpl /etc/3proxy.cfg.tpl
COPY ./entrypoint.sh /opt/entrypoint.sh

EXPOSE 8080
EXPOSE 1080

ENTRYPOINT ["/opt/entrypoint.sh"]
