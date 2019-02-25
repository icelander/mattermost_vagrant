#!/bin/bash

echo "INSTALLING MATTERMOST"
echo "Updating and Upgrading"
apt-get -q -y update > /dev/null
apt-get -q -y install jq
echo "Downloading mattermost"
# wget --quiet https://releases.mattermost.com/5.5.1/mattermost-5.5.1-linux-amd64.tar.gz

# TODO: Check if file exists and use that, otherwise download latest version
# TODO: Specify version

cp /vagrant/mattermost*.gz ./
echo "Extracting"
tar -xzf mattermost*.gz

rm mattermost*.gz
mv mattermost /opt

mkdir /opt/mattermost/data

ln -s /vagrant/license.txt /opt/mattermost/license.txt
mv /opt/mattermost/config/config.json /opt/mattermost/config/config.orig.json
jq '.ServiceSettings.LicenseFileLocation = "/opt/mattermost/license.txt"' /opt/mattermost/config/config.orig.json > /vagrant/config.tmp.json && mv /vagrant/config.tmp.json /vagrant/config.json
jq '.SqlSettings.DataSource = "mmuser:really_secure_password@tcp(192.168.33.101:3306)/mattermost?charset=utf8mb4,utf8\u0026readTimeout=30s\u0026writeTimeout=30s"' /vagrant/config.json > /vagrant/config.tmp.json && mv /vagrant/config.tmp.json /vagrant/config.json
jq '.ClusterSettings.Enable = true' /vagrant/config.json > /vagrant/config.tmp.json && mv /vagrant/config.tmp.json /vagrant/config.json
jq '.ClusterSettings.ClusterName = "Buster"' /vagrant/config.json > /vagrant/config.tmp.json && mv /vagrant/config.tmp.json /vagrant/config.json
jq '.ClusterSettings.OverrideHostname = "#IP_ADDR"' /vagrant/config.json > /vagrant/config.tmp.json && mv /vagrant/config.tmp.json /vagrant/config.json

cp /vagrant/config.json /opt/mattermost/config/config.json

useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

cp /vagrant/mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload
echo "Starting Mattermost"
service mattermost start