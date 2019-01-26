#!/bin/bash

###################
# Author: Paloma García
# Description: Script que permite crear unidades organizativas
###################

clear
echo "Introduzca su nombre de dominio"
read dc1
echo "Introduzca terminacion de su dominio"
read dc2
echo "Introduzca un nombre para su nueva OU - salir saldrá del script "
read ou

while [ $ou != "salir" ]; do
	echo "dn: ou=$ou,dc=$dc1,dc=$dc2" > crearou.ldif
	echo "ObjectClass: organizationalUnit" >> crearou.ldif
	echo "ou: $ou" >> crearou.ldif
	ldapadd -D "cn=admin,dc=$dc1,dc=$dc2" -W -f crearou.ldif
	echo "-- Unidad organizativa $ou creada correctamente --"
	echo "-- Lista unidades organizativas --"
	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=organizationalUnit| grep dn
	echo "EIntroduzca un nombre para su nueva OU - salir saldrá del script "
	read ou
done

