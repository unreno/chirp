
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
	maiden_name VARCHAR(50),	--Maiden Name VARCHAR
	birth_date DATE,	--Birth Date DATE
	place_of_birth VARCHAR(50),	--Place of birth VARCHAR
	address VARCHAR(50),	--Address 1 VARCHAR
	city VARCHAR(50),	--City VARCHAR
	state VARCHAR(50),	--State VARCHAR
	zip_code VARCHAR(15),	--Zip Code VARCHAR
	phone_1 VARCHAR(15),	--Phone no. 1 VARCHAR
	phone_2 VARCHAR(15),	--Phone no. 2 VARCHAR
	location VARCHAR(50),	--Location VARCHAR
	entry_mode VARCHAR(50),	--Entry Mode VARCHAR
	rank VARCHAR(50),	--Rank VARCHAR
	mom_surname VARCHAR(50),	--Mother's surname VARCHAR
	mom_first_name VARCHAR(50),	--Mother's first name VARCHAR
	mom_maiden_name VARCHAR(50),	--Mother's maiden name VARCHAR
	mom_birth_date DATE,	--Mother's date of birth DATE
	contact_facility VARCHAR(75),	--Contact facility VARCHAR
	contact_address VARCHAR(50),	--Contact Address 1 VARCHAR
	birth_weight VARCHAR(10)	-- Weight Birth (looks like grams)
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

EXEC bin.add_imported_at_column_to_tables_by_schema 'health_lab';
EXEC bin.add_imported_to_dw_column_to_tables_by_schema 'health_lab';



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
FROM health_lab.newborn_screenings;
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
FROM health_lab.newborn_screenings;
GO


