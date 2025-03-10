FROM amd64/debian:buster

LABEL maintainer="marcus.edel@fu-berlin.de"

## For apt to be noninteractive.
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN truncate -s0 /tmp/preseed.cfg; \
    echo "tzdata tzdata/Areas select Europe" >> /tmp/preseed.cfg; \
    echo "tzdata tzdata/Zones/Europe select Berlin" >> /tmp/preseed.cfg; \
    debconf-set-selections /tmp/preseed.cfg && \
    rm -f /etc/timezone /etc/localtime

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    bzip2 \
    cmake \
    curl \
    gcc \
    g++ \
    git \
    make \
    pkg-config \
    python3.7 \
    python3-distutils \
    unzip \
    valgrind \
    xz-utils \
    libstb-dev \
    python3-pip \
    python3-setuptools \
    wget \
    libopenblas-dev \
    liblapack-dev \
    binutils-dev \
    libboost-all-dev \
    libcereal-dev \
    txt2man \
    doxygen \
    graphviz \
    sloccount \
    sudo \
    gnupg \
    build-essential \
    gcc-arm-linux-gnueabi \
    g++-arm-linux-gnueabi \
    gfortran-arm-linux-gnueabi \
    qemu-system-arm \
    g++-aarch64-linux-gnu \
    gcc-aarch64-linux-gnu \
    gfortran-aarch64-linux-gnu \
    qemu-system-aarch64 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip3 --no-cache-dir install --upgrade --ignore-installed cython numpy \
    pandas setuptools

# Install armadillo.
RUN curl -Lk https://sourceforge.net/projects/arma/files/armadillo-9.800.6.tar.xz | tar -xvJ && \
    cd armadillo* && \
    cmake . && \
    make && \
    sudo make install && \
    cd ..

# Install ensmallen.
RUN wget http://ensmallen.org/files/ensmallen-2.16.2.tar.gz && \
    tar -xf ensmallen-2.16.2.tar.gz && \
    cd ensmallen-2.16.2 && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make install

RUN useradd -ms /bin/bash jenkins

# Setup environment.
ENV LD_LIBRARY_PATH /usr/local/lib
USER jenkins
WORKDIR /home/jenkins
CMD /bin/bash
