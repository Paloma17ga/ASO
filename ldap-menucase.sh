#!/bin/bash

################
# Author: Paloma García
# Description: Script que recoge datos de dominio y unidad organizativa
# y muestra un menú que permite la gestión de usuarios ldap: creado y borrado.
###############

datosiniciales(){
	clear
	read -p "Introduzca nombre de su dominio (ana): " base1 
	read -p "Introduzca la terminacion de su dominio (es): " base2 
	read -p "Introduzca su contraseña: " contr
	#read -p nombre de tu carpeta personal normalmente el mismo que el usuario del sistema" nomsis
	#nomsis=$HOME
	base="dc=$base1,dc=$base2"
	pass="$contr"
	echo $base
	rootdn="cn=admin,dc=$base1,dc=$base2"
}

function crearusuario(){
	read -p "Introduzca el nombre del usuario que desea crear: " nusu 
	ldapsearch -x -H ldap://127.0.0.1 -b "ou=$ou,$base" objectclass=organizationalPerson | grep $nusu 
	read -p "Introduzca el apellido del usuario: " apeusu 
	read -p "Introduzca el nombre con el que se va a mostrar su usuario: " mostrar
	ult=`ldapsearch -xLLL -b "$base" | grep uidNumber | cut -d: -f2 |tail -1`
	nuevo_uid=`expr $ult + 1`
	echo "dn: cn=$nusu,ou=$ou,$base" > NuevoUser.ldif
	echo "objectClass: inetOrgPerson" >> NuevoUser.ldif
	echo "objectClass: posixAccount" >> NuevoUser.ldif
	echo "objectClass: shadowAccount" >> NuevoUser.ldif
	echo "uid: $nusu" >> NuevoUser.ldif
	echo "sn: $apeusu" >> NuevoUser.ldif
	echo "givenName: $nusu" >> NuevoUser.ldif
	echo "cn: $nusu $apeusu" >> NuevoUser.ldif
	echo "displayName: Smostrar" >> NuevoUser.ldif
	echo "uidNumber: $nuevo_uid" >> NuevoUser.ldif
	echo "gidNumber: 10010" >> NuevoUser.ldif
	echo "gecos: $mostrar" >> NuevoUser.ldif
	echo "loginShell: /bin/bash" >> NuevoUser.ldif
	echo "homeDirectory: /home/$nusu" >> NuevoUser.ldif
	#sudo ldapadd -D $rootdn -w $pass -f $nomsis/NuevoUser.ldif #> /dev/null 2>&1
	ldapadd -x -D $rootdn -w $pass -f NuevoUser.ldif > /dev/null 2>&1
	if [ ! $? -eq "0" ]; then
		echo
		echo "El usuario $mostrar ya existe" 
	else
		echo
		echo "El usuario $mostrar se ha creado correctamente"
	fi
} 

function borrarusuario(){
	ldapsearch -x -H ldap://127.0.0.1 -b "ou=$ou,$base" objectclass=Person | grep dn
	read -p "Introduzca el usuario que quieres borrar : " delusu
	ldapsearch -xLLL -b "ou=$ou,$base" | grep $delusu
	if [ $? -eq "0" ]; then
		echo
		read -p "¿Seguro? (Y/N) " res 
		if [ "$res" = "Y" ]; then
			ldapdelete -x -D $rootdn -w $pass "cn=$delusu,ou=$ou,$base"
			echo
			echo "Usuario $delusu borrado correctamente"
		elif [ "$res" = "N" ]; then 
			echo
			echo "Error, el usuario $delusu no se ha borrado"
			exit
		else
			echo 
			echo "Solo Y o N" 
			echo 
		fi 
	else 
		echo 
	echo "El usuario $delusu no existe" 
	echo 
	fi
}

###############################
#
###############################

datosiniciales
echo
echo "Crear o borrar usuarios de una unidad organizativa" 
echo " __________________________________________________ " 
ldapsearch -xLLL -b "$base" objectclass=organizationalUnit| grep dn
read -p "Nombre de la unidad organizativa donde crear o borrar usuarios (F) finaliza: " ou
while [ "$ou" != "F" ]; do
	exist='ldapsearch -xLLL -b "$base" ou=$ou'
	while [ ! "Sexist" ]; do 
		echo
		echo "La unidad organizativa $ou no existe"
		exit
	done 
	echo 
	echo "Opciones: " 
	echo "1.Crear un usuario"
	echo "2.Borrar un usuario"
	echo "F- Para salir"
	echo
	read -p "Escribe el numero de la opcion de la seleccion: " op 
case "$op" in
	1) crearusuario;;
	2) borrarusuario;;
	f) echo "bye bye...."
	exit;;
	*) echo "Opción erronea";; 
esac 
ldapsearch -xLLL -b "$base" objectclass=organizationalUnit|grep dn 
read -p "Nombre de la unidad organizativa donde crear o borrar usuarios (F) finaliza : " ou
done 
