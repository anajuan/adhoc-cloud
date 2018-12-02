#!/bin/bash
SIZE=100
DATAFILE="./data/dataetcd-leave-cluster.dat"
LOGFILE="./data/dataetcd-leave-cluster-LOG.log"
function log {
	DATE='date +%Y/%m/%d:%H:%M:%S'
	echo `$DATE`" $1"
}

function leaving {
	nodes=$1
	log "Leaving $1 nodes"
	./leave-cluster-etcd.sh $nodes
}

echo "Creating cluster of $SIZE nodes">>$LOGFILE
log "Creating cluster of $SIZE nodes"


echo "ExistingClusterSize,NodesLeave,TimeTaken">> $DATAFILE
log "Percentage Leaving 20%"
echo "Percentage Leaving 20%">>$LOGFILE
sudo ./adhoc-cloud-etcd.sh nodes $SIZE
sudo docker stats -a --no-stream >>$LOGFILE
leaving 20
./cleanup-etcd.sh 80

log "Percentage Leaving 40%"
echo "Percentage Leaving 40%">>$LOGFILE
sudo ./adhoc-cloud-etcd.sh nodes $SIZE
sudo docker stats -a --no-stream >>$LOGFILE
leaving 40
./cleanup-etcd.sh 60

log "Percentage Leaving 60%"
echo "Percentage Leaving 60%">>$LOGFILE
sudo ./adhoc-cloud-etcd.sh nodes $SIZE
sudo docker stats -a --no-stream >>$LOGFILE
leaving 60
./cleanup-etcd.sh 40 

log "Percentage Leaving 80%"
echo "Percentage Leaving 80%">>$LOGFILE
sudo ./adhoc-cloud-etcd.sh nodes $SIZE
sudo docker stats -a --no-stream >>$LOGFILE
leaving 80
./cleanup-etcd.sh 20

