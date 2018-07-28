#!/bin/bash

#if [ $1 == "register" ]
#then
	echo "register _master $WHOAMI"
        while ! cqlsh -e 'describe cluster' ; do
            sleep 1
        done
        #echo "...dormo un rato.."
        #sleep 20 
        #echo "desperto..." 
        echo "cqlsh ready..." 
        cqlsh $WHOAMI -f /usr/src/keyspace_def.txt
	cqlsh $WHOAMI -e "INSERT into adhoc_cloud.nodes(id,ip) values (uuid(), '$WHOAMI');"
        cqlsh $WHOAMI -e "SELECT * FROM adhoc_cloud.nodes" > /usr/src/nodes.txt
	cat /usr/src/nodes.txt
	echo "bye"
#else
#	echo "k ase?"
#fi
