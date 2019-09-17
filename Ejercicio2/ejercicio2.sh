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
	echo "EXECUTION"
	echo "  ./ejercicio6.sh /mi_directorio [-r]"
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

if [ $# -gt 2 ]; 
then
	echo "La cantidad de parametros ingresados es incorrecto."
	exit
elif [ $# -eq 2 ]
then
	if [ "$2" != "-r" ]
	then
		echo "El segundo parámetro no es válido."
		exit
	fi
fi

if ! [ -d "$1" ]; 
then
	echo "Por favor verique que el directorio existe y que esté correctamente el path"
	exit;
fi

function reemplazoNoRecursivo() {
	echo "Estoy en la funcion NO recursiva."

	

}

function reemplazoRecursivo() {
	echo "Estoy en la funcion recursiva."
}
	if [ "$2" == "-r" ]
	then
		reemplazoRecursivo
	else
		reemplazoNoRecursivo
	fi
