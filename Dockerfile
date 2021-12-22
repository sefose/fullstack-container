ARG BASE_VERSION
FROM sefose/code-server:$BASE_VERSION

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y \
    apt-transport-https \
    gnupg-agent \
    software-properties-common \
    openjdk-17-jdk \
    maven \
    nodejs \
    vim \
    git \
    sudo \
    wget \
    && rm -rf /var/lib/apt/lists/*

# install kubectl and helm
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    curl https://baltocdn.com/helm/signing.asc | apt-key add - && \
    apt-get install apt-transport-https --yes && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && apt-get install -y \
    helm \
    kubectl
# install docker
ARG DOCKER_VERSION
RUN wget -O docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" && \
    tar --extract \
        --file docker.tgz \
        --strip-components 1 \
        --directory /usr/local/bin/  &&\
        rm docker.tgz

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
    coder && \
    echo "coder:changeme" | chpasswd 


RUN ln -s /lib/systemd/system/code-server@.service. /etc/systemd/system/default.target.wants/code-server@coder.service