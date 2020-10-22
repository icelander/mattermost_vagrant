#!/usr/bin/env bash


mysql -u mmuser -preally_secure_password -e "SELECT Email, Username, AuthService FROM Users WHERE Email='fry@planetexpress.com';" mattermost

printf '=%.0s' {1..80}
echo 
echo 'Updating LDAP server'

ldapmodify -x -D "cn=admin,dc=planetexpress,dc=com" -w GoodNewsEveryone -H ldap://127.0.0.1:389 -f /vagrant/ldifs/change_username.ldif


printf '=%.0s' {1..80}
echo
echo 'Running Mattermost LDAP Sync'

/opt/mattermost/bin/mattermost ldap sync

printf '=%.0s' {1..80}
echo
echo 'Checking DB'
echo
printf '=%.0s' {1..80}
echo

mysql -u mmuser -preally_secure_password -e "SELECT Email, Username, AuthService FROM Users WHERE Email='fry@planetexpress.com';" mattermost