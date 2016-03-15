USE chirp
-- Sadly, TSQL scripts don't seem to crash
-- IF chirp doesn't exist, this script continues after the GO statement.
GO


IF OBJECT_ID('dbo.concepts', 'U') IS NOT NULL
	DROP TABLE dbo.concepts;
CREATE TABLE dbo.concepts (
	id INT IDENTITY(1,1),
	code VARCHAR(255) PRIMARY KEY,
	path VARCHAR(255),
	description VARCHAR(MAX),
	CONSTRAINT unique_code 
		UNIQUE (code)
);
-- Examples:
-- code: ICD10CM:M71.432, description: Calcium deposit in bursa, left wrist
-- code: HCPC:0356T, description: INSERTION OF DRUG-ELUTING IMPLANT ....
-- code: LOINC:8302-2, description: Body Height (LOINC:8302-2)
-- code: LOINC:3141-9, description: Body Weight (LOINC:3141-9)
-- code: DEM:Race, description: Race
-- code: DEM:Language, description: Language



IF OBJECT_ID('dbo.providers', 'U') IS NOT NULL
	DROP TABLE dbo.providers;
CREATE TABLE dbo.providers (
	id INT IDENTITY(1,1) PRIMARY KEY,


);



/*

--Not sure what purpose this table can serve.

IF OBJECT_ID('dbo.encounters', 'U') IS NOT NULL
	DROP TABLE dbo.encounters;
CREATE TABLE dbo.encounters (
	id INT IDENTITY(1,1) PRIMARY KEY,

);
*/




IF OBJECT_ID('dbo.locations', 'U') IS NOT NULL
	DROP TABLE dbo.locations;
CREATE TABLE dbo.locations (
	id INT IDENTITY(1,1) PRIMARY KEY,


);




--Can't declare foreign key constraints until those tables exist.
IF OBJECT_ID('dbo.observations', 'U') IS NOT NULL
	DROP TABLE dbo.observations;
CREATE TABLE dbo.observations (
	id INT IDENTITY(1,1) PRIMARY KEY,
	chirp_id        INT NOT NULL,
--	encounter_id    INT NOT NULL,
	provider_id     INT NOT NULL,
	location_id     INT NOT NULL,
	concept         VARCHAR(255) NOT NULL,
	started_at      DATETIME NOT NULL,
	ended_at        DATETIME,
	value_type      VARCHAR(1) NOT NULL,
	n_value         DECIMAL(18,5),
	s_value         VARCHAR(255),
--	l_value         VARCHAR(MAX),
--	d_value         DATE,
	t_value         DATETIME,
	units           VARCHAR(20),
	downloaded_at   DATETIME,
	downloaded_from VARCHAR(50),
	imported_at     DATETIME
		CONSTRAINT dbo_observations_imported_at_default 
		DEFAULT CURRENT_TIMESTAMP NOT NULL,

--	CONSTRAINT fk_encounter_id
--		FOREIGN KEY (encounter_id) REFERENCES encounters(id),
--	CONSTRAINT fk_provider_id
--		FOREIGN KEY (provider_id) REFERENCES providers(id),
--	CONSTRAINT fk_location_id
--		FOREIGN KEY (location_id) REFERENCES locations(id),
	CONSTRAINT fk_concept_code
		FOREIGN KEY (concept) REFERENCES concepts(code)
);

/*

ALTER TABLE dbo.observations NOCHECK CONSTRAINT fk_concept_code;
-- remove old and add new records
ALTER TABLE dbo.observations CHECK CONSTRAINT fk_concept_code;

--OR?

ALTER TABLE dbo.observations DROP fk_concept_code
	FOREIGN KEY (concept) REFERENCES concepts(code)
);
-- remove old and add new records
ALTER TABLE dbo.observations ADD fk_concept_code
	FOREIGN KEY (concept) REFERENCES concepts(code)
);

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
