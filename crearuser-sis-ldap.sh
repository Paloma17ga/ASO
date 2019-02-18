#!/bin/bash

##########
# Autor: Paloma García
# Description: script que almacena los nombres de los usuarios del sistema 
# y genera usuarios ldap.
##########

# Recogemos los datos del dominio y unidad organizativa
clear
echo "Introduzca su nombre de dominio (example es)"
read dc1 dc2
echo "Introduza su contraseña: "
read -s contra
echo "Introduzca unidad organizativa para sus usuarios"
read ou


# Almacenamos los nombres de los usuarios del sistema
cat /etc/passwd|cut -d : -f 1 > "/home/paloma/scripts/fichero.txt"

# Leemos linea por linea, creando un usuario con cada nombre
while	read linea;do
	echo $linea
	ult=`ldapsearch -xLLL -b "cn=admin,dc=$dc1,dc=$dc2" | grep uidNumber | cut -d: -f2 |tail -1`
	nuevo_uid=`expr $ult + 1`
  sudo touch "/home/paloma/script/NuevoUser.ldif"
  pathldif="/home/paloma/script/NuevoUser.ldif"
	echo "dn: cn=$linea,ou=$ou,dc=$dc1,dc=$dc2" > $pathldif
  echo "objectClass: inetOrgPerson" >> $pathldif
	echo "objectClass: posixAccount" >> $pathldif
  echo "objectClass: shadowAccount" >> $pathldif
	echo "cn: $linea" >> $pathldif
	echo "uid: $nuevo_uid" >> $pathldif
	echo "sn: $linea" >> $pathldif
	echo "givenName: $linea" >> $pathldif
	ldapadd -D "cn=admin,dc=$dc1,dc=$dc2" -w $contra -f $pathldif
done < "/home/paloma/scripts/fichero.txt"
