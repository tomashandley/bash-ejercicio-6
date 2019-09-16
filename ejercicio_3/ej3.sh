#!/bin/bash
accion=$1
#echo $$
salir(){
	echo 'se seguira ejecutando en segundo plano'
	bg
}

ayuda(){
	echo 'se usa asi .....'
}

#trap salir SIGINT

PIDFILE=$(pwd)
PIDFILE+="/daemonpid"
touch ej3.log

LOGFILE=$(pwd)
LOGFILE+="/ej3.out"

case $accion in 
start)
	if [ $# -lt 4 ]
   then
    echo "Parametros insuficientes. Utilice -h o -help para conocer el funcionamiento"
    exit
	fi
	if [ -f $PIDFILE ]
	then
		if [ ps -pid $(<$PIDFILE)]
		then
		echo "No se puede ejecutar.Se esta ejecutando en este momento."
		exit
		fi	
	fi
	intervalo=$4
	#directorio=$(pwd)
	#directorio+="/ej3_daemon.sh"
	#start-stop-daemon --start --startas /bin/bash --pidfile=$PIDFILE -- -c "exec $directorio $2 $3 $4 >> $LOGFILE 2>&1" --make-pidfile --background
	nohup sh ej3_daemon.sh  $2 $3 $4 > $LOGFILE &
	exit
	;;
stop) 
	#start-stop-daemon --stop --quiet --pidfile=$PIDFILE
	if[ !f $PIDFILE ]
	then
		echo "No hay instancia ejecutando"
		exit
	fi
	pidDaemon=$(<$PIDFILE)
	kill $pidDaemon
	exit;;
count)echo 'count'	
;;
clear)
		##if[ $# -gt 0 ]
		##then
		#	echo 'cantidad de backup'
		#else
		#	rm -rf '$*'
		#fi;
		;;
play)echo 'play';;
-h|-help|-?) ayuda;;
*) echo 'Utilice -h ,-? o -help para conocer el funcionamiento';;
esac



