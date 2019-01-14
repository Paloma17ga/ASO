#!/bin/bash

#####################
##Author:Paloma García
##Description:Copia de seguridad con fecha almacenada en /tmp/.
####################

user=$(whoami)
input=/home/$user
output=/tmp/${user}_home_$(date +%Y-%m-%d_%H%M%S).tar.gz

tar -czf $output $input
clear
echo "Backup of $input completed! Details about the output backup file:"
ls -l $output

