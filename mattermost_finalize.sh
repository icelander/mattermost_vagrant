#!/bin/bash

cd /opt/mattermost
bin/mattermost version

bin/mattermost user create --email admin@planetexpress.com --username admin --password admin --system_admin

bin/mattermost sampledata --seed 10 --teams 4 --users 30
bin/mattermost team add odio-0 admin@planetexpress.com

# TODO: Migrate config from file to database