#!/bin/bash

################
#Autor:
#Descripcion: Script que pide nombre de usuario y otros datos 
#y permite crear usuarios hasta que se escriba salir
#################

clear
echo "Introduzca nombre para nuevo usuario - salir para cerrar el script"
read usuario

while [ $usuario != "salir" ]; do
	useradd -m -d /home/$usuario $usuario
#	Añade contraseña a usuario
#	passwd $usuario
	echo "Introduzca nombre para nuevo usuario - salir para cerrar el script"
	read usuario
done
