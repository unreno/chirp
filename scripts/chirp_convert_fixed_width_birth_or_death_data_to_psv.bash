#!/usr/bin/env bash

script=`basename $0`
dictionary="CHIRP Birth Extract MODIFIED Dictionary (v1.2) - Dictionary Extract.tsv"
datafile="CHIRP Birth Extract 20160721.txt"


function usage(){
	echo
	echo "Usage: (NO EQUALS SIGNS)"
	echo
	echo "$script dictionary_file data_file"
	echo
	echo "DICTIONARY IS EXPECTING field name in column 1 and field width in 7."
	echo
	echo "Example:"
	echo "$script \"CHIRP Birth Extract MODIFIED Dictionary (v1.2) - Dictionary Extract.tsv\" \"CHIRP Birth Extract 20160721.txt\""
	echo
	exit
}

#while [ $# -ne 0 ] ; do
#	case $1 in
#		-h|--h*)
#			shift; human=$1; shift ;;
#		-v|--v*)
#			shift; viral=$1; shift ;;
#		-t|--t*)
#			shift; threads=$1; shift ;;
#		-d|--d*)
#			shift; distance=$1; shift ;;
#		-*)
#			echo ; echo "Unexpected args from: ${*}"; usage ;;
#		*)
#			break;;
#	esac
#done

[ $# -ne 2 ] && usage

dictionary="$1"
datafile="$2"

if [ ! -e "$1" ] ; then
	echo "$1 does not exist"
	usage
fi
if [ ! -e "$2" ] ; then
	echo "$2 does not exist"
	usage
fi



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
' "$dictionary"`

#	"CHIRP Birth Extract Dictionary (v1.2) - Dictionary Extract.tsv"
#	The raw file contains 21 gaps of 61 unaccount characters found by ...
#	awk -F"\t" '{gsub(/\r/,"");print NR+1,$6,s+1,$7;s=s+$7;}' CHIRP\ Birth\ Extract\ MODIFIED\ Dictionary\ \(v1.2\)\ -\ Dictionary\ Extract.tsv
#	The MODIFIED file has 21 UNKNOWN fields added to fill them.
#	"CHIRP Birth Extract MODIFIED Dictionary (v1.2) - Dictionary Extract.tsv"

#	Gotta use gawk to use join

gawk -v input="$input" '
@include "join"
BEGIN {
	split(input,a,"\n")
	split(a[1],names)
	split(a[2],widths)
	FIELDWIDTHS=a[2]
	OFS="|"
	print tolower(join(names,1,length(names),OFS))
}
{
	for(i=1;i<=NF;i++){
		gsub (/^ */,"",$i);
		gsub (/ *$/,"",$i);
	}
	print
}' "$datafile"

