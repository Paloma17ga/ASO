#!/bin/bash

##########################
# Author: Paloma García
# Description: Script que permite crear usuarios ldap
##########################

clear
echo "Introduzca su nombre de dominio"
read dc1
echo "Introduzca terminacion de su dominio"
read dc2
echo "Introduzca unidad organizativa para su usuario"
read ou
echo "Introduzca un nombre para su nuevo usuario - salir saldrá del script "
read usuario

while [ $usuario != "salir" ]; do
	echo "-- Uid último usuario --"
	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep uid | tail -1
	echo "Introduzca el uid de su nuevo usuario"
	read uid
	echo "Introduzca el apellido"
	read apellido
	echo "dn: cn=$usuario,ou=$ou,dc=$dc1,dc=$dc2" > crearuser.ldif
	echo "objectClass: inetOrgPerson" >> crearuser.ldif
       	echo "objectClass: person" >> crearuser.ldif
	echo "cn: $usuario" >> crearuser.ldif
	echo "uid: $uid" >> crearuser.ldif
	echo "sn: $apellido" >> crearuser.ldif
	echo "givenName: $usuario" >> crearuser.ldif
	ldapadd -D "cn=admin,dc=$dc1,dc=$dc2" -W -f crearuser.ldif
	echo "-- Usuario $usuario añadido correctamente  --"
	echo "-- Listado usuarios del dominio $dc1 . $dc2 --"
    	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep cn
	echo "Introduzca un nombre para su nuevo usuario - salir saldrá del script "
	read usuario
done
