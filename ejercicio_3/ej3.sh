#!/bin/bash
accion=$1
#echo $$

ayuda(){
	echo 'Usage:'
	echo 'ej3.sh <start|stop|count|clear|play>'
	echo 'start dir_a_salvar dir_backup intervalo'
	echo 'stop '
	echo 'count'
	echo 'clear cabt_backup'
}

PIDFILE=$(pwd)
PIDFILE+="/daemonpid"
touch ej3.log

PATHTOBACKUPDIR="pathToBackUpDir";

LOGFILE=$(pwd)
LOGFILE+="/ej3.out"
case $accion in 
start)
	if [ $# -lt 4 ]
	then
    echo "Parametros insuficientes. Utilice -h o -help para conocer el funcionamiento"
    exit
	fi
	if [ ! -f ej3.out ]
	then
		touch ej3.out
	fi
	if [ -f $PIDFILE ]
	then
		CANTPROCESOS=$( ps aux | grep ej3.daemon.sh -c ) 
		if [ $CANTPROCESOS -gt  1 ] 
		then
			echo "No se puede ejecutar.Se esta ejecutando en este momento."
		exit
		fi	
	fi
	if [ ! -f pathToBackUpDir ] 
	then
		touch pathToBackUpDir 
	fi
	echo $3 >| pathToBackUpDir 
	intervalo=$4
	#directorio=$(pwd)
	#directorio+="/ej3_daemon.sh"
	#start-stop-daemon --start --startas /bin/bash --pidfile=$PIDFILE -- -c "exec $directorio $2 $3 $4 >> $LOGFILE 2>&1" --make-pidfile --background
	nohup sh ej3_daemon.sh  $2 $3 $4 > $LOGFILE &
	exit
	;;
stop) 
	#start-stop-daemon --stop --quiet --pidfile=$PIDFILE
	
	if [ ! -f $PIDFILE ]
	then
		echo "No hay instancia ejecutando"
		exit
	fi
	pidDaemon=$(<$PIDFILE)
	kill $pidDaemon
	exit
	;;
count)
		DIRBACKUP=$(<$PATHTOBACKUPDIR) 
		echo $(find $DIRBACKUP -type f | wc -l)
		;;
clear)
		##if[ $# -gt 0 ]
		##then
		#	echo 'cantidad de backup'
		#else
		#	rm -rf '$*'
		#fi;
		;;
play)
	if  $# -lt 3 ; then
		echo "Parametros insuficientes. Utilice -h o -help para conocer el funcionamiento"
		exit
	fi
	
	cp -r $1 $2
	;;
-h|-help|-?) ayuda
		;;
*) echo 'Utilice -h ,-? o -help para conocer el funcionamiento';;
esac





