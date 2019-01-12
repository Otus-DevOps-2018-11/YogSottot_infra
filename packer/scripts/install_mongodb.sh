#!/usr/bin/env bash

# Add key and repo MongoDB
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Update the index of available packages and install the required package.
apt update
apt install -y mongodb-org

# Add to autostart:
systemctl enable mongod
