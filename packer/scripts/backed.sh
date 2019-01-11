#!/usr/bin/env bash

# Add key and MongoDB-repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Update APT and install: Ruby, Bundler, MongoDB
apt update
apt install -y mongodb-org ruby-full ruby-bundler build-essential

# Add MongoDB to autostart
systemctl enable mongod

sudo -i -u appuser bash << EOF
cd /home/appuser
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
EOF

# Add systemd-unit fot puma
cat <<EOT > /etc/systemd/system/puma.service
[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
# Foreground process (do not use --daemon in ExecStart or config.rb)
Type=simple

# Preferably configure a non-privileged user
User=appuser
Group=appuser

# Specify the path to your puma application root
WorkingDirectory=/home/appuser/reddit

ExecStart=/usr/local/bin/puma

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOT

# Add puma to autostart
systemctl enable puma
