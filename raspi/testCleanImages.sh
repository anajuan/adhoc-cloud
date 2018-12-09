#!/bin/bash

WHO=$1
echo "clean_images) WHO $WHO"
IFS=,
ary=($WHO)

numLeave=${#ary[@]}
echo "clean_images) num nodes [$numLeave]"

for key in "${!ary[@]}"; do
	node=${ary[$key]}
        ssh pi@$node "docker rmi 68779230840a"
done
