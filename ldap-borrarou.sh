#!/bin/bash

##################
# Author:Paloma García
# Description: Script que permite crear unidades organizativas ldap
##################

clear
#Pedimos datos del dominio
echo "Introduzca su nombre de dominio"
read dn1
echo "Introduzca terminacion de su dominio"
read dn2
#Listamos OU
ldapsearch -x -b "dc=$dn1,dc=$dn2" objectClass=organizationalUnit | grep dn:
# Pedimos el nombre de la unidad organizativa
echo "Introduzca nombre de la unidad organizativa a borrar -f- saldrá del script"
read ou

#Programa principal
while [ $ou != f ]; do
	echo "Has elegido la unidad organizativa $ou"
	echo "Confirme que desea borrar la OU s/n"
	read confir
	#Confirmación para borrar
	if [ $confir = s ];then
		ldapdelete -x -D "cn=admin,dc=$dn1,dc=$dn2" -W ou=$ou,dc=$dn1,dc=$dn2 
		ldapsearch -x -b "dc=$dn1,dc=$dn2" objectClass=organizationalUnit | grep dn:
	fi
	echo "Introduzca nombre de la unidad organizativa a borrar -f- saldrá del script"
	read ou
done
