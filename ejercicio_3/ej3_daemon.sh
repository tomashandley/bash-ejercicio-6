#!/bin/bash

do_backup(){
	hora=$(date +%Y%m%d%H%M%S)
	PATHBACKUP=$(<pathToBackUpDir) 
	PATHAGUARDAR=$(<pathDirGuardar)
	echo  " $hora : Haciendo backup de $PATHAGUARDAR en $PATHBACKUP"
	FILENAME=backup_$hora.tar.gz
	tar -czvf $FILENAME $PATHAGUARDAR
	mv $FILENAME $PATHBACKUP
}


trap do_backup SIGTERM
 
if [ ! -f daemonpid ]
then
	touch daemonpid
fi
echo $$ >| daemonpid
while true; do	
	do_backup
	sleep $1 &
	wait;
done

	
	
