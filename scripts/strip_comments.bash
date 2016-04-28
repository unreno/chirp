#!/usr/bin/env bash

#	this will select single line c style comments.
#	sed -n '/^\/\*/p; /^ \*/p' < file.js

#	This almost works to remove all comments
# sed 's|/\*|\n&|g;s|*/|&\n|g' a.txt | sed '/\/\*/,/*\//d'

#	This would be nice
#	cat Format\ Birth.sas | sed 's|\/\*.*\*\/||'
#	if sed could be told to ignore newline

# /* this is a comment */


#	This works, although quite slow.

#	Also this "/*/*" will also match a closing comment, so DON'T DO THAT.


while [ $# -ne 0 ] ; do 
	incomment=false
	buffer=
	while IFS= read -r -d '' -n1 char
	do
		if ( ! $incomment ) ; then	#	Yes, parentheses and not square brackets
			#	search for beginning of comment / and then /*
			buffer=$buffer"$char"
			if [ "$buffer" == "/" ] ; then
				# incomment=almost?
				incomment=false	#	gotta put something here
			elif [ "$buffer" == "/*" ] ; then
				incomment=true
			else
				echo -n "$buffer"
				buffer=
			fi
		else
			#	search for ending of comment * and then */
			buffer=$buffer"$char"
			if [ "$buffer" == "*" ] ; then
				#	incomment=still?
				incomment=true	#	gotta put something here
			elif [ "$buffer" == "*/" ] ; then
				incomment=false
				buffer=
			else
				buffer=
			fi
		fi
		
	done < "$1"
	shift
done
