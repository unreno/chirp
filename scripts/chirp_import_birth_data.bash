#!/usr/bin/env bash


#SELECT COUNT(1) AS births_buffer_pre_count FROM vital.births_buffer
#--	0
#EXEC bin.import_birth_records 'C:\Users\gwendt\Desktop\Data\NSBR\v1.0\Washoe_2015.csv.psv'
#SELECT COUNT(1) AS births_buffer_2015_count FROM vital.births_buffer
#--	5432

#INSERT INTO vital.births SELECT * FROM vital.births_buffer
#DELETE FROM vital.births_buffer

psv_dir="/cygdrive/c/Users/gwendt/Desktop/Data/NSBR/v1.0"
for f in $(ls $psv_dir/*psv) ; do
	echo $f

	q="EXEC bin.import_birth_records '$f';
	INSERT INTO vital.births SELECT * FROM vital.births_buffer;
	DELETE FROM vital.births_buffer;"

	echo sqlcmd -d chirp -Q "$q"

done
