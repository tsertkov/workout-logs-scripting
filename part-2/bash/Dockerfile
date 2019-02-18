FROM alpine:latest

RUN \
  apk add --update \
    lynx bash coreutils rrdtool && \
    rm -rf /var/cache/apk/*

ADD stream2graph.sh /
ENTRYPOINT [ "/stream2graph.sh" ]
