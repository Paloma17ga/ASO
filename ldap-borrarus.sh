#!/bin/bash

##########################
# Author: Paloma García
# Description: Script que permite eliminar usuarios ldap
##########################

#Recogemos los datos del dominio
clear
echo "Introduzca su nombre de dominio "
read dc1
echo "Introduzca terminación de dominio "
read dc2
echo "-- Listado usuarios del dominio $dc1 . $dc2 --"
ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep cn
echo "Introduzca nombre del usuario que desea borrar -f- saldrá del script"
read usuario
echo "Introduzca la ou a la que pertenece su usuario"
read ou

while [ $usuario != "f" ]; do
	echo "Confirme que desea borrar el usuario $usuario s/n"
	read confir
	if [ $confir = s ];then
		ldapdelete -x -D "cn=admin,dc=$dc1,dc=$dc2" -W cn=$usuario,ou=$ou,dc=$dc1,dc=$dc2 
		echo "-- Listado usuarios del dominio $dc1 . $dc2 --"
		ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep cn
	fi
	echo "-- Usuario $usuario borrado correctamente --"
	echo "Introduzca nombre del usuario que desea borrar -f- saldrá del script"
	read usuario
done
