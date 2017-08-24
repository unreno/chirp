#!/usr/bin/env bash

#	As SQL apparently can't "include" other files,
#	and as this will really only be used once,
#	just catting them.

[[ -z $1 ]] && DB_NAME="chirp" || DB_NAME=$1


#	Put this here so can programmatically select dev or prod
echo "USE master;"
echo "IF db_id('$DB_NAME') IS NOT NULL"
echo "	DROP DATABASE $DB_NAME;"
#-- "WITH TRUSTWORTHY ON" required for use of tSQLt Testing Framework.
#--CREATE DATABASE $DB_NAME WITH TRUSTWORTHY ON;
echo "CREATE DATABASE $DB_NAME;"
echo "GO"

#	Given that Paul has to move database somewhere for Reports,
#	DROPping and CREATEing breaks this. So STOP DOING IT.
#	Actually, I think that he moved it so rock on.


echo "USE $DB_NAME"
echo "GO"

cat bin.sql
cat private.sql
cat dbo.sql
dbo_codes.bash
dbo_dictionary.bash

cat vital_birth.sql
./normalize_name_column.bash vital.births name_last
./normalize_name_column.bash vital.births mother_name_last_p
./normalize_name_column.bash vital.births mother_name_last
./normalize_name_column.bash vital.births mother_name_first
./normalize_name_column.bash vital.births name_first
./normalize_name_column.bash vital.births name_middle
./normalize_street_column.bash vital.births mother_res_addr1
./dehyphenate_name_column.bash vital.births mother_name_last_p
./dehyphenate_name_column.bash vital.births mother_name_last
./dehyphenate_name_column.bash vital.births mother_name_first
./dehyphenate_name_column.bash vital.births name_last
./dehyphenate_name_column.bash vital.births name_first
#./split_date_column.bash vital.births bth_date
#./split_date_column.bash vital.births mom_dob
./split_string_date_column.bash vital.births date_of_birth
./split_string_date_column.bash vital.births b2_mother_dob



./split_address_column.bash vital.births mother_res_addr1

./varchar_to_int_column.bash vital.births hos_number


cat vital_death.sql




















cat webiz.sql
./normalize_name_column.bash webiz.immunizations mother_last_name
./normalize_name_column.bash webiz.immunizations last_name
./normalize_name_column.bash webiz.immunizations mother_first_name
./normalize_name_column.bash webiz.immunizations first_name
./normalize_name_column.bash webiz.immunizations middle_name
./normalize_name_column.bash webiz.immunizations mother_maiden_name
./dehyphenate_name_column.bash webiz.immunizations mother_last_name
./dehyphenate_name_column.bash webiz.immunizations mother_maiden_name
./dehyphenate_name_column.bash webiz.immunizations mother_first_name
./dehyphenate_name_column.bash webiz.immunizations last_name
./dehyphenate_name_column.bash webiz.immunizations first_name
./split_date_column.bash webiz.immunizations dob

./normalize_street_column.bash webiz.addresses address_line1
./split_address_column.bash webiz.addresses address_line1

./varchar_to_int_column.bash webiz.local_ids local_id


#cat health_lab.sql
#./normalize_name_column.bash health_lab.newborn_screenings mom_surname
#./normalize_name_column.bash health_lab.newborn_screenings last_name
#./normalize_name_column.bash health_lab.newborn_screenings mom_first_name
#./normalize_name_column.bash health_lab.newborn_screenings first_name
#./normalize_street_column.bash health_lab.newborn_screenings address
#./dehyphenate_name_column.bash health_lab.newborn_screenings last_name
#./dehyphenate_name_column.bash health_lab.newborn_screenings mom_surname
#./split_date_column.bash health_lab.newborn_screenings birth_date
#./split_date_column.bash health_lab.newborn_screenings mom_birth_date
#./split_address_column.bash health_lab.newborn_screenings address




cat health_lab_prams.sql














#	sed 's/[[:space:]]*[^<>]=[[:space:]]*/,/g' Format\ Birth-clean.sas | tr "\t" "\n" | grep -vs "^\s*$" | grep -vs ";" | sed 's/[[:space:]]*$//' | tr -d "\r" | awk 'BEGIN{IGNORECASE=1}( /^value / ){ f=sprintf("%s.csv",$2);gsub(/\r/,"",f);next; }{print >> f }'
#	sed 's/[[:space:]]*[^<>]=[[:space:]]*/,/g' Format\ Death-clean.sas | tr "\t" "\n" | grep -vs "^\s*$" | grep -vs ";" | sed 's/[[:space:]]*$//' | tr -d "\r" | awk 'BEGIN{IGNORECASE=1}( /^value / ){ f=sprintf("%s.csv",$2);gsub(/\r/,"",f);next; }{print >> f }'



#		print "		FIELDTERMINATOR = '"''"','"''"',"
#		print "BEGIN TRY"
#		print "END TRY BEGIN CATCH"
#		print "	PRINT ERROR_MESSAGE()"
#		print "END CATCH"

#echo "UPDATE dbo.codes"
#echo "	SET value = SUBSTRING ( value, 2, LEN(value)-2 )"
#echo "	WHERE value LIKE '\"%\"';"
#echo "UPDATE dbo.codes"
#echo "	SET value = SUBSTRING ( value, 2, LEN(value)-2 )"
#echo "	WHERE value LIKE '''%''';"



#cat fakedoc1.sql

#cat dev.sql



#
#	Include the testing framework?
#	Is 'clr enabled' a security issue?
#	I'm turning it on only as needed. Worth it?
#
#	It's probably NOT a good idea to install this when we are actually in production.
#
#echo "EXEC sp_configure 'clr enabled', 1;"
#echo "RECONFIGURE;"
#cat ../tSQLt_V1.0.5873.27393/tSQLt.class.sql
#echo "EXEC sp_configure 'clr enabled', 0;"
#echo "RECONFIGURE;"
#cat testing_procedures.sql


for concept in DOB Sex Height Weight Race Language Zipcode Other; do
	echo "INSERT INTO dbo.concepts VALUES ("
	echo -e "\t'DEM:$concept',"
	echo -e "\t'/Demographics/$concept',"
	echo -e "\t'Demographics:$concept');"
done

echo
echo
