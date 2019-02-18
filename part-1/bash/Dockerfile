FROM alpine:latest

RUN \
  apk add --update \
    lynx bash coreutils && \
    rm -rf /var/cache/apk/*

ADD emit-logs.sh /
ENTRYPOINT [ "/emit-logs.sh" ]
