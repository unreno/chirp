#!/usr/bin/env bash

#	$1 - schema and table: ${table}
#	$2 - field: name_sur

[ $# -ne 2 ] && exit;

table=$1
field=$2
index=${table/./_}

echo 
#echo "--IF IndexProperty(Object_Id('${table}'),"
#echo "--	'${index}__${field}_pre', 'IndexId') IS NOT NULL"
#echo "--	DROP INDEX ${index}__${field}_pre"
#echo "--		ON ${table};"
echo "IF COL_LENGTH('${table}','_${field}_pre') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_pre;"
echo "ALTER TABLE ${table} ADD _${field}_pre AS"
echo "	SUBSTRING(${field}, 1,"
echo "		ISNULL(NULLIF(CHARINDEX(' ',${field})-1,-1),LEN(${field}))"
echo "	) PERSISTED;"
#echo "--CREATE INDEX ${index}__${field}_pre"
#echo "--	ON ${table}( _${field}_pre );"
echo
#echo "--IF IndexProperty(Object_Id('${table}'),"
#echo "--	'${index}__${field}_suf', 'IndexId') IS NOT NULL"
#echo "--	DROP INDEX ${index}__${field}_suf"
#echo "--		ON ${table};"
echo "IF COL_LENGTH('${table}','_${field}_suf') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_suf;"
echo "ALTER TABLE ${table} ADD _${field}_suf AS"
echo "	SUBSTRING(${field},"
echo "		ISNULL(NULLIF(CHARINDEX(' ',${field})+1,1),1),"
echo "		LEN(${field})"
echo "	) PERSISTED;"
#echo "--CREATE INDEX ${index}__${field}_suf"
#echo "--	ON ${table}( _${field}_suf );"
echo 
