
Once imported ...

Create some random birth data (100 records each call)




EXEC dev.create_random_vital_records
EXEC dev.create_random_vital_records
EXEC dev.create_random_vital_records
EXEC dev.create_random_vital_records
EXEC dev.create_random_vital_records
SELECT COUNT(*) FROM vital_records.birth


Create some chirp ids for this random data




INSERT INTO private.identifiers
	( chirp_id, source_schema, source_table, source_column, source_id ) 
	SELECT private.create_unique_chirp_id(), 'vital_records', 'birth', 'state_file_number', 
	state_file_number from vital_records.birth b where b.imported_to_dw = 'FALSE';
SELECT COUNT(*) FROM private.identifiers
SELECT COUNT(*) from dbo.observations


UNPIVOT this birth data into the observations table




EXEC import_into_data_warehouse



SELECT COUNT(*) from vital_records.birth
SELECT COUNT(*) from vital_records.birth
	WHERE imported_to_dw = 'FALSE'
SELECT COUNT(*) from private.identifiers
SELECT COUNT(*) from dbo.observations


