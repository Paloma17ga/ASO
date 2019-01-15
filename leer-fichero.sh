#!/bin/bash

if [ -z $1 ]; then
	echo "Error: Introduce un parametro. "
	exit;
else 
	fichero=$1
	if [ -f $fichero ]; then
		echo "Es un fichero"
		ct=0	
		while	read linea;do
		let ct=ct+1
		echo $ct $linea
		echo "....."
	done <	$1
	else 
		echo "Error: No es un fichero"

fi 
fi

