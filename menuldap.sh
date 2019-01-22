#!/bin/bash

##########################
##Autor: Paloma García
##Description: Script que muestra un menú y
## nos permite crear, listar y borrar unidades organizativas y usuarios...
##########################

#Recogemos los datos del dominio
	clear
	echo "------------------------------"
        echo "Escriba nombre de dominio : "
        read dc1
        echo "Escriba terminación de dominio : "
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
	echo "Escriba un nombre para nueva OU - salir para volver al menú"
	read ou

	while [ $ou != "salir" ]; do
		echo "dn: ou=$ou,dc=$dc1,dc=$dc2" > crearou.ldif
		echo "ObjectClass: organizationalUnit" >> crearou.ldif
		echo "ou: $ou" >>crearou.ldif
		ldapadd -D "cn=admin,dc=$dc1,dc=$dc2" -W -f crearou.ldif
		echo "Escriba un nombre para crear otra ou - salir para volver al menú "
		read ou
	done
	echo "-- Unidad organizativa borrada correctamente"
	echo "-- Lista unidades organizativas del dominio $dc1 . $dc2 --"
	ldapsearch -x -b "dc=$d1,dc=$d2" objectClass=organizationalUnit | grep dn:
}

##Función que lista las ou y permite borrarlas
borrarou(){
	clear
	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=organizationalUnit | grep dn:
	echo "Escriba nombre unidad organizativa a borrar - salir para volver al menú"
	read ou
	while [ $ou != "salir" ]; do
		echo "Confirme que desea borrar la OU $ou s/n"
		read confir
		if [ $confir = s ];then
			ldapdelete -x -D "cn=admin,dc=$dc1,dc=$dc2" -W ou=$ou,dc=$dc1,dc=$dc2 
			ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=organizationalUnit | grep dn:
		fi
		echo "-- Unidad Organizativa borrada correctamente --"
		echo "Introduce otra OU - salir para volver al menú"
		read ou
	done
}

##Función que crea usuarios en unidad organizativa y lista los usuarios
crearu(){
	echo "Escriba la unidad organizativa a la que desea añadir el usuario"
	read ou
	echo "Escriba un nombre para su usuario - salir para volver al menú"
	read usuario

	while [ $usuario != "salir" ]; do
		echo "-- Uid último usuario --"
		ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep uid | tail -1
		echo "Escriba el uid de su nuevo usuario"
		read uid
		echo "Escribe el apellido"
		read apellido
		echo "dn: cn=$usuario,ou=$ou,dc=$dc1,dc=$dc2" > crearuser.ldif
		echo "objectClass: inetOrgPerson" >> crearuser.ldif
       		echo "objectClass: person" >> crearuser.ldif
		echo "cn: $usuario" >> crearuser.ldif
		echo "uid: $uid" >> crearuser.ldif
		echo "sn: $apellido" >> crearuser.ldif
		echo "givenName: $usuario" >> crearuser.ldif

		ldapadd -D "cn=admin,dc=$dc1,dc=$dc2" -W -f crearuser.ldif
##userPassword: {SSHA}6dVMmOtZ7P0mSR/FN9peprES6P1rV5

		echo "Escriba un nombre para su usuario - salir para volver al menú "
		read usuario

	done
	echo "-- Listado usuarios del dominio $dc1 . $dc2 --"
	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person
}

#Función que lista los usuarios y los borra
borraru(){
        clear
        ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep cn
        echo "Escriba nombre del usuario que desea borrar - salir para volver al menú"
        read usuario
	echo "Escriba la ou a la que pertenece su usuario"
	read ou
        while [ $usuario != "salir" ]; do
                echo "Confirme que desea borrar el usuario $usuario s/n"
                read confir
                if [ $confir = s ];then
                        ldapdelete -x -D "cn=admin,dc=$dc1,dc=$dc2" -W uid=$usuario,ou=$ou,dc=$dc1,dc=$dc2 
                        echo "-- Listado usuarios del dominio $dc1 . $dc2"
			ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep cn
		fi
                echo "-- Usuario borrada correctamente --"
                echo "Escribe otro nombre de usuario para borrar - salir para volver al menú"
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
	read -p "Pulse una tecla para continuar" p
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
