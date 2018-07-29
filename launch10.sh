#!/bin/bash

NODENAME="adhoc-cloud-node"
SIZE=10

function log {
	DATE='date +%Y/%m/%d:%H:%M:%S'
	echo `$DATE`" $1"
}

function check_cluster {
	numnodes=`sudo docker ps --format "{{.ID}}: {{.Names}}" | grep $NODENAME | wc -l`
	if [ "$numnodes" != "$SIZE" ]; then
		log "ERROR: cluster of wrong size. There are $numnodes"
		exit 9
	fi
}

function leaving {

	check_cluster
	nodes=$1
	log "Leaving $1 nodes"
	./leave-cluster.sh $nodes
	log "Reconstructing cluster"
	sudo ./adhoc-cloud.sh nodes $nodes
}

log "Creating cluster of $SIZE nodes"
sudo ./adhoc-cloud.sh master
sudo ./adhoc-cloud.sh nodes $SIZE

leaving 2
leaving 4
leaving 6
leaving 8

log "Cleanup"
./cleanup $SIZE
sudo docker kill adhoc-cloud-master

