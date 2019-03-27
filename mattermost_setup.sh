#!/bin/bash

apt-get -q -y update > /dev/null
apt-get -q -y install jq cifs-utils

mkdir -p /media/mmst-data
cat /vagrant/client_fstab >> /etc/fstab
mount -a

# Download Mattermost
if [ ! -f /vagrant/mattermost-5.6.1-linux.amd64.tar.gz ]; then
    wget --quiet https://releases.mattermost.com/5.6.1/mattermost-5.6.1-linux-amd64.tar.gz
    cp mattermost-5.6.1-linux-amd64.tar.gz /vagrant/mattermost-5.6.1-linux.amd64.tar.gz
else
	cp /vagrant/mattermost-5.6.1-linux.amd64.tar.gz ./	
fi

tar -xzf mattermost*.gz
rm mattermost*.gz
mv mattermost /opt

mkdir /opt/mattermost/data

ln -s /vagrant/license.txt /opt/mattermost/license.txt
mv /opt/mattermost/config/config.json /opt/mattermost/config/config.orig.json

jq -s '.[0] * .[1]' /opt/mattermost/config/config.orig.json /vagrant/config.json > /vagrant/config.vagrant.json
chmod 777 /vagrant/config.vagrant.json

sed -i 's|#IP_ADDRESS|#IP_ADDRESS#|g' /vagrant/config.vagrant.json

cp /vagrant/config.vagrant.json /opt/mattermost/config/config.json

rm /vagrant/config.vagrant.json

useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

cp /vagrant/mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload
/opt/mattermost/bin/mattermost version
echo "Starting Mattermost"
service mattermost start