
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='health_lab')
	EXEC('CREATE SCHEMA health_lab')
GO


-- July 2015 - December 2015
-- "Accession Number","Kit Number","Patient ID","Last Name","First Name","Maiden Name","Birth Date","Place of birth","Address 1","City","State","Zip Code","Phone no. 1","Phone no. 2","Location","Entry Mode","Rank","Mother's surname","Mother's first name","Mother's maiden name","Mother's date of birth","Contact facility","Contact Address 1"

-- January 2016 -
-- "Accession Number","Kit Number","Patient ID","Last Name","First Name","Birth Date","Address 1","City","State","Zip Code","Phone no. 1","Weight  Birth","Mother's surname","Mother's first name","Mother's maiden name","Mother's date of birth","Contact facility","Contact Address 1"

-- Minus a few, plus "Weight Birth"

-- Where are the results????

IF OBJECT_ID('health_lab.newborn_screenings', 'U') IS NOT NULL
	DROP TABLE health_lab.newborn_screenings;
CREATE TABLE health_lab.newborn_screenings (
	id INT IDENTITY(1,1),
	CONSTRAINT health_lab_newborn_screenings_id PRIMARY KEY CLUSTERED (id ASC),
	accession_number VARCHAR(15),	--Accession Number
	kit_number VARCHAR(15),	--Kit Number
	patient_id VARCHAR(30),	--Patient ID VARCHAR(15)
	last_name VARCHAR(50),	--Last Name VARCHAR(15)
	first_name VARCHAR(50),	--First Name VARCHAR(15)	-- MALE, FEMALE????
	maiden_name VARCHAR(50),	--Maiden Name VARCHAR		-- All NULL in initial set
	birth_date DATE,	--Birth Date DATE
	place_of_birth VARCHAR(50),	--Place of birth VARCHAR		-- All NULL in initial set
	address VARCHAR(50),	--Address 1 VARCHAR
	city VARCHAR(50),	--City VARCHAR
	state VARCHAR(50),	--State VARCHAR
	zip_code VARCHAR(15),	--Zip Code VARCHAR
	phone_1 VARCHAR(15),	--Phone no. 1 VARCHAR
	phone_2 VARCHAR(15),	--Phone no. 2 VARCHAR
	location VARCHAR(50),	--Location VARCHAR		-- (2/3='Default location',1/3=NULL)
	entry_mode VARCHAR(50),	--Entry Mode VARCHAR (2/3='Reported',1/3 NULL, 3 are 'Linking')
	rank VARCHAR(50),	--Rank VARCHAR			-- All NULL in initial set
	mom_surname VARCHAR(50),	--Mother's surname VARCHAR
	mom_first_name VARCHAR(50),	--Mother's first name VARCHAR
	mom_maiden_name VARCHAR(50),	--Mother's maiden name VARCHAR
	mom_birth_date DATE,	--Mother's date of birth DATE
	contact_facility VARCHAR(75),	--Contact facility VARCHAR
	contact_address VARCHAR(50),	--Contact Address 1 VARCHAR
	birth_weight VARCHAR(10),	-- Weight Birth (looks like grams)	-- 2/3 NULL in initial set

	source_filename VARCHAR(255),
	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT,


	imported_at DATETIME
		CONSTRAINT health_lab_newborn_screenings_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_dw BIT
		CONSTRAINT health_lab_newborn_screenings_imported_to_dw_default
		DEFAULT 'FALSE' NOT NULL,
);
GO

IF OBJECT_ID('health_lab.newborn_screenings_buffer', 'U') IS NOT NULL
	DROP TABLE health_lab.newborn_screenings_buffer;
