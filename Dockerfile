FROM ubuntu:21.10

# installing needed packages 
RUN apt-get -y update && apt-get -y install \
    curl \
    openjdk-17-jdk \
    maven \
    podman \
    && rm -rf /var/lib/apt/lists/*

# installing node.js
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs


# install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# installing all updates
RUN apt-get -y update && apt-get -y upgrade


#ENTRYPOINT [ "/bin/sh" ]