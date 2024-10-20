
FROM alpine:latest

WORKDIR /usr/src/app

COPY updater .

RUN apk add --no-cache \
        bash \
        ca-certificates \
        curl  \
        krb5-libs \
        libgcc \
        libintl \
        libssl3 \
        libstdc++ \
        openssh \
        zlib


RUN \
    curl https://dot.net/v1/dotnet-install.sh -L -o /usr/src/app/dotnet-install.sh; \
    chmod +x /usr/src/app/dotnet-install.sh; \
    mkdir /tracking; \
    mkdir /work; \
    mkdir /dotnet

ENTRYPOINT [ "/usr/src/app/updater" ]

ENV DOTNET_CHANNELS="$DOTNET_CHANNELS"
ENV REPOS_LIST="$REPOS_LIST"
ENV PACKAGES="$PACKAGES"
ENV TEMPLATE="$TEMPLATE"