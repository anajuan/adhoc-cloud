#!/bin/bash
echo "create node [$WHOAMI]"
echo "set Autobootstrap [$AUTO]"
if [ "$AUTO" = false ] ; then
    	echo "AUTO_BOOTSTRAP is set to false"
	echo "auto_bootstrap: false" >>/etc/cassandra/cassandra.yaml
fi
#echo "set Autobootstrap FALSE"
#echo "auto_bootstrap: false" >>/etc/cassandra/cassandra.yaml

echo "WAIT TO CASSANDRA START"
while ! cqlsh -e 'describe cluster' ; do
 sleep 1
 echo "."
done
echo "action register node [$WHOAMI] "
cqlsh -e "INSERT into adhoc_cloud.nodes(id,ip) values (uuid(), '$WHOAMI');"
cqlsh -e "SELECT * FROM adhoc_cloud.nodes" > /usr/src/nodes.txt
cat /usr/src/nodes.txt
echo "bye, node [$WHOAMI] registered ..."






echo "bye, node [$WHOAMI] created..."
