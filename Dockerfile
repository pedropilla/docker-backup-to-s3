FROM alpine:latest
MAINTAINER Pedro Pilla <pedropilla@gmail.com>

RUN \
  echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories && \
  echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories && \
  apk update && \
  apk add --no-cache dumb-init python3 py-pip

RUN pip install s3cmd

ADD s3cfg /root/.s3cfg

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD sync.sh /sync.sh
RUN chmod +x /sync.sh

ADD get.sh /get.sh
RUN chmod +x /get.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
