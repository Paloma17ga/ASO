#!/bin/bash

##################
#Autor:Paloma Garcia
#Description: Script que pide un dominio,
#lista las ou y permite borrarlas
##################

#Pedimos datos del dominio
echo "Escriba un nombre de dominio"
read dn1
echo "Escriba terminacion de su dominio"
read dn2
#Listamos OU
ldapsearch -x -b "dc=$dn1,dc=$dn2" objectClass=organizationalUnit | grep dn:
# Pedimos el nombre de la unidad organizativa
echo "Nombre Unidad Organizativa a borrar"
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
	echo "Introduce otra UO"
	read ou
done
