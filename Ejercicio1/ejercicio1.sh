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

: '
	a) ¿Cuál es el objetivo de este script?
	El objetivo del script es realizar el conteo de lineas (L), caracteres totales (C) o caracteres
	de la línea de mayor longitud del archivo pasado por parámetro.

	b) ¿Qué parámetros recibe?
		El script recibe dos parametros:
			- nombre_archivo: Nombre de un archivo
			- L, C o M:
				* L: Contará la cantidad de líneas que posee el archivo.
				* C: Contará la cantidad de caracteres que posee el archivo.
				* M: Contará la cantidad de caracteres de la linea con mayor longitud.

	c) Comentar el código según la funcionalidad (no describa los comandos, indique la lógica)
		Comentado.
	d) Completar los “echo” con el mensaje correspondiente.
		Completo.
	
	e) ¿Qué información brinda la variable “$#”? ¿Qué otras variables similares conocen?
	Explíquelas.
		$#: Indica la cantidad de parámetros que recibe el script
		Otras variables:
		$-: Lista, en forma de string, los parámetros recibidos al ejecutar el script.
		$@: Lista, en forma de array, los parámetros recibidos al ejecutar el script.
		$?: Retorna 0 si el proceso anterior se ejecutó correctamente, o un número distinto de 0
			si hubo un error con el mismo.
		$_: Indica el nombre del último script o comando ejecutado
	f) Explique las diferencias entre los distintos tipos de comillas que se pueden utilizar en Shell
	scripts.
		Hay 3 tipos de encomillado:
		'': Las comillas simples se utilizan para alamacenar literales. Es decir, se almacenará exactamente
			lo que hay encerrado en ellas.
			Ejemplo:
				user=pepe 
				var='$user'
				echo $var --> La salida será $user 
		"": Las comillas dobles permiten interpretar las referencias a las variables.
			Ejemplo:
				user=pepe
				var="$user"
				echo $var --> La salida será pepe 
		``: Las comillas invertidas se utilizan para almacenar el output de los comandos ejecutados dentro de ellas.
			Ejemplo:
				var=`ls | wc -l`
				echo $var --> La salida será el número de elementos listados por ls

'


ErrorS() {
	echo "Error. La sintaxis del script es la siguiente:"
	echo "Cantidad de líneas del archivo: $0 nombre_archivo L"
	echo "Cantidad de caracteres dentro del archivo: $0 nombre_archivo C"
	echo "Cantidad de caracteres de la línea de mayor longitud: $0 nombre_archivo M"
}

ErrorP() {
	echo "Error. nombre_archivo "$1""
}

	if test $# -lt 2; 
	then
		ErrorS # Si el script recibe menos de 2 parámetros, arroja el error descripto en ErrorS
	fi

	if !(test -r "$1"); 
	then
		ErrorP "$1" # Si el archivo recibido no existe o no tiene permisos de lectura, arroja el error descripto en ErrorP
	elif test -f $1 && (test $2 = "L" || test $2 = "C" || test $2 = "M"); 
		then
			if test $2 = "L" # Si el segundo parámetro es una L, se contarán la cantidad de lineas del archivo
			then
			res=`wc -l $1`
			echo "Cantidad de líneas: $res"
			elif test $2 = "C"; # Si el segundo parámetro es una C, se contará la totalidad de caracteres del archivo
				then
				res=`wc -m $1`
				echo "Cantidad de caracteres del archivo: $res"
				elif test $2 = "M"; # Si el segundo parámetro es una M, contará los caracteres de la linea de mayor lingut
					then
					res=`wc -L $1`
					echo "Cantidad de caracteres de la línea más larga: $res"
				fi
	else
		ErrorS # Arroja error si el archivo no existe o el segundo parámetro no es L, C o M
	fi