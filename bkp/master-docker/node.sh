#!/bin/bash
 
echo "register node $WHOAMI"
echo "...dormo un rato..."
sleep 60
echo "desperto"
cqlsh $WHOAMI -e "INSERT into adhoc_cloud.nodes(id,ip) values (uuid(), '$WHOAMI');"
cqlsh $WHOAMI -e "SELECT * FROM adhoc_cloud.nodes" > /usr/src/nodes.txt
cat /usr/src/nodes.txt
echo "bye"
