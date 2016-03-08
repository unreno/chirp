#!/usr/bin/env bash

#	As SQL apparently can't "include" other files,
#	and as this will really only be used once,
#	just catting them.


cat create_core_database.tsql

cat create_identifiers.tsql

cat create_warehouse.tsql

cat create_vital_records.tsql

#
#	Include the testing framework?
#
#cat ../tSQLt_V1.0.5873.27393/tSQLt.class.sql
#


