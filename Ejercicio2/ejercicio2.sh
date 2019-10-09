#!/bin/bash

#################################################
#			Sistemas Operativos		            #       
#		Trabajo Práctico 1 - Ejericio 2		    #
#		Nombre del Script: ejercicio2.sh		#
#							                    #
#				Integrantes:		            #
#         Di Tommaso, Giuliano     38695645		#
#         Handley, Tomas           39210894		#
#         Imperatori, Nicolas      38622912		#
#							                    #
#		Instancia de Entrega: Entrega		    #
#							                    #
#################################################

function ayuda(){
	echo "NAME"
	echo "   ejercicio2.sh"
	echo " "
	echo "SYNOPSIS"
	echo "  ./ejercicio2.sh /directorio [-r]"
	echo " "
	echo "DESCRIPTION"
    echo "  El script, dado un directorio, reemplazará los espacios dentro de los nombres de los archivos"
	echo "	con un _."
	echo "	En caso de que el nombre del archivo contenga más de un espacio se reemplará con un solo _."
	echo "	Luego de hecho el reemplazo, si quedaran dos archivos con el mismo nombre, se agrega al final del nombre"
	echo "	un *."
	echo "	Además, es posible especificar el operador '-r'. De esta manera, se hará el reemplazo en todos"
	echo "	los subdirectorios del directorio especificado."
	echo "	De no ingresarse ningún directorio, el reemplazo se hará sobre el directorio actual."
	echo "EXECUTION"
	echo "  ./ejercicio6.sh [/mi_directorio] [-r]"
}

if [ $# == 1 ]; 
then
	if test "$1" = "-h" -o "$1" = "-?" -o "$1" = "-help";
    then
		ayuda
		exit
	fi
fi

if [ $# == 0 ]
then
	echo "Debe ingresar un directorio";
	exit;
fi

if [ $# == 1 ]
then
	if test "$1" = "-r"
	then
		echo "Si no se especifica un directorio, no se podrá aplicar la recursividad."
		exit
	else
		if ! [ -d "$1" ]; 
		then
			echo "Por favor verique que el directorio existe y que esté correctamente el path"
			exit;
		else
			miDirectorio="$1"
		fi
	fi
fi

esRecursivo="false"

if [ $# -gt 2 ]; 
then
	echo "La cantidad de parametros ingresados es incorrecto."
	exit
elif [ $# -eq 2 ]
then
	if [ "$1" != "-r" ]
	then
		if [ "$2" != "-r" ]
		then
			echo "Uno de los dos parámetros no es correcto. Revice la ayuda."
			exit
		fi
		
		if ! [ -d "$1" ]; 
		then
			echo "Por favor verique que el directorio existe y que esté correctamente el path"
			exit;
		else
		esRecursivo="true"
		miDirectorio="$1"
		fi
	else
		if ! [ -d "$2" ]; 
		then
			echo "Por favor verique que el directorio existe y que esté correctamente el path"
			exit;
		else
		esRecursivo="true"
		miDirectorio="$2"
		fi
	fi
fi

# barra="/";

function splitPath() {
	IFS='/' read -r -a array <<< "$1"
	IFS=$'\n'
}

function reemplazoNoRecursivo() {
	echo "Estoy en la funcion NO recursiva."
	archivosModificados=`find "$miDirectorio" -maxdepth 1 -type f -name '* *'| wc -l `

	archivosConEspacio=`find "$miDirectorio" -maxdepth 1 -type f -name '* *'`;

	IFS=$'\n'
	pos=1;
	for i in ${archivosConEspacio[@]}
	do	
		# Hago split del PATH por si algun directorio tiene espacios
		splitPath "$i"
		# Reemplazo los espacios, solo del archivo
		newfile="$(echo ${array[-1]} | sed -r  's/[[:space:]]+/_/g')"
		replacedValue=${array[-1]}
		newPath=$(echo $i | sed -e "s/$replacedValue/$newfile/g")
		# Chequeo que ese archivo no exista. Si existe, le agrego al nombre (copyN), N numero de copia.
		while [ -f "$newPath" ]
		do
			baseFileName="${newPath%.*}"
			fileExtension="${newPath##*.}"
			newPath="$baseFileName(copy$pos).$fileExtension"
			(( pos++ ))
		done
		# Hago el renombre del archivo, de espacios a _
		mv "$i" "$newPath"
		pos=1;
	done

	echo "Archivos modificados: $archivosModificados"
	
}

function reemplazoRecursivo() {
	archivosModificados=`find "$miDirectorio" -type f -name '* *'| wc -l `

	IFS=$'\n'
	# Obtengo los directorios de $miDirectorio (incluido este) y los almaceno en un array
	arrayR=`find "$miDirectorio" -type d -print`

	# Itero el array y aplico la misma funcionanlidad que en la funcion no recursiva
	for element in ${arrayR[@]}
	do
		archivosConEspacio=`find "$element" -maxdepth 1 -type f -name '* *'`;

		IFS=$'\n'
		pos=1;
		for i in ${archivosConEspacio[@]}
		do	
			# Hago split del PATH por si algun directorio tiene espacios
			splitPath "$i"
			# Reemplazo los espacios, solo del archivo
			newfile="$(echo ${array[-1]} | sed -r  's/[[:space:]]+/_/g')"
			# Agarro el archivo con el espacio
			replacedValue=${array[-1]}
			# Reemplazo en el path el archivo con espacios con el nuevo con "_"
			newPath=$(echo $i | sed -e "s/$replacedValue/$newfile/g")
			# Chequeo que ese archivo no exista. Si existe, le agrego al nombre (copyN), N numero de copia.
			while [ -f "$newPath" ]
			do
				baseFileName="${newPath%.*}"
				fileExtension="${newPath##*.}"
				newPath="$baseFileName(copy$pos).$fileExtension"
				(( pos++ ))
			done
			# Hago el renombre del archivo, de espacios a _
			mv "$i" "$newPath"
			pos=1;
		done
	done

	echo "Archivos modificados: $archivosModificados"
}

function init() {
	if [ $esRecursivo == "true" ]
	then
		reemplazoRecursivo 
	else
		reemplazoNoRecursivo
	fi
}
	
init
