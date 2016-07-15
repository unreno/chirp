#!/usr/bin/env bash

while [ $# -ne 0 ] ; do
	echo $1
#	awk -f /cygdrive/z/Renown\ Project/CHIRP/Personal\ folders/Jake/chirp/scripts/csv_prepare_for_bulk_insert.awk September\ 2015.csv > September\ 2015.csv.tsv
	awk -f /cygdrive/z/Renown\ Project/CHIRP/Personal\ folders/Jake/chirp/scripts/csv_prepare_for_bulk_insert.awk "$1" > "$1".tsv
	shift
done
