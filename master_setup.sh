#!/bin/bash

apt-get -q -y update

# Install mysql
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -q -y install mysql-server mysql-client

mysql -uroot -proot < /vagrant/master_db_setup.sql

service mysql stop
mv /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/orig.mysqld.cnf
cp /vagrant/master.mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Set up Mattermost database and user
# 