#!/bin/bash

apt-get -q -y update
apt-get -q -y upgrade

# Sets the root password for MariaDB
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password root'
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password root'
apt-get -q -y install mariadb-server

apt-get -y -q install nginx

# Allows cluster to connect
sed -i 's|127.0.0.1|0.0.0.0|g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy Nginx configuration
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
cp /vagrant/nginx.conf /etc/nginx/sites-available/default

service nginx restart
service mysql restart

# Set up Mattermost database and user
mysql -uroot -proot < /vagrant/db_setup.sql