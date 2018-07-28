#!/bin/bash

echo "Deregistering node $WHOAMI"

id=`cqlsh -e "SELECT id,ip from adhoc_cloud.nodes" | grep $WHOAMI | cut -d\| -f1`
if [ "$id" == "" ]; then
	echo "ERROR: Node not registered."
	exit 1
fi
echo "Identifier: $id"
cqlsh -e "DELETE FROM adhoc_cloud.nodes WHERE id=$id"
echo "Table updated"

