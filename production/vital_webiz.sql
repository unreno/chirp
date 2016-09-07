
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='vital')
	EXEC('CREATE SCHEMA vital')
GO



IF OBJECT_ID('vital.webizs', 'U') IS NOT NULL
	DROP TABLE vital.webizs;
CREATE TABLE vital.webizs (
	id INT IDENTITY(1,1),		--	1
	CONSTRAINT vital_webizs_id PRIMARY KEY CLUSTERED (id ASC),

	patient_id	INT,	--	System Assigned Number used for Primary key. Represents the Patient ID within the system (a.k.a., Web­IZ ID)
	last_name	VARCHAR(30), --	Last Name of the Patient
	first_name	VARCHAR(25), --	First Name of the patient
	middle_name	VARCHAR(25), --	Middle Name of the patient
	dob	DATE, --	Date of Birth for the patient
	po_box	VARCHAR(50), --	The PO Box portion of the address
	street_number	VARCHAR(25), --	The street number portion of the address.
	street_prefix_desc	VARCHAR(50), --	Short description of the street prefix.
	street_name	VARCHAR(250), --	The street name portion of the address.
	street_type_desc	VARCHAR(50), --	Short description of the street type.
	city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.
	apt_number	VARCHAR(25), --	The apartment or unit number portion of the address.
	zip_code	VARCHAR(50), --	The zip code portion of the address
	county_desc	VARCHAR(50), --	Name of the County. Displayed in some dropdowns, reports, etc. within the application.
	race_desc	VARCHAR(50), --	Full description of the race. Displayed in some dropdowns, reports, etc. within the application.
	ethnicity_desc	VARCHAR(50), --	Description of the Ethnicity code. Displayed in some dropdowns, reports, etc. within the application.
	gender_code	CHAR(1), --	Identifies the gender of the patient
	mother_last_name	VARCHAR(30), --	Last Name of the patient's mother
	mother_first_name	VARCHAR(25), --	First name of the patient's mother.
	mother_maiden_name	VARCHAR(30), --	Maiden name of the patient's mother.
	telephone	VARCHAR(30), --	Home Phone Number for the patient
	ssn	VARCHAR(11), --	Social Security Number of the patient
	local_id	VARCHAR(50), --	The identifier this clinic has assigned to the patient
	vaccination_desc	VARCHAR(100), --	Full description of the vaccine
	vaccination_date	DATE, --	Date the vaccine was administered to the patient
	patient_vaccination_id	INT, --	System Assigned Number used for Primary key
	dosage_num	INT, --	DEPRECATED. No longer used by the system.

	npi	VARCHAR(25), --	NPI (National Provider Identifier) for the provider.
	provider_desc	VARCHAR(50), --	Name of the provider
	provider_id	INT, --	System Assigned Number used for Primary key
--	provider_id	VARCHAR(50), --	System Assigned Number used for Primary key
	provider_street_number	VARCHAR(25), --	The street number portion of the address.
	provider_street_prefix_desc	VARCHAR(50), --	Short description of the street prefix.
	provider_street_name	VARCHAR(250), --	The street name portion of the address.
	provider_street_type_desc	VARCHAR(50), --	Short description of the street type.
	provider_city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.

	clinic_desc	VARCHAR(50), --	Full name of the clinic
	clinic_id	INT, --	System Assigned Number used for Primary key
--	clinic_id	VARCHAR(50), --	System Assigned Number used for Primary key
	clinic_street_number	VARCHAR(25), --	The street number portion of the address.
	clinic_street_prefix_desc	VARCHAR(50), --	Short description of the street prefix.
	clinic_street_name	VARCHAR(250), --	The street name portion of the address.
	clinic_street_type_desc	VARCHAR(50), --	Short description of the street type.
	clinic_city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.

	history_address_line	VARCHAR(50), --	Line 1 of the address
	history_city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.
	history_zip_code	VARCHAR(10), --	The Zip Code portion of the address
	history_county_desc	VARCHAR(50), --	Name of the County. Displayed in some dropdowns, reports, etc. within the application.

	birth_city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.
	birth_county_desc	VARCHAR(50), --	Name of the County. Displayed in some dropdowns, reports, etc. within the application.
	birth_state_desc	VARCHAR(50), --	Full description for the state
	birth_country_desc	VARCHAR(50), --	Name of the Country. Displayed in some dropdowns, reports, etc. within the application.
	health_insurance_desc	VARCHAR(50), --	Full name of the Insurance Source. Displayed in some dropdowns, reports, etc. within the application.

	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT,

	imported_at DATETIME
		CONSTRAINT vital_webizs_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT vital_webizs_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL
);
GO




IF OBJECT_ID('vital.webizs_buffer', 'U') IS NOT NULL
	DROP TABLE vital.webizs_buffer;
