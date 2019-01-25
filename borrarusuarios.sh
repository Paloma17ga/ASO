#!/bin/bash

################
#Autor:
#Descripcion: Script que pide nombre de usuario
#y permite eliminar usuarios hasta que se escriba salir
#################

clear
echo "-- Usuarios del sistema --"
user= cat /etc/passwd | cut -d : -f 1
echo "Introduzca de usuario a borrar - salir para cerrar el script"
read usuario

while [ $usuario != "salir" ]; do
	userdel $usuario
	echo "-- Usuario $usuario borrado correctamente --"
        echo "-- Usuarios del sistema --"
        user= cat /etc/passwd | cut -d : -f 1
	echo "Introduzca nombre de usuario a borrar - salir para cerrar el script"
	read usuario
done
