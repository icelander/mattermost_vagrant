# Mattermost w/ Database Cluster

## Architecture

 - One Mattermost server
 - Four DB servers
 	- Active/Passive Cluster
 	- Two Read Replica Slaves


## Goals

0. Setup Mattermost server
	- 192.168.33.101
		- :8065
1. Create a three-node db cluster, one master and two slaves
	 - 192.168.33.102 - Main Node
	 	- 3306:103306
	 - 192.168.33.103, .104 - slaves
	 	- 3306:113306
2. Set up a Blue/Green master cluster
	 - 192.168.33.102
	 	- 3306:103306 
	 - 192.168.33.105 - Blue Node
	 	- 3306:143306

## Research

Synchronous Replication should go between the Master and the Read Slaves to make sure they happen fast.

The Blue/Green is for

## Discussion

## Sizing

[Requirements] https://docs.mattermost.com/install/requirements.html#database-software


## Bibliography

[Several Nines] https://severalnines.com/blog/learn-difference-between-multi-master-and-multi-source-replication