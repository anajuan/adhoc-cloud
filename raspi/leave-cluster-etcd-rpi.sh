#!/bin/bash

DATAFILE="./data/dataetcdrpi-leave-cluster.dat"
NODENAME="etcd"
BASE_PORT=2379

tstart=`date +'%s'`
WHO=$1
echo "leave_cluster) WHO $WHO"
IFS=,
ary=($WHO)

numLeave=${#ary[@]}
echo "leave_cluster) num nodes [$numLeave]"

firstNode=${ary[0]}
IP_firstNode=$(ssh pi@$firstNode 'ip -4 route get 8.8.8.8'|awk {'print $7'} | tr -d '\n')
clusterSize=$(curl -sS http://$IP_firstNode:2379/v2/members | jq '.members |length')
echo "leave_cluster) current cluster size [$clusterSize]"


for key in "${!ary[@]}"; do
	node=${ary[$key]}
	num=$key
	IP_Node=$(ssh pi@$node 'ip -4 route get 8.8.8.8'|awk {'print $7'} | tr -d '\n')
	echo "leave_cluster) Num [$num] Node[$node] IP[$IP_Node]" 
       	#TODO call borrar del directory. workarround es update value a removed	
        curl http://$IP_Node:2379/v2/keys/adhoc-cloud/etcd$num -XPUT -d value="REMOVED"
        id=$(curl -Ss http://$IP_Node:2379/v2/stats/self | jq '.id'|tr -d "\"")
	echo "leave_cluster) Etcd node to remove $id"
        curl http://$IP_Node:2379/v2/members/$id -XDELETE
        ssh pi@$node "/home/pi/adhoc-cloud/raspi/cleanup-etcd-rpi.sh 1"
done

tend=`date +'%s'`
ttotal=`expr $tend - $tstart`

echo "Total time of $ttotal seconds"

echo "clusterSize, numLeave, ttotal" >> $DATAFILE
echo "$clusterSize, $numLeave, $ttotal" >> $DATAFILE
