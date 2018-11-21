#!/bin/bash
SIZE=10
DATAFILE="./data/dataetcd-leave-cluster.dat"

function log {
	DATE='date +%Y/%m/%d:%H:%M:%S'
	echo `$DATE`" $1"
}

function leaving {
	nodes=$1
	log "Leaving $1 nodes"
	./leave-cluster-etcd.sh $nodes
}
echo "ExistingClusterSize,NodesLeave,TimeTaken">> $DATAFILE
log "Creating cluster of $SIZE nodes"

log "Percentage Leaving 20%"
sudo ./adhoc-cloud-etcd.sh nodes $SIZE
leaving 4
./cleanup-etcd.sh 16

log "Percentage Leaving 40%"
sudo ./adhoc-cloud-etcd.sh nodes $SIZE
leaving 8 
./cleanup-etcd.sh 12 

log "Percentage Leaving 60%"
sudo ./adhoc-cloud-etcd.sh nodes $SIZE
leaving 12 
./cleanup-etcd.sh 8 

log "Percentage Leaving 80%"
sudo ./adhoc-cloud-etcd.sh nodes $SIZE
leaving 16 
./cleanup-etcd.sh 4 

