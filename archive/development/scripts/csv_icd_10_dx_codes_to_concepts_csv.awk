#
#	tail -n +2 all_lmrp/icd10_code_lookup.csv | sort -r -k1,1 -k2,2n | awk -F, '( $1 != prev ){ print; prev=$1 }' | sort -k1,1 | awk -f scripts/csv_icd_10_dx_codes_to_concepts_csv.awk
#
#	code VARCHAR(255) PRIMARY KEY,
#	path VARCHAR(255),
#	description VARCHAR(MAX),
#
BEGIN { 
	FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)" 
}
{
	gsub("\"","",$1)
#	print "ICD10DX:"$1",/ICD10DX/"$1",\""substr($5,2,length($5)-2)"\""
#	$5 is wrapped in double quotes so why remove them and then add them?
	print "ICD10DX:"$1",/ICD10DX/"$1","$5
}
