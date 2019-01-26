#!/bin/bash

#########################
## Author: Paloma García Acebes
##
## Description: Este script automatiza la busqueda de servidor ldap
########################

host=192.168.86.157
base="dc=paloma,dc=es"

ldapsearch -x -H ldap://$host -b $base
