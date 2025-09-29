
#FROM alpine:latest
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0-noble

WORKDIR /usr/src/app

COPY updater .
COPY healthcheck .
COPY install-dotnet .
COPY optimise-git .
COPY setup-git .
COPY setup-gpg .

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

#RUN apk add --no-cache \
#        bash \
#        ca-certificates \
#        curl  \
#        doas \
#        git \
#        gnupg \
#        icu-libs \
#        jq \
#        krb5-libs \
#        libgcc \
#        libintl \
#        libssl3 \
#        libstdc++ \
#        openssh \
#        zlib

RUN apt-get update && apt-get install -y \
        bash \
        ca-certificates \
        curl  \
        doas \
        git \
        gnupg \
        jq

# Add Updater group
RUN \
    # Add updater user \
    mkdir /local && \
    addgroup -S "updater" && \
    adduser -S -D "updater" -G "updater" -h /local && \
    chown updater:updater /local && \
    chmod 700 /local && \
    echo 'updater ALL=(ALL) NOPASSWD: ALL' > /etc/doas.d/doas.conf
#    echo 'permit nopass :updater as root' > /etc/doas.d/doas.conf

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