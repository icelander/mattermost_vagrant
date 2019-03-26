#!/bin/bash

apt-get -q -y update

# Sets the root password for MariaDB
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -q -y install mysql-server nginx samba

# Allows cluster to connect to MySQL
sed -i 's|bind-address|#bind-address|g' /etc/mysql/mysql.conf.d/mysqld.cnf
cat /vagrant/master.mysqld.cnf >> /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
mysql -uroot -proot < /vagrant/db_setup.sql

DB=mattermost
DUMP_FILE="/tmp/$DB-export-$(date +"%Y%m%d").sql"

MASTER_USER=root
MASTER_PASS=root

USER=mmuser
PASS=really_secure_password

MASTER_HOST=192.168.33.101

##
# MASTER
# ------
# Export database and read log position from master, while locked
##

echo "MASTER: $MASTER_HOST"

mysql "-u$MASTER_USER" "-p$MASTER_PASS" $DB <<-EOSQL &
	GRANT REPLICATION SLAVE ON *.* TO '$USER'@'%' IDENTIFIED BY '$PASS';
	FLUSH PRIVILEGES;
	FLUSH TABLES WITH READ LOCK;
	DO SLEEP(3600);
EOSQL

echo "  - Waiting for database to be locked"
sleep 3

# Dump the database (to the client executing this script) while it is locked
echo "  - Dumping database to $DUMP_FILE"
mysqldump "-u$MASTER_USER" "-p$MASTER_PASS" --opt $DB > $DUMP_FILE
echo "  - Dump complete."

# Take note of the master log position at the time of dump
MASTER_STATUS=$(mysql "-u$MASTER_USER" "-p$MASTER_PASS" -ANe "SHOW MASTER STATUS;" | awk '{print $1 " " $2}')
LOG_FILE=$(echo $MASTER_STATUS | cut -f1 -d ' ')
LOG_POS=$(echo $MASTER_STATUS | cut -f2 -d ' ')
echo "  - Current log file is $LOG_FILE and log position is $LOG_POS"
cat /vagrant/db_setup.sql >> /vagrant/slave_setup.sql
echo "STOP SLAVE;
	CHANGE MASTER TO MASTER_HOST='$MASTER_HOST',
	MASTER_USER='$USER',
	MASTER_PASSWORD='$PASS',
	MASTER_LOG_FILE='$LOG_FILE',
	MASTER_LOG_POS=$LOG_POS;
	START SLAVE;" > /vagrant/slave_setup.sql

# When finished, kill the background locking command to unlock
kill $! 2>/dev/null
wait $! 2>/dev/null

echo "  - Master database unlocked"


mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
cp /vagrant/nginx.conf /etc/nginx/sites-available/default
service nginx restart

mkdir -p /shared/mmst-data

adduser --no-create-home --disabled-password --disabled-login --gecos "" mattermost

chown -R mattermost:mattermost /shared/mmst-data
mv /etc/samba/smb.conf /etc/samba/orig.smb.conf
ln -s /vagrant/smb.conf /etc/samba/smb.conf
cat /etc/passwd | mksmbpasswd > /etc/smbpasswd
(echo samba_password; echo samba_password) | smbpasswd -a mattermost
service smbd restart