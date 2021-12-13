FROM ubuntu:20.04

RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    openjdk-17-jdk \
    maven \
    nodejs \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88

RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
RUN apt-get update && apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io

# add user for coding
## create group for user
RUN groupadd coder --gid 1000
## create user
RUN useradd \
    --create-home \
    --shell /bin/bash \
    --groups sudo \
    --uid 1000 \
    --gid 1000 \
    coder

# install code-server
# RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN VSC_VERSION=3.12.0 && curl -fOL https://github.com/cdr/code-server/releases/download/v${VSC_VERSION}/code-server_${VSC_VERSION}_amd64.deb && \
    dpkg -i code-server_${VSC_VERSION}_amd64.deb && \
    rm code-server_${VSC_VERSION}_amd64.deb

RUN ln -s /lib/systemd/system/code-server@.service. /etc/systemd/system/default.target.wants/code-server@coder.service

ENTRYPOINT ["/sbin/init"]