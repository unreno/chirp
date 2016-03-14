#!/usr/bin/env bash

#	As SQL apparently can't "include" other files,
#	and as this will really only be used once,
#	just catting them.


cat create_core_database.sql

cat create_private_structure.sql
cat create_private_procedures.sql

cat create_warehouse_structure.sql
cat create_warehouse_procedures.sql

cat create_vital_records_structure.sql
cat create_vital_records_procedures.sql


#
#	Include the testing framework?
#	Is 'clr enabled' a security issue?
#	I'm turning it on only as needed. Worth it?
#
echo "EXEC sp_configure 'clr enabled', 1;"
echo "RECONFIGURE;"
cat ../tSQLt_V1.0.5873.27393/tSQLt.class.sql
echo "EXEC sp_configure 'clr enabled', 0;"
echo "RECONFIGURE;"
cat testing_procedures.sql

#	No more bulk importing of all this as most won't actually be used this way.
#../scripts/csv_to_concept_codes.bash ../scripts/vital_records/*csv

for concept in DOB Sex Height Weight Race; do

	echo "INSERT INTO dbo.concepts VALUES ("
	echo -e "\t'DEM:$concept',"
	echo -e "\t'/Demographics/$concept',"
	echo -e "\t'Demographics:$concept');"

done

echo
echo
