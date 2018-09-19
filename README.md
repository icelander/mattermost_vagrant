# LDAP Sync - Unable to Change User's Display Name

[Zendesk Ticket](https://mattermost.zendesk.com/agent/tickets/5877)

## Steps to Reproduce

0. Install [Virtualbox] and [Vagrant]
1. run `vagrant up` from this directory
2. Go to [your new server] Try to log in with the username and password `professor`, create a new team, and make that team open
3. In a different browser, log in with the username/password `fry`
4. Notice that both `fry` and `professor` have the username `@delivery-boy` and `@owner`, respectively
5. `vagrant ssh` into the server and then run `/vagrant/update_fry.sh`

[Virtualbox]: https://www.virtualbox.org/wiki/Downloads
[Vagrant]: https://www.vagrantup.com/downloads.html
[your new server]: http://localhost:8065

## Important!

*When you're done testing make sure to run `vagrant halt` to stop the server. To delete it entirely, run `vagrant destroy`*