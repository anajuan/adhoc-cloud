#!/bin/bash
echo "raspberrypi-new1-eth0 =============> raspberrypi-new2-eth0"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-new2-eth0:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-new2-eth0:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-eth0 =============> raspberrypi-new3-eth0"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-new3-eth0:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-new3-eth0:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-eth0 =============> raspberrypi-new4-eth0"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-new4-eth0:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-new4-eth0:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-eth0 =============> raspberrypi-new5-eth0"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-new5-eth0:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-new5-eth0:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-eth0 =============> raspberrypi-jgn1-eth0"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-jgn1-eth0:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-jgn1-eth0:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-eth0 =============> raspberrypi-jgn2-eth0"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-jgn2-eth0:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-jgn2-eth0:/home/pi/adhoc-cloud/raspi

#echo "raspberrypi-new1-eth0 =============> raspberrypi-old1-eth0"
#scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-old1-eth0:/home/pi/adhoc-cloud/raspi
#scp cleanup-etcd-rpi.sh pi@raspberrypi-old1-eth0:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-eth0 =============> raspberrypi-old2-eth0"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-old2-eth0:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-old2-eth0:/home/pi/adhoc-cloud/raspi
