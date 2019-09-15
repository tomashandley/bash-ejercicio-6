#!/bin/bash

#################################################
#			Sistemas Operativos		            #       
#		Trabajo Práctico 1 - Ejericio 1		    #
#		Nombre del Script: ejercicio1.sh		#
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