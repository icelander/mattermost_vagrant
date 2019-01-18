#!/usr/bin/env bash

# This contains the commands to run the mattermost-update. Start with:
#
# $ git clone https://github.com/icelander/mattermost-update
#
# to get the latest update script


# Use the --no-backups flag to skip DB and Data backups
clear
echo 'executing: /vagrant/mattermost-update/mmupdate.sh /opt/mattermost https://releases.mattermost.com/5.6.2/mattermost-5.6.2-linux-amd64.tar.gz --no-backup'
echo '==='
sudo /vagrant/mattermost-update/mmupdate.sh /opt/mattermost https://releases.mattermost.com/5.6.2/mattermost-5.6.2-linux-amd64.tar.gz --no-backup