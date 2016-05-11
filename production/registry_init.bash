#!/usr/bin/env bash

#	As SQL apparently can't "include" other files,
#	and as this will really only be used once,
#	just catting them.

#DB_NAME='chirp_dev'
DB_NAME='chirp'

#	Put this here so can programmatically select dev or prod
echo "USE master;"
echo "IF db_id('$DB_NAME') IS NOT NULL"
echo "	DROP DATABASE $DB_NAME;"
#-- "WITH TRUSTWORTHY ON" required for use of tSQLt Testing Framework.
#--CREATE DATABASE $DB_NAME WITH TRUSTWORTHY ON;
echo "CREATE DATABASE $DB_NAME;"
echo "GO"
echo "USE $DB_NAME"
echo "GO"

cat bin.sql
cat private.sql
cat dbo.sql

cat vital.sql







#	sed 's/[[:space:]]*[^<>]=[[:space:]]*/,/g' Format\ Birth-clean.sas | tr "\t" "\n" | grep -vs "^\s*$" | grep -vs ";" | sed 's/[[:space:]]*$//' | tr -d "\r" | awk 'BEGIN{IGNORECASE=1}( /^value / ){ f=sprintf("%s.csv",$2);gsub(/\r/,"",f);next; }{print >> f }'
#	sed 's/[[:space:]]*[^<>]=[[:space:]]*/,/g' Format\ Death-clean.sas | tr "\t" "\n" | grep -vs "^\s*$" | grep -vs ";" | sed 's/[[:space:]]*$//' | tr -d "\r" | awk 'BEGIN{IGNORECASE=1}( /^value / ){ f=sprintf("%s.csv",$2);gsub(/\r/,"",f);next; }{print >> f }'

echo "DECLARE @bulk_cmd VARCHAR(1000)"

#		print "DECLARE @bulk_cmd VARCHAR(1000) = '"'"'BULK INSERT dbo.bulk_insert_codes"
#	Can only DECLARE once. Could call GO but predeclaring works. Thought I might need to call GO.

# The contents of these csv files can contain commas
#	and so are quoted and bulk insert won't remove these.
#	Must manually remove single and double quote wrappers.
ls -1 content/vital/{births,deaths}/*csv | \
	awk -F. '{print $1}' | awk -F/ '{
		gang=$(NF-1)
		trait=$NF
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_source_default DEFAULT '"'"'vital'"'"' FOR source;"
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_gang_default DEFAULT '"'"'"gang"'"'"' FOR gang;"
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_trait_default DEFAULT '"'"'"trait"'"'"' FOR trait;"
		print "BEGIN TRY"
		print "SET @bulk_cmd = '"'"'BULK INSERT dbo.bulk_insert_codes"
		print "	FROM '"''"'Z:\\Renown Project\\CHIRP\\Personal folders\\Jake\\chirp\\production\\content\\vital\\"gang"\\"trait".csv'"''"'"
		print "	WITH ("
		print "		FIELDTERMINATOR = '"''"','"''"',"
		print "		ROWTERMINATOR = '"'''"'+CHAR(10)+'"'''"',"
		print "		TABLOCK"
		print "	)'"'"';"
		print "	EXEC(@bulk_cmd);"
		print "END TRY BEGIN CATCH"
		print "	PRINT ERROR_MESSAGE()"
		print "END CATCH"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_source_default;"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_gang_default;"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_trait_default;\n"
}'


echo "UPDATE dbo.codes"
echo "	SET value = SUBSTRING ( value, 2, LEN(value)-2 )"
echo "	WHERE value LIKE '\"%\"';"
echo "UPDATE dbo.codes"
echo "	SET value = SUBSTRING ( value, 2, LEN(value)-2 )"
echo "	WHERE value LIKE '''%''';"



#cat health_lab.sql

#cat fakedoc1.sql

#cat dev.sql



#
#	Include the testing framework?
#	Is 'clr enabled' a security issue?
#	I'm turning it on only as needed. Worth it?
#
#	It's probably NOT a good idea to install this when we are actually in production.
#
#echo "EXEC sp_configure 'clr enabled', 1;"
#echo "RECONFIGURE;"
#cat ../tSQLt_V1.0.5873.27393/tSQLt.class.sql
#echo "EXEC sp_configure 'clr enabled', 0;"
#echo "RECONFIGURE;"
#cat testing_procedures.sql


for concept in DOB Sex Height Weight Race Language Zipcode Other; do
	echo "INSERT INTO dbo.concepts VALUES ("
	echo -e "\t'DEM:$concept',"
	echo -e "\t'/Demographics/$concept',"
	echo -e "\t'Demographics:$concept');"
done

echo
echo
