# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

# Execute during the build of the image
ARG TEMPIO_VERSION BUILD_ARCH
RUN \
    curl -sSLf -o /usr/bin/tempio \
    "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}"

# HamClock supported resolutions are 800x480, 1600x960, 2400x1440 and 3200x1920 as of v3.02
ARG HAMCLOCK_RESOLUTION=1600x960

# Install updates and required packages
RUN apk update && apk upgrade
RUN apk add curl make g++ libx11-dev perl linux-headers

RUN mkdir /hamclock
WORKDIR /hamclock

# Download HamClock source
# Sort-of following Desktop build steps from https://www.clearskyinstitute.com/ham/HamClock/
#RUN curl -O https://www.clearskyinstitute.com/ham/HamClock/ESPHamClock.zip && \
#    unzip ESPHamClock.zip

# For some reason GitHub won't CURL from clearskyinstitute.com, so embed it in the repo temporarily
COPY ESPHamClock.zip /hamclock/ESPHamClock.zip
RUN unzip ESPHamClock.zip
WORKDIR /hamclock/ESPHamClock

# Change optimization level to -O2
# Fixes build failure on ARM64
RUN chmod 664 Makefile
RUN ls -alh Makefile
RUN sed -i 's/-O3/-O2/g' Makefile

# Let's build it
RUN make -j 4 hamclock-web-${HAMCLOCK_RESOLUTION}
RUN make install

USER root

# HamClock REST API
EXPOSE 8080/tcp
# HamClock Web UI
EXPOSE 8081/tcp

# Persist HamClock settings outside of container
VOLUME /root/.hamclock

# Healtheck - call REST API, give it 2 mins to get through setup
HEALTHCHECK --interval=30s --timeout=15s --start-period=30s --retries=3 CMD curl -f http://localhost:8081/live.html || exit 1

# Start HamClock
WORKDIR /hamclock/ESPHamClock

# Copy root filesystem
COPY rootfs /
RUN chmod -R +x /etc/services.d/hamclock/*
