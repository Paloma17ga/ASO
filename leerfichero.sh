#!/bin/bash

while read linea;do
	echo $linea
	echo $linea|cut -d : -f 1,6
	usuario=$( echo $linea|cut -d: -f 1)
	echo "El usuario es $usuario"

done < /etc/passwd
