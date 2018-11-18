#!/bin/bash

DATAFILE="./data/data-leave-cluster.dat"
NODENAME="adhoc-cloud-node"
#NODENAME="cassandra"


function log {
	DATE='date +%Y/%m/%d:%H:%M:%S'
	echo `$DATE`" $1"
}

function remove_node {
	nodeIP=$1
	sudo docker exec -it -e "NODETOREMOVE=$nodeIP" adhoc-cloud-master /usr/src/remove_node.sh
}

function kill {
	node=`sudo docker ps --format "{{.ID}}: {{.Names}}" | grep $NODENAME | cut -d: -f2 | shuf | head -1`
	if [ "$node" == "" ]; then
		log "Not enough nodes. Ending the process"
		exit 1
	fi
	log "Selected node $node"

	log "Updating database"
	nodeIP=`sudo docker inspect --format='{{ .NetworkSettings.IPAddress }}' $node`
	sudo docker exec -it -e "WHOAMI=$nodeIP" $node /usr/src/deregister.sh

	log "Stopping docker"
	sudo docker stop $node

	remove_node $nodeIP
}

function syncnode {
	node=$1
	num=$2
	log "Sync node $node with $2"
	current=0
	while [ $num != $current ]
	do
		query=`sudo docker exec -it $node /usr/src/currentnodes.sh | wc -l`
		# 5 extra lines + master	
		current=`expr $query - 6`
	done
	log "Node $node sync"
}


function sync {
	log "Waiting for sync"
	start=`date +'%s'`
	num=`sudo docker ps --format "{{.ID}}: {{.Names}}" | grep $NODENAME | cut -d: -f2 | wc -l`
	log "$num nodes remaining"
	nodes=`sudo docker ps --format "{{.ID}}: {{.Names}}" | grep $NODENAME | cut -d: -f2`
	for node in $nodes
	do
		syncnode $node $num	
	done
	end=`date +'%s'`
	total=`expr $end - $start`
	log "Sync time (secs): $total"
}

function check_cluster {
	log "Checking cluster state"
	sudo docker exec -it adhoc-cloud-master /usr/src/check_cluster.sh
}

# main

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <nodes to kill>" >&2
  exit 1
fi

numnodes=`sudo docker ps --format "{{.ID}}: {{.Names}}" | grep $NODENAME | wc -l`
log "Cluster of $numnodes nodes"
##### Due to autobootstrap false,  try to sync master before starting to remove nodes
#####docker exec -i -t adhoc-cloud-master sh -c 'nodetool rebuild'
tstart=`date +'%s'`

# Kill nodes
for ((i=0;i<$1;i++))
do
	log "Killing node $i ..."
	kill
done

# Wait for sync
#++sync

check_cluster

tend=`date +'%s'`
ttotal=`expr $tend - $tstart`

log "Total time of $ttotal seconds"

echo "$numnodes, $1, $ttotal" >> $DATAFILE
