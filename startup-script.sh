#!/usr/bin/env bash

# Add key and MongoDB-repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Update APT and install: Ruby, Bundler, MongoDB
apt update
apt install -y mongodb-org ruby-full ruby-bundler build-essential

# Start MongoDB
systemctl start mongod

# Add MongoDB to autostart
systemctl enable mongod

sudo -i -u appuser bash << EOF
cd /home/appuser
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
puma -d
EOF
