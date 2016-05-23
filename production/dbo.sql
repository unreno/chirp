
IF OBJECT_ID('dbo.concepts', 'U') IS NOT NULL
	DROP TABLE dbo.concepts;
CREATE TABLE dbo.concepts (
	id INT IDENTITY(1,1),
	code VARCHAR(255),
	CONSTRAINT concept_code PRIMARY KEY CLUSTERED (code ASC),
	path VARCHAR(255),	-- Remnant from I2B2. Will we have a use for this?
	description VARCHAR(MAX)
);

--	CONSTRAINT unique_code 
--		UNIQUE (code)	-- Is this necessary? No
-- Examples:
-- code: ICD10CM:M71.432, description: Calcium deposit in bursa, left wrist
-- code: HCPC:0356T, description: INSERTION OF DRUG-ELUTING IMPLANT ....
-- code: LOINC:8302-2, description: Body Height (LOINC:8302-2)
-- code: LOINC:3141-9, description: Body Weight (LOINC:3141-9)
-- code: DEM:Race, description: Race
-- code: DEM:Language, description: Language


--BULK INSERT requires a format file? for column selection
--Using a view works just as well.
IF OBJECT_ID ( 'dbo.cc', 'V' ) IS NOT NULL
	DROP VIEW dbo.cc;
GO
CREATE VIEW dbo.cc AS SELECT code, path, description FROM dbo.concepts;
GO


-- ll *concept_codes.csv
-- -rwx------ 1 jakewendt  2105675 Mar 17 12:59 hcpc_concept_codes.csv
-- -rwx------ 1 jakewendt  7869583 Mar 17 12:59 icd10dx_concept_codes.csv
-- -rwx------ 1 jakewendt  1023195 Apr 28 13:04 icd10pcs_concept_codes.csv
-- -rwx------ 1 jakewendt  1223532 Mar 17 12:59 icd9dx_concept_codes.csv
-- -rwx------ 1 jakewendt   267271 Mar 17 12:59 icd9sg_concept_codes.csv
-- -rwx------ 1 jakewendt 16960137 Mar 17 12:59 ndc_concept_codes.csv
-- cat *concept_codes.csv > ../all_concept_codes.csv

--
--  14567 ICD9DX
--   3882 ICD9SG
--  18449 subtotal
--
--  16710 HCPC
--  69834 ICD10DX
--      5 DEM (manually added for testing)
--  86549 subtotal
--
--   2026 ICD10 PCS
-- 107024 subtotal
--
-- 192355 NDC
-- -   18 NDC duplicates extras
-- -    2 NDC triplicate extras
-- 299359 subTOTAL concepts
--
--	     2 2 more DEM codes, Language and Zipcode
-- 299361 TOTAL concepts
--

--UNIX line feeds don\'t work well in MS so need dynamic sql 
--However, ALL the double quotes in the description are preserved
--This would require a series of UPDATEs, STUFFs and/or REPLACEs.
--Still faster that dealing with SSIS.
--	FROM ''C:\Users\gwendt\Desktop\all_concept_codes.csv''
BEGIN TRY
	--A GO call apparently undeclare variables, so redeclare here
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT cc
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\all_concept_codes.csv''
	WITH (
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = '''+CHAR(10)+''',
		TABLOCK
	)';
	EXEC(@bulk_cmd);
END TRY BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH
IF OBJECT_ID ( 'dbo.cc', 'V' ) IS NOT NULL
	DROP VIEW dbo.cc;	-- only needed this for the import.
GO

--
-- FIXED
--
--The ICD10PCS codes weren't trimmed far enough so will end
--up with a leading double quote. Removing it here.
--UPDATE dbo.concepts
--	SET path = STUFF(path, 1,1,'')
--	WHERE path LIKE '"%';


-- some of these records are actually wrapped in a quotes
-- ->"blah blah blah ""something quoted"" blah blah"<-
-- so replace the wrappers together

UPDATE dbo.concepts
	SET description = SUBSTRING ( description, 2, LEN(description)-2 )
	WHERE description LIKE '"%"';

