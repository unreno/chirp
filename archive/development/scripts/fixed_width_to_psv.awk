#
#	I think that this is a good start, but is currently wrong. The fields don't look right.
#
BEGIN{
	FIELDWIDTHS="4 6 1 \
		1 21 4";
#	FIELDWIDTHS+="21 4";
	OFS="|";
	print "123545";
}
{
	for (i=1;i<=NF;i++){
		gsub (/^ */,"",$i);
		gsub (/ *$/,"",$i);
	}
	print $1,$2,$3,$4,"XXXX";
}
