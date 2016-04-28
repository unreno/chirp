#
#	awk -f sas_proc_format_to_csv.awk sas_text_file
#
BEGIN{ IGNORECASE = 1 }	#	1 = true
( /value/ ){ 
	table=$2; 
#print ""
#print ""
#	print table; 
#	print "code, value"
	next }	#	$2 would be our table name.  Assign it here!
( /=/ ){ 
	#	As some of these have a TAB before or after the =, this needs fixed
	#	Some of the jumbled data are separated by a single TAB. 
	#	Added another so can split on 2 TABs here
#	split($0,a,"\t\t")
#	for(i=0;i<length(a);i++){
#		l=a[i]
#		if( l !~ /^\s*$/ ){
#			split(l,f,/\s*=\s*/)
#			code=f[1]
#			gsub(/\t/,"",code)
#			value=f[2]
#			gsub(/\t/,"",value)
#			print code","value
#		}
#	}

#	grep -o "=" FILE | wc -l
#	grep -o " =" FILE | wc -l
#	grep -o " = " FILE | wc -l
#	541 total records
#	3 have an = (or 2) in their value
#	101= Lovelock (no whitespace between code and =!!!!!
#	facilities 801 and 901 started with a tab inside the double quotes?
#	patsplit($0,a,/[[:digit:]]+[[:space:]]+\=[[:space:]]+\S+/)
	patsplit($0,a,/[[:digit:]]+[[:space:]]+=[[:space:]]+[^\t]+[\t|\n]?/)
	for(i=0;i<length(a);i++){
		l=a[i]
		if( l !~ /^\s*$/ )
			print l
	}

}

#	Should probably learn how to use patsplit ( like with FPAT /\d*\s*=\s*\S+/ )
#
#patsplit(string, array [, fieldpat [, seps ] ]) #
#
#Divide string into pieces defined by fieldpat and store the pieces in array and the separator strings in the seps array. The first piece is stored in array[1], the second piece in array[2], and so forth. The third argument, fieldpat, is a regexp describing the fields in string (just as FPAT is a regexp describing the fields in input records). It may be either a regexp constant or a string. If fieldpat is omitted, the value of FPAT is used. patsplit() returns the number of elements created. seps[i] is the separator string between array[i] and array[i+1]. Any leading separator will be in seps[0].
#
#The patsplit() function splits strings into pieces in a manner similar to the way input lines are split into fields using FPAT (see Splitting By Content).
#
#Before splitting the string, patsplit() deletes any previously existing elements in the arrays array and seps.
#