-- and the double double quotes LAST
-- ->blah blah blah ""something quoted"" blah blah<-
UPDATE dbo.concepts
	SET description = REPLACE(description, '""', '"')
	WHERE description LIKE '%""%';
















IF OBJECT_ID('dbo.providers', 'U') IS NOT NULL
	DROP TABLE dbo.providers;
CREATE TABLE dbo.providers (
	id INT IDENTITY(1,1),
	CONSTRAINT provider_id PRIMARY KEY CLUSTERED (id ASC)
);



/*

--Not sure what purpose this table can serve.

IF OBJECT_ID('dbo.encounters', 'U') IS NOT NULL
	DROP TABLE dbo.encounters;
CREATE TABLE dbo.encounters (
	id INT IDENTITY(1,1),
	CONSTRAINT encounter_id PRIMARY KEY CLUSTERED (id ASC)
);
*/



/*
IF OBJECT_ID('dbo.locations', 'U') IS NOT NULL
	DROP TABLE dbo.locations;
CREATE TABLE dbo.locations (
	id INT IDENTITY(1,1),
	CONSTRAINT location_id PRIMARY KEY CLUSTERED (id ASC)
);
*/




--Can't declare foreign key constraints until those tables exist.
IF OBJECT_ID('dbo.observations', 'U') IS NOT NULL
	DROP TABLE dbo.observations;
CREATE TABLE dbo.observations (
	id INT IDENTITY(1,1),
	CONSTRAINT observation_id PRIMARY KEY CLUSTERED (id ASC),

	chirp_id        INT NOT NULL,
--	encounter_id    INT NOT NULL,
	provider_id     INT NOT NULL,
--	location_id     INT NOT NULL,
	concept         VARCHAR(255) NOT NULL,
	started_at      DATETIME NOT NULL,
	ended_at        DATETIME,
--	value_type      VARCHAR(1) NOT NULL,
--	n_value         DECIMAL(18,5),
--	s_value         VARCHAR(255),
--	l_value         VARCHAR(MAX),
--	d_value         DATE,
--	t_value         DATETIME,
	value           VARCHAR(255),
	units           VARCHAR(20),
	downloaded_at   DATETIME,
	source_schema   VARCHAR(50) NOT NULL,
	source_table    VARCHAR(50) NOT NULL,
	source_id       INT NOT NULL,
	imported_at     DATETIME
		CONSTRAINT dbo_observations_imported_at_default 
		DEFAULT CURRENT_TIMESTAMP NOT NULL,

--	CONSTRAINT fk_encounter_id
--		FOREIGN KEY (encounter_id) REFERENCES encounters(id),
--	CONSTRAINT fk_provider_id
--		FOREIGN KEY (provider_id) REFERENCES providers(id),
--	CONSTRAINT fk_location_id
--		FOREIGN KEY (location_id) REFERENCES locations(id),

--Temporarily skip concept codes
--	CONSTRAINT fk_concept_code
--		FOREIGN KEY (concept) REFERENCES concepts(code)

);

/*

ALTER TABLE dbo.observations NOCHECK CONSTRAINT fk_concept_code;
-- remove old and add new records
ALTER TABLE dbo.observations CHECK CONSTRAINT fk_concept_code;

--OR?

ALTER TABLE dbo.observations DROP CONSTRAINT fk_concept_code;
-- remove old and add new records
ALTER TABLE dbo.observations ADD CONSTRAINT fk_concept_code
	FOREIGN KEY (concept) REFERENCES concepts(code);


*/

--This would have been nice, but the referenced column
--	must be unique and this is not the case.
--
--There are no primary or candidate keys in the referenced table 'private.identifiers' 
--	that match the referencing column list in the foreign key 'fk_chirp_id'.
--
--ALTER TABLE dbo.observations ADD
--	CONSTRAINT fk_chirp_id
--		FOREIGN KEY (chirp_id) 
--		REFERENCES private.identifiers(chirp_id)
--
--Thought this would work, but no. 
--Subqueries are not allowed in this context. Only scalar expressions are allowed.
--
--ALTER TABLE dbo.observations 
--	ADD CONSTRAINT valid_chirp_id 
--	CHECK (chirp_id in (SELECT DISTINCT chirp_id FROM private.identifiers))
--

