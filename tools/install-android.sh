#!/bin/bash

mkdir -p $ANDROID_HOME \
    && mkdir -p /root/.android \
    && mv /tmp/licenses $ANDROID_HOME/licenses \
    && touch /root/.android/repositories.cfg \
    && cd $ANDROID_HOME \
    && wget $ANDROID_SDK_URL \
    && unzip $ANDROID_SDK_FILE \
    && export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools \
    && chgrp -R users $ANDROID_HOME \
    && chmod -R 0775 $ANDROID_HOME \
    && rm $ANDROID_SDK_FILE

/opt/tools/accept-licenses.sh sdkmanager platform-tools "platforms;android-23" "build-tools;23.0.1" "build-tools;23.0.3" "extras;android;m2repository" "extras;google;m2repository"  "system-images;android-23;default;x86_64"

# install react native
npm install -g react-native-cli