CREATE TABLE health_lab.newborn_screenings_buffer (
--	id INT IDENTITY(1,1),
--	CONSTRAINT health_lab_newborn_screenings_id PRIMARY KEY CLUSTERED (id ASC),
	accession_number VARCHAR(15),	--Accession Number
	kit_number VARCHAR(15),	--Kit Number
	patient_id VARCHAR(30),	--Patient ID VARCHAR(15)
	last_name VARCHAR(50),	--Last Name VARCHAR(15)
	first_name VARCHAR(50),	--First Name VARCHAR(15)	-- MALE, FEMALE????
	maiden_name VARCHAR(50),	--Maiden Name VARCHAR		-- All NULL in initial set
	birth_date DATE,	--Birth Date DATE
	place_of_birth VARCHAR(50),	--Place of birth VARCHAR		-- All NULL in initial set
	address VARCHAR(50),	--Address 1 VARCHAR
	city VARCHAR(50),	--City VARCHAR
	state VARCHAR(50),	--State VARCHAR
	zip_code VARCHAR(15),	--Zip Code VARCHAR
	phone_1 VARCHAR(15),	--Phone no. 1 VARCHAR
	phone_2 VARCHAR(15),	--Phone no. 2 VARCHAR
	location VARCHAR(50),	--Location VARCHAR		-- (2/3='Default location',1/3=NULL)
	entry_mode VARCHAR(50),	--Entry Mode VARCHAR (2/3='Reported',1/3 NULL, 3 are 'Linking')
	rank VARCHAR(50),	--Rank VARCHAR			-- All NULL in initial set
	mom_surname VARCHAR(50),	--Mother's surname VARCHAR
	mom_first_name VARCHAR(50),	--Mother's first name VARCHAR
	mom_maiden_name VARCHAR(50),	--Mother's maiden name VARCHAR
	mom_birth_date DATE,	--Mother's date of birth DATE
	contact_facility VARCHAR(75),	--Contact facility VARCHAR
	contact_address VARCHAR(50),	--Contact Address 1 VARCHAR
	birth_weight VARCHAR(10),	-- Weight Birth (looks like grams)	-- 2/3 NULL in initial set

	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT health_lab_newborn_screenings_buffer_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_dw BIT
		CONSTRAINT health_lab_newborn_screenings_buffer_imported_to_dw_default
		DEFAULT 'FALSE' NOT NULL,
);
GO

--IF OBJECT_ID('health_lab.newborn_screening', 'U') IS NOT NULL
--	DROP TABLE health_lab.newborn_screening;
--CREATE TABLE health_lab.newborn_screening (
--	id INT IDENTITY(1,1),
--	CONSTRAINT health_lab_newborn_screening_id PRIMARY KEY CLUSTERED (id ASC),
--	name_first VARCHAR(250),
--	name_last VARCHAR(250),
--	date_of_birth DATETIME,
--	sex VARCHAR(1),
--	testresults1 VARCHAR(250),
--	testresults2 VARCHAR(250),
--	testresults3 VARCHAR(250),
--	testresults4 VARCHAR(250),
--	testresults5 VARCHAR(250),
--
----Congenital Adrenal Hyperplasia
----Congenital Hypothyroidism
----Sickle Cell Disease S/S
----Sickle Cell Disease S/C
----Thalassemia Major
----Biotinidase Deficiency
----Galactosemia
----Argininosuccinate Lyase Deficiency (ASA)
----Classic Citrullinemia
----Citrullinemia Type II
----Homocystinuria
----Hyperphenylalanemia, including Phenylketonuria
----Tyrosinemia, Type 1
----Tyrosinemia, Type 2
----Beta-Ketothiolase Deficiency
----Glutaric Aciduria, Type I (Glutaryl-CoA Dehydrogenase Deficiency)
----Isovaleryl-CoA Dehydrogenase Deficiency (Isovaleric Acidemia)
----Maple Syrup Urine Disease
----Methylmalonic Acidemia (MMA; 8 types)
----Methylmalonic Aciduria, Vitamin B-12 Responsive
----Methylmalonic Aciduria, Vitamin B-12 Nonresponsive
----Vitamin B12 Metabolic Defect with Methylmalonicacidemia and Homocystinuria
----Propionic Acidemia (PA)
----3-methylglutaconyl-CoA Hydratase Deficiency
----3-methylglutaconyl-CoA Aciduria Type I
----3-methylglutaconyl-CoA Aciduria Type II
----3-methylglutaconyl-CoA Aciduria Type III
----3-methylglutaconyl-CoA aciduria Type IV
----Multiple Carboxylase Deficiency
----Carnitine uUptake/Transporter Defects
----Carnitine-Acylcarnitine Translocase Deficiency
----Carnitine Transporter Defect
----Carnitine Palmitoyl Transferase I Deficiency (CPT I)
----Carnitine PalmitoylTransferase II Deficiency (CPT II)
----Glutaric Aciduria, Type II (Multiple Acyl-CoA Dehydrogenase Deficiency (MADD))
----Very Long Chain Acyl-CoA Dehydrogenase Deficiency (VLCADD)
----Long Chain L-3 Hydroxyacyl-CoA Dehydrogenase Deficiency (LCHADD)
----Medium Chain Acyl-CoA Dehydrogenase Deficiency (MCADD)
----Short Chain Acyl-CoA Dehydrogenase Deficiency (SCADD)
----Cystic Fibrosis
--
--);
--GO

