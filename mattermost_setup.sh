#!/bin/bash

echo "INSTALLING MATTERMOST"
echo "Updating and Upgrading"
apt-get -q -y update > /dev/null
apt-get -q -y install jq
echo "Downloading mattermost"
wget --quiet https://releases.mattermost.com/5.5.1/mattermost-5.5.1-linux-amd64.tar.gz
echo "Extracting"
tar -xzf mattermost*.gz

rm mattermost*.gz
mv mattermost /opt

mkdir /opt/mattermost/data
rm /opt/mattermost/config/config.json

cp /vagrant/license.txt /opt/mattermost/license.txt

cp /vagrant/config.json /opt/mattermost/config/config.json

jq '.ClusterSettings.OverrideHostname = "#IP_ADDR"' /vagrant/config.json > /opt/mattermost/config/config.json

useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

cp /vagrant/mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload

service mattermost start