#!/usr/bin/env bash

schema='vital_records'

echo "USE chirp"

#
#	NOTE: databases and schemas must be unique on entire server.
#		If another database has a schema of the same name, too bad.
#

#	FYI: 'CREATE SCHEMA' must be the first statement in a query batch.
#		So precede with a GO call.
echo "GO"
echo "CREATE SCHEMA $schema"
echo "GO"

while [ $# -ne 0 ] ; do

#IF OBJECT_ID('births', 'U') IS NOT NULL
#        DROP TABLE births;
#CREATE TABLE births (
#        id int IDENTITY(1,1) PRIMARY KEY,

	base=${1%.*}
	echo
#	echo "CREATE TABLE ${base,,} ("
	echo "IF OBJECT_ID('[$schema].$base', 'U') IS NOT NULL"
	echo "	DROP TABLE [$schema].$base;"

	echo "CREATE TABLE [$schema].$base ("

	sort -t, -k2,2n $1 | awk -F, '{
		if( buffer )
			printf "%s,\n", buffer
		type=$4
		if( $4 == "varch" )
			type="VARCHAR("$5")"
		else if( $4 == "datet" )
			type="DATETIME"
		null=( $3 == "NO" ) ? " NOT NULL" : ""
		buffer=sprintf("\t%s %s%s", $1, type, null)
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
