#!/usr/bin/env bash

#	$1 - schema and table: vital.births
#	$2 - field: name_sur

[ $# -ne 2 ] && exit;

table=$1
field=$2

#	order matters. BOULEVARD contains RD, so before RD extraction"

echo
echo "IF COL_LENGTH('${table}','_${field}') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field};"
echo "ALTER TABLE ${table} ADD _${field} AS"
echo "	RTRIM( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( ${field}"
echo "		,' BOULEVARD',' ') ,' BLVD',' ')"
echo "		,' COURT',' ') ,' CT',' ') ,' STREET',' ') ,' ST',' ')"
echo "		,' DRIVE',' ') ,' DRIV',' ') ,' DRI',' ') ,' DR',' ')"
echo "		,' ROAD',' ') ,' RD',' ')"
echo "		,' CIRCLE',' ') ,' CIR',' ') ,' LANE',' ') ,' LN',' ')"
echo "		,' AVENUE',' ') ,' AVE',' ')"
echo "		,' MOUNT',' MT'),' PARKWAY',' '),' PKWY',' ')"
echo "		,'SOUTH','S') ,'NORTH','N') ,'EAST','E') ,'WEST','W') )"
echo "	PERSISTED;"
echo

