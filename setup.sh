#!/bin/bash

apt-get -q -y update

# Sets the root password for MariaDB
# export DEBIAN_FRONTEND=noninteractive
# debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
# debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
# apt-get -q -y install mysql-server

apt-get -y -q install nginx

# Allows cluster to connect
# sed -i 's|bind-address|#bind-address|g' /etc/mysql/mysql.conf.d/mysqld.cnf

# Copy Nginx configuration
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
cp /vagrant/nginx.conf /etc/nginx/sites-available/default

service nginx restart
# service mysql restart

# Set up Mattermost database and user
# mysql -uroot -proot < /vagrant/db_setup.sql