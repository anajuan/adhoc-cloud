#!/bin/bash

case $1 in
"standalone")

   	echo "setup ETCD"
	docker run -d -p 4001:4001 -p 2380:2380 -p 2379:2379 --net=host --name etcd0 quay.io/coreos/etcd:v2.0.3  -name etcd0  -advertise-client-urls http://localhost:2379,http://localhost:4001  -listen-client-urls http://localhost:2379,http://localhost:4001  -initial-advertise-peer-urls http://localhost:2380  -listen-peer-urls http://localhost:2380  -initial-cluster-token etcd-cluster-1  -initial-cluster etcd0=http://localhost:2380
	master_ip=`docker inspect --format='{{ .NetworkSettings.IPAddress }}' etcd0`
        echo "HEALTH" 
	curl -L http://127.0.0.1:2379/health
	echo "MEMBERS"
	curl -L http://127.0.0.1:2379/v2/members
	;;

"nodes") 
	data_ini=`date +%s`
	fileName="data/data-addNodes-$data_ini-$2.dat"
	echo -e "num \t Acumtime \t TimeIns">>$fileName
	echo "$data_ini vols $2 fills"
	initialClusterStr=""
	port2=2380
	for ((i=0; i<$2; i++))
	do
		nom="etcd$i=http://localhost:$port2";
		echo $nom
    		initialClusterStr="$initialClusterStr $nom,"
		echo $initialClusterStr
                port2=`expr $port2 + 100`
	done
        port1=4001
	port2=2380
	port3=2379	
	for ((i=0; i<$2; i++))
	do

      	   echo "setup ETCD$i"
	   echo " Port 1[$port1] Port2[$port2] Port3[$port3]"
 	   #echo "docker run -d -p $port1:$port1 -p $port2:$port2 -p $port3:$port3 --net=host --name etcd$i quay.io/coreos/etcd:v2.0.3  -name etcd$i \
	   #	-advertise-client-urls http://localhost:2379,http://localhost:4001 \
	   #    	-listen-client-urls http://localhost:2379,http://localhost:4001 \
	  #	-initial-advertise-peer-urls http://localhost:2380 \
	#	-listen-peer-urls http://localhost:2380 \
	#	-initial-cluster-token etcd-cluster-1  \
	#	-initial-cluster $initialClusterStr"
	   
	  echo "EXECUTO === docker run -d -p $port1:$port1 -p $port2:$port2 -p $port3:$port3 --net=host --name etcd$i quay.io/coreos/etcd:v2.0.3  -name etcd$i \
                -advertise-client-urls http://localhost:$port3,http://localhost:$port1\
                -listen-client-urls http://localhost:$port3,http://localhost:$port1\
                -initial-advertise-peer-urls http://localhost:$port2\
                -listen-peer-urls http://localhost:$port2\
                -initial-cluster-token etcd-cluster-1  \
                -initial-cluster $initialClusterStr"
	   docker run -d -p $port1:$port1 -p $port2:$port2 -p $port3:$port3 --net=host --name etcd$i quay.io/coreos/etcd:v2.0.3  -name etcd$i \
                -advertise-client-urls http://localhost:$port3,http://localhost:$port1\
                -listen-client-urls http://localhost:$port3,http://localhost:$port1\
                -initial-advertise-peer-urls http://localhost:$port2\
                -listen-peer-urls http://localhost:$port2\
                -initial-cluster-token etcd-cluster-1  \
                -initial-cluster $initialClusterStr
	        data_iniIns=`date +%s`
		port1=`expr $port1 + 100`
		port2=`expr $port2 + 100`
		port3=`expr $port3 + 100`

		## nodeName="adhoc-cloud-node$i"
		## Determine node name
		#alreadyexist="x"
		#j=1
		#while [ "$alreadyexist" != "" ];
		#do
		#	nodeName="adhoc-cloud-node$j"
		#	alreadyexist=`docker ps | grep $nodeName`
		#	j=`expr $j + 1`
		#done

		#echo "nodeName $nodeName"
		##docker run --rm --name $nodeName -d -e HEAP_NEWSIZE=1M -e MAX_HEAP_SIZE=64M -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' adhoc-cloud-master)"  adhocc:latest
		#docker run -m 320M --rm --name $nodeName -d -e HEAP_NEWSIZE=1M -e MAX_HEAP_SIZE=64M -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' adhoc-cloud-master)"  adhocc:latest
                #nodeIP=`docker inspect --format='{{ .NetworkSettings.IPAddress }}' $nodeName`
                
	        #### solament arranco node	
		#docker exec -e "WHOAMI=$nodeIP" -e "AUTO=true" -i -t $nodeName sh -c 'exec /usr/src/node.sh' 
		#### faig insert a node
		##docker exec -e "WHOAMI=$nodeIP" -i -t $nodeName sh -c 'exec /usr/src/register.sh' 
	        
                ##num=`docker exec -i -t $nodeName  sh -c 'nodetool status'| grep ^UN | wc -l`

                data_end=`date +%s`
                ELAPSED_TIME=`expr $data_end - $data_ini`
                ELAPSED_TIME_INS=`expr $data_end - $data_iniIns`
                echo -e "$i \t $ELAPSED_TIME \t $ELAPSED_TIME_INS">>$fileName
		
		## Using autobootstrap false to start nodes. Manual launch of sync to keep consistency
		#echo "Lauch cluster data sync after creation"
		#docker exec -i -t $nodeName sh -c 'nodetool bootstrap resume' 
		
		#echo "Num $num t $ELAPSED_TIME"
                #docker run -it -e "WHOAMI=$nodeIP" --link "$nodeName" --rm master-node:latest sh -c 'exec /usr/src/node.sh' 
	done
 
        echo "HEALTH" 
	curl -L http://127.0.0.1:2379/health
	echo "MEMBERS"
	curl -L http://127.0.0.1:2379/v2/members
	
	data_end=`date +%s`
	ELAPSED_TIME=`expr $data_end - $data_ini`
	echo -e "TOTAL$2 \t $ELAPSED_TIME">>$fileName
		
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

	echo "bye"
	;;
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
