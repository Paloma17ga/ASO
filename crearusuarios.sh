#!/bin/bash

################
#Autor:
#Descripcion: Script que pide nombre de usuario y otros datos 
#y permite crear usuarios hasta que se escriba salir
#################

clear
echo "Introduzca nombre para nuevo usuario - salir para cerrar el script"
read usuario
echo "Introduzca nombre para home"
read home

while [ $usuario != "salir" ]; do
	useradd -m -d /home/$home $usuario
#	Añade contraseña a usuario
#	passwd $usuario
	clear
	echo "-- Usuario $usuario añadido correctamente --"
	echo "Introduzca otro nombre para nuevo usuario - salir para cerrar el script"
	read usuario
	echo "Introduzca otro home"
	read home
done
