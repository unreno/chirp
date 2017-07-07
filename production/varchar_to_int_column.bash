#!/usr/bin/env bash

#	$1 - schema and table: vital.births
#	$2 - field: name_sur

[ $# -ne 2 ] && exit;

table=$1
field=$2

echo
echo "IF COL_LENGTH('${table}','_${field}_int') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_int;"
echo "ALTER TABLE ${table} ADD _${field}_int AS"

echo "CAST( NULLIF("
ascii_letters=$(seq 65 90)
for l in $ascii_letters ; do
echo -n "REPLACE("
done

echo -n "REPLACE("
echo -n "REPLACE("
echo -n "REPLACE("
echo -n "REPLACE("
echo -n "REPLACE("
echo -n "REPLACE("
echo -n "REPLACE("

echo -n "${field} "

for l in $ascii_letters ; do
printf ", '\x$(printf %x $l)','')"
done

echo -n ",' ','')"
echo -n ",'.','')"
echo -n ",'-','')"
echo -n ",'\`','')"
echo -n ",'/','')"
echo -n ",'*','')"
echo -n ",'?','')"

echo ",'') AS DECIMAL(38,0))"

echo "PERSISTED;"
echo

