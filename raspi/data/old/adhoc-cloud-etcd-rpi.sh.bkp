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
		#####echo "IP Array Step1 ${IPs[num]}"
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
		###IP_Node=$(ssh pi@$node 'ip -4 route get 8.8.8.8'|awk {'print $7'} | tr -d '\n')
		IP_Node=${IPs[num]}
		echo "IP Array Step2 ${IPs[num]} IP_Node $IP_Node"
		nom="etcd$num"
		value="$node#$IP_Node"
                ssh pi@$node "/home/pi/adhoc-cloud/raspi/adhoc-cloud-etcd-rpi.sh member $IP_Node $nom $initialClusterStr" 
		data_end=`date +%s`
                ELAPSED_TIME=`expr $data_end - $data_ini`
                ELAPSED_TIME_INS=`expr $data_end - $data_iniIns`
                echo -e "$node \t $num \t $ELAPSED_TIME \t $ELAPSED_TIME_INS">>$fileName
		echo "cluster_create) Num [$num] Node[$node] IP[$IP_Node] InstanceTime[$ELAPSED_TIME_INS] STimeFromStart[$ELAPSED_TIME]"
		nodeStats=$(curl -sS http://$IP_Node:2379/v2/stats/self)
		echo "cluster_create) Node Stats $nodeStats"
	done

        ### Step 3: Insert each value in keyspace. This can not be done until the full cluster is instantiated.  	
	for key in "${!ary[@]}"; do 
		node=${ary[$key]}
		num=$key
		#IP_Node=$(ssh pi@$node 'ip -4 route get 8.8.8.8'|awk {'print $7'} | tr -d '\n')
		IP_Node=${IPs[num]}
		echo "IP Array Step3 ${IPs[num]} IP_Node $IP_Node "
		nom="etcd$num"
		value="$node#$IP_Node"
	        insertValue=$(curl -sS http://$IP_Node:2379/v2/keys/adhoc-cloud/$nom -XPUT -d value="$value")
	        echo "cluster_create) IntertValue $insertValue"
        done
	### Step 4: check cluster health, members and inserted keys.
	firstNode=${ary[0]}
	echo "IP Array Step 4${IPs[0]}"
	IP_FirstNode=${IPs[num]}
	#IP_FirstNode=$(ssh pi@$firstNode 'ip -4 route get 8.8.8.8'|awk {'print $7'} | tr -d '\n')
	health=$(curl -sS http://$IP_FirstNode:2379/health)
	echo "cluster_data) Health[$health]" 
	members=$(curl -sS http://$IP_FirstNode:2379/v2/members)
	echo "cluster_data) Members[$members]"
	data=$(curl -sS http://$IP_FirstNode:2379/v2/keys/adhoc-cloud)
	echo "cluster_data) DATA[$data]"
	;;
#"nodes") 
#	data_ini=`date +%s`
#	fileName="data/data-addNodesETCD-$data_ini-$2.dat"
#	echo -e "num \t Acumtime \t TimeIns">>$fileName
#	echo "$data_ini vols $2 fills"
#	initialClusterStr=""
#	port2=2380
#	for ((i=0; i<$2; i++))
#	do
#		nom="etcd$i=http://localhost:$port2";
#		#echo $nom
#		if [ "$initialClusterStr" != "" ]
#		then
#    		 initialClusterStr="$initialClusterStr,"
#		fi
#    		initialClusterStr="$initialClusterStr$nom"
#		#echo $initialClusterStr
#                port2=`expr $port2 + 100`
#	done
 #       port1=4001
#	port2=2380
#	port3=2379	
#	for ((i=0; i<$2; i++))
#	do
  #         data_iniIns=`date +%s`
 #     	   echo "setup ETCD$i"
	   #echo " Port 1[$port1] Port2[$port2] Port3[$port3]"
	  
	   #echo "EXECUTO === docker run -m $memLimit -d -p $port1:$port1 -p $port2:$port2 -p $port3:$port3 --net=host --name etcd$i  $etcd_docker -name etcd$i \
           #     -advertise-client-urls http://localhost:$port3,http://localhost:$port1\
           #     -listen-client-urls http://localhost:$port3,http://localhost:$port1\
           #     -initial-advertise-peer-urls http://localhost:$port2\
           #     -listen-peer-urls http://localhost:$port2\
           #     -initial-cluster-token etcd-cluster-1  \
           #     -initial-cluster $initialClusterStr"
#	   docker run -m $memLimit -d -p $port1:$port1 -p $port2:$port2 -p $port3:$port3 --net=host --name etcd$i  $etcd_docker -name etcd$i \
    #            -advertise-client-urls http://localhost:$port3,http://localhost:$port1\
    #            -listen-client-urls http://localhost:$port3,http://localhost:$port1\
    #            -initial-advertise-peer-urls http://localhost:$port2\
   #             -listen-peer-urls http://localhost:$port2\
  #              -initial-cluster-token etcd-cluster-1  \
 #             -initial-cluster $initialClusterStr
  #              
 #               echo "STATS*****************************************************"
#	        stat=$(curl -L -Ss http://localhost:$port3/v2/stats/self)
 #               echo "STATS*****************************************************"
#
#		data_end=`date +%s`
   #             ELAPSED_TIME=`expr $data_end - $data_ini`
  #              ELAPSED_TIME_INS=`expr $data_end - $data_iniIns`
                #echo "CREAR $i \t $ELAPSED_TIME \t $ELAPSED_TIME_INS"
 #               echo -e "$i \t $ELAPSED_TIME \t $ELAPSED_TIME_INS">>$fileName
                
#		port1=`expr $port1 + 100`
 #               port2=`expr $port2 + 100`
 #               port3=`expr $port3 + 100`
#	done

 # 	port3=2379
 #       for ((i=0; i<$2; i++))
 #       do
#	   echo "insert to i[$i] to[http://localhost:$port3/v2/keys/adhoc-cloud/ectd$i] val[etcd$i]"
#	   curl -L http://localhost:$port3/v2/keys/adhoc-cloud/ectd$i -XPUT -d value="etcd$i"
 #          port3=`expr $port3 + 100`
#	done

#       echo "HEALTH" 
#	curl -L http://localhost:2379/health
#	echo "MEMBERS"
#	curl -L http://localhost:2379/v2/members
#	echo "DATA"
#	curl -L http://localhost:2379/v2/keys/adhoc-cloud
	
#	data_end=`date +%s`
#	ELAPSED_TIME=`expr $data_end - $data_ini`
#	echo -e "TOTAL$2 \t $ELAPSED_TIME">>$fileName
		
	###echo "Before leaving. Sync all data..."
	###for ((i=0;i<$2;i++))
        ###do
	###	#$numNode=`eval($i+1)`
	###	numNode=`expr $i + 1`
	###	nodeName="adhoc-cloud-node$numNode"
	###	echo "Sync $nodeName..."
	###	docker exec -i -t $nodeName sh -c 'nodetool rebuild' 
        ###done
	###docker exec -i -t adhoc-cloud-master sh -c 'nodetool rebuild' 
	###echo "END Before leaving. Sync all data..."

#	echo "bye"
#	;;
*)
	echo "k ase?"
#if [ $1 == "setup" ]
#then
#   	echo "setup"
#	docker run --name adhoc-cloud-master -d master-node:latest
#	master_ip=`docker inspect --format='{{ .NetworkSettings.IPAddress }}' adhoc-cloud-master`
#	echo "master IP is [" $master_ip "]"
#        docker run -it -e "WHOAMI=$master_ip" --link adhoc-cloud-master --rm master-node:latest sh -c 'exec /usr/src/master.sh register' 
#	
#	echo "vols $2 fills"
#	for ((i=1; i<=$2; i++))
#	do
#    		echo $i
#		nodeName="adhoc-cloud-node$i"
#		echo "nodeName $nodeName"
#               #docker run --name node_fill  -d -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' adhoc-cloud-master)"  master-node:latest
#                #docker run --name $nodeName -d -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' adhoc-cloud-master)"  master-node:latest
#                echo `docker run --name $nodeName -d -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' adhoc-cloud-master)"  master-node:latest`
#                #docker run --name adhoc-cloud-node$i -e "CASSANDRA_SEEDS=$master_ip" -d master-node:latest
#                echo `docker inspect --format='{{ .NetworkSettings.IPAddress }}' $nodeName`
#
#	done
#	
#	echo "bye"
#else
#	if  [ $1 == "clean" ]
#	then
#		echo "clean"
#		docker stop adhoc-cloud-master
#                docker rm adhoc-cloud-master
#	else
#   		echo "k ase?"
#	fi
#fi
;;
esac
