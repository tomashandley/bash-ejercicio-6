#!/bin/bash
BACKGROUND=false
if [! -f daemonpid]
then
	touch daemonpid
fi
while true; do
	if $background ; then	
		echo $$ >| daemonpid
	fi
	if  !$background ; then
		$background=true
	fi	
	hora=$(date +%Y%m%d%H%M%S)
	echo  " $hora : Haciendo backup de $1 en $2"
	cp -r $1 $2
	sleep $3
done

	
	
