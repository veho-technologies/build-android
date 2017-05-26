#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update \
    && apt-get install -y \
    libssl-dev g++ openssl

wget https://github.com/AGWA/git-crypt/archive/0.5.0.tar.gz
tar -xvzf 0.5.0.tar.gz
rm -f 0.5.0.tar.gz

cd git-crypt-0.5.0
make
make install PREFIX=/usr/local
cd ..
rm -Rf git-crypt-0.5.0
