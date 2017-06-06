#!/usr/bin/env bash

#	$1 - schema and table: vital.births
#	$2 - field: name_sur

[ $# -ne 2 ] && exit;

table=$1
field=$2

index=${table/./_}

#	Indexes on the month and year proved useful as WHERE'd some of them. 
#	Not so much for the day.

echo 
#echo "IF IndexProperty(Object_Id('${table}'),"
#echo "	'${index}__${field}_day', 'IndexId') IS NOT NULL"
#echo "	DROP INDEX ${index}__${field}_day"
#echo "		ON ${table};"
echo "IF COL_LENGTH('${table}','_${field}_day') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_day;"
echo "ALTER TABLE ${table} ADD _${field}_day AS"
echo "	CAST(RIGHT(LEFT(${field},4),2) AS INT) PERSISTED;"
#echo "	DAY(${field}) PERSISTED;"
#echo "CREATE INDEX ${index}__${field}_day"
#echo "	ON ${table}( _${field}_day );"
echo
echo "IF IndexProperty(Object_Id('${table}'),"
echo "	'${index}__${field}_month', 'IndexId') IS NOT NULL"
echo "	DROP INDEX ${index}__${field}_month"
echo "		ON ${table};"
echo "IF COL_LENGTH('${table}','_${field}_month') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_month;"
echo "ALTER TABLE ${table} ADD _${field}_month AS"
echo "	CAST(LEFT(${field},2) AS INT) PERSISTED;"
#echo "	MONTH(${field}) PERSISTED;"
echo "CREATE INDEX ${index}__${field}_month"
echo "	ON ${table}( _${field}_month );"
echo
echo "IF IndexProperty(Object_Id('${table}'),"
echo "	'${index}__${field}_year', 'IndexId') IS NOT NULL"
echo "	DROP INDEX ${index}__${field}_year"
echo "		ON ${table};"
echo "IF COL_LENGTH('${table}','_${field}_year') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_year;"
echo "ALTER TABLE ${table} ADD _${field}_year AS"
echo "	CAST(RIGHT(${field},4) AS INT) PERSISTED;"
#echo "	YEAR(${field}) PERSISTED;"
echo "CREATE INDEX ${index}__${field}_year"
echo "	ON ${table}( _${field}_year );"
echo 

#	create an actual date field?
#	cannot be persisted or indexed because ...
#	"the column is non-deterministic." ??
#	Using CONVERT with a third parameter for STYLE fixes this.
#	Apparently the locale allows this to not always be the same.
#	101 = US style mm/dd/yyyy, although I don't know if it really matters.

echo
echo "IF IndexProperty(Object_Id('${table}'),"
echo "	'${index}__${field}_date', 'IndexId') IS NOT NULL"
echo "	DROP INDEX ${index}__${field}_date"
echo "		ON ${table};"
echo "IF COL_LENGTH('${table}','_${field}_date') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_date;"
echo "ALTER TABLE ${table} ADD _${field}_date AS"
#echo "	CAST(LEFT(${field},2)+'/'+LEFT(RIGHT(${field},6),2)+'/'+RIGHT(${field},4) AS DATE) PERSISTED;"
echo "	CONVERT(DATE,LEFT(${field},2)+'/'+LEFT(RIGHT(${field},6),2)+'/'+RIGHT(${field},4), 101) PERSISTED;"
echo "CREATE INDEX ${index}__${field}_date"
echo "	ON ${table}( _${field}_date );"
echo 

