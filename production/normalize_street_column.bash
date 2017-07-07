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
echo "	RTRIM( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( ${field}"
echo "		,' TRAIL',' '),' TRL',' ')"
echo "		,' BOULEVARD',' '),' BLVD',' ')"
echo "		,' COURT',' '),' CT',' ')"
echo "		,' STREET',' '),' ST',' ')"
echo "		,' DRIVE',' '),' DRIV',' '),' DRI',' '),' DR',' ')"
echo "		,' ROAD',' '),' RD',' ')"
echo "		,' CIRCLE',' '),' CIR',' ')"
echo "		,' LANE',' '),' LN',' ')"
echo "		,' AVENUE',' '),' AVE',' ')"
echo "		,' APT',' '),' UNIT',' ')"
echo "		,' MOUNT',' MT'),' PARKWAY',' '),' PKWY',' ')"
echo "		,' WAY',' '),' PL',' ')"
echo "		,'SOUTH','S'),'NORTH','N'),'EAST','E'),'WEST','W') )"
echo "	PERSISTED;"
echo

echo
echo "IF COL_LENGTH('${table}','_${field}_prehash') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_prehash;"
echo "ALTER TABLE ${table} ADD _${field}_prehash AS"
echo "	RTRIM( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "		SUBSTRING( ${field}, 1,"
echo "			ISNULL(NULLIF(CHARINDEX('#',${field})-1,-1),LEN(${field})))"
echo "		,' TRAIL',' '),' TRL',' ')"
echo "		,' BOULEVARD',' '),' BLVD',' ')"
echo "		,' COURT',' '),' CT',' ')"
echo "		,' STREET',' '),' ST',' ')"
echo "		,' DRIVE',' '),' DRIV',' '),' DRI',' '),' DR',' ')"
echo "		,' ROAD',' '),' RD',' ')"
echo "		,' CIRCLE',' '),' CIR',' ')"
echo "		,' LANE',' '),' LN',' ')"
echo "		,' AVENUE',' '),' AVE',' ')"
echo "		,' APT',' '),' UNIT',' ')"
echo "		,' MOUNT',' MT'),' PARKWAY',' '),' PKWY',' ')"
echo "		,' WAY',' '),' PL',' ')"
echo "		,'SOUTH','S'),'NORTH','N'),'EAST','E'),'WEST','W') )"
echo "	PERSISTED;"
echo




echo
echo "IF COL_LENGTH('${table}','_${field}_precomma') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_precomma;"
echo "ALTER TABLE ${table} ADD _${field}_precomma AS"
echo "	RTRIM( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "	REPLACE( REPLACE("
echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
echo "		SUBSTRING( ${field}, 1,"
echo "			ISNULL(NULLIF(CHARINDEX(',',${field})-1,-1),LEN(${field})))"
echo "		,' TRAIL',' '),' TRL',' ')"
echo "		,' BOULEVARD',' '),' BLVD',' ')"
echo "		,' COURT',' '),' CT',' ')"
echo "		,' STREET',' '),' ST',' ')"
echo "		,' DRIVE',' '),' DRIV',' '),' DRI',' '),' DR',' ')"
echo "		,' ROAD',' '),' RD',' ')"
echo "		,' CIRCLE',' '),' CIR',' ')"
echo "		,' LANE',' '),' LN',' ')"
echo "		,' AVENUE',' '),' AVE',' ')"
echo "		,' APT',' '),' UNIT',' ')"
echo "		,' MOUNT',' MT'),' PARKWAY',' '),' PKWY',' ')"
echo "		,' WAY',' '),' PL',' ')"
echo "		,'SOUTH','S'),'NORTH','N'),'EAST','E'),'WEST','W') )"
echo "	PERSISTED;"
echo




