FROM ubuntu:bionic

LABEL maintainer="brutalgg"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV \
  LANGUAGE="en_US.UTF-8" \
  LANG="en_US.UTF-8" \
  TZ="America/New_York" \
  TERM="xterm"

ADD ["https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz", "/tmp"]

RUN \
# Extract S6 overlay
  tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
# Update and get dependencies
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    locales \
    tzdata \
  && \
# Add user
  echo "**** create abc user and make folders ****" && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
   mkdir -p \
    /app \
    /config \
    /defaults && \
# Generate locale
  echo "**** generate locale ****" && \
  locale-gen en_US.UTF-8 && \
# Cleanup
  echo "**** cleanup ****" && \
  apt-get -y autoremove && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/*

COPY root/ /

ENTRYPOINT ["/init"]