#!/usr/bin/env bash

#	$1 - schema and table: vital.births
#	$2 - field: name_sur

[ $# -ne 2 ] && exit;

table=$1
field=$2

echo
echo "IF COL_LENGTH('${table}','_${field}_pre') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_pre;"
echo "ALTER TABLE ${table} ADD _${field}_pre AS"
echo "	REPLACE(SUBSTRING(${field}, 1,"
echo "		ISNULL(NULLIF(CHARINDEX('-',REPLACE(${field},' ','-'))-1,-1),LEN(${field}))"
echo "	),' ','') PERSISTED;"
echo ""
echo "IF COL_LENGTH('${table}','_${field}_suf') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_suf;"
echo "ALTER TABLE ${table} ADD _${field}_suf AS"
echo "	REPLACE(SUBSTRING(${field},"
echo "		ISNULL(NULLIF(CHARINDEX('-',REPLACE(${field},' ','-'))+1,1),1),"
echo "		LEN(${field})"
echo "	),' ','') PERSISTED;"
echo

