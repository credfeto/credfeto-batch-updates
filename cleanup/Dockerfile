FROM mcr.microsoft.com/dotnet/runtime-deps:10.0-noble

WORKDIR /usr/src/app

COPY updater .
COPY healthcheck .
COPY install-dotnet .
COPY optimise-git .
COPY setup-git .
COPY setup-gpg .
COPY setup-certificates .

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install prerequisites.
# Note fonts required for SixLabours.Fonts
RUN \
    apt-get update && \
    apt-get upgrade -y && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt-get install -y ttf-mscorefonts-installer --no-install-recommends && \
    apt-get install -y \
        bash \
        ca-certificates \
        curl  \
        git \
        gnupg \
        jq \
        sudo && \
    apt-get autoremove -y && \
    apt-get clean

# Add updater user
RUN \
    useradd \
           --create-home \
           --system \
           --user-group \
           --shell /bin/bash \
           --home-dir /local \
           --comment "Template updater" \
           "updater" && \
    echo 'updater ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/01_updater

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