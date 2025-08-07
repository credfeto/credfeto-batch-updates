
FROM alpine:latest

WORKDIR /usr/src/app

COPY updater .
COPY ../scripts/setup-gpg .
COPY ../scripts/install-dotnet .
COPY healthcheck .

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
        bash \
        ca-certificates \
        curl  \
        doas \
        git \
        gnupg \
        icu-libs \
        krb5-libs \
        libgcc \
        libintl \
        libssl3 \
        libstdc++ \
        openssh \
        zlib

# Add Updater group
RUN \
    # Add updater user \
    mkdir /local && \
    addgroup -S "updater" && \
    adduser -S -D "updater" -G "updater" -h /local && \
    chown updater:updater /local && \
    chmod 700 /local && \
    echo 'permit nopass :updater as root' > /etc/doas.d/doas.conf

USER updater

RUN \
    mkdir -p /local/tracking && \
    mkdir -p /local/work && \
    mkdir -p /local/dotnet && \
    mkdir -p /local/.ssh && \
    mkdir -p /local/.gnupg && \
    mkdir -p /local/downloads

ENTRYPOINT [ "/usr/src/app/updater" ]

ENV DOTNET_CHANNELS="$DOTNET_CHANNELS"
ENV REPOS_LIST="$REPOS_LIST"
ENV PACKAGES="$PACKAGES"
ENV TEMPLATE="$TEMPLATE"
ENV RELEASE="$$RELEASE"

HEALTHCHECK --interval=5s --timeout=2s --retries=3 --start-period=60s CMD [ "/usr/src/app/healthcheck" ]