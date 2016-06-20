FROM lch82327/docker-ryu

MAINTAINER Vicky Li <vickyli.tw@gmail.com>

# development tool, numpy and scipy prerequisite
RUN apt-get update && apt-get install -y --no-install-recommends \
                        build-essential \
                        gfortran \
                        libatlas-base-dev \
                        python-dev \
                        curl \
                   && rm -rf /var/lib/apt/lists/*

# Node.js 6.x Installation
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs

# Install rpy-ryu server
RUN wget -O /opt/rpc-ryu.zip "https://github.com/hsnl-dev/rpc-ryu/archive/master.zip" --no-check-certificate && \
    unzip -q /opt/rpc-ryu.zip -d /opt && \
    mv /opt/rpc-ryu-master /opt/ryu/rpc-ryu && \
    cd /opt/ryu/rpc-ryu && npm install

# Download vCPE hub
RUN wget -O /opt/vcpe-hub.zip "https://github.com/hsnl-dev/vcpe-hub/archive/master.zip" --no-check-certificate && \
    unzip -q /opt/vcpe-hub.zip -d /opt && \
    mv /opt/vcpe-hub-master /opt/ryu

# vCPE hub dependencies package
RUN pip install -U networkx numpy scipy requests

# Clean up APT when done.
RUN apt-get clean && rm -rf /opt/vcpe-hub.zip /opt/rpc-ryu.zip

# Define working directory.
WORKDIR /opt/ryu

CMD ["DEBUG=rpc-ryu:*", "node", "./rpc-ryu/bin/www"]