--EXEC bin.add_imported_at_column_to_tables_by_schema 'health_lab';
--EXEC bin.add_imported_to_dw_column_to_tables_by_schema 'health_lab';



IF OBJECT_ID ( 'health_lab.bulk_insert_newborn_screenings_2015', 'V' ) IS NOT NULL
	DROP VIEW health_lab.bulk_insert_newborn_screenings_2015;
GO
CREATE VIEW health_lab.bulk_insert_newborn_screenings_2015 AS SELECT
	accession_number,
	kit_number,
	patient_id,
	last_name,
	first_name,
	maiden_name,
	birth_date,
	place_of_birth,
	address,
	city,
	state,
	zip_code,
	phone_1,
	phone_2,
	location,
	entry_mode,
	rank,
	mom_surname,
	mom_first_name,
	mom_maiden_name,
	mom_birth_date,
	contact_facility,
	contact_address
FROM health_lab.newborn_screenings_buffer;
GO

IF OBJECT_ID ( 'health_lab.bulk_insert_newborn_screenings_2016', 'V' ) IS NOT NULL
	DROP VIEW health_lab.bulk_insert_newborn_screenings_2016;
GO
CREATE VIEW health_lab.bulk_insert_newborn_screenings_2016 AS SELECT
	accession_number,
	kit_number,
	patient_id,
	last_name,
	first_name,
--	maiden_name,
	birth_date,
--	place_of_birth,
	address,
	city,
	state,
	zip_code,
	phone_1,
--	phone_2,
	birth_weight,	-- new field
--	location,
--	entry_mode,
--	rank,
	mom_surname,
	mom_first_name,
	mom_maiden_name,
	mom_birth_date,
	contact_facility,
	contact_address
FROM health_lab.newborn_screenings_buffer;
GO



--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id
--		ON health_lab.newborn_screenings;
--CREATE INDEX health_lab_newborn_screenings_patient_id
--	ON health_lab.newborn_screenings( patient_id );



IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_accession_kit_number', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_accession_kit_number
		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','accession_kit_number') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN accession_kit_number;
ALTER TABLE health_lab.newborn_screenings ADD accession_kit_number AS
	accession_number + '-' + kit_number;
CREATE INDEX health_lab_newborn_screenings_accession_kit_number
	ON health_lab.newborn_screenings( accession_kit_number );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_pre', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_pre
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_pre') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_pre;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_pre AS
	RTRIM(SUBSTRING(patient_id, 1,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))-1,-1),LEN(patient_id))
	)) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_pre
--	ON health_lab.newborn_screenings( patient_id_pre );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_suf', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_suf
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_suf') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_suf;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_suf AS
	LTRIM(SUBSTRING(patient_id,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))+1,1),1),
		LEN(patient_id)
	)) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_suf
--	ON health_lab.newborn_screenings( patient_id_suf );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_prex', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_prex
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_prex') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_prex;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_prex AS
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(patient_id, 1,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))-1,-1),LEN(patient_id))
	),' ',''),'M',''),'R',''),'D',''),'V','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_prex
