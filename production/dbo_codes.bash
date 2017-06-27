#!/usr/bin/env bash

cat dbo_codes.sql


echo "DECLARE @bulk_cmd VARCHAR(1000)"

#		print "DECLARE @bulk_cmd VARCHAR(1000) = '"'"'BULK INSERT dbo.bulk_insert_codes"
#	Can only DECLARE once. Could call GO but predeclaring works. Thought I might need to call GO.

# The contents of these csv files can contain commas
#	and so are quoted and bulk insert won't remove these.
#	In this case, BULK INSERT works as the commas are in the last field
#	Nevertheless, converting to TABs with tsv. Pretty on github and in vi too.
#	TABs are BULK INSERT's default separator anyhow.
#	Must manually remove single and double quote wrappers.
ls -1 content/vital/*/*tsv | \
	awk -F. '{print $1}' | awk -F/ '{
		schema=$(NF-2)  #	or $2
		table=$(NF-1)   #	or $3
		codeset=$NF     #	or $4
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT '"'"'"schema"'"'"' FOR _schema;"
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT '"'"'"table"'"'"' FOR _table;"
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT '"'"'"codeset"'"'"' FOR codeset;"
		print "SET @bulk_cmd = '"'"'BULK INSERT dbo.bulk_insert_codes"
		print "	FROM '"''"'Z:\\Renown Project\\CHIRP\\Personal folders\\Jake\\chirp\\production\\content\\"schema"\\"table"\\"codeset".tsv'"''"'"
		print "	WITH ("
		print "		ROWTERMINATOR = '"'''"'+CHAR(10)+'"'''"',"
		print "		FIRSTROW = 2,"
		print "		TABLOCK"
		print "	)'"'"';"
		print "	EXEC(@bulk_cmd);"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;\n"
}'

ls -1 content/webiz/*/*tsv | \
	awk -F. '{print $1}' | awk -F/ '{
		schema=$(NF-2)  #	or $2
		table=$(NF-1)   #	or $3
		codeset=$NF     #	or $4
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT '"'"'"schema"'"'"' FOR _schema;"
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT '"'"'"table"'"'"' FOR _table;"
		print "ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT '"'"'"codeset"'"'"' FOR codeset;"
		print "SET @bulk_cmd = '"'"'BULK INSERT dbo.bulk_insert_codes_with_units"
		print "	FROM '"''"'Z:\\Renown Project\\CHIRP\\Personal folders\\Jake\\chirp\\production\\content\\"schema"\\"table"\\"codeset".tsv'"''"'"
		print "	WITH ("
		print "		ROWTERMINATOR = '"'''"'+CHAR(10)+'"'''"',"
		print "		FIRSTROW = 2,"
		print "		TABLOCK"
		print "	)'"'"';"
		print "	EXEC(@bulk_cmd);"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;"
		print "ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;\n"
}'



