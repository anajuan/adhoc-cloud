#!/bin/bash
echo "set Autobootstrap FALSE"
echo "auto_bootstrap: false" >>/etc/cassandra/cassandra.yaml
echo "register node [$WHOAMI]"
while ! cqlsh -e 'describe cluster' ; do
 sleep 1
done
#echo "...dormo un rato..."
#sleep 40
#echo "desperto"
cqlsh -e "INSERT into adhoc_cloud.nodes(id,ip) values (uuid(), '$WHOAMI');"
cqlsh -e "SELECT * FROM adhoc_cloud.nodes" > /usr/src/nodes.txt
cat /usr/src/nodes.txt
echo "bye"
