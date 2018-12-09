#!/bin/bash
echo "Crear cluster 2"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0
echo "cleanup"
./testClean.sh raspberrypi-new1-eth0,raspberrypi-new2-eth0
echo "**********************************END TEST CREATE CLUSTER 2"

echo "Crear cluster 4"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0
echo "cleanup"
./testClean.sh raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0
echo "**********************************END TEST CREAR CLUSTER 4"

echo "Crear cluster 6"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0
echo "cleanup"
./testClean.sh raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0
echo "**********************************END TEST CREAR CLUSTER 6"

echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "cleanup"
./testClean.sh raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "**********************************END TEST CREAR CLUSTER 8"
