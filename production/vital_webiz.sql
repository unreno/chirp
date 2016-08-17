
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='vital')
	EXEC('CREATE SCHEMA vital')
GO



IF OBJECT_ID('vital.webizs', 'U') IS NOT NULL
	DROP TABLE vital.webizs;
CREATE TABLE vital.webizs (
	id INT IDENTITY(1,1),		--	1
	CONSTRAINT vital_webizs_id PRIMARY KEY CLUSTERED (id ASC),

	patient_id	INT,	-- identity NOT NULL,
	first_name	VARCHAR(25),	-- NOT NULL,
	middle_name	VARCHAR(25),	-- NULL,
	last_name	VARCHAR(30),	-- NOT NULL,
	dob	DATETIME,	-- NULL,
	gender_code	CHAR(1),	-- NULL,
	race_code_id	INT,	-- NOT NULL,
	ethnicity_code_id	INT,	-- NULL,
	vfc_code_id	INT,	-- NULL,
	program_close_date	DATETIME,	-- NULL,
	close_reason_desc	VARCHAR(50),	-- NOT NULL,
	mother_last_name	VARCHAR(30),	-- NULL,
	mother_first_name	VARCHAR(25),	-- NULL,
	birth_state_code_id	INT,	-- NULL,
	birth_country_code_id	INT,	-- NULL,
	vaccination_code_id	INT,	-- NOT NULL,
	vaccination_desc	VARCHAR(100),	-- NOT NULL,
	vaccination_date	DATETIME,	-- NOT NULL
	manufacturer_desc	VARCHAR(50),	-- NOT NULL,
	history_only_flag	CHAR(1),	-- NOT NULL,
	allergy_risk_desc	VARCHAR(250),	-- NULL,
	address_line1	VARCHAR(50),	-- NULL,
	city_code_id	INT,	-- NULL,
	state_code_id	INT,	-- NULL,
	zip_code	VARCHAR(10),	-- NULL,
	county_code_id	INT,	-- NULL,
	telephone	VARCHAR(30),	-- NULL,
	email_address	VARCHAR(100),	-- NULL,
	cell_phone	VARCHAR(30),	-- NULL,
	audit_update_dttm	DATETIME,	-- NOT NULL,
	provider_id	INT,	-- identity NOT NULL,
	provider_desc	VARCHAR(50),	-- NOT NULL,
	provider_address_line1	VARCHAR(50),	-- NULL,
	provider_city_code_id	INT,	-- NULL,
	provider_state_code_id	INT,	-- NULL,
	provider_zip_code	VARCHAR(10),	-- NULL,
	provider_telephone	VARCHAR(30),	-- NULL,
	provider_type_of_practice_code_desc	VARCHAR(35),	-- NOT NULL,

	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT,

	imported_at DATETIME
		CONSTRAINT vital_webizs_imported_at_default DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_dw BIT
		CONSTRAINT vital_webizs_imported_to_dw_default DEFAULT 'FALSE' NOT NULL
);
GO





IF OBJECT_ID('vital.webizs_buffer', 'U') IS NOT NULL
	DROP TABLE vital.webizs_buffer;
CREATE TABLE vital.webizs_buffer (

	patient_id	INT,	-- identity NOT NULL,
	first_name	VARCHAR(25),	-- NOT NULL,
	middle_name	VARCHAR(25),	-- NULL,
	last_name	VARCHAR(30),	-- NOT NULL,
	dob	DATETIME,	-- NULL,
	gender_code	CHAR(1),	-- NULL,
	race_code_id	INT,	-- NOT NULL,
	ethnicity_code_id	INT,	-- NULL,
	vfc_code_id	INT,	-- NULL,
	program_close_date	DATETIME,	-- NULL,
	close_reason_desc	VARCHAR(50),	-- NOT NULL,
	mother_last_name	VARCHAR(30),	-- NULL,
	mother_first_name	VARCHAR(25),	-- NULL,
	birth_state_code_id	INT,	-- NULL,
	birth_country_code_id	INT,	-- NULL,
	vaccination_code_id	INT,	-- NOT NULL,
	vaccination_desc	VARCHAR(100),	-- NOT NULL,
	vaccination_date	DATETIME,	-- NOT NULL
	manufacturer_desc	VARCHAR(50),	-- NOT NULL,
	history_only_flag	CHAR(1),	-- NOT NULL,
	allergy_risk_desc	VARCHAR(250),	-- NULL,
	address_line1	VARCHAR(50),	-- NULL,
	city_code_id	INT,	-- NULL,
	state_code_id	INT,	-- NULL,
	zip_code	VARCHAR(10),	-- NULL,
	county_code_id	INT,	-- NULL,
	telephone	VARCHAR(30),	-- NULL,
	email_address	VARCHAR(100),	-- NULL,
	cell_phone	VARCHAR(30),	-- NULL,
	audit_update_dttm	DATETIME,	-- NOT NULL,
	provider_id	INT,	-- identity NOT NULL,
	provider_desc	VARCHAR(50),	-- NOT NULL,
	provider_address_line1	VARCHAR(50),	-- NULL,
	provider_city_code_id	INT,	-- NULL,
	provider_state_code_id	INT,	-- NULL,
	provider_zip_code	VARCHAR(10),	-- NULL,
	provider_telephone	VARCHAR(30),	-- NULL,
	provider_type_of_practice_code_desc	VARCHAR(35),	-- NOT NULL,



	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT vital_webizs_buffer_imported_at_default DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_dw BIT
		CONSTRAINT vital_webizs_buffer_imported_to_dw_default DEFAULT 'FALSE' NOT NULL,
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


