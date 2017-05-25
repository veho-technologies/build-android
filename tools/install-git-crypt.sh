#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update \
    && apt-get install -y \
    libssl-dev g++ openssl

wget https://github.com/AGWA/git-crypt/archive/debian/0.5.0-2.tar.gz
tar -xvzf 0.5.0-2.tar.gz
rm -f 0.5.0-2.tar.gz

cd git-crypt-debian-0.5.0-2
make
make install PREFIX=/usr/local
