#!/bin/bash

wget https://github.com/stackrox/kube-linter/releases/download/v0.6.8/kube-linter-linux.tar.gz || exit
tar xvzf kube-linter-linux.tar.gz && rm kube-linter-linux.tar.gz || exit
sudo mv kube-linter /usr/local/bin/ || exit
sudo chmod +x /usr/local/bin/kube-linter 
echo "run the command 'kube-linter version'"
