# Elasticsearch Cluster

## Problem

You need to run Elasticsearch behind and SSL proxy in Mattermost

## Solution

1. Set up a three-server Elasticsearch cluster
2. Set up a TLS Nginx proxy for elastic.planex.com that balances between the three servers
2. Connect Mattermost to the nginx proxy for Elasticsearch
	

	|                   | Verify TLS True | Verify TLS False |
	|:------------------|:----------------|:-----------------|
	| Cert in store     |                 |                  |
	| Cert not in store |                 |                  |

## Discussion

## Architecture

Nginx Proxy
 - search.planex.com
 	- Three docker images on separate ports
 - mattermost.planex.com