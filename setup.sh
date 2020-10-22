#!/bin/bash

mattermost_version=$1
root_password=$2
mysql_password=$3

apt-get -qq -y update
apt-get install -y -q mariadb-client ldapscripts jq xmlsec1

archive_filename="mattermost-$mattermost_version-linux-amd64.tar.gz"
archive_path="/vagrant/mattermost_archives/$archive_filename"
archive_url="https://releases.mattermost.com/$mattermost_version/$archive_filename"

if [[ ! -f $archive_path ]]; then
	wget --quiet $archive_url -O $archive_path
fi

if [[ ! -f $archive_path ]]; then
	echo "Could not find archive file, aborting"
	echo "Path: $archive_path"
	exit 1
fi

cp $archive_path ./

rm -rf /opt/mattermost
echo "Downloading Mattermost"
cp /vagrant/mattermost-5.9.0-linux.amd64.tar.gz ./
# wget https://releases.mattermost.com/3.8.0/mattermost-3.8.0-linux-amd64.tar.gz
# wget https://releases.mattermost.com/5.5.0/mattermost-5.5.0-linux-amd64.tar.gz
echo "Unzipping Mattermost"
tar -xzf mattermost*.gz

rm mattermost*.gz
mv mattermost /opt

mkdir /opt/mattermost/data

mv /opt/mattermost/config/config.json /opt/mattermost/config/config.orig.json
cat /vagrant/config.json | sed "s/MATTERMOST_PASSWORD/$mysql_password/g" > /tmp/config.json
jq -s '.[0] * .[1]' /opt/mattermost/config/config.orig.json /tmp/config.json > /opt/mattermost/config/config.json
rm /tmp/config.json

useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

cp /vagrant/mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload

cd /opt/mattermost
if [[ -f /vagrant/e20license.txt ]]; then
	echo "Installing E20 License"
	bin/mattermost license upload /vagrant/e20license.txt
fi
bin/mattermost user create --email admin@planetexpress.com --username admin --password admin --system_admin
bin/mattermost team create --name planet-express --display_name "Planet Express" --email "professor@planetexpress.com"
bin/mattermost team add planet-express admin@planetexpress.com

service mattermost start

printf '=%.0s' {1..80}
echo 
echo '                     VAGRANT UP!'
echo "GO TO http://127.0.0.1:8065 and log in with \`professor\`"
echo
printf '=%.0s' {1..80}