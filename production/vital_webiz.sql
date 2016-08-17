
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='vital')
	EXEC('CREATE SCHEMA vital')
GO



IF OBJECT_ID('vital.webizs', 'U') IS NOT NULL
	DROP TABLE vital.webizs;
CREATE TABLE vital.webizs (
	id INT IDENTITY(1,1),		--	1
	CONSTRAINT vital_webizs_id PRIMARY KEY CLUSTERED (id ASC),


	patient_id	INT, --System Assigned Number used for Primary key. Represents the Patient ID within the system (a.k.a., Web­IZ ID)
	last_name	VARCHAR(30),	--	Last Name of the Patient
	first_name	VARCHAR(25),	--	First Name of the patient
	middle_name	VARCHAR(25),	--	Middle Name of the patient
	dob	DATETIME,	-- Date of Birth for the patient
	street_number	VARCHAR(25),	--	The street number portion of the address.
	street_name	VARCHAR(250),	--	The street name portion of the address.
	city_desc	VARCHAR(50),	--	Name of the City. Displayed in some dropdowns, reports, etc. within the application.
	zip_code	VARCHAR(50),	--	The zip code portion of the address
	county_desc	VARCHAR(50),	--	Name of the County. Displayed in some dropdowns, reports, etc. within the application.
	race_desc	VARCHAR(50),	--	Full description of the race. Displayed in some dropdowns, reports, etc. within the application.
	ethnicity_desc	VARCHAR(50),	--	Description of the Ethnicity code. Displayed in some dropdowns, reports, etc. within the application.
	gender_code	CHAR(1),	--	Identifies the gender of the patient
	mother_last_name	VARCHAR(30),	--	Last Name of the patient's mother
	mother_first_name	VARCHAR(25),	--	First name of the patient's mother.
	mother_maiden_name	VARCHAR(30),	--	Maiden name of the patient's mother.
	telephone	VARCHAR(30),	--	Home Phone Number for the patient
	ssn	VARCHAR(11),	--	Social Security Number of the patient
	local_id	VARCHAR(50),	--	The identifier this clinic has assigned to the patient (MRN)
	vaccination_desc	VARCHAR(100),	--	Full description of the vaccine
	vaccination_date	DATETIME,	--	Date the vaccine was administered to the patient
	patient_vaccination_id	INT,	--	System Assigned Number used for Primary key


	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT,

	imported_at DATETIME
		CONSTRAINT vital_webizs_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_dw BIT
		CONSTRAINT vital_webizs_imported_to_dw_default
		DEFAULT 'FALSE' NOT NULL
);
GO





IF OBJECT_ID('vital.webizs_buffer', 'U') IS NOT NULL
	DROP TABLE vital.webizs_buffer;
CREATE TABLE vital.webizs_buffer (


	patient_id	INT, --System Assigned Number used for Primary key. Represents the Patient ID within the system (a.k.a., Web­IZ ID)
	last_name	VARCHAR(30),	--	Last Name of the Patient
	first_name	VARCHAR(25),	--	First Name of the patient
	middle_name	VARCHAR(25),	--	Middle Name of the patient
	dob	DATETIME,	-- Date of Birth for the patient
	street_number	VARCHAR(25),	--	The street number portion of the address.
	street_name	VARCHAR(250),	--	The street name portion of the address.
	city_desc	VARCHAR(50),	--	Name of the City. Displayed in some dropdowns, reports, etc. within the application.
	zip_code	VARCHAR(50),	--	The zip code portion of the address
	county_desc	VARCHAR(50),	--	Name of the County. Displayed in some dropdowns, reports, etc. within the application.
	race_desc	VARCHAR(50),	--	Full description of the race. Displayed in some dropdowns, reports, etc. within the application.
	ethnicity_desc	VARCHAR(50),	--	Description of the Ethnicity code. Displayed in some dropdowns, reports, etc. within the application.
	gender_code	CHAR(1),	--	Identifies the gender of the patient
	mother_last_name	VARCHAR(30),	--	Last Name of the patient's mother
	mother_first_name	VARCHAR(25),	--	First name of the patient's mother.
	mother_maiden_name	VARCHAR(30),	--	Maiden name of the patient's mother.
	telephone	VARCHAR(30),	--	Home Phone Number for the patient
	ssn	VARCHAR(11),	--	Social Security Number of the patient
	local_id	VARCHAR(50),	--	The identifier this clinic has assigned to the patient (MRN)
	vaccination_desc	VARCHAR(100),	--	Full description of the vaccine
	vaccination_date	DATETIME,	--	Date the vaccine was administered to the patient
	patient_vaccination_id	INT,	--	System Assigned Number used for Primary key


	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT vital_webizs_buffer_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_dw BIT
		CONSTRAINT vital_webizs_buffer_imported_to_dw_default
		DEFAULT 'FALSE' NOT NULL,
);
GO

--EXEC bin.add_imported_at_column_to_tables_by_schema 'vital';
--EXEC bin.add_imported_to_dw_column_to_tables_by_schema 'vital';



--IF OBJECT_ID ( 'vital.bulk_insert_webizs', 'V' ) IS NOT NULL
--	DROP VIEW vital.bulk_insert_webizs;
--GO
--
--CREATE VIEW vital.bulk_insert_webizs AS SELECT
--
--
--
--
--
--
--FROM vital.webizs_buffer;
--GO


