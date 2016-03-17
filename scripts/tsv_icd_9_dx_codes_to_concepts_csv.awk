#
#	awk -f scripts/tsv_icd_9_dx_codes_to_concepts_csv.awk ICD-9-CM-v32-master-descriptions/CMS32_DESC_LONG_DX.txt
#
#	code VARCHAR(255) PRIMARY KEY,
#	path VARCHAR(255),
#	description VARCHAR(MAX),
#
BEGIN{
	FS="\t"
}
{
	print "ICD9DX:"$1",/ICD9DX/"$1",\""$2"\""
}
