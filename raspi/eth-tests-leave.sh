#!/bin/bash
echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "leave 25% -- 2"
./leave-cluster-etcd-rpi.sh raspberrypi-new1-eth0,raspberrypi-new2-eth0
./testClean.sh raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "**********************************END TEST LEAVE 25%"

echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "leave 50% -- 4"
./leave-cluster-etcd-rpi.sh raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0
./testClean.sh raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "**********************************END TEST LEAVE 50%"

echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "leave 75% -- 6"
./leave-cluster-etcd-rpi.sh raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0
./testClean.sh raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "**********************************END TEST LEAVE 75%"

echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "leave 100% -- 8"
./leave-cluster-etcd-rpi.sh raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-new5-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "**********************************END TEST LEAVE 100%"
