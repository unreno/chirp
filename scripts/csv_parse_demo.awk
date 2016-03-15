#
#	This is mostly "for the record".
#	The hcpc lookup csv file contains double-quoted fields, non-double-quoted fields,
#	double-quoted fields containing double quotes, and
#	double-quoted fields containing commas.  Whew!
#	Parsing csv can be an issue but using the proper FPAT does the trick.
#	I stumbled upon this one in a disregarded comment
#		FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)"
#	(Some records may have one more empty column though.)
#	(This happens when the last column is wrapped in double quotes.)
#
#	echo '"S2067",55,"Breast ""stacked"" diep/gap",2016-01-19 00:00:00,"BREAST RECONSTRUCTION OF A SINGLE BREAST WITH ""STACKED"" DEEP INFERIOR EPIGASTRIC PERFORATOR (DIEP) FLAP(S) AND/OR GLUTEAL ARTERY PERFORATOR (GAP) FLAP(S), INCLUDING HARVESTING OF THE FLAP(S), MICROVASCULAR TRANSFER, CLOSURE OF DONOR SITE(S) AND SHAPING THE FLAP INTO A BREAST, UNILATERAL"' | awk 'BEGIN { OFS="\n"; FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)" }{print $1,$2,$3,$4,$5}'
#	->
#	"S2067"
#	55
#	"Breast ""stacked"" diep/gap"
#	2016-01-19 00:00:00
#	"BREAST RECONSTRUCTION OF A SINGLE BREAST WITH ""STACKED"" DEEP INFERIOR EPIGASTRIC PERFORATOR (DIEP) FLAP(S) AND/OR GLUTEAL ARTERY PERFORATOR (GAP) FLAP(S), INCLUDING HARVESTING OF THE FLAP(S), MICROVASCULAR TRANSFER, CLOSURE OF DONOR SITE(S) AND SHAPING THE FLAP INTO A BREAST, UNILATERAL"
#
#	Boom!
#
BEGIN { 
	OFS="\n"; 
	FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)" 
}
{
	print NF
	for(i=1;i<=NF;i++)
		print $i
}
