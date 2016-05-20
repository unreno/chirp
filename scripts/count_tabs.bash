#!/usr/bin/env bash

#	tr -d -c "\t\n" < state.tsv | awk '{print length}' | uniq -c

while [ $# -ne 0 ] ; do
	echo $1
#	tr -d -c "\"\n" < $1 | awk '{print length}' | uniq -c
	tr -d -c "\'\n" < $1 | awk '{print length}' | uniq -c

#	tr -d -c "\t\n" < $1 | awk '{print length}' | uniq -c
#	tr -d -c "\t\n" < $1 | awk '{print NR,length}'

	shift
done
