#!/bin/bash

cd $HOME
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
rm get-pip.py

pip install awscli --upgrade --user