--	ON health_lab.newborn_screenings( patient_id_prex );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_sufx', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_sufx
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_sufx') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_sufx;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_sufx AS
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(patient_id,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))+1,1),1),
		LEN(patient_id)
	),' ',''),'M',''),'R',''),'D',''),'V','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_sufx
--	ON health_lab.newborn_screenings( patient_id_sufx );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_prexi', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_prexi
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_prexi') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_prexi;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_prexi AS
	REPLACE(LTRIM(REPLACE(
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(patient_id, 1,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))-1,-1),LEN(patient_id))
	),' ',''),'M',''),'R',''),'D',''),'V','')
	, '0', ' ')), ' ', '0') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_prexi
--	ON health_lab.newborn_screenings( patient_id_prexi );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_sufxi', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_sufxi
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_sufxi') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_sufxi;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_sufxi AS
	REPLACE(LTRIM(REPLACE(
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(patient_id,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))+1,1),1),
		LEN(patient_id)
	),' ',''),'M',''),'R',''),'D',''),'V','')
	, '0', ' ')), ' ', '0') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_sufxi
--	ON health_lab.newborn_screenings( patient_id_sufxi );



--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__mom_surname', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__mom_surname
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_mom_surname') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _mom_surname;
ALTER TABLE health_lab.newborn_screenings ADD _mom_surname AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( mom_surname
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__mom_surname
--	ON health_lab.newborn_screenings( _mom_surname );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__last_name', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__last_name
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_last_name') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _last_name;
ALTER TABLE health_lab.newborn_screenings ADD _last_name AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( last_name
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__last_name
--	ON health_lab.newborn_screenings( _last_name );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__mom_first_name', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__mom_first_name
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_mom_first_name') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _mom_first_name;
ALTER TABLE health_lab.newborn_screenings ADD _mom_first_name AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( mom_first_name
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__mom_first_name
--	ON health_lab.newborn_screenings( _mom_first_name );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__first_name', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__first_name
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_first_name') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _first_name;
ALTER TABLE health_lab.newborn_screenings ADD _first_name AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( first_name
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__first_name
--	ON health_lab.newborn_screenings( _first_name );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__address', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__address
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_address') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _address;
ALTER TABLE health_lab.newborn_screenings ADD _address AS
	RTRIM( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( address
		,' BOULEVARD',' ') ,' BLVD',' ') -- contains RD, so before RD extraction
		,' COURT',' ') ,' CT',' ') ,' STREET',' ') ,' ST',' ')
		,' DRIVE',' ') ,' DRIV',' ') ,' DRI',' ') ,' DR',' ')
		,' ROAD',' ') ,' RD',' ')
		,' CIRCLE',' ') ,' CIR',' ') ,' LANE',' ') ,' LN',' ')
		,' AVENUE',' ') ,' AVE',' ')
		,' MOUNT',' MT'), ' PARKWAY',' '),' PKWY',' ')
		,'SOUTH','S') ,'NORTH','N') ,'EAST','E') ,'WEST','W') )
	PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__address
--	ON health_lab.newborn_screenings( _address );



--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__last_name_pre', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__last_name_pre
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_last_name_pre') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _last_name_pre;
ALTER TABLE health_lab.newborn_screenings ADD _last_name_pre AS
	REPLACE(SUBSTRING(last_name, 1,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(last_name,' ','-'))-1,-1),LEN(last_name))
	),' ','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__last_name_pre
--	ON health_lab.newborn_screenings( _last_name_pre );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__last_name_suf', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__last_name_suf
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_last_name_suf') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _last_name_suf;
ALTER TABLE health_lab.newborn_screenings ADD _last_name_suf AS
	REPLACE(SUBSTRING(last_name,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(last_name,' ','-'))+1,1),1),
		LEN(last_name)
	),' ','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__last_name_suf
--	ON health_lab.newborn_screenings( _last_name_suf );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__mom_surname_pre', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__mom_surname_pre
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_mom_surname_pre') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _mom_surname_pre;
ALTER TABLE health_lab.newborn_screenings ADD _mom_surname_pre AS
	REPLACE(SUBSTRING(mom_surname, 1,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(mom_surname,' ','-'))-1,-1),LEN(mom_surname))
	),' ','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__mom_surname_pre