CREATE TABLE vital.webizs_buffer (
	patient_id	INT,	--	System Assigned Number used for Primary key. Represents the Patient ID within the system (a.k.a., Web­IZ ID)
	last_name	VARCHAR(30), --	Last Name of the Patient
	first_name	VARCHAR(25), --	First Name of the patient
	middle_name	VARCHAR(25), --	Middle Name of the patient
	dob	DATE, --	Date of Birth for the patient
	po_box	VARCHAR(50), --	The PO Box portion of the address
	street_number	VARCHAR(25), --	The street number portion of the address.
	street_prefix_desc	VARCHAR(50), --	Short description of the street prefix.
	street_name	VARCHAR(250), --	The street name portion of the address.
	street_type_desc	VARCHAR(50), --	Short description of the street type.
	city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.
	apt_number	VARCHAR(25), --	The apartment or unit number portion of the address.
	zip_code	VARCHAR(50), --	The zip code portion of the address
	county_desc	VARCHAR(50), --	Name of the County. Displayed in some dropdowns, reports, etc. within the application.
	race_desc	VARCHAR(50), --	Full description of the race. Displayed in some dropdowns, reports, etc. within the application.
	ethnicity_desc	VARCHAR(50), --	Description of the Ethnicity code. Displayed in some dropdowns, reports, etc. within the application.
	gender_code	CHAR(1), --	Identifies the gender of the patient
	mother_last_name	VARCHAR(30), --	Last Name of the patient's mother
	mother_first_name	VARCHAR(25), --	First name of the patient's mother.
	mother_maiden_name	VARCHAR(30), --	Maiden name of the patient's mother.
	telephone	VARCHAR(30), --	Home Phone Number for the patient
	ssn	VARCHAR(11), --	Social Security Number of the patient
	local_id	VARCHAR(50), --	The identifier this clinic has assigned to the patient
	vaccination_desc	VARCHAR(100), --	Full description of the vaccine
	vaccination_date	DATE, --	Date the vaccine was administered to the patient
	patient_vaccination_id	INT, --	System Assigned Number used for Primary key
	dosage_num	INT, --	DEPRECATED. No longer used by the system.

	npi	VARCHAR(25), --	NPI (National Provider Identifier) for the provider.
	provider_desc	VARCHAR(50), --	Name of the provider
	provider_id	INT, --	System Assigned Number used for Primary key
--	provider_id	VARCHAR(50), --	System Assigned Number used for Primary key
	provider_street_number	VARCHAR(25), --	The street number portion of the address.
	provider_street_prefix_desc	VARCHAR(50), --	Short description of the street prefix.
	provider_street_name	VARCHAR(250), --	The street name portion of the address.
	provider_street_type_desc	VARCHAR(50), --	Short description of the street type.
	provider_city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.

	clinic_desc	VARCHAR(50), --	Full name of the clinic
	clinic_id	INT, --	System Assigned Number used for Primary key
--	clinic_id	VARCHAR(50), --	System Assigned Number used for Primary key
	clinic_street_number	VARCHAR(25), --	The street number portion of the address.
	clinic_street_prefix_desc	VARCHAR(50), --	Short description of the street prefix.
	clinic_street_name	VARCHAR(250), --	The street name portion of the address.
	clinic_street_type_desc	VARCHAR(50), --	Short description of the street type.
	clinic_city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.

	history_address_line	VARCHAR(50), --	Line 1 of the address
	history_city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.
	history_zip_code	VARCHAR(10), --	The Zip Code portion of the address
	history_county_desc	VARCHAR(50), --	Name of the County. Displayed in some dropdowns, reports, etc. within the application.

	birth_city_desc	VARCHAR(50), --	Name of the City. Displayed in some dropdowns, reports, etc. within the application.
	birth_county_desc	VARCHAR(50), --	Name of the County. Displayed in some dropdowns, reports, etc. within the application.
	birth_state_desc	VARCHAR(50), --	Full description for the state
	birth_country_desc	VARCHAR(50), --	Name of the Country. Displayed in some dropdowns, reports, etc. within the application.
	health_insurance_desc	VARCHAR(50), --	Full name of the Insurance Source. Displayed in some dropdowns, reports, etc. within the application.


	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT vital_webizs_buffer_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT vital_webizs_buffer_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL,
);
GO


IF OBJECT_ID ( 'vital.bulk_insert_webizs', 'V' ) IS NOT NULL
	DROP VIEW vital.bulk_insert_webizs;
GO

CREATE VIEW vital.bulk_insert_webizs AS SELECT

	patient_id,
	last_name,
	first_name,
	middle_name,
	dob,
	po_box,
	street_number,
	street_prefix_desc,
	street_name,
	street_type_desc,
	city_desc,
	apt_number,
	zip_code,
	county_desc,
	race_desc,
	ethnicity_desc,
	gender_code,
	mother_last_name,
	mother_first_name,
	mother_maiden_name,
	telephone,
	ssn,
	local_id,
	vaccination_desc,
	vaccination_date,
	patient_vaccination_id,
	dosage_num,
	npi,
	provider_desc,
	provider_id,
	provider_street_number,
	provider_street_prefix_desc,
	provider_street_name,
	provider_street_type_desc,
	provider_city_desc,
	clinic_desc,
	clinic_id,
	clinic_street_number,
	clinic_street_prefix_desc,
	clinic_street_name,
	clinic_street_type_desc,
	clinic_city_desc,
	history_address_line,
	history_city_desc,
	history_zip_code,
	history_county_desc,
	birth_city_desc,
	birth_county_desc,
	birth_state_desc,
	birth_country_desc,
	health_insurance_desc
FROM vital.webizs_buffer;
GO


