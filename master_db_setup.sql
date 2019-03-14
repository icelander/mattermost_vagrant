
GRANT REPLICATION SLAVE ON *.* TO 'slave_user'@'%' IDENTIFIED BY 'password';

CREATE DATABASE IF NOT EXISTS mattermost;

CREATE USER 'mmuser'@'%' IDENTIFIED BY 'really_secure_password';
GRANT ALL PRIVILEGES ON `mattermost`.* TO 'mmuser'@'%';

FLUSH PRIVILEGES;