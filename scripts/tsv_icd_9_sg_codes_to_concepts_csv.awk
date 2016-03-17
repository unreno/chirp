#
#	awk -f scripts/tsv_icd_9_sg_codes_to_concepts_csv.awk ICD-9-CM-v32-master-descriptions/CMS32_DESC_LONG_SG.txt
#
#	code VARCHAR(255) PRIMARY KEY,
#	path VARCHAR(255),
#	description VARCHAR(MAX),
#
BEGIN{
	FS="\t"
}
{
	gsub("\"","\"\"",$2)
	print "ICD9SG:"$1",/ICD9SG/"$1",\""$2"\""
}
