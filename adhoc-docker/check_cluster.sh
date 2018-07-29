#!/bin/bash

function remove_node {
        id=$1
        echo "Removing node $id"
        nodetool removenode $id
        status=""
        while [ "$status" == "" ];
        do
                status=`nodetool removenode status|grep 'No token removals in process'`
        done
        echo "Node removed"
}


echo "Checking cluster"

ids=`nodetool status | grep ^DN | cut -c59-95`
for id in $ids
do
        remove_node $id
done

