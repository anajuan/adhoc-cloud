#!/bin/bash

WHO=$1
echo "sync_cluster) WHO $WHO"
IFS=,
ary=($WHO)

numSync=${#ary[@]}
echo "sync_cluster) num nodes [$numSync]"

for key in "${!ary[@]}"; do
        host=${ary[$key]}
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SYNC@$host "
	cat /home/ubuntu/.ssh/id_rsa.pub| ssh -i "huevoEgg.pem" ubuntu@$host "cat >> ~/.ssh/authorized_keys"
	ssh $host '. .profile; test -d /home/ubuntu/adhoc-cloud || mkdir /home/ubuntu/adhoc-cloud'
	ssh $host '. .profile; test -d /home/ubuntu/adhoc-cloud/aws-a1 || mkdir /home/ubuntu/adhoc-cloud/aws-a1'
	ssh $host 'sudo snap install docker; sudo groupadd docker; sudo usermod -aG docker ubuntu'
	ssh $host '/snap/bin/docker pull peterrosell/etcd-rpi:2.3.7'
	scp adhoc-cloud-etcd-awsa1.sh ubuntu@$host:/home/ubuntu/adhoc-cloud/aws-a1
	scp cleanup-etcd-awsa1.sh ubuntu@$host:/home/ubuntu/adhoc-cloud/aws-a1

done

#echo "cat /home/ubuntu/.ssh/id_rsa.pub| ssh -i "huevoEgg.pem" ubuntu@$host4 "cat >> ~/.ssh/authorized_keys""
#cat /home/ubuntu/.ssh/id_rsa.pub| ssh -i "huevoEgg.pem" ubuntu@$host4 "cat >> ~/.ssh/authorized_keys"
#ssh $host4 '. .profile; test -d /home/ubuntu/adhoc-cloud || mkdir /home/ubuntu/adhoc-cloud'
#ssh $host4 '. .profile; test -d /home/ubuntu/adhoc-cloud/aws-a1 || mkdir /home/ubuntu/adhoc-cloud/aws-a1'
#ssh $host4 'sudo snap install docker; sudo groupadd docker; sudo usermod -aG docker ubuntu'
#scp adhoc-cloud-etcd-awsa1.sh ubuntu@$host4:/home/ubuntu/adhoc-cloud/aws-a1
#scp cleanup-etcd-awsa1.sh ubuntu@$host4:/home/ubuntu/adhoc-cloud/aws-a1

