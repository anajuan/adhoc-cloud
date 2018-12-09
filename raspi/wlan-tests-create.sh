#!/bin/bash
echo "Crear cluster 2"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-wlan,raspberrypi-new2-wlan
echo "cleanup"
./testClean.sh raspberrypi-new1-wlan,raspberrypi-new2-wlan
echo "**********************************END TEST CREATE CLUSTER 2"

echo "Crear cluster 4"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan
echo "cleanup"
./testClean.sh raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan
echo "**********************************END TEST CREAR CLUSTER 4"

echo "Crear cluster 6"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan
echo "cleanup"
./testClean.sh raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan
echo "**********************************END TEST CREAR CLUSTER 6"

echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "cleanup"
./testClean.sh raspberrypi-new1-wlan,raspberrypi-new2-wlan,raspberrypi-new3-wlan,raspberrypi-new4-wlan,raspberrypi-new5-wlan,raspberrypi-jgn1-wlan,raspberrypi-jgn2-wlan,raspberrypi-old2-wlan
echo "**********************************END TEST CREAR CLUSTER 8"
