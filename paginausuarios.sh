#!/bin/bash

#######################
#Autor:Paloma García
#Description: Este script genera una página web 
#que muestra los usuarios del sistema
#######################

#Definicion de la ruta, del fichero y de la extension del fichero en el que almacenaremos la página web
path=/var/www/html/
pagina=usuarios_sistema
extension=".html"

fichero=$path$pagina$extension
echo "La ruta del fichero es :" $fichero
 
#Definicion variables del código html fijo del fichero creado.
cabecera="<html><head><tittle><h1>USUARIOS</h1></tittle></head><style>table,th,td{border: 2px solid black;}</style></head><body>"
fin="</table></body></html>"
echo $cabecera > $fichero

tabla="<table><tr><th>Usuarios</th></tr>" 
echo $tabla >> $fichero

#Fichero de usuarios para la página web
cat /etc/passwd|cut -d : -f 1,6 > ficherou.txt

while 	read linea;do
	echo $linea
	echo "<tr><td>"$linea"</td></tr>" >> $fichero
done < ficherou.txt
echo $fin >> $fichero

#Abrimos el navegador Firefox
/usr/bin/firefox http://localhost/$pagina/$extension
