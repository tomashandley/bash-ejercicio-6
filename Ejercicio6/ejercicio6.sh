#!/bin/bash

#################################################
#			Sistemas Operativos		            #       
#		Trabajo Práctico 1 - Ejericio 6		    #
#		Nombre del Script: ejercicio6.sh		#
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
	echo "   ejercicio6.sh"
	echo " "
	echo "SYNOPSIS"
	echo "  ./ejercicio6.sh /directorio"
	echo " "
	echo "DESCRIPTION"
    echo "  El script listará los 10 subdirectorios más grandes de un directorio (pasado parámetro)."
    echo "  Sólo se tendrán en cuenta aquellos directorios que no posean subdirectorios."
	echo "EXECUTION"
	echo "  ./ejercicio6.sh /directorio"
}

if [ $# == 0 ]; 
then
	echo "La cantidad de parametros ingresados es incorrecto."
	exit
fi

if [ $# == 1 ]; 
then
	if test "$1" = "-h" -o "$1" = "-?" -o "$1" = "-help";
    then
		ayuda
		exit
	fi
fi

if [ $# -ge 2 ]; 
then
	echo "La cantidad de parametros ingresados es incorrecto."
	exit
fi

if ! [ -d "$1" ]; 
then
	echo "Por favor verique que el directorio existe y que esté correctamente el path"
	exit;
fi

	###### Comienzo de ejercicio ######

    echo ">>> Directorio: $1"
	
	OLDIFS=$IFS
	IFS=$'\n'

    subdircount=`find $1 -maxdepth 1 -type d | wc -l`
	
	control=0;
	arrayOnlySubdirectories=();
	filteredArray=();

	numeroDirectorios=$(( subdircount - 1))
	# echo ">>> Cantidad de subdirectorios $numeroDirectorios"

	### Si el directorio no tiene subdirectorios, entonces avisa al usuario
	if [ $subdircount -eq 1 ]
	then 
		echo "El directorio especificado no posee subdirectorios."
		exit
	else
		pos=0
		arraySubdirectorios=`find $1 -maxdepth 1 -type d`

		### Find lista los subdirectorios dado un PATH, pero incluye ese mismo PATH
		### Por lo tanto, aca lo remuevo
		for j in $arraySubdirectorios
		do
			if [ $j == $1 ]
			then
				# echo "Soy el mismo directorio"
				printf "";
			else
				arrayOnlySubdirectories[$pos]=$j;
				# echo "Soy un subdirectorio y pos vale $pos"
				(( pos++ ))
			fi
		done
	fi

	pos=0;
	### NO tengo en cuenta los subdirectorios del PATH que tengan dentro otros subdirectorios
	for i in "${arrayOnlySubdirectories[@]}"
	do
		subdircount=`find $i -maxdepth 1 -type d | wc -l`
		if [ $subdircount -eq 1 ]
		then
			filteredArray[$pos]=$i
		else
			# echo "El subdirectorio $i tiene subdirectorios dentro."
			printf "";
		fi
		(( pos++ ))
	done

	totalDirectorios=`ls | wc -l`
	pos=0;
	### Obtengo, de forma ordenada, N subdirectorios de PATH (TODOS)
	while read -r line; 
	do 
		# echo "$line"
		arrayTodosOrdenados[$pos]="$line";
		(( pos++ )) 
	done < <(du $1 -a --max-depth=1 | sort -n -r | head -n 99999 | cut -f 2)

	pos=0;
	posDA=0;
	definitiveArray=();
	### De los subdirectorios ordenados (arriba) del PATH, me quedo con aquellos
	### que no tienen subdirectorios
	for t in "${arrayTodosOrdenados[@]}"
	do
		for fa in "${filteredArray[@]}"
		do
			if [ $t == $fa ]
			then
				definitiveArray[$posDA]=$fa
				(( posDA++ ))
			fi
		done
		(( pos++ ))	
	done

	pos=0;
	ultimateArray=();
	### Me quedo con los 10 subdirectorios mas grande
	for da in "${definitiveArray[@]}"
	do
		if [ $pos -lt 10 ]
		then
			ultimateArray[$pos]=$da
		else
			break;
		fi
		(( pos++ ))
	done

	arrayTamanios=();
	arrayCantArchivos=();
	pos=0;
	### De esos 10 subdirectorios, obtengo tamanio y cantidad de archivos
	for f in "${ultimateArray[@]}"
	do
		# echo ">>> $f"
		dirListado=`du -sh "$f" | cut -f 1`
		arrayTamanios[$pos]=$dirListado;
		cantArchivos=`ls -1q "$f" | wc -l`;
		arrayCantArchivos[$pos]=$cantArchivos;
		(( pos++ ))
	done

	### Listado final: imprimo el listado de 10 subdirectorios segun el formato requerido
	pos=0;
	for f in "${ultimateArray[@]}"
	do
		echo "$f ${arrayTamanios[$pos]} ${arrayCantArchivos[$pos]} arch."
		(( pos++ ))
	done
