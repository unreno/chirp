
Once imported ...




C:\Users\gwendt\Desktop\all_concept_codes.csv

--BULK INSERT requires a format file? for column selection
--Using a view works just as well.
CREATE VIEW cc AS SELECT code, path, description FROM dbo.concepts;

--UNIX line feeds don't work well in MS so need dynamic sql 
--However, ALL the double quotes in the description are preserved
--This would require a series of UPDATEs, STUFFs and/or REPLACEs.
--Still faster that dealing with SSIS.
DECLARE @bulk_cmd VARCHAR(1000);
SET @bulk_cmd = 'BULK INSERT cc
FROM ''C:\Users\gwendt\Desktop\all_concept_codes.csv''
WITH (
	FIELDTERMINATOR = '','',
	ROWTERMINATOR = '''+CHAR(10)+''',
	ERRORFILE = ''C:\Users\gwendt\Desktop\all_concept_codes_ERRORS.csv'',
	TABLOCK
)';
EXEC(@bulk_cmd);

-- some of these records actually end in a quote ->blah blah blah "something quoted"<-
-- so replace the double double quotes LAST

UPDATE dbo.concepts
	SET description = STUFF(description, LEN(description), 1,'')
	WHERE description LIKE '%"';
UPDATE dbo.concepts
	SET description = STUFF(description, 1,1,'')
	WHERE description LIKE '"%';
UPDATE dbo.concepts
	SET path = STUFF(path, 1,1,'')
	WHERE path LIKE '"%';
UPDATE dbo.concepts
	SET description = REPLACE(description, '""', '"')
	WHERE description LIKE '%""%';


Create some random birth data (1000 records each call)




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





SELECT COUNT(*) from private.identifiers
EXEC dev.create_newborn_screening_for_each_birth_record
SELECT COUNT(*) from health_lab.newborn_screening
SELECT COUNT(*) from health_lab.newborn_screening
	WHERE imported_to_dw = 'FALSE'
EXEC dev.link_newborn_screening_to_births
SELECT COUNT(*) from health_lab.newborn_screening
SELECT COUNT(*) from health_lab.newborn_screening
	WHERE imported_to_dw = 'FALSE'
SELECT COUNT(*) from private.identifiers
EXEC import_into_data_warehouse
SELECT COUNT(*) from private.identifiers
SELECT COUNT(*) from dbo.observations





