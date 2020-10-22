# LDAP Server

## About

Spins up a Mattermost server at http://127.0.0.1:8065 that includes LDAP sync and eventually SAML login to demonstrate 

## To Do

- [ ] Get SimpleSAMLphp working
- [ ] SimpleSAMLphp auth against LDAP docker container
- [ ] SAML Login with full security
- [ ] Profile Images

## Test Scenarios

1. User in SAML, not in LDAP
	- Sync w/ SAML
	- Sync LDAP
2. User in SAML and LDAP
	- Sync with SAML enabled
	- Sync w/ LDAP enabled