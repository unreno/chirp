#
#	awk -f scripts/tsv_icd_9_dx_codes_to_concepts_sql.awk ICD-9-CM-v32-master-descriptions/CMS32_DESC_LONG_DX.txt
#
#	code VARCHAR(255) PRIMARY KEY,
#	path VARCHAR(255),
#	description VARCHAR(MAX),
#
BEGIN{
	FS="\t"
}
{
	gsub("'","''",$2);
	print "INSERT INTO [dbo].[concepts] VALUES ("
	print "\t\x27ICD9DX:"$1"\x27,"
	print "\t\x27/ICD9DX/"$1"\x27,"
	print "\t\x27"$2"\x27);"
}
