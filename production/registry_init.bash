#!/usr/bin/env bash

#	As SQL apparently can't "include" other files,
#	and as this will really only be used once,
#	just catting them.


cat create_core_database.tsql

cat create_private_structure.tsql
cat create_private_procedures.tsql

cat create_warehouse_structure.tsql
cat create_warehouse_procedures.tsql

cat create_vital_records_structure.tsql
cat create_vital_records_procedures.tsql

#
#	Include the testing framework?
#
#cat ../tSQLt_V1.0.5873.27393/tSQLt.class.sql
#

../scripts/csv_to_concept_codes.bash ../scripts/vital_records/*csv



