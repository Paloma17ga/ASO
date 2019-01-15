#!/bin/bash

##Author:Paloma García
##Description:Copia de seguridad con fecha almacenada en /tmp/.
####################

user=$(whoami)
input=/home/$user
output=/tmp/${user}_home_$(date +%Y-%m-%d_%H%M%S).tar.gz

function total_files {
	find $1 -type f | wc -l
}

function total_directories {
	find $1 -type f | wc -l
}

function total_archived_directories {
	tar -tzf $1 | grep /$ | wc -l
}

function total_archived_files {
	tar -tzf $1 | grep -v /$ | wc -l
}

tar -czf $output $input 2> /dev/null

clear
scr_files =$( total_files $input )
scr_directories =$( total_directories $input) 

arch_files =$( total_archived_files $output )
arch_directories =$( total_archived_directories $output )

clear
echo "Backup of $input completed! Details about the output backup file:"

echo "Files to be included : $src_files"
echo "Directories to be included : $src_directories"
echo "Files archived : $arch_files"
echo "Directories archived : $arch_directories"

if [ $src_files -eq $arch_files ]; then
	echo "Backup of $input completed!"
	echo "Details about the output backup file :"
	ls -l $output
else
	echo "Backup of $input failed!"
fi
