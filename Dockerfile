ARG VERSION
FROM sefose/code-server:$VERSION

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

RUN ln -s /lib/systemd/system/code-server@.service. /etc/systemd/system/default.target.wants/code-server@coder.service

ENTRYPOINT ["/sbin/init"]