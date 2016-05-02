
--Once imported ...


--Create some random birth data


-- 10,000 takes about 5 minutes with all of the uniqueness checking.
SELECT COUNT(*) FROM vital.birth
EXEC dev.create_random_vital 10
SELECT COUNT(*) FROM vital.birth


--Create some chirp ids for this random data
--( this can crash on uniqueness of state file number in identifiers )
--( I think that I fixed it to create an actual unique state file number )


SELECT COUNT(*) FROM private.identifiers
INSERT INTO private.identifiers
	( chirp_id, source_schema, source_table, source_column, source_id ) 
	SELECT private.create_unique_chirp_id(), 'vital', 'birth', 'state_file_number', 
	state_file_number from vital.birth b where b.imported_to_dw = 'FALSE';
SELECT COUNT(*) FROM private.identifiers





--UNPIVOT this birth data into the observations table

SELECT COUNT(*) from dbo.observations
EXEC bin.import_into_data_warehouse
SELECT COUNT(*) from dbo.observations
SELECT COUNT(*) from vital.birth
SELECT COUNT(*) from vital.birth
	WHERE imported_to_dw = 'FALSE'
SELECT COUNT(*) from private.identifiers
SELECT COUNT(*) from dbo.observations



--This takes about 5 minutes with 10k too.

SELECT COUNT(*) from private.identifiers
EXEC dev.create_FAKE_newborn_screening_for_each_birth_record
SELECT COUNT(*) from health_lab.newborn_screening
SELECT COUNT(*) from health_lab.newborn_screening
	WHERE imported_to_dw = 'FALSE'
EXEC dev.link_FAKE_newborn_screening_to_births
SELECT COUNT(*) from health_lab.newborn_screening
SELECT COUNT(*) from health_lab.newborn_screening
	WHERE imported_to_dw = 'FALSE'
SELECT COUNT(*) from private.identifiers
EXEC bin.import_into_data_warehouse
SELECT COUNT(*) from private.identifiers
SELECT COUNT(*) from dbo.observations




--And this takes about 20 minutes with 10k birth records

SELECT COUNT(*) from fakedoc1.emrs
EXEC dev.create_FAKE_fakedoc1_emrs
SELECT COUNT(*) from fakedoc1.emrs
SELECT COUNT(*) from private.identifiers
EXEC dev.link_FAKE_fakedoc1_emrs_to_births
SELECT COUNT(*) from private.identifiers
SELECT COUNT(*) from dbo.observations
EXEC bin.import_into_data_warehouse
SELECT COUNT(*) from dbo.observations




