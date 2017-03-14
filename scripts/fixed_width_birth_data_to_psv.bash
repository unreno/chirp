#!/usr/bin/env bash

#	Sadly, can't really use FS and FIELDWIDTHS in the same awk command.
#	However, one could wrap a bash script around a couple awk commands.

#	This works, but I don't think that the data is in the proper format.

#	There are 61 characters unaccounted for. Need to edit the dictionary I guess.


input=`awk '
BEGIN{
	FS="\t"
}
( NR == FNR && FNR > 1){
	gsub(/\r/,"")
	names=names" "$1
	widths=widths" "$7
}
END{
	print names
	print widths
}
' "CHIRP Birth Extract Dictionary (v1.2) - Dictionary Extract.tsv"`

awk -v input="$input" '
BEGIN {
	split(input,a,"\n")
	split(a[1],names)
	split(a[2],widths)
	FIELDWIDTHS=a[2]
	OFS="|"
}
{
	for(i=1;i<=NF;i++){
		gsub (/^ */,"",$i);
		gsub (/ *$/,"",$i);
	}
	print
}' "CHIRP Birth Extract 20160721.txt"

