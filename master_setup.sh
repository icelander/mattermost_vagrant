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

service mysql start

# Set up Mattermost database and user
# 

# +------------------+----------+--------------+------------------+-------------------+
# | File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
# +------------------+----------+--------------+------------------+-------------------+
# | mysql-bin.000001 |      154 | mattermost   |                  |                   |
# +------------------+----------+--------------+------------------+-------------------+