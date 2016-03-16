#
#	awk -f scripts/tsv_ndc_package_codes_to_concepts_sql.awk ndc/package.txt
#
#	code VARCHAR(255) PRIMARY KEY,
#	path VARCHAR(255),
#	description VARCHAR(MAX),
#
#	Sadly, there are about 20 codes that are not unique here.
#	If I ignore this and just insert them, the repeats will just
#	fail to load which is as good a result as I would get if 
#	I spent time trying to figure out how to not insert them.
#
#	http://www.fda.gov/Drugs/InformationOnDrugs/ucm142438.htm
#	http://www.accessdata.fda.gov/cder/ndc.zip
#
BEGIN{
	FS="\t"
}
( NR > 1 ){
	gsub("'","''",$4);
	gsub("","",$4);
	print "INSERT INTO [dbo].[concepts] VALUES ("
	print "\t\x27NDC:"$3"\x27,"
	print "\t\x27/NDC/"$3"\x27,"
	print "\t\x27"$4"\x27);"
}
