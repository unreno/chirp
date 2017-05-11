#
#	tail -n +2 ndc/package.txt | sort -t$'\t' -k3,3  | awk -F"\t" '( $3 != prev ){ print; prev=$3 }' | awk -f scripts/tsv_ndc_package_codes_to_concepts_csv.awk
#
#	code VARCHAR(255) PRIMARY KEY,
#	path VARCHAR(255),
#	description VARCHAR(MAX),
#
#	Sadly, there are about 20 codes that are not unique here.
#	If I ignore this and just insert them, the repeats will just
#	fail to load which is as good a result as I would get if 
#	I spent time trying to figure out how to not insert them.
#	(removing dupes now)
#
#	http://www.fda.gov/Drugs/InformationOnDrugs/ucm142438.htm
#	http://www.accessdata.fda.gov/cder/ndc.zip
#
BEGIN{
	FS="\t"
}
#( NR > 1 ){
{
	gsub("","",$4);
	print "NDC:"$3",/NDC/"$3",\""$4"\""
}
