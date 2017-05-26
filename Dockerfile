FROM ruby:latest

MAINTAINER Daniel Holzmann <d@velopment.at>

ENV PATH $PATH:node_modules/.bin

# NVM and node
ENV NODE_VERSION 7.10.0
ENV NVM_DIR /usr/local/nvm
ENV NVM_VERSION 0.33.2

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Android SDK
ENV ANDROID_SDK_FILE sdk-tools-linux-3859397.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/$ANDROID_SDK_FILE

ENV ANDROID_HOME /usr/local/android-sdk-linux

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/23.0.3

COPY licenses /tmp/licenses

# Fastlane
ENV FASTLANE_VERSION=2.35.0

# setup user
ENV USERNAME dev

# Tell gradle to store dependencies in a sub directory of the android project
# this persists the dependencies between builds
ENV GRADLE_USER_HOME /home/$USERNAME/app/android/gradle_deps

# run install scripts
COPY tools /opt/tools
RUN /opt/tools/install.sh

USER $USERNAME

# install AWS CLI
ENV PATH $PATH:/home/$USERNAME/.local/bin
RUN /opt/tools/install-aws-cli.sh

# Set workdir
# You'll need to run this image with a volume mapped to /home/dev (i.e. -v $(pwd):/home/dev) or override this value
WORKDIR /home/$USERNAME/app
