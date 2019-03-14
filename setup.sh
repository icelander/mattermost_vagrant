#!/bin/bash

apt-get -q -y update > /dev/null

# Install mysql
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -q -y install jq

# Set up Mattermost database and user
# mysql -uroot -proot < /vagrant/db_setup.sql

cp /vagrant/mattermost*.gz ./
echo "Extracting"
tar -xzf mattermost*.gz

rm mattermost*.gz
mv mattermost /opt

mkdir /opt/mattermost/data

ln -s /vagrant/license.txt /opt/mattermost/license.txt
mv /opt/mattermost/config/config.json /opt/mattermost/config/config.orig.json
jq '.ServiceSettings.LicenseFileLocation = "/opt/mattermost/license.txt"' /opt/mattermost/config/config.orig.json > /vagrant/config.tmp.json && mv /vagrant/config.tmp.json /vagrant/config.json
# jq '.SqlSettings.DataSource = "mmuser:really_secure_password@tcp(192.168.33.101:3306)/mattermost?charset=utf8mb4,utf8\u0026readTimeout=30s\u0026writeTimeout=30s"' /vagrant/config.json > /vagrant/config.tmp.json && mv /vagrant/config.tmp.json /vagrant/config.json

cp /vagrant/config.json /opt/mattermost/config/config.json

useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

cp /vagrant/mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload
echo "Starting Mattermost"
# service mattermost start