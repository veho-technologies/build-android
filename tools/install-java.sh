#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export JAVA_VERSION=8u131
export JAVA_DEBIAN_VERSION=8u131-b11-1~bpo8+1

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
export CA_CERTIFICATES_JAVA_VERSION=20161107~bpo8+1

echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
{ \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home

# install Java and 32bit support for Android SDK
set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install --force-yes -y --no-install-recommends \
        sudo libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386 python python-dev \
        expect bzip2 unzip xz-utils \
        openjdk-8-jre="$JAVA_DEBIAN_VERSION" \
        openjdk-8-jdk-headless="$JAVA_DEBIAN_VERSION" \
        openjdk-8-jre-headless="$JAVA_DEBIAN_VERSION" \
        openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
        ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
    && rm -rf /var/lib/apt/lists/* \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ]

# see CA_CERTIFICATES_JAVA_VERSION notes above
/var/lib/dpkg/info/ca-certificates-java.postinst configure