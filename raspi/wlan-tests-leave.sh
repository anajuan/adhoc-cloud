#!/bin/bash
echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "leave 25% -- 2"
./leave-cluster-etcd-rpi.sh raspberrypi-new1-wlan,raspberrypi-new2-wlan
./testClean.sh raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "**********************************END TEST LEAVE 25%"

echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "leave 50% -- 4"
./leave-cluster-etcd-rpi.sh raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan
./testClean.sh raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "**********************************END TEST LEAVE 50%"

echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "leave 75% -- 6"
./leave-cluster-etcd-rpi.sh raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan
./testClean.sh raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "**********************************END TEST LEAVE 75%"

echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "leave 100% -- 8"
./leave-cluster-etcd-rpi.sh raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "**********************************END TEST LEAVE 100%"
