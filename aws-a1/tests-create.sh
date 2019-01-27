#!/bin/bash
echo "Crear cluster 2"
./adhoc-cloud-etcd-awsa1.sh cluster 172.31.23.222,172.31.24.29
echo "cleanup"
./testClean.sh 172.31.23.222,172.31.24.29
echo "**********************************END TEST CREATE CLUSTER 2"

echo "Crear cluster 4"
./adhoc-cloud-etcd-awsa1.sh cluster 172.31.23.222,172.31.24.29,172.31.28.183,172.31.29.52 
echo "cleanup"
./testClean.sh 172.31.23.222,172.31.24.29,172.31.28.183,172.31.29.52 
echo "**********************************END TEST CREATE CLUSTER 2"
#./adhoc-cloud-etcd-awsa1.sh cluster $host1,$host2,$host3,$host4
#echo "cleanup"
#./testClean.sh $host1,$host2,$host3,$host4
echo "**********************************END TEST CREAR CLUSTER 4"
echo "**********************************END TEST CREAR CLUSTER 6"
echo "**********************************END TEST CREAR CLUSTER 8"
