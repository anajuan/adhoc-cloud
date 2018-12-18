#!/bin/bash

DATAFILE="./data/dataetcd-leave-cluster.dat"
NODENAME="etcd"
BASE_PORT=2379

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
        num=`printf $node | tail -c 1`
	portNum=`expr $num \* 10`
	portNum=`expr $BASE_PORT + $portNum`
	log "Num[$num] BASE[$BASE_PORT] portNum[$portNum]"
        ##### TODO call borrar del directory. workarround es update value a removed	
        curl -L  http://localhost:$portNum/v2/keys/adhoc-cloud/etcd$num -XPUT -d value="REMOVED"
        id=$(curl -L -Ss http://localhost:$portNum/v2/stats/self | jq '.id'|tr -d "\"")
	log "ID to remove $id"
        curl -L http://localhost:$portNum/v2/members/$id -XDELETE
	log "Stopping docker"
	sudo docker stop $node
	log "Removing docker"
	sudo docker rm $node
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

tend=`date +'%s'`
ttotal=`expr $tend - $tstart`

log "Total time of $ttotal seconds"

echo "$numnodes, $1, $ttotal" >> $DATAFILE
