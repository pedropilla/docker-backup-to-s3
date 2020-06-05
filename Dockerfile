FROM alpine:latest
MAINTAINER Pedro Pilla <pedropilla@gmail.com>

RUN \
  echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories && \
  echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories && \
  apk update && \
  apk add --no-cache dumb-init python3 py-pip && \
  pip install s3cmd

ADD s3cfg /root/.s3cfg

ADD start.sh sync.sh get.sh /

ENTRYPOINT ["/start.sh"]

CMD [""]
