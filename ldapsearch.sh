#!/bin/bash
######################
##Author: Paloma García Acebes	
##Description: Script 
#####################

clear
echo -e "IP or host (localhost default) \c"
read host
echo "Can you enter domain name example (ana es)"
read dc1 dc2
echo "Your domain name is dc=$dc1, dc=$dc2"
base="dc="$dc1",dc="$dc2
echo $base
echo $host

# -a makes read command to read into an array
echo "What are your OU's?"
read -a ou

echo "Your OU are ${ou[0]} ${ou[1]} ${ou[2]} ${ou[3]}"

ldapsearch -x -H ldap://$host -b $base 2> /dev/null
