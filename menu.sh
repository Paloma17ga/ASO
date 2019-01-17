#!/bin/bash

##########################
##Autor: Paloma García
##Description: Script que muestra un menú y
## nos permite ver procesos, usuarios...
##########################

show_menu(){
	clear
	echo "Menu"
	echo "1.- Procesos"
	echo "2.- Usuarios"
	echo "3.- Grupos"
	echo "4.- Paquetes instalados"
	echo "9.- Finalizar"
}
read_option(){
	read -p "Seleccione una opción [1-9] " opcion
	case $opcion in
		1) procesos;;
		2) usuarios;;
		3) grupos;;
		4) paquetes;;
		9) exit;;
		*) echo "Seleccione otra opción"
		sleep 2;;
	esac
}
procesos(){
	ps -ax|more
	read -p "Pulse una tecla para continuar" pausa
}
usuarios(){
	cat /etc/passwd|cut -f 1 -d :|sort
	read -p "Pulse una tecla para continuar" pausa
}
grupos(){
	cat /etc/group|cut -f 1 -d :|sort
	pause
}
paquetes(){
	dpkg -l
	pause
}
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
