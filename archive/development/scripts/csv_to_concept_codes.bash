#!/usr/bin/env bash


function usage(){
	echo
	echo "Usage: (NO EQUALS SIGNS)"
	echo
	echo "`basename $0`"
	echo
	echo "`basename $0` PATH/CSV_FILES"
	echo
	echo "Example:"
	echo
	echo "`basename $0` vital_records/*.csv"
	echo
	echo "`basename $0` /some/abs/path/vital_records/*.csv"
	echo
	echo "Defaults:"
	echo
	exit 1
}

echo "USE chirp"
echo "GO"

while [ $# -ne 0 ] ; do


	base=${1%.*}	#	remove extension
	base=${base,,}	#	downcase
	#echo $base
	schema=${base%/*}			#	remove everything after last / (basically the file name)
	schema=${schema##*/}	#	remove everything before first / (basically the abs path if exists)
	#echo $schema
	table=${base##*/}	#	file name
	#echo $table

	#/Users/jakewendt/github/unreno/chirp/scripts/vital_records/BIRTH.csv
	#/users/jakewendt/github/unreno/chirp/scripts/vital_records/birth
	#vital_records
	#birth

	#vital_records/BIRTH.csv
	#vital_records/birth
	#vital_records
	#birth


	#CREATE TABLE [dbo].concepts (
	#        id int IDENTITY(1,1),
	#        code VARCHAR(255) PRIMARY KEY,
	#        path VARCHAR(255),
	#        description VARCHAR(MAX),
	#        CONSTRAINT unique_code 
	#                UNIQUE (code)
	#);

	#	printing single quotes in awk is so fun.
	#	can pass in a variable when calling -v sq="'" then print sq will print '
	#	can use some nested quotes print "'"'"'" will also print '
	#	can also print the ascii code \x27 so print "\x27" will also print '
	#	whichever floats your boat.

	sort -t, -k2,2n $1 | awk -F, -v schema=$schema -v table=$table '{
		print "INSERT INTO [dbo].[concepts] VALUES ("
		print "\t\x27"table":"tolower($1)"\x27,"
		print "\t\x27/"schema"/"table"/"tolower($1)"\x27,"
		print "\t\x27"schema":"table":"tolower($1)"\x27);"
	}'

	shift
done

#	No need for this now as changed code above.
#echo
#echo "UPDATE dbo.concepts"
#echo "SET code = STUFF(code, 1, CharIndex(':',code), '')"
#echo "WHERE code LIKE 'vital_records:%'"
#echo
