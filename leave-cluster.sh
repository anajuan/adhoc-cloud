#!/bin/bash

NODENAME="adhoc-cloud-node"
#NODENAME="cassandra"


function log {
	DATE='date +%Y/%m/%d:%H:%M:%S'
	echo `$DATE`" $1"
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

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <nodes to kill>" >&2
  exit 1
fi

for ((i=0;i<$1;i++))
do
	log "Killing node $i ..."
	kill
done
sync