/*
-- These could have been included in the CREATE
ALTER TABLE dbo.observations ADD CONSTRAINT ck_value_type CHECK (
	value_type IN ('N','T','S')
--	value_type IN ('N','D','T','S','L')
);
ALTER TABLE dbo.observations ADD CONSTRAINT ck_n_value CHECK (
	( value_type <> 'N' AND n_value IS NULL ) OR
	( value_type = 'N' AND n_value IS NOT NULL )
);
--ALTER TABLE dbo.observations ADD CONSTRAINT ck_d_value CHECK (
--	( value_type <> 'D' AND d_value IS NULL ) OR
--	( value_type = 'D' AND d_value IS NOT NULL )
--);
ALTER TABLE dbo.observations ADD CONSTRAINT ck_t_value CHECK (
	( value_type <> 'T' AND t_value IS NULL ) OR
	( value_type = 'T' AND t_value IS NOT NULL )
);
-- The s_value can contain data when not Short Text type.
ALTER TABLE dbo.observations ADD CONSTRAINT ck_s_value CHECK (
	( value_type <> 'S' ) OR
	( value_type = 'S' AND s_value IS NOT NULL )
);
-- Can the l_value contain data when not Long Text type?
--ALTER TABLE dbo.observations ADD CONSTRAINT ck_l_value CHECK (
--	( value_type <> 'L' AND l_value IS NULL ) OR
--	( value_type = 'L' AND l_value IS NOT NULL )
--);
*/


-- SCHEMA, TABLE, GROUP and GROUPING are reserved words
IF OBJECT_ID('dbo.codes', 'U') IS NOT NULL
	DROP TABLE dbo.codes;
CREATE TABLE dbo.codes (
	_schema VARCHAR(50) NOT NULL,
	_table VARCHAR(50) NOT NULL,
	codeset VARCHAR(50) NOT NULL,
	code INT NOT NULL,
	value VARCHAR(255) NOT NULL, 	-- Isn't this comma needed?
	CONSTRAINT codes_unique_schema_table_codeset_code
		UNIQUE ( _schema, _table, codeset, code )
);
-- FYI The maximum key length is 900 bytes. For some combination of large values, the insert/update operation will fail.
IF OBJECT_ID ( 'dbo.bulk_insert_codes', 'V' ) IS NOT NULL
	DROP VIEW dbo.bulk_insert_codes;
GO
CREATE VIEW dbo.bulk_insert_codes AS SELECT code, value FROM dbo.codes;
GO




IF OBJECT_ID('dbo.dictionary', 'U') IS NOT NULL
	DROP TABLE dbo.dictionary;
CREATE TABLE dbo.dictionary (
	_schema VARCHAR(50) NOT NULL,
	_table VARCHAR(50) NOT NULL,
	field VARCHAR(50) NOT NULL,
	codeset VARCHAR(50),
--	concept VARCHAR(255),	-- add concept?
	label VARCHAR(255),
--	definition VARCHAR(255),
	description VARCHAR(MAX),	-- very verbose
	CONSTRAINT dictionary_unique_schema_table_field
		UNIQUE ( _schema, _table, field ),
	CONSTRAINT dictionary_unique_schema_table_field_codeset
		UNIQUE ( _schema, _table, field, codeset )
);

-- These files were created from a Windows file and hence had hidden CRLFs!
-- Had to "sed 's/^M//' birth_dictionary.csv" them to correct.

--BEGIN TRY
--		FIELDTERMINATOR = '','',
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT dbo.dictionary
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\birth_dictionary.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		TABLOCK
	)';
	EXEC(@bulk_cmd);
--END TRY BEGIN CATCH
--	PRINT ERROR_MESSAGE()
--END CATCH
GO

--BEGIN TRY
--		FIELDTERMINATOR = '','',
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT dbo.dictionary
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\death_dictionary.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		TABLOCK
	)';
	EXEC(@bulk_cmd);
--END TRY BEGIN CATCH
--	PRINT ERROR_MESSAGE()
--END CATCH
GO

