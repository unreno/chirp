#!/usr/bin/env bash


#SELECT COUNT(1) AS births_buffer_pre_count FROM vital.births_buffer
#--	0
#EXEC bin.import_birth_records 'C:\Users\gwendt\Desktop\Data\NSBR\v1.0\Washoe_2015.csv.psv'
#SELECT COUNT(1) AS births_buffer_2015_count FROM vital.births_buffer
#--	5432

#INSERT INTO vital.births SELECT * FROM vital.births_buffer
#DELETE FROM vital.births_buffer



q="EXEC bin.import_birth_records 'C:\Users\gwendt\Desktop\Data\NSBR\v1.0\Washoe_2015.csv.psv';
INSERT INTO vital.births SELECT * FROM vital.births_buffer;
DELETE FROM vital.births_buffer;"

echo "$q"

#sqlcmd -d chirp -Q "$q"

