#!/bin/bash

##################
## Author:Paloma García Acebes
## Description: Sencillo script con variable para definir ruta del fichero
##################

fichero="index"
extension=".html"
ruta="/var/www/html/"

my_file=$ruta$fichero$extension

echo $my_file
cat $my_file