--	ON health_lab.newborn_screenings( _mom_surname_pre );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__mom_surname_suf', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__mom_surname_suf
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_mom_surname_suf') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _mom_surname_suf;
ALTER TABLE health_lab.newborn_screenings ADD _mom_surname_suf AS
	REPLACE(SUBSTRING(mom_surname,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(mom_surname,' ','-'))+1,1),1),
		LEN(mom_surname)
	),' ','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__mom_surname_suf
--	ON health_lab.newborn_screenings( _mom_surname_suf );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__address_pre', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__address_pre
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_address_pre') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _address_pre;
ALTER TABLE health_lab.newborn_screenings ADD _address_pre AS
	SUBSTRING(address, 1,
		ISNULL(NULLIF(CHARINDEX(' ',address)-1,-1),LEN(address))
	) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__address_pre
--	ON health_lab.newborn_screenings( _address_pre );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__address_suf', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__address_suf
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_address_suf') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _address_suf;
ALTER TABLE health_lab.newborn_screenings ADD _address_suf AS
	SUBSTRING(address,
		ISNULL(NULLIF(CHARINDEX(' ',address)+1,1),1),
		LEN(address)
	) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__address_suf
--	ON health_lab.newborn_screenings( _address_suf );


IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_zip_code', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_zip_code
		ON health_lab.newborn_screenings;
CREATE INDEX health_lab_newborn_screenings_zip_code
	ON health_lab.newborn_screenings( zip_code );

IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_birth_date', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_birth_date
		ON health_lab.newborn_screenings;
CREATE INDEX health_lab_newborn_screenings_birth_date
	ON health_lab.newborn_screenings( birth_date );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_mom_birth_date', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_mom_birth_date
--		ON health_lab.newborn_screenings;
--CREATE INDEX health_lab_newborn_screenings_mom_birth_date
--	ON health_lab.newborn_screenings( mom_birth_date );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_birth_date_day', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_birth_date_day
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','birth_date_day') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN birth_date_day;
ALTER TABLE health_lab.newborn_screenings ADD birth_date_day AS
	DAY(birth_date) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_birth_date_day
--	ON health_lab.newborn_screenings( birth_date_day );

IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_birth_date_month', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_birth_date_month
		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','birth_date_month') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN birth_date_month;
ALTER TABLE health_lab.newborn_screenings ADD birth_date_month AS
	MONTH(birth_date) PERSISTED;
CREATE INDEX health_lab_newborn_screenings_birth_date_month
	ON health_lab.newborn_screenings( birth_date_month );

IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_birth_date_year', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_birth_date_year
		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','birth_date_year') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN birth_date_year;
ALTER TABLE health_lab.newborn_screenings ADD birth_date_year AS
	YEAR(birth_date) PERSISTED;
CREATE INDEX health_lab_newborn_screenings_birth_date_year
	ON health_lab.newborn_screenings( birth_date_year );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_mom_birth_date_day', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_mom_birth_date_day
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','mom_birth_date_day') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN mom_birth_date_day;
ALTER TABLE health_lab.newborn_screenings ADD mom_birth_date_day AS
	DAY(mom_birth_date) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_mom_birth_date_day
--	ON health_lab.newborn_screenings( mom_birth_date_day );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_mom_birth_date_month', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_mom_birth_date_month
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','mom_birth_date_month') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN mom_birth_date_month;
ALTER TABLE health_lab.newborn_screenings ADD mom_birth_date_month AS
	MONTH(mom_birth_date) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_mom_birth_date_month
--	ON health_lab.newborn_screenings( mom_birth_date_month );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_mom_birth_date_year', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_mom_birth_date_year
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','mom_birth_date_year') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN mom_birth_date_year;
ALTER TABLE health_lab.newborn_screenings ADD mom_birth_date_year AS
	YEAR(mom_birth_date) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_mom_birth_date_year
--	ON health_lab.newborn_screenings( mom_birth_date_year );


