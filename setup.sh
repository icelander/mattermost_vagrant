#!/bin/bash

apt-get -qq update > /dev/null

apt-get install -y -q postgresql postgresql-contrib


# sudo su postgres -c "createdb -E UTF8 -T template0 --locale=en_US.utf8 -O vagrant wtm"
cp /etc/postgresql/9.5/main/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.orig.conf
cp /vagrant/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf

cp /etc/postgresql/9.5/main/postgresql.conf /etc/postgresql/9.5/main/postgresql.orig.conf
cp /vagrant/postgresql.conf /etc/postgresql/9.5/main/postgresql.conf

sudo systemctl reload postgresql

cp /vagrant/db_setup.sql /tmp/db_setup.sql
sed -i 's/MATTERMOST_PASSWORD/#MATTERMOST_PASSWORD/' /tmp/db_setup.sql
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
echo "Creating Mattermost User"
useradd --system --user-group mattermost
chown -R mattermost:mattermost /opt/mattermost

chmod -R g+w /opt/mattermost
echo "Copying Config File"
cp /vagrant/config.json /opt/mattermost/config/config.json
sed -i -e 's/mostest/#MATTERMOST_PASSWORD/g' /opt/mattermost/config/config.json

cp /vagrant/mattermost.service /lib/systemd/system/mattermost.service
systemctl daemon-reload

cd /opt/mattermost
bin/mattermost user create --email admin@planetexpress.com --username admin --password admin --system_admin
bin/mattermost sampledata --seed 10 --teams 4 --users 30

echo "Starting PostgreSQL"
service postgresql start
echo "Starting Mattermost!"
service mattermost start