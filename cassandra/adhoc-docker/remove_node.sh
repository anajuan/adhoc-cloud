#!/bin/bash

echo "Removing node $NODETOREMOVE"

id=`nodetool status | grep $NODETOREMOVE | cut -c59-95`
if [ "$id" == "" ]; then
        echo "ERROR: Node not exists."
        exit 1
fi
echo "Identifier: $id"
nodetool removenode $id
status=""
while [ "$status" == "" ];
do
        status=`nodetool removenode status|grep 'No token removals in process'`
done
echo " Node removed"

