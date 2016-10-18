#!/usr/bin/env bash

#	$1 - schema and table: vital.births
#	$2 - field: name_sur

[ $# -ne 2 ] && exit;

table=$1
field=$2

echo
echo "IF COL_LENGTH('${table}','_${field}') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field};"
echo "ALTER TABLE ${table} ADD _${field} AS"
echo "REPLACE( REPLACE( REPLACE( REPLACE("
echo "REPLACE( REPLACE( REPLACE( ${field}"
echo "	, '-','') , ' ','') ,'''','')"
echo "	,'RR','R') ,'SS','S') ,'LL','L'),'TT','T')"
echo "PERSISTED;"
echo

