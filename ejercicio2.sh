#!/bin/sh

#################
#Autor: Paloma García
#Description: Comentar el siguiente script, interpretar y reorganizar
#################

crear_fichero(){
	if [ -z $2 ];then
		orden="user"
	else 
		orden=$2
	fi
	echo $orden
	read pause
	echo "<html>" >$fichero
	echo "<body>" >>$fichero
		echo "<pre>" >>$fichero
	ps -eo user,pid,cmd --sort $orden	>>$fichero
		echo "</pre>" >>$fichero
	echo "</body>" >>$fichero
	echo "</html>" >>$fichero
		echo "¿Desea verificar que se ha creado el fichero?"
		read respuesta
		if [ $respuesta = "s" ]; then
			comprobar
		fi
}
comprobar(){
	#Verificar que el fichero se ha creado con exito
	cat $fichero
}
if [ -z $1 ];then
	echo "Uso: $0 nombrefichero.hmtl [user|pid|cmd]"
	read pause
else
	if [ -z $2 ];then
		order="user"
	else
		case $2 in
		user|pid|cmd)
			orden=$2
			;;
		*) echo "Error de parametro ordenacion"
			exit
			;;
		esac
	fi
	echo $orden
	read pause
	fichero=$1
	if [ -e $fichero ];then
		echo "Fichero $fichero existe, ¿desea sobreescribirlo? s/n"
		read respuesta
		if [ $respuesta = "s" ];then
			crear_fichero
		else
			echo "No quieres crear el fichero"
			exit
		fi
	else
		echo "No existe y no lo creo"
		crear_fichero
		
	fi
fi

