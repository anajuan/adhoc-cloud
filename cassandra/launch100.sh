#!/bin/bash
DATAFILE="./data/data-leave-cluster.dat"
LOGFILE="./data/data-leave-cluster-LOG.log"
NODENAME="adhoc-cloud-node"
SIZE=100

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
echo "Creating cluster of $SIZE nodes">>$LOGFILE

sudo ./adhoc-cloud.sh master
sudo ./adhoc-cloud.sh nodes $SIZE
sudo docker stats -a --no-stream >>$LOGFILE

echo "ExistingClusterSize,NodesLeave,TimeTaken">> $DATAFILE
echo "Percentage leaving 20%">>$LOGFILE
leaving 20
echo "Percentage leaving 40%">>$LOGFILE
leaving 40
echo "Percentage leaving 60%">>$LOGFILE
leaving 60
echo "Percentage leaving 80%">>$LOGFILE
leaving 80

log "Cleanup"
./cleanup.sh $SIZE
sudo docker kill adhoc-cloud-master

