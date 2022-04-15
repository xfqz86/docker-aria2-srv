FROM alpine:3.15.4
LABEL CHENGTONG="xfqz86@gmail.com"

RUN set -xe &&\
    apk add --no-cache aria2=1.36.0-r0 &&\
    rm -rf /var/cache/apk/* /tmp/*

COPY root/ /
RUN chmod +x /entrypoint.sh

VOLUME [ "/downloads", "/config" ]

EXPOSE 6800 6888 6888/udp

ENTRYPOINT ["/entrypoint.sh"]