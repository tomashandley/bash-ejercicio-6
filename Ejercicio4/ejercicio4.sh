#!/bin/bash
#################################################
#			Sistemas Operativos		            #       
#		Trabajo Práctico 1 - Ejericio 4		    #
#		Nombre del Script: ejercicio4.sh		#
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
	echo "Este script cuenta la cantidad de lineas de codigo y la 
    cantidad de lineas comentadas que poseen una ruta solo de la extesion especificada.
    La ruta y la extension se reciben por parametro.
    Uso: $0 /path/directorio .extension"
	echo
	echo "Ejemplos: ./ejercicio4.sh ./archivos/ .java"
	echo "Con -h, -? o -help se mostrara esta ayuda"
	exit 1
}
Error()
{
	echo "Error en la cantidad de parametros"
	Ayuda
}

if [ $# -gt 2 -o $# -lt 1 ]; then
	Error
fi

if [ "$1" = "?" -o "$1" = "-h" -o "$1" = "-help" ]; then
	Ayuda
fi

if [ "$1" != "?" -o "$1" != "-h" -o "$1" != "-help" ] && [ $# -ne 2 ]; then
	Error
fi

if [ ! -d "$1" ]; then
    Error
fi

ruta=$(realpath "$1")
extension=$2
cantidadArchivos=$(find "$ruta" -type f -name "*$extension" | wc -l)
echo "Cantida de archivos analizados: $cantidadArchivos"

totalLineas=$(find "$ruta" -type f -name "*$extension" -exec wc -l {} + | tail -1 | awk {'print $1'})
echo "Total de lineas de los archivos analizados: $totalLineas"

cantLineasCodigo=0
cantLineasComentario=0
comentariosTotales=0
codigoTotales=0

comentario=0
comentariosTotales=$(find "$ruta" -type f -name "*$extension" | (while read archivo; do
    cant=$(awk -f comentario.awk "$archivo")
    comentario=$((comentario+cant))
done 
echo $comentario))

codigo=0
codigoTotales=$(find "$ruta" -type f -name "*$extension" | (while read archivo; do
    cant=$(awk -f codigo.awk "$archivo")
    codigo=$((codigo+cant))
done 
echo $codigo))

porcentajeComentarios=$(echo "scale=2 ; ($comentariosTotales / $totalLineas)*100" | bc)
echo "Cantidad de lineas de comentarios totales: $comentariosTotales ($porcentajeComentarios %)"

porcentajeCodigo=$(echo "scale=2 ; ($codigoTotales / $totalLineas)*100" | bc)
echo "Cantidad de lineas de codigo totales: $codigoTotales ($porcentajeCodigo %)"
