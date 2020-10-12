FROM linuxserver/piwigo:latest

LABEL maintainer="Jeffrey Phillips Freeman the@jeffreyfreeman.me"

RUN apk add --no-cache php7-curl
