#!/usr/bin/env bash

#	$1 - schema and table: vital.births
#	$2 - field: name_sur

[ $# -ne 2 ] && exit;

table=$1
field=$2

#	order matters. BOULEVARD contains RD, so do before RD extraction"

#	Perhaps I should rewrite this as a loop to make it more clear
#
#echo
#echo "IF COL_LENGTH('${table}','_${field}') IS NOT NULL"
#echo "	ALTER TABLE ${table} DROP COLUMN _${field};"
#echo "ALTER TABLE ${table} ADD _${field} AS"
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( ${field}"
#echo "		,' TRAIL',' '),' TRL',' ')"
#echo "		,' BOULEVARD',' '),' BLVD',' ')"
#echo "		,' COURT',' '),' CT',' ')"
#echo "		,' STREET',' '),' ST',' ')"
#echo "		,' DRIVE',' '),' DRIV',' '),' DRI',' '),' DR',' ')"
#echo "		,' ROAD',' '),' RD',' ')"
#echo "		,' CIRCLE',' '),' CIR',' ')"
#echo "		,' LANE',' '),' LN',' ')"
#echo "		,' AVENUE',' '),' AVE',' ')"
#echo "		,' APT',' '),' UNIT',' ')"
#echo "		,' MOUNT',' MT'),' PARKWAY',' '),' PKWY',' ')"
#echo "		,' WAY',' '),' PL',' ')"
#echo "		,'SOUTH','S'),'NORTH','N'),'EAST','E'),'WEST','W'),' ','')"
#echo "	PERSISTED;"
#echo
#
#echo
#echo "IF COL_LENGTH('${table}','_${field}_prehash') IS NOT NULL"
#echo "	ALTER TABLE ${table} DROP COLUMN _${field}_prehash;"
#echo "ALTER TABLE ${table} ADD _${field}_prehash AS"
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "		SUBSTRING( ${field}, 1,"
#echo "			ISNULL(NULLIF(CHARINDEX('#',${field})-1,-1),LEN(${field})))"
#echo "		,' TRAIL',' '),' TRL',' ')"
#echo "		,' BOULEVARD',' '),' BLVD',' ')"
#echo "		,' COURT',' '),' CT',' ')"
#echo "		,' STREET',' '),' ST',' ')"
#echo "		,' DRIVE',' '),' DRIV',' '),' DRI',' '),' DR',' ')"
#echo "		,' ROAD',' '),' RD',' ')"
#echo "		,' CIRCLE',' '),' CIR',' ')"
#echo "		,' LANE',' '),' LN',' ')"
#echo "		,' AVENUE',' '),' AVE',' ')"
#echo "		,' APT',' '),' UNIT',' ')"
#echo "		,' MOUNT',' MT'),' PARKWAY',' '),' PKWY',' ')"
#echo "		,' WAY',' '),' PL',' ')"
#echo "		,'SOUTH','S'),'NORTH','N'),'EAST','E'),'WEST','W'),' ','')"
#echo "	PERSISTED;"
#echo
#
#
#
#
#echo
#echo "IF COL_LENGTH('${table}','_${field}_precomma') IS NOT NULL"
#echo "	ALTER TABLE ${table} DROP COLUMN _${field}_precomma;"
#echo "ALTER TABLE ${table} ADD _${field}_precomma AS"
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE("
#echo "	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE("
#echo "		SUBSTRING( ${field}, 1,"
#echo "			ISNULL(NULLIF(CHARINDEX(',',${field})-1,-1),LEN(${field})))"
#echo "		,' TRAIL',' '),' TRL',' ')"
#echo "		,' BOULEVARD',' '),' BLVD',' ')"
#echo "		,' COURT',' '),' CT',' ')"
#echo "		,' STREET',' '),' ST',' ')"
#echo "		,' DRIVE',' '),' DRIV',' '),' DRI',' '),' DR',' ')"
#echo "		,' ROAD',' '),' RD',' ')"
#echo "		,' CIRCLE',' '),' CIR',' ')"
#echo "		,' LANE',' '),' LN',' ')"
#echo "		,' AVENUE',' '),' AVE',' ')"
#echo "		,' APT',' '),' UNIT',' ')"
#echo "		,' MOUNT',' MT'),' PARKWAY',' '),' PKWY',' ')"
#echo "		,' WAY',' '),' PL',' ')"
#echo "		,'SOUTH','S'),'NORTH','N'),'EAST','E'),'WEST','W'),' ','')"
#echo "	PERSISTED;"
#echo
#

add_nest(){
	nest="${*}"
#	Perhaps should always expand or always abbreviate?
#	Replacing with spaces is just destroying info.
#	Of course, I've noticed some cases where one was STREET and another was ROAD.
#	Removing removes this user induced limitation.
	nest="REPLACE(${nest},' TRAIL',' ')"
	nest="REPLACE(${nest},' TRL',' ')"
#	order matters. BOULEVARD contains RD, so do before RD extraction"
	nest="REPLACE(${nest},' BOULEVARD',' ')"
	nest="REPLACE(${nest},' BLVD',' ')"
	nest="REPLACE(${nest},' COURT',' ')"
	nest="REPLACE(${nest},' CT',' ')"
	nest="REPLACE(${nest},' DRIVE',' ')"
	nest="REPLACE(${nest},' DRIV',' ')"
	nest="REPLACE(${nest},' DR',' ')"
	nest="REPLACE(${nest},' ROAD',' ')"
	nest="REPLACE(${nest},' RD',' ')"
	nest="REPLACE(${nest},' CIRCLE',' ')"
	nest="REPLACE(${nest},' LANE',' ')"
	nest="REPLACE(${nest},' LN',' ')"
	nest="REPLACE(${nest},' AVENUE',' ')"
	nest="REPLACE(${nest},' AVE',' ')"
	nest="REPLACE(${nest},' APT',' ')"
	nest="REPLACE(${nest},' UNIT',' ')"
#	why keep? what about MNT? Or MTN? Or MTAIN? (Actually MTAIN is a result of this replacement)
#	nest="REPLACE(${nest},' MOUNT',' MT')"
	nest="REPLACE(${nest},' MOUNTAIN',' ')"
	nest="REPLACE(${nest},' MOUNT',' ')"
	nest="REPLACE(${nest},' MTN',' ')"
	nest="REPLACE(${nest},' PARKWAY',' ')"
	nest="REPLACE(${nest},' PKWY',' ')"
	nest="REPLACE(${nest},' WAY',' ')"
	nest="REPLACE(${nest},' PLACE',' ')"
	nest="REPLACE(${nest},' PL',' ')"
	nest="REPLACE(${nest},' STREET',' ')"
	nest="REPLACE(${nest},' ST',' ')"
	nest="REPLACE(${nest},'NORTH','N')"
	nest="REPLACE(${nest},'SOUTH','S')"
	nest="REPLACE(${nest},'EAST','E')"
	nest="REPLACE(${nest},'WEST','W')"
	nest="REPLACE(${nest},'SS','S')"
	nest="REPLACE(${nest},'OO','O')"
	nest="REPLACE(${nest},'NN','N')"
	nest="REPLACE(${nest},' ','')"
	echo $nest
}


s=$(add_nest "${field}")
echo 
echo "IF COL_LENGTH('${table}','_${field}') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field};"
echo "ALTER TABLE ${table} ADD _${field} AS"
echo $s
echo "	PERSISTED;"
echo

#	Take everything up to first , (comma)
s="SUBSTRING( ${field}, 1, ISNULL(NULLIF(CHARINDEX('#',${field})-1,-1),LEN(${field})))"
s=$(add_nest "$s")
echo 
echo "IF COL_LENGTH('${table}','_${field}_prehash') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_prehash;"
echo "ALTER TABLE ${table} ADD _${field}_prehash AS"
echo $s
echo "	PERSISTED;"
echo

#	Take everything up to first , (comma)
s="SUBSTRING( ${field}, 1, ISNULL(NULLIF(CHARINDEX(',',${field})-1,-1),LEN(${field})))"
s=$(add_nest "$s")
echo 
echo "IF COL_LENGTH('${table}','_${field}_precomma') IS NOT NULL"
echo "	ALTER TABLE ${table} DROP COLUMN _${field}_precomma;"
echo "ALTER TABLE ${table} ADD _${field}_precomma AS"
echo $s
echo "	PERSISTED;"
echo



