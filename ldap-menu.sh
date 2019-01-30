#!/bin/bash

##########################
# Author: Paloma García
# Description: Script que muestra un menú y
# permite crear, listar y borrar unidades organizativas y usuarios...
##########################

#Recogemos los datos del dominio
clear
echo "Introduzca nombre de dominio "
read dc1
echo "Introduzca terminación de dominio "
read dc2

#Función menú
show_menu(){
	clear
	echo "---------------Menu---------------"
	echo "1.- Crear Unidad Organizativa"
	echo "2.- Borrar Unidad Organizativa"
	echo "3.- Crear Usuarios"
	echo "4.- Borrar Usuarios"
	echo "5.- Listar Unidades Organizativas"
	echo "6.- Listar Usuarios"
	echo "7.- Finalizar"
        echo "----------------------------------"
}

##Función que pide una opción y la asigna con su función
read_option(){
	read -p "Seleccione una opción [1-6] " opcion
	case $opcion in
		1) crearou;;
		2) borrarou;;
		3) crearu;;
		4) borraru;;
		5) listarou;;
		6) listaru;;
		7) exit;;
		*) echo "Seleccione otra opción"
		sleep 2;;
	esac
}

##Función que recoge nombre, crea unidad organizativa, lista y permite seguir creando
crearou(){
	clear
	echo "Introduzca un nombre para su nueva OU -f- para para volver al menú"
	read ou

	while [ $ou != "f" ]; do
		echo "dn: ou=$ou,dc=$dc1,dc=$dc2" > crearou.ldif
		echo "ObjectClass: organizationalUnit" >> crearou.ldif
		echo "ou: $ou" >>crearou.ldif
		ldapadd -D "cn=admin,dc=$dc1,dc=$dc2" -W -f crearou.ldif
        	echo "-- Lista unidades organizativas del dominio $dc1 . $dc2 --"
       		ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=organizationalUnit | grep dn:
		echo "Introduzca un nombre para su nueva OU -f- para volver al menú "
		read ou
	done
}

##Función que lista las ou y permite borrarlas
borrarou(){
	clear
	echo "-- Lista unidades organizativas del dominio $dc1 . $dc2 --"
	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=organizationalUnit | grep dn:
	echo "Introduzca el nombre unidad organizativa a borrar -f- para volver al menú"
	read ou

	while [ $ou != "f" ]; do
		echo "Confirme que desea borrar la OU $ou s/n"
		read confir
		if [ $confir = s ];then
			ldapdelete -x -D "cn=admin,dc=$dc1,dc=$dc2" -W ou=$ou,dc=$dc1,dc=$dc2 
		fi
        	echo "-- Lista unidades organizativas del dominio $dc1 . $dc2 --"
        	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=organizationalUnit | grep dn:
		echo "Introduzca el nombre unidad organizativa a borrar -f- para volver al menú"
		read ou
	done
}

##Función que crea usuarios en unidad organizativa y lista los usuarios
crearu(){
	clear
	echo "Introduzca unidad organizativa a la que desea añadir el usuario"
	read ou
	echo "Introduzca un nombre para su usuario -f- para volver al menú"
	read usuario

	while [ $usuario != "f" ]; do
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
		echo "-- Listado usuarios del dominio $dc1 . $dc2 --"
       		ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep cn
		echo "Introduzca un nombre para su usuario -f- para volver al menú "
		read usuario
	done
}

#Función que lista los usuarios y los borra
borraru(){
        clear
	echo "-- Listado usuarios del dominio $dc1 . $dc2 --"
        ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep cn
        echo "Introduzca nombre del usuario que desea borrar -f- para volver al menú"
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

		echo "Introduzca nombre del usuario que desea borrar -f- para volver al menú"
                read usuario
        done
}

##Función que lista ous
listarou(){
        clear
        echo "-- Listado unidades organizativas del dominio $dc1 . $dc2 --"
        ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=organizationalUnit | grep dn:
        pause
}

#Función que lista los usuarios
listaru(){
	clear
	echo "-- Listado usuarios del dominio $dc1 . $dc2 --"
	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep cn
	pause
}

#Función que hace una pausa para la función listar
pause(){
	read -p "Pulse cualquier tecla para continuar" p
}


#####################################
#
# MAIN PROGRAM
#
#####################################
while	true; do
	show_menu
	read_option
done
