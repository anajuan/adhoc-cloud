#!/bin/bash

NODENAME="etcd"


function log {
	DATE='date +%Y/%m/%d:%H:%M:%S'
	echo `$DATE`" $1"
}

function kill {
	node=`sudo docker ps -a	--format "{{.ID}}: {{.Names}}" | grep $NODENAME | cut -d: -f2 | shuf | head -1`
	if [ "$node" == "" ]; then
		log "Not enough nodes. Ending the process"
		exit 1
	fi
	log "Selected node $node"
	
	log "Stopping docker"
	sudo docker stop $node

	log "Removing docker"
        sudo docker rm $node
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
