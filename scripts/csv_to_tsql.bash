#!/usr/bin/env bash

while [ $# -ne 0 ] ; do

#IF OBJECT_ID('births', 'U') IS NOT NULL
#        DROP TABLE births;
#CREATE TABLE births (
#        id int IDENTITY(1,1) PRIMARY KEY,

	base=${1%.*}
	echo
#	echo "CREATE TABLE ${base,,} ("
	echo "CREATE TABLE $base ("

	sort -t, -k2,2n $1 | awk -F, '{
		if( buffer )
			printf "%s,\n", buffer
		type=$4
		if( $4 == "varch" ){
			type="VARCHAR("$5")"
		}else if( $4 == "datet" ){
			type="DATETIME"
		} 
		buffer=sprintf("\t%s %s", $1, type)
	}
	END {
		printf "%s\n", buffer
	}'

#	DON'T print last ,

	echo ");"
	echo "GO"
	echo

	shift
done
