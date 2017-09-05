FROM resin/rpi-raspbian:wheezy
MAINTAINER Eduardo Quintana <eddiarnoldo<at>hotmail.com>

ENV ERLANG_VERSION=20.0 \
    ERLANG_SHA=548815fe08f5b661d38334ffa480e9e0614db5c505da7cb0dc260e729697f2ab

ENV DEBIAN_FRONTEND=noninteractive \
    OTP_VERSION=OTP-${ERLANG_VERSION} \
    OTP_DOWNLOAD_SHA=${ERLANG_SHA} \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y \
    locales \
    build-essential \
    autoconf \
    libncurses5-dev \
    libssl-dev \
    curl \
    ca-certificates \
    procps \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN export LANG=en_US.UTF-8 \
    && echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG

RUN set -xe \
    && curl -SL https://github.com/erlang/otp/archive/${OTP_VERSION}.tar.gz -o otp-src.tar.gz \
    && echo "${OTP_DOWNLOAD_SHA}  otp-src.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/otp-src \
    && tar -xzC /usr/src/otp-src --strip-components=1 -f otp-src.tar.gz \
    && rm otp-src.tar.gz \
    && cd /usr/src/otp-src \
    && ./otp_build autoconf \
    && ./configure \
    && make -j $(nproc) \
    && make install \
    && rm -rf /usr/src/otp-src

CMD ["erl"]
