ARG BUILD_FROM=chrisromp/hamclock-docker:latest
FROM $BUILD_FROM

# Install prerequisites
RUN apk add --no-cache curl bash jq tar

# Set up the architecture for multiarch builds
ARG BUILD_ARCH
RUN echo "Building for architecture: ${BUILD_ARCH}"

# Map BUILD_ARCH to s6-overlay architecture names
RUN case "${BUILD_ARCH}" in \
        "amd64") export S6_ARCH="x86_64" ;; \
        "armv7") export S6_ARCH="armhf" ;; \
        "arm64") export S6_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture ${BUILD_ARCH}" && exit 1 ;; \
    esac && \
    curl -L -o /tmp/s6-overlay-noarch.tar.xz https://github.com/just-containers/s6-overlay/releases/download/v3.1.5.0/s6-overlay-noarch.tar.xz && \
    curl -L -o /tmp/s6-overlay-${S6_ARCH}.tar.xz https://github.com/just-containers/s6-overlay/releases/download/v3.1.5.0/s6-overlay-${S6_ARCH}.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz && \
    rm -f /tmp/s6-overlay-noarch.tar.xz /tmp/s6-overlay-${S6_ARCH}.tar.xz

# Add bashio (thx https://github.com/hassio-addons/addon-debian-base/blob/main/base/Dockerfile#L47)
ADD https://github.com/hassio-addons/bashio/archive/v0.15.0.tar.gz /tmp/bashio.tar.gz
RUN mkdir /tmp/bashio && \
    tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio && \
    mv /tmp/bashio/lib /usr/lib/bashio && \
    ln -s /usr/lib/bashio/bashio /usr/bin/bashio && \
    rm -rf /tmp/bashio /tmp/bashio.tar.gz

# Add the nice banner
ADD https://raw.githubusercontent.com/hassio-addons/addon-debian-base/v5.1.0/base/rootfs/etc/cont-init.d/00-banner.sh /etc/s6-overlay/s6-rc.d/banner/
RUN mkdir -p /etc/s6-overlay/s6-rc.d/banner && \
    echo "oneshot" > /etc/s6-overlay/s6-rc.d/banner/type && \
    echo "/etc/s6-overlay/s6-rc.d/banner/script" > /etc/s6-overlay/s6-rc.d/banner/up && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/banner && \
    mv /etc/s6-overlay/s6-rc.d/banner/00-banner.sh /etc/s6-overlay/s6-rc.d/banner/script && \
    chmod +x /etc/s6-overlay/s6-rc.d/banner/script && \
    sed -i '1 s/^.*$/#!\/command\/with-contenv bashio/' /etc/s6-overlay/s6-rc.d/banner/script

# Create the hamclock service with the correct working directory
RUN mkdir -p /etc/s6-overlay/s6-rc.d/hamclock && \
    echo "#!/bin/sh" > /etc/s6-overlay/s6-rc.d/hamclock/run && \
    echo "cd /hamclock/ESPHamClock && exec /usr/local/bin/hamclock -o" >> /etc/s6-overlay/s6-rc.d/hamclock/run && \
    chmod +x /etc/s6-overlay/s6-rc.d/hamclock/run && \
    echo "longrun" > /etc/s6-overlay/s6-rc.d/hamclock/type

# Add HEALTHCHECK for hamclock service
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD s6-svstat /var/run/s6/services/hamclock | grep -q "up (pid" || exit 1

# enhance timeout, as sometimes the api calls are slow (rate limited?)
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=30000

# Set s6-overlay as the entrypoint
ENTRYPOINT ["/init"]
