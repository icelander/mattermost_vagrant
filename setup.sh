#!/bin/bash

rm /vagrant/config.vagrant.json

apt-get -qq update > /dev/null

apt-get install -y -q postgresql postgresql-contrib jq


# sudo su postgres -c "createdb -E UTF8 -T template0 --locale=en_US.utf8 -O vagrant wtm"
cp /etc/postgresql/9.5/main/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.orig.conf
cp /vagrant/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf

cp /etc/postgresql/9.5/main/postgresql.conf /etc/postgresql/9.5/main/postgresql.orig.conf
cp /vagrant/postgresql.conf /etc/postgresql/9.5/main/postgresql.conf

sudo systemctl reload postgresql

cp /vagrant/db_setup.sql /tmp/db_setup.sql
echo "Setting up database"
su postgres -c "psql -f /tmp/db_setup.sql"
rm /tmp/db_setup.sql

rm -rf /opt/mattermost
echo "Downloading Mattermost"
cp /vagrant/mattermost-5.7.0-linux-amd64.tar.gz ./
echo "Unzipping Mattermost"
tar -xzf mattermost*.gz

rm mattermost*.gz
mv mattermost /opt

mkdir /opt/mattermost/data

echo "Copying Config File"
cp /opt/mattermost/config/config.json /opt/mattermost/config/config.orig.json
mv /opt/mattermost/config/config.json /vagrant/config.vagrant.json
# Edit config file with JQ
jq '.SqlSettings.DriverName = "postgres"' /vagrant/config.vagrant.json > /vagrant/config.vagrant.json.tmp && mv /vagrant/config.vagrant.json.tmp /vagrant/config.vagrant.json
jq '.SqlSettings.DataSource = "postgres://mmuser:really_secure_password@127.0.0.1:5432/mattermost?sslmode=disable\u0026connect_timeout=10"' /vagrant/config.vagrant.json > /vagrant/config.vagrant.json.tmp && mv /vagrant/config.vagrant.json.tmp /vagrant/config.vagrant.json
jq '.ServiceSettings.LicenseFileLocation = "/opt/mattermost/license.txt"' /vagrant/config.vagrant.json > /vagrant/config.vagrant.json.tmp && mv /vagrant/config.vagrant.json.tmp /vagrant/config.vagrant.json

chmod 777 /vagrant/config.vagrant.json

ln -s /vagrant/config.vagrant.json /opt/mattermost/config/config.json
ln -s /vagrant/license.txt /opt/mattermost/license.txt

echo "Creating Mattermost User"
useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

ln -s /vagrant/mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload

cd /opt/mattermost
bin/mattermost user create --email admin@planetexpress.com --username admin --password admin --system_admin
bin/mattermost sampledata --seed 10 --teams 4 --users 30

echo "Starting PostgreSQL"
service postgresql start
echo "Starting Mattermost!"
service mattermost start