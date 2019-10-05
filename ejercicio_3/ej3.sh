#!/bin/bash
accion=$1

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

PATHTOBACKUPDIR="pathToBackUpDir";

LOGFILE=$(pwd)
LOGFILE+="/ej3.out"


check_parameters_start(){
	if [ $1 -lt 4 ]
	then
     echo "Parametros insuficientes. Utilice -h o -help para conocer el funcionamiento"
     exit
	fi
}

generar_archivo_log(){
   if [ ! -f ej3.out ]
   then
		touch ej3.out
   fi
}

verificar_ejecucion(){
	CANTPROCESOS=$( ps aux | grep ej3.daemon.sh -c ) 
	if [ $CANTPROCESOS -gt  2 ] 
	then
		if [ $1 == 'false' ]
		then	
		   echo "No se puede ejecutar.Se esta ejecutando en este momento."
		   exit
		fi 
	else
		if [ $1 == 'true' ]
		then	
			echo "No hay instancia corriendo"
			exit
		fi	
	fi	
}

guardar_path_backup(){
	if [ ! -f pathToBackUpDir ] 
	then
		touch pathToBackUpDir 
	fi
	echo $1 >| pathToBackUpDir 	
}


guardar_path_dir_guardar(){
	if [ ! -f pathDirGuardar ] 
	then
		touch pathDirGuardar 
	fi
	echo $1 >| pathDirGuardar	
}

case $accion in 
start)
	check_parameters_start $#
 	generar_archivo_log
	verificar_ejecucion false
	guardar_path_dir_guardar "$2"
	guardar_path_backup "$3"
	./ej3_daemon.sh "$4" &>> $LOGFILE &
	exit
	;; 
stop) 
	verificar_ejecucion true
	pidDaemon=$(<$PIDFILE)
	kill -9 $pidDaemon
	rm $PIDFILE
	exit
	;;
count)
	DIRBACKUP=$(<$PATHTOBACKUPDIR) 
	echo $(find $DIRBACKUP -type f | wc -l)
	;;
clear)
	DIRBACKUP=$(<$PATHTOBACKUPDIR)
	if [ $# -gt 1 ]
	then
		CANTIDADMANTENER="$2"
		cd $DIRBACKUP
		ls -t | sed -e '1,'"$CANTIDADMANTENER"'d' | xargs -d '\n' rm 
	else
		DIRBACKUP=$(<$PATHTOBACKUPDIR)
		rm $DIRBACKUP/*.tar.gz
	fi
	;;
play)
	verificar_ejecucion true
	pidDaemon=$(<$PIDFILE)
	kill -SIGTERM $pidDaemon &>> $LOGFILE &
	;;
-h|-help|-?) ayuda
		;;
*) echo 'Utilice -h ,-? o -help para conocer el funcionamiento';;
esac





