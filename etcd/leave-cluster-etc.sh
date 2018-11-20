#!/bin/bash

DATAFILE="./data/dataETD-leave-cluster.dat"
NODENAME="etcd"
BASE_PORT=2379

function log {
	DATE='date +%Y/%m/%d:%H:%M:%S'
	echo `$DATE`" $1"
}

function remove_node {
	nodeIP=$1
	#sudo docker exec -it -e "NODETOREMOVE=$nodeIP" adhoc-cloud-master /usr/src/remove_node.sh
}

function kill {
	node=`sudo docker ps --format "{{.ID}}: {{.Names}}" | grep $NODENAME | cut -d: -f2 | shuf | head -1`
	if [ "$node" == "" ]; then
		log "Not enough nodes. Ending the process"
		exit 1
	fi
	log "Selected node $node"

	log "Updating database"
        num=`printf $node | tail -c 1`
	portNum=`expr $num \* 100`
	portNum=`expr $BASE_PORT + $portNum`
	echo "Num[$num] BASE[$BASE_PORT] portNum[$portNum]"
        ##### TODO call borrar del directory	
	echo "curl -L http://localhost:$portNum/v2/adhoc-cloud/etcd$num -XDELETE"
 
	dataNode=$(curl -L http://localhost:2479/v2/stats/self)
	echo "DATANODE $dataNode"



	#log "Stopping docker"
	#sudo docker stop $node

	#remove_node $nodeIP
}

function check_cluster {
	log "Checking cluster state"
	#sudo docker exec -it adhoc-cloud-master /usr/src/check_cluster.sh
}

# main

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <nodes to kill>" >&2
  exit 1
fi

numnodes=`sudo docker ps --format "{{.ID}}: {{.Names}}" | grep $NODENAME | wc -l`
log "Cluster of $numnodes nodes"
tstart=`date +'%s'`

# Kill nodes
for ((i=0;i<$1;i++))
do
	log "Killing node $i ..."
	kill
done

# Wait for sync
##++sync

#check_cluster

#tend=`date +'%s'`
#ttotal=`expr $tend - $tstart`

#log "Total time of $ttotal seconds"

#echo "$numnodes, $1, $ttotal" >> $DATAFILE
