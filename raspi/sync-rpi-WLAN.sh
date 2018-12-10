!/bin/bash
echo "raspberrypi-new1-wlan =============> raspberrypi-new2-wlan"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-new2-wlan:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-new2-wlan:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-wlan =============> raspberrypi-new3-wlan"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-new3-wlan:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-new3-wlan:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-wlan =============> raspberrypi-new4-wlan"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-new4-wlan:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-new4-wlan:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-wlan =============> raspberrypi-new5-wlan"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-new5-wlan:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-new5-wlan:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-wlan =============> raspberrypi-jgn1-wlan"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-jgn1-wlan:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-jgn1-wlan:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-wlan =============> raspberrypi-jgn2-wlan"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-jgn2-wlan:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-jgn2-wlan:/home/pi/adhoc-cloud/raspi

#echo "raspberrypi-new1-wlan =============> raspberrypi-old1-wlan"
#scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-old1-wlan:/home/pi/adhoc-cloud/raspi
#scp cleanup-etcd-rpi.sh pi@raspberrypi-old1-wlan:/home/pi/adhoc-cloud/raspi

echo "raspberrypi-new1-wlan =============> raspberrypi-old2-wlan"
scp adhoc-cloud-etcd-rpi.sh pi@raspberrypi-old2-wlan:/home/pi/adhoc-cloud/raspi
scp cleanup-etcd-rpi.sh pi@raspberrypi-old2-wlan:/home/pi/adhoc-cloud/raspi
