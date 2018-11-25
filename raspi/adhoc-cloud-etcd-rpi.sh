#!/bin/bash

etcd_docker="peterrosell/etcd-rpi:2.3.7"
memLimit="32M"
case $1 in
"member")
	if [ $2 ]; then
		IP=$2
	else
		IP="default"
	fi

	if [ $3 ]; then
		nom=$3
	else
		nom="default"
	fi
	if [ $4 ]; then
		initialCluster=$4
	else
		initialCluster="default"
	fi
	echo "cluster_member_create) Params IP[$IP] Nom[$nom] clusterMembers[$initialCluster] "
	#	IP=`ip -4 route get 8.8.8.8 | awk {'print $7'} | tr -d '\n'`
	#	nom="etcd"
	#	initialCluster="$nom=http://$IP:2380"
	
	docker run --env GOMAXPROCS=4 \
		-e ETCD_UNSUPPORTED_ARCH=arm \
		-m $memLimit \
		-d \
		-p 4001:4001 -p 2379:2379 -p 2380:2380 \
		--net=host \
		--name=$nom \
		$etcd_docker \
		-name $nom \
		-advertise-client-urls http://$IP:2379,http://$IP:4001 \
		-listen-client-urls http://$IP:2379,http://$IP:4001 \
		-initial-advertise-peer-urls http://$IP:2380 \
		-listen-peer-urls http://$IP:2380 \
		-initial-cluster-token etcd-cluster-1 \
		-initial-cluster $initialCluster 
	;;
"cluster")
	if [ $3 ]; then
		./sync-rpi.sh
	fi
	WHO=$2
	echo "cluster_create) WHO $WHO"
	IFS=,
	ary=($WHO)
	initialClusterStr=""
	clusterSize=${#ary[@]}
	echo "cluster_create) size is [$clusterSize]"
        declare -a IPs
	data_ini=`date +%s`
	fileName="data/data-rpiEtcdCluster-$data_ini-$clusterSize.dat"
	echo -e "Nodes $WHO">>$fileName
	echo -e "Name \t Num \t Acumtime \t TimeIns">>$fileName
        ### Step 1: Create the initialCluster parameter	
	initialClusterStr=""
	for key in "${!ary[@]}"; do 
		node=${ary[$key]}
		num=$key
		IP_Node=$(ssh pi@$node 'ip -4 route get 8.8.8.8'|awk {'print $7'} | tr -d '\n')
		IPs[num]=$IP_Node
		nom="etcd$num=http://$IP_Node:2380";
		if [ "$initialClusterStr" != "" ]
		then
    			initialClusterStr="$initialClusterStr,"
		fi
    		initialClusterStr="$initialClusterStr$nom"
	done
	
        ### Step 2: Instatiate etcd container in each rpi hosts 	
	for key in "${!ary[@]}"; do 
                data_iniIns=`date +%s`
		node=${ary[$key]}
		num=$key
		IP_Node=${IPs[num]}
		nom="etcd$num"
		value="$node#$IP_Node"
                ssh pi@$node "/home/pi/adhoc-cloud/raspi/adhoc-cloud-etcd-rpi.sh member $IP_Node $nom $initialClusterStr" 
		data_end=`date +%s`
                ELAPSED_TIME=`expr $data_end - $data_ini`
                ELAPSED_TIME_INS=`expr $data_end - $data_iniIns`
                echo -e "$node \t $num \t $ELAPSED_TIME \t $ELAPSED_TIME_INS">>$fileName
		echo "cluster_create) Num [$num] Node[$node] IP[$IP_Node] InstanceTime[$ELAPSED_TIME_INS] STimeFromStart[$ELAPSED_TIME]"

		attempt_counter=0
		max_attempts=10
		#echo $(curl http://$IP_Node:2379)
		#echo $(curl --output /dev/null --silent --fail http://$IP_Node:2379/v2/stats/self)
		until $(curl --output /dev/null --silent --fail http://$IP_Node:2379/v2/stats/self); do
	    	if [ ${attempt_counter} -eq ${max_attempts} ];then
			echo "Max attempts reached"
			exit 1
		fi
		printf '.'
	       	attempt_counter=$(($attempt_counter+1))
		sleep 5
		done

		nodeStats=$(curl -sS http://$IP_Node:2379/v2/stats/self)
		echo "cluster_create) Node Stats $nodeStats"
	done
	data_end=`date +%s`
        ELAPSED_TIME=`expr $data_end - $data_ini`
	echo -e "Total Cluster Creation Time [$ELAPSED_TIME]">>$fileName

        ### Step 3: Insert each value in keyspace. This can not be done until the full cluster is instantiated.  	
	for key in "${!ary[@]}"; do 
		node=${ary[$key]}
		num=$key
		IP_Node=${IPs[num]}
		nom="etcd$num"
		value="$node#$IP_Node"
	        insertValue=$(curl -sS http://$IP_Node:2379/v2/keys/adhoc-cloud/$nom -XPUT -d value="$value")
	        echo "cluster_create) IntertValue $insertValue"
        done
	### Step 4: check cluster health, members and inserted keys.
	firstNode=${ary[0]}
	IP_FirstNode=${IPs[num]}
	health=$(curl -sS http://$IP_FirstNode:2379/health)
	echo "cluster_data) Health[$health]" 
	members=$(curl -sS http://$IP_FirstNode:2379/v2/members)
	echo "cluster_data) Members[$members]"
	data=$(curl -sS http://$IP_FirstNode:2379/v2/keys/adhoc-cloud)
	echo "cluster_data) DATA[$data]"
	;;
*)
	echo "k ase?"
;;
esac
