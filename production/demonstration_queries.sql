
DELETE FROM private.identifiers
DELETE FROM dbo.observations
DELETE FROM fakedoc1.emrs
DELETE FROM vital_records.birth
DELETE FROM vital_records.birth2
DELETE FROM health_lab.newborn_screening

EXEC dev.create_random_vital_records 1
SELECT * FROM vital_records.birth
SELECT state_file_number, name_first, name_last, date_of_birth
sex, birth_weight_lbs, birth_weight_oz,
apgar_1, apgar_5, apgar_10, infant_living
FROM vital_records.birth b
LEFT JOIN vital_records.birth2 b2
ON b.birth2id = b2.birth2id

INSERT INTO private.identifiers
	( chirp_id, source_schema, source_table, source_column, source_id ) 
	SELECT private.create_unique_chirp_id(), 'vital_records', 'birth', 'state_file_number', 
	state_file_number FROM vital_records.birth b WHERE b.imported_to_dw = 'FALSE';
SELECT * FROM private.identifiers

EXEC dev.create_FAKE_newborn_screening_for_each_birth_record
SELECT * FROM health_lab.newborn_screening

EXEC dev.link_FAKE_newborn_screening_to_births
SELECT * FROM private.identifiers

EXEC dev.create_FAKE_fakedoc1_emrs
SELECT * FROM fakedoc1.emrs

EXEC dev.link_FAKE_fakedoc1_emrs_to_births
SELECT * FROM private.identifiers

EXEC dbo.import_into_data_warehouse
SELECT * FROM dbo.observations
ORDER BY started_at




DELETE FROM private.identifiers
DELETE FROM dbo.observations
DELETE FROM fakedoc1.emrs
DELETE FROM vital_records.birth
DELETE FROM vital_records.birth2
DELETE FROM health_lab.newborn_screening

EXEC dev.create_random_vital_records 1000
INSERT INTO private.identifiers
	( chirp_id, source_schema, source_table, source_column, source_id ) 
	SELECT private.create_unique_chirp_id(), 'vital_records', 'birth', 'state_file_number', 
	state_file_number FROM vital_records.birth b WHERE b.imported_to_dw = 'FALSE';
EXEC dev.create_FAKE_newborn_screening_for_each_birth_record
EXEC dev.link_FAKE_newborn_screening_to_births
EXEC dev.create_FAKE_fakedoc1_emrs
EXEC dev.link_FAKE_fakedoc1_emrs_to_births
EXEC dbo.import_into_data_warehouse
SELECT * FROM private.identifiers
SELECT * FROM dbo.observations








SELECT infant_living, COUNT(*) 
FROM vital_records.birth2 GROUP BY infant_living



SELECT b2.infant_living, COUNT(*) 
FROM private.identifiers i 
join vital_records.birth b 
ON i.source_schema = 'vital_records'
AND i.source_table = 'birth'
AND i.source_column = 'state_file_number'
AND i.source_id = b.state_file_number
join vital_records.birth2 b2
ON b.birth2id = b2.birth2id
GROUP BY infant_living



SELECT COUNT(*) FROM dbo.observations
WHERE concept = 'DEM:DOB'
AND CAST(value AS DATE) BETWEEN '2013-06-01' AND '2013-06-30';

SELECT chirp_id, CAST(value AS DATE) FROM dbo.observations
WHERE concept = 'DEM:DOB'
AND CAST(value AS DATE) BETWEEN '2013-06-01' AND '2013-06-30'
ORDER BY CAST(value AS DATE) DESC;







DECLARE @c INT;

SELECT TOP 1 @c = chirp_id FROM private.identifiers ORDER BY NEWID();

SELECT * FROM private.identifiers WHERE chirp_id = @c;

SELECT * FROM dbo.observations WHERE chirp_id = @c ORDER BY started_at;

SELECT h.chirp_id, h.value AS height, w.value AS weight ,
  ( w.value * 703. / SQUARE(h.value) ) AS bmi
FROM dbo.observations h
JOIN (
  SELECT * FROM dbo.observations
  WHERE concept = 'DEM:Weight'
) w ON h.chirp_id = w.chirp_id  AND h.started_at = w.started_at
WHERE h.concept = 'DEM:Height' AND h.chirp_id = @c;



SELECT h.chirp_id, h.value AS height, w.value AS weight ,
  ( w.value * 703. / SQUARE(h.value) ) AS bmi
FROM dbo.observations h
JOIN (
  SELECT * FROM dbo.observations
  WHERE concept = 'DEM:Weight'
) w ON h.chirp_id = w.chirp_id  AND h.started_at = w.started_at
WHERE h.concept = 'DEM:Height'
ORDER BY ( w.value * 703. / SQUARE(h.value) ) DESC;



