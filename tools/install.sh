#!/bin/bash

set -e

# install NVM and node
curl -o- "https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh" | bash \
    && . /root/.bashrc \
    && nvm i $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

/opt/tools/install-java.sh
/opt/tools/install-android.sh
/opt/tools/install-fastlane.sh
/opt/tools/install-git-crypt.sh
/opt/tools/setup-user.sh

# clean up
apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && npm cache clear