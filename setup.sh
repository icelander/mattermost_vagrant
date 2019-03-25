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
cp /vagrant/mattermost-5.8.0-linux-amd64.tar.gz ./
# wget https://releases.mattermost.com/5.5.0/mattermost-5.5.0-linux-amd64.tar.gz
echo "Unzipping Mattermost"
tar -xzf mattermost*.gz

rm mattermost*.gz
mv mattermost /opt

mkdir /opt/mattermost/data

echo "Copying Config File"
mv /opt/mattermost/config/config.json /opt/mattermost/config/config.orig.json
# Edit config file with JQ

jq -s '.[0] * .[1]' /opt/mattermost/config/config.orig.json /vagrant/config.json > /vagrant/config.vagrant.json

chmod 777 /vagrant/config.vagrant.json


ln -s /vagrant/config.vagrant.json /opt/mattermost/config/config.json
ln -s /vagrant/e10license.txt /opt/mattermost/license.txt

echo "Creating Mattermost User"
useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

ln -s /vagrant/mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload

echo "Starting PostgreSQL"
service postgresql start

cd /opt/mattermost
bin/mattermost config validate
bin/mattermost user create --email admin@planetexpress.com --username admin --password admin --system_admin
bin/mattermost sampledata --seed 10 --teams 4 --users 30

echo "Starting Mattermost!"
service mattermost start