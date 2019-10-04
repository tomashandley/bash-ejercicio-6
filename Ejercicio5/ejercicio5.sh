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
#		Instancia de Entrega: Entrega		    #
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
Error()
{
	echo "Error en la cantidad de parametros"
	Ayuda
}
ListarArchivos()
{
	if [ $# -eq 0 ]; then
		echo -e "Nombre \t\t Ubicacion original"
		echo "-----------------------------------"
		awk -F "|" '{print $2,"\t",$3}' "$HOME/.papelera/.indice"
		exit 1
	else
		echo -e "Nombre original \t Nombre en la papelera \t Ubicacion original"
		awk -v nombre=$1 -F "|" '$2==nombre{print $2,"\t\t",$1,"\t",$3}' "$HOME/.papelera/.indice"
	fi
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
	cantidad=$(awk -v nombre=$1 -F "|" 'BEGIN{cant=0;}
	$2==nombre{cant++;}
	END{print cant}' "$HOME/.papelera/.indice")
	while [ $cantidad -gt 1 ]; do
		echo "$1 esta veces $cantidad en la papelera."
		ListarArchivos $1
		echo "Ingrese el nombre con el que esta guardado en la papelera para restaurarlo:"
		read archivo

		cantidad=$(awk -v nombre=$archivo -F "|" 'BEGIN{cant=0;}
		$1==nombre{cant++;}
		END{print cant}' "$HOME/.papelera/.indice")
	done
	awk -v nombre=$archivo -F "|" '$1==nombre || $2==nombre{system("mv $HOME/.papelera/" $1 " " $3 "/" $2)}
		$1!=nombre && $2!=nombre{print}' "$HOME/.papelera/.indice" > "$HOME/.papelera/.indiceNuevo"
	rm "$HOME/.papelera/.indice"
	mv "$HOME/.papelera/.indiceNuevo" "$HOME/.papelera/.indice"
	exit 1
}

if [ $# -gt 2 -o $# -lt 1 ]; then
	Error
fi

if [ "$1" = "?" -o "$1" = "-h" -o "$1" = "-help" ]; then
	Ayuda
fi

if [ "$1" = "-r" ] && [ $# -ne 2 ]; then
	Error
fi

if [ ! -d "$HOME/.papelera" ]; then
	echo "no existe la papelera"
fi

if [ $1 = "-l" ]
then
	ListarArchivos
fi

if [ $1 = "-e" ]
then
	VaciarPapelera
fi

if [ $1 = "-r" ]
then
	RestaurarArchivo $2
fi

fullpath=$(realpath "$1")
path="${fullpath%/*}"
filename="${fullpath##*/}"
nombre="${filename%.*}"
extension="${filename#*.}"
nuevoNombre="$nombre$RANDOM.$extension"
echo "$nuevoNombre|$filename|$path" >> "$HOME/.papelera/.indice"

mv $fullpath "$HOME/.papelera/$nuevoNombre"