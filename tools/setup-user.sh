#!/bin/bash

adduser --disabled-password --gecos '' $USERNAME && \
    echo $USERNAME:$USERNAME | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    adduser $USERNAME sudo && \
    chown $USERNAME:$USERNAME $ANDROID_HOME