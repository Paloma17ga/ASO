#!/bin/bash

################
# Autor: Paloma García
# Descripcion: Script que pide nombre de usuario y otros datos
# y permite crear usuarios hasta que se escriba salir
#################

clear
echo "Introduzca nombre para nuevo usuario -f- para cerrar el script"
read usuario

while [ $usuario != "f" ]; do
        useradd -m -d /var/www/$usuario $usuario
#       Añade contraseña a usuario (problema: si el usuario existe, se modifica su contraseña)
#       passwd $usuario
        read usuario
        echo "Introduzca nombre para nuevo usuario -f-  para cerrar el script"
done

cat /etc/passwd

