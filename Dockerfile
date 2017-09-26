FROM hypriot/rpi-alpine
MAINTAINER Eduardo Quintana <eddiarnoldo@gmail.com>

ENV ERLANG_VERSION=20.0 \
    ERLANG_SHA=548815fe08f5b661d38334ffa480e9e0614db5c505da7cb0dc260e729697f2ab

ENV DEBIAN_FRONTEND=noninteractive \
    OTP_VERSION=OTP-${ERLANG_VERSION} \
    OTP_DOWNLOAD_SHA=${ERLANG_SHA} \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN apk --no-cache upgrade && \
    apk update && apk add \
    curl \
    make \
    tar \
    ncurses-dev \
    libressl-dev
    

RUN set -xe \
    && curl -SL https://github.com/erlang/otp/archive/${OTP_VERSION}.tar.gz -o otp-src.tar.gz \
    && mkdir -p /usr/src/otp-src \
    && tar -xzC /usr/src/otp-src --strip-components=1 -f otp-src.tar.gz \
    && rm otp-src.tar.gz \
    && cd /usr/src/otp-src \
    && ./configure \
    && make \
    && cd .. \
    && rm -rf /usr/src/otp-src

CMD ["erl"]

