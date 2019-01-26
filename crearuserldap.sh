#!/bin/bash

echo "Escriba un nombre de dominio"
read dc1

echo "Escriba terminacion de su dominio"
read dc2

echo "Escriba la unidad organizativa a la que pertenece su usuario"
read ou

echo "Escriba un nombre para su usuario - salir'saldrá del scrip "
read usuario

while [ $usuario != "salir" ]; do
	echo "--Uid ultimo usuario--"
	ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person | grep uid
	echo "Escriba el uid de su nuevo usuario"
	read uid
	echo "Escribe el apellido"
	read apellido
	echo "dn: uid=$usuario,ou=$ou,dc=$dc1,dc=$dc2" > crearuser.ldif
	echo "objectClass: inetOrgPerson" >> crearuser.ldif
        echo "objectClass: person" >> crearuser.ldif
	echo "cn: $usuario" >> crearuser.ldif
	echo "uid: $uid" >> crearuser.ldif
	echo "sn: $apellido" >> crearuser.ldif
	echo "givenName: $usuario" >> crearuser.ldif

	ldapadd -D "cn=admin,dc=$dc1,dc=$dc2" -W -f crearuser.ldif
##userPassword: {SSHA}6dVMmOtZ7P0mSR/FN9peprES6P1rV5

	echo "Escriba un nombre para su usuario - salir'saldrá del scrip "
	read usuario

done

ldapsearch -x -b "dc=$dc1,dc=$dc2" objectClass=person
