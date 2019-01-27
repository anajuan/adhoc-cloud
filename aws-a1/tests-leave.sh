#!/bin/bash
echo "Crear cluster 4"
./adhoc-cloud-etcd-awsa1.sh cluster 172.31.23.222,172.31.24.29,172.31.28.183,172.31.29.52
echo "leave 25% -- 1"
./leave-cluster-etcd-awsa1.sh 172.31.29.52
./testClean.sh 172.31.23.222,172.31.24.29,172.31.28.183
echo "**********************************END TEST LEAVE 25%"

echo "Crear cluster 4"
./adhoc-cloud-etcd-awsa1.sh cluster 172.31.23.222,172.31.24.29,172.31.28.183,172.31.29.52
echo "leave 50% -- 2"
./leave-cluster-etcd-awsa1.sh 172.31.29.52,172.31.28.183
./testClean.sh 172.31.23.222,172.31.24.29
echo "**********************************END TEST LEAVE 50%"

echo "Crear cluster 4"
./adhoc-cloud-etcd-awsa1.sh cluster 172.31.23.222,172.31.24.29,172.31.28.183,172.31.29.52
echo "leave 75% -- 3"
./leave-cluster-etcd-awsa1.sh 172.31.29.52,172.31.28.183,172.31.24.29
./testClean.sh 172.31.23.222
echo "**********************************END TEST LEAVE 75%"
