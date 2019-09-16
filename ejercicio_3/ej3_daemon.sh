#!/bin/bash
 
if [! -f daemonpid]
then
	touch daemonpid
fi
echo $$ >| daemonpid
while true; do
	hora=$(date +%Y%m%d%H%M%S)
	echo  " $hora : Haciendo backup de $1 en $2"
	cp -r $1 $2
	sleep $3
done	
	
	
