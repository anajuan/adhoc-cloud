#!/bin/bash
echo "Crear cluster ALL"
./adhoc-cloud-etcd-rpi.sh cluster raspberrypi-new1-eth0,raspberrypi-new2-eth0,raspberrypi-new3-eth0,raspberrypi-new4-eth0,raspberrypi-jgn1-eth0,raspberrypi-jgn2-eth0,raspberrypi-old2-eth0
echo "leave 20% -- 4"
./leave-cluster-etcd-rpi.sh \
		raspberrypi-old2-eth0,raspberrypi-jgn2-eth0,\
		raspberrypi-jgn1-eth0,raspberrypi-new4-eth0
