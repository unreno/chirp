#!/usr/bin/env bash

#	As SQL apparently can't "include" other files,
#	and as this will really only be used once,
#	just catting them.

DB_NAME='chirp_dev'

#	Put this here so can programmatically select dev or prod
echo "USE master;"
echo "IF db_id('$DB_NAME') IS NOT NULL"
echo "	DROP DATABASE $DB_NAME;"
#-- "WITH TRUSTWORTHY ON" required for use of tSQLt Testing Framework.
#--CREATE DATABASE $DB_NAME WITH TRUSTWORTHY ON;
echo "CREATE DATABASE $DB_NAME;"
echo "GO"
echo "USE $DB_NAME"
echo "GO"

cat core_database.sql

cat private_structure.sql
cat private_procedures.sql

cat warehouse_structure.sql
cat warehouse_procedures.sql

cat vital_records_structure.sql
cat vital_records_procedures.sql

cat health_lab_structure.sql
cat health_lab_procedures.sql

cat development.sql

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


#	No more bulk importing of all this as most won't actually be used this way.
#../scripts/csv_to_concept_codes.bash ../scripts/vital_records/*csv

for concept in DOB Sex Height Weight Race Language Zipcode Other; do
	echo "INSERT INTO dbo.concepts VALUES ("
	echo -e "\t'DEM:$concept',"
	echo -e "\t'/Demographics/$concept',"
	echo -e "\t'Demographics:$concept');"
done

#
#  14567 ICD9DX
#   3882 ICD9SG
#  18449 subtotal
#
#  16710 HCPC
#  69834 ICD10DX
#      5 DEM (manually added for testing)
#  86549 subtotal
#
#   2026 ICD10 PCS
# 107024 subtotal
#
# 192355 NDC
# -   18 NDC duplicates extras
# -    2 NDC triplicate extras
# 299359 subTOTAL concepts
#
#	     2 2 more DEM codes, Language and Zipcode
# 299361 TOTAL concepts
#

#tail -n +2 ../all_lmrp/hcpc_code_lookup.csv | LC_ALL='C' sort -r -k1,1 -k2,2n \
#	| awk -F, '( $1 != prev ){ print; prev=$1 }' | sort -k1,1 \
#	| awk -f ../scripts/csv_hcpc_codes_to_concepts_sql.awk
#
#awk -f ../scripts/tsv_icd_9_dx_codes_to_concepts_sql.awk \
#	../ICD-9-CM-v32-master-descriptions/CMS32_DESC_LONG_DX.txt
#
#awk -f ../scripts/tsv_icd_9_sg_codes_to_concepts_sql.awk \
#	../ICD-9-CM-v32-master-descriptions/CMS32_DESC_LONG_SG.txt 
#
#tail -n +2 ../all_lmrp/icd10_code_lookup.csv | sort -r -k1,1 -k2,2n \
#	| awk -F, '( $1 != prev ){ print; prev=$1 }' | sort -k1,1 \
#	| awk -f ../scripts/csv_icd_10_dx_codes_to_concepts_sql.awk
#
#../scripts/xml_icd_10_pcs_codes_to_concepts_sql.rb
#
#tail -n +2 ../ndc/package.txt | sort -t$'\t' -k3,3  \
#	| awk -F"\t" '( $3 != prev ){ print; prev=$3 }' \
#	| awk -f ../scripts/tsv_ndc_package_codes_to_concepts_sql.awk ndc/package.txt
#
#	Be advised that SQL Server won't run a script larger than 1MB.
#	Even with Intellisense turned off.
#	The NDC codes is over 25MB by itself.
#
#
#	I have created a giant csv file that is importable via a SSIS package
#


awk '{print "INSERT INTO dev.names VALUES (\x27"$1"\x27, \x27last\x27)"}' ../scripts/1000_most_common_last_name_in_US
#	\x27f is a valid character so need to add ""
awk '{print "INSERT INTO dev.names VALUES (\x27"$1"\x27, \x27""female\x27)"}' ../scripts/1000_most_common_female_name_in_US
awk '{print "INSERT INTO dev.names VALUES (\x27"$1"\x27, \x27male\x27)"}' ../scripts/1000_most_common_male_name_in_US

echo
echo
