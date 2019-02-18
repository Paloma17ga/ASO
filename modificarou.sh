#!/bin/bash

clear
echo "Introduzca su dominio y su terminación (example es): "
read dc1 dc2
echo "Introduzca su contraseña: "
read -s contra
echo "$contra"
echo "Introduzca unidad organizativa: "
read ou
base="ou=$ou,dc=$dc1,dc=dc2"
dnroot="cn=admin,dc=$dc1,dc=$dc2"
while [ $ou != "f" ]; do
	clear
	echo "-----Script para modificar atributos de usuarios-----"
	echo "Introduzca un atributo a modificar(mail,description): "
	read atributo
	echo "Introduzca nuevo valor:" 
	read valor
########echo "-----USUARIOS MODIFICABLES-----"
#	ldapsearch -xLLL -b $base|grep uid:
	echo "Introduzca el usuario que desea modificar: "
	read usuario
	echo "El usuario $usuario va a modicarse."
	echo "dn: uid=$usuario,$base">modifi.ldif
	echo "changetype: modify">>modifi.ldif
	echo "replace: $atributo">>modifi.ldif
	echo "$atributo: $valor">>modifi.ldif
	ldapmodify -D cn=admin,dc=$dc1,dc=$dc2 -w $contra -f modifi.ldif
	ldapsearch -xLLL -b $base uid=$usuario
	echo "Introduzca unidad organizativa: "
        read ou
done
