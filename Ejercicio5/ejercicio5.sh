#!/bin/bash
#################################################
#			Sistemas Operativos		            #       
#		Trabajo Práctico 1 - Ejericio 5		    #
#		Nombre del Script: ejercicio5.sh		#
#							                    #
#				Integrantes:		            #
#         Di Tommaso, Giuliano     38695645		#
#         Handley, Tomas           39210894		#
#         Imperatori, Nicolas      38622912		#
#							                    #
#		Instancia de Entrega: Reentrega 1	    #
#							                    #
#################################################

Ayuda()
{
	echo $0 " tiene las siguientes opciones:
	-l listar los archivos que contiene la papelera de reciclaje.
	-r [archivo] recuperar el archivo pasado por parámetro a su ubicación original.
	-e vaciar la papelera de reciclaje (eliminar definitivamente)
	Sin modificador para que elimine el archivo."
	echo
	echo "Ejemplos: ./ejercicio5.sh -l
	./ejercicio5.sh -r archivo.txt
	./ejercicio5.sh -e
	./ejercicio5.sh ../../Descargas/archivo.txt"
	echo "Con -h, -? o -help se mostrara esta ayuda"
	exit 1
}
ListarArchivos()
{
	if [ $# -eq 0 ]; then
		echo -e "Nombre \t\t Ubicacion original"
		echo "-----------------------------------"
		awk -F "|" '{print $2,"\t",$3}' "$HOME/.papelera/.indice"
	else
		echo -e "Nombre original \t Nombre en la papelera \t Ubicacion original"
		awk -v nombre=$1 -F "|" '$2==nombre{print $2,"\t\t",$1,"\t",$3}' "$HOME/.papelera/.indice"
	fi
	exit 1
}

VaciarPapelera(){
	cat /dev/null > "$HOME/.papelera/.indice"
	cantArchivos=$(ls "$HOME/.papelera" | wc -l)
	echo "Se eliminaron $cantArchivos archivos definitivamente."
	if [ $cantArchivos -gt 0 ]; then
		rm -v $HOME/.papelera/*
	fi
	exit 1
}

RestaurarArchivo(){
	archivo="$1"
	cantidad=$(awk -v nombre="$archivo" -F "|" 'BEGIN{cant=0;}
	$2==nombre{cant++;}
	END{print cant}' "$HOME/.papelera/.indice")
	while [ $cantidad -gt 1 ]; do
		echo "$1 esta veces $cantidad en la papelera."
		ListarArchivos $1
		echo "Ingrese el nombre con el que esta guardado en la papelera para restaurarlo:"
		read archivo

		cantidad=$(awk -v nombre="$archivo" -F "|" 'BEGIN{cant=0;}
		$1==nombre{cant++;}
		END{print cant}' "$HOME/.papelera/.indice")
	done
	
	#awk -v nombre="$archivo" -F "|" '$1==nombre || $2==nombre{print "\""$1"\"" " " "\"" $3 "\"" " " "\""$2"\""}
	awk -v nombre="$archivo" -F "|" '$1==nombre || $2==nombre{system("mv $HOME/.papelera/" "\""$1"\"" " " "\""$3"\"" "/" "\""$2"\"")}
		$1!=nombre && $2!=nombre{print}' "$HOME/.papelera/.indice" > "$HOME/.papelera/.indiceNuevo"
	rm "$HOME/.papelera/.indice"
	mv "$HOME/.papelera/.indiceNuevo" "$HOME/.papelera/.indice"
	exit 1
}

EliminarArchivo(){
	fullpath=$(realpath "$1")
	path="${fullpath%/*}"
	filename="${fullpath##*/}"
	nombre="${filename%.*}"
	extension="${filename#*.}"
	nuevoNombre="$nombre$RANDOM.$extension"
	echo "$nuevoNombre|$filename|$path" >> "$HOME/.papelera/.indice"
	
	#mv $fullpath "$HOME/.papelera/$nuevoNombre"
	mv "$fullpath" "$HOME/.papelera/"
	mv "$HOME/.papelera/$filename" "$HOME/.papelera/$nuevoNombre"
	exit 1
}

#error cantidad de parametros
if [ $# -gt 2 -o $# -lt 1 ]; then
	echo "Error en la cantidad de parametros ingresados"
	Ayuda
fi

#error en parametros
if [ "$1" != "-h" ] && [ "$1" != "-?" ] && [ "$1" != "-help" ] && [ "$1" != "-l" ] && [ "$1" != "-r" ] && [ "$1" != "-e" ] && [ ! -f "$1" ]; then
	echo "Error en los parametros ingresados"
	Ayuda
fi

#ayuda
if [ "$1" = "?" -o "$1" = "-h" -o "$1" = "-help" ]; then
	Ayuda
fi

#crear papelera si no existe
if [ ! -d "$HOME/.papelera" ]; then
	mkdir -p "$HOME/.papelera"
fi

#crear indice si no existe
if [ ! -f "$HOME/.papelera/.indice" ]; then
	cat /dev/null > "$HOME/.papelera/.indice"
fi

#listar -> 1 parametro
if [ "$1" = "-l" ]; then
	if [ $# -eq 1 ]; then
		ListarArchivos
	else
		echo "Error en la cantidad de parametros para listar el contenido de la papelera"
		Ayuda
	fi
fi

#restaurar -> 2 parametros
if [ "$1" = "-r" ]; then
	if [ $# -eq 2 ]; then
		RestaurarArchivo "$2"
	else
		echo "Error en la cantidad de parametros para restaurar un archivo"
		Ayuda
	fi
fi

#vaciar -> 1 parametro
if [ "$1" = "-e" ]; then
	if [ $# -eq 1 ]; then
		VaciarPapelera
	else
		echo "Error en la cantidad de parametros para vaciar la papelera"
		Ayuda
	fi
fi

#eliminar archivo -> 1 parametro
if [ -f "$1" ]; then
	if [ $# -eq 1 ]; then
		EliminarArchivo "$1"
	else
		echo "Error en la cantidad de parametros para eliminar un archivo"
		Ayuda
	fi
else
	echo "El archivo no existe"
fi