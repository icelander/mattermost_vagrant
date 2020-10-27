#!/bin/bash

domain="planex.com"
country="US"
state="New York"
city="New New York"
org="Planet Express, Inc."
email="admin@planex.com"

if [[ -d /etc/ssl/$domain ]]; then
	echo "/etc/ssl/$domain already exists. Exiting..."
	exit 1
fi

if [[ ! -d /vagrant/certs ]]; then
	mkdir -p /vagrant/certs
fi

if [[ -d /vagrant/certs/$domain ]]; then
	cp -R /vagrant/certs/$domain /etc/ssl/$domain
else
	mkdir /etc/ssl/$domain
	cd /etc/ssl/$domain

	openssl genrsa -out $domain.key 4096
	openssl req -new -key $domain.key \
					 -out $domain.csr \
					 -subj "/C=$country/ST=$state/L=$city/O=$org/CN=*.$domain/emailAddress=$email"

	openssl x509 -req -days 365 -in $domain.csr -signkey $domain.key -out $domain.crt

	cat $domain.crt $domain.key | tee $domain.pem

	cp -R /etc/ssl/$domain /vagrant/certs/$domain
fi

if [[ ! -d /etc/ssl/haproxy ]]; then
	mkdir /etc/ssl/haproxy
fi

ln -s /etc/ssl/$domain/$domain.pem /etc/ssl/haproxy/$domain.pem