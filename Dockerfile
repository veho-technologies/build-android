FROM ruby:latest

MAINTAINER Daniel Holzmann <d@velopment.at>

ENV PATH $PATH:node_modules/.bin

# install NVM and node
ENV NODE_VERSION 7.10.0
ENV NVM_DIR /usr/local/nvm
ENV NVM_VERSION 0.33.2

RUN touch /root/.bashrc \
    && curl -o- "https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh" | bash \
    && . /root/.bashrc \
    && nvm i $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# install Java and 32bit support for Android SDK
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386 \
    && apt-get update -q \
    && apt-get install --force-yes -y --no-install-recommends \
    sudo libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386 python python-dev \
    expect bzip2 unzip xz-utils

COPY tools /opt/tools
RUN /opt/tools/install-java.sh

# install Android SDK
ENV ANDROID_SDK_FILE sdk-tools-linux-3859397.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/$ANDROID_SDK_FILE

ENV ANDROID_HOME /usr/local/android-sdk-linux
RUN mkdir -p $ANDROID_HOME \
    && mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg \
    && cd $ANDROID_HOME \
    && wget $ANDROID_SDK_URL \
    && unzip $ANDROID_SDK_FILE \
    && export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools \
    && chgrp -R users $ANDROID_HOME \
    && chmod -R 0775 $ANDROID_HOME \
    && rm $ANDROID_SDK_FILE

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/23.0.3

COPY licenses /usr/local/android-sdk-linux/licenses
RUN ["/opt/tools/accept-licenses.sh", "sdkmanager platform-tools \"platforms;android-23\" \"build-tools;23.0.1\" \"build-tools;23.0.3\" \"extras;android;m2repository\" \"extras;google;m2repository\"  \"system-images;android-23;default;x86_64\""]

# install react native
RUN npm install -g react-native-cli

# clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && npm cache clear

# install fastlane
ENV FASTLANE_VERSION=2.35.0

RUN gem install fastlane:$FASTLANE_VERSION -NV

# Fix SSL certificates
RUN update-ca-certificates -f

# install git-crypt
RUN /opt/tools/install-git-crypt.sh

# setup user
ENV USERNAME dev

RUN adduser --disabled-password --gecos '' $USERNAME && \
    echo $USERNAME:$USERNAME | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    adduser $USERNAME sudo && \
    chown $USERNAME:$USERNAME $ANDROID_HOME

# Tell gradle to store dependencies in a sub directory of the android project
# this persists the dependencies between builds
ENV GRADLE_USER_HOME /home/$USERNAME/app/android/gradle_deps

USER $USERNAME

# install AWS CLI
ENV PATH $PATH:/home/$USERNAME/.local/bin
RUN /opt/tools/install-aws-cli.sh

# Set workdir
# You'll need to run this image with a volume mapped to /home/dev (i.e. -v $(pwd):/home/dev) or override this value
WORKDIR /home/$USERNAME/app
