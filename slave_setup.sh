#!/bin/bash

apt-get -q -y update

# Install mysql
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -q -y install mysql-server mysql-client

# Set up Mattermost database and user
mysql -uroot -proot < /vagrant/slave_db_setup.sql


service mysql stop
mv /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/orig.mysqld.cnf
cp /vagrant/slave.mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

sed -i 's/SERVERID/#SERVERID/g' /etc/mysql/mysql.conf.d/mysqld.cnf