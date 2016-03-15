#
#	tail -n +2 all_lmrp/hcpc_code_lookup.csv | sort -r -k1,1 -k2,2n | awk -F, '( $1 != prev ){ print; prev=$1 }'  | sort -k1,1 | awk -f scripts/csv_hcpc_codes_to_concepts_sql.awk
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
	gsub("\"\"","\"",$5);
	gsub("'","''",$5);

	print "INSERT INTO [dbo].[concepts] VALUES ("
	print "\t\x27HCPC:"$1"\x27,"
	print "\t\x27/HCPC/"$1"\x27,"
	print "\t\x27"substr($5,2,length($5)-2)"\x27);"
}
