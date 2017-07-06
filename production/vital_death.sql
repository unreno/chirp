
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='vital')
	EXEC('CREATE SCHEMA vital')
GO


IF OBJECT_ID('vital.deaths', 'U') IS NOT NULL
	DROP TABLE vital.deaths;
CREATE TABLE vital.deaths (
	id INT IDENTITY(1,1),		--	1
	CONSTRAINT vital_deaths_id PRIMARY KEY CLUSTERED (id ASC),

	certificate_number VARCHAR(10),
	alias_name INT,
	full_name VARCHAR(25),
	death_year INT,
	death_month INT,
	death_day INT,
	state_of_death INT,
	city_of_death VARCHAR(3),
	county_of_death INT,
	death_facility_code INT,
	place_of_death VARCHAR(1),
	unknown01 VARCHAR(2),
	ethnic_yesno VARCHAR(1),
	mexican VARCHAR(1),
	puerto_rican VARCHAR(1),
	cuban VARCHAR(1),
	other_race VARCHAR(1),
	other_race_lit VARCHAR(20),
	unknown02 VARCHAR(1),
	race_white VARCHAR(1),
	race_black VARCHAR(1),
	race_amer_indian VARCHAR(1),
	race_asian_indian VARCHAR(1),
	race_chinese VARCHAR(1),
	race_filipino VARCHAR(1),
	race_japanese VARCHAR(1),
	race_korean VARCHAR(1),
	race_vietnamese VARCHAR(1),
	race_other_asian VARCHAR(1),
	race_native_hawaiian VARCHAR(1),
	race_guam VARCHAR(1),
	race_samoan VARCHAR(1),
	race_other_pacific VARCHAR(1),
	race_other VARCHAR(1),
	race_native_american_lit VARCHAR(30),
	race_other_asian_lit VARCHAR(30),
	race_other_pacific_lit VARCHAR(30),
	race_other_lit VARCHAR(30),
	race_not_obtainable VARCHAR(1),
	race_unknown VARCHAR(1),
	race_refused VARCHAR(1),
	unknown03 VARCHAR(2),
	education INT,
	age_unit INT,
	age INT,
	birth_year INT,
	birth_month INT,
	birth_day INT,
	gender INT,
	birth_state INT,
	citizen_of INT,
	marital_status INT,
	ssn VARCHAR(9),
	occupation VARCHAR(3),
	industry VARCHAR(3),
	resident_state VARCHAR(2),
	resident_city VARCHAR(3),
	resident_county VARCHAR(2),
	resident_address VARCHAR(40),
	apt_number VARCHAR(10),
	zip_code VARCHAR(9),
	father_last_name VARCHAR(25),
	mother_last_name VARCHAR(20),
	mother_suffix VARCHAR(5),
	mother_first_name VARCHAR(10),
	mother_middle_name VARCHAR(10),
	method_of_disposition INT,
	unknown04 VARCHAR(3),
	certifier_type INT,
	coroner_contacted INT,
	manner_of_death VARCHAR(1),
	nchs_icd10 VARCHAR(4),
	immediate_cause VARCHAR(60),
	first_consequence VARCHAR(60),
	second_consequence VARCHAR(60),
	third_consequence VARCHAR(60),
	other_consequences VARCHAR(60),
	communicable_disease INT,
	autopsy_performed INT,
	tobacco_use INT,
	female_pregnant INT,
	injury_at_work INT,
	injury_place INT,
	transportation_injury INT,
	transportation_injury_lit VARCHAR(1),
	unknown05 VARCHAR(1),
	birth_year_2 INT,
	birth_state_file_number VARCHAR(8),
	supermicar1 VARCHAR(5),
	supermicar2 VARCHAR(5),
	supermicar3 VARCHAR(5),
	supermicar4 VARCHAR(5),
	supermicar5 VARCHAR(5),
	supermicar6 VARCHAR(5),
	supermicar7 VARCHAR(5),
	supermicar8 VARCHAR(5),
	supermicar9 VARCHAR(5),
	supermicar10 VARCHAR(5),
	supermicar11 VARCHAR(5),
	supermicar12 VARCHAR(5),
	supermicar13 VARCHAR(5),
	supermicar14 VARCHAR(5),
	supermicar15 VARCHAR(5),
	supermicar16 VARCHAR(5),
	supermicar17 VARCHAR(5),
	supermicar18 VARCHAR(5),
	supermicar19 VARCHAR(5),
	supermicar20 VARCHAR(5),
	unknown06 VARCHAR(48),
	hispanic_code INT,
	unknown07 VARCHAR(3),
	bridged_race INT,
	unknown08 VARCHAR(3),
	death_year_2 INT,
	unknown09 VARCHAR(1),
	state_file_number VARCHAR(10),
	army VARCHAR(1),
	unknown10 VARCHAR(3),
	birth_country_fips VARCHAR(2),
	unknown11 VARCHAR(1),
	birth_state_fips VARCHAR(2),
	unknown12 VARCHAR(1),
	resident_city_2 VARCHAR(5),
	unknown13 VARCHAR(1),
	resident_county_fips VARCHAR(3),
	unknown14 VARCHAR(2),
	resident_state_2 VARCHAR(2),
	unknown15 VARCHAR(2),
	resident_country VARCHAR(2),
	unknown16 VARCHAR(3),
	death_state VARCHAR(2),
	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT,

	imported_at DATETIME
		CONSTRAINT vital_deaths_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT vital_deaths_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL,
);
GO





IF OBJECT_ID('vital.deaths_buffer', 'U') IS NOT NULL
	DROP TABLE vital.deaths_buffer;
CREATE TABLE vital.deaths_buffer (
	certificate_number VARCHAR(10),
	alias_name INT,
	full_name VARCHAR(25),
	death_year INT,
	death_month INT,
	death_day INT,
	state_of_death INT,
	city_of_death VARCHAR(3),
	county_of_death INT,
	death_facility_code INT,
	place_of_death VARCHAR(1),
	unknown01 VARCHAR(2),
	ethnic_yesno VARCHAR(1),
	mexican VARCHAR(1),
	puerto_rican VARCHAR(1),
	cuban VARCHAR(1),
	other_race VARCHAR(1),
	other_race_lit VARCHAR(20),
	unknown02 VARCHAR(1),
	race_white VARCHAR(1),
	race_black VARCHAR(1),
	race_amer_indian VARCHAR(1),
	race_asian_indian VARCHAR(1),
	race_chinese VARCHAR(1),
	race_filipino VARCHAR(1),
	race_japanese VARCHAR(1),
	race_korean VARCHAR(1),
	race_vietnamese VARCHAR(1),
	race_other_asian VARCHAR(1),
	race_native_hawaiian VARCHAR(1),
	race_guam VARCHAR(1),
	race_samoan VARCHAR(1),
	race_other_pacific VARCHAR(1),
	race_other VARCHAR(1),
	race_native_american_lit VARCHAR(30),
	race_other_asian_lit VARCHAR(30),
	race_other_pacific_lit VARCHAR(30),
	race_other_lit VARCHAR(30),
	race_not_obtainable VARCHAR(1),
	race_unknown VARCHAR(1),
	race_refused VARCHAR(1),
	unknown03 VARCHAR(2),
	education INT,
	age_unit INT,
	age INT,
	birth_year INT,
	birth_month INT,
	birth_day INT,
	gender INT,
	birth_state INT,
	citizen_of INT,
	marital_status INT,
	ssn VARCHAR(9),
	occupation VARCHAR(3),
	industry VARCHAR(3),
	resident_state VARCHAR(2),
	resident_city VARCHAR(3),
	resident_county VARCHAR(2),
	resident_address VARCHAR(40),
	apt_number VARCHAR(10),
	zip_code VARCHAR(9),
	father_last_name VARCHAR(25),
	mother_last_name VARCHAR(20),
	mother_suffix VARCHAR(5),
	mother_first_name VARCHAR(10),
	mother_middle_name VARCHAR(10),
	method_of_disposition INT,
	unknown04 VARCHAR(3),
	certifier_type INT,
	coroner_contacted INT,
	manner_of_death VARCHAR(1),
	nchs_icd10 VARCHAR(4),
	immediate_cause VARCHAR(60),
	first_consequence VARCHAR(60),
	second_consequence VARCHAR(60),
	third_consequence VARCHAR(60),
	other_consequences VARCHAR(60),
	communicable_disease INT,
	autopsy_performed INT,
	tobacco_use INT,
	female_pregnant INT,
	injury_at_work INT,
	injury_place INT,
	transportation_injury INT,
	transportation_injury_lit VARCHAR(1),
	unknown05 VARCHAR(1),
	birth_year_2 INT,
	birth_state_file_number VARCHAR(8),
	supermicar1 VARCHAR(5),
	supermicar2 VARCHAR(5),
	supermicar3 VARCHAR(5),
	supermicar4 VARCHAR(5),
	supermicar5 VARCHAR(5),
	supermicar6 VARCHAR(5),
	supermicar7 VARCHAR(5),
	supermicar8 VARCHAR(5),
	supermicar9 VARCHAR(5),
	supermicar10 VARCHAR(5),
	supermicar11 VARCHAR(5),
	supermicar12 VARCHAR(5),
	supermicar13 VARCHAR(5),
	supermicar14 VARCHAR(5),
	supermicar15 VARCHAR(5),
	supermicar16 VARCHAR(5),
	supermicar17 VARCHAR(5),
	supermicar18 VARCHAR(5),
	supermicar19 VARCHAR(5),
	supermicar20 VARCHAR(5),
	unknown06 VARCHAR(48),
	hispanic_code INT,
	unknown07 VARCHAR(3),
	bridged_race INT,
	unknown08 VARCHAR(3),
	death_year_2 INT,
	unknown09 VARCHAR(1),
	state_file_number VARCHAR(10),
	army VARCHAR(1),
	unknown10 VARCHAR(3),
	birth_country_fips VARCHAR(2),
	unknown11 VARCHAR(1),
	birth_state_fips VARCHAR(2),
	unknown12 VARCHAR(1),
	resident_city_2 VARCHAR(5),
	unknown13 VARCHAR(1),
	resident_county_fips VARCHAR(3),
	unknown14 VARCHAR(2),
	resident_state_2 VARCHAR(2),
	unknown15 VARCHAR(2),
	resident_country VARCHAR(2),
	unknown16 VARCHAR(3),
	death_state VARCHAR(2),

	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT vital_deaths_buffer_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT vital_deaths_buffer_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL
);
GO



IF OBJECT_ID ( 'vital.bulk_insert_deaths', 'V' ) IS NOT NULL
	DROP VIEW vital.bulk_insert_deaths;
GO

-- This is ugly as there are many fields.  Nevertheless.
CREATE VIEW vital.bulk_insert_deaths AS SELECT
	certificate_number,
	alias_name,
	full_name,
	death_year,
	death_month,
	death_day,
	state_of_death,
	city_of_death,
	county_of_death,
	death_facility_code,
	place_of_death,
	unknown01,
	ethnic_yesno,
	mexican,
	puerto_rican,
	cuban,
	other_race,
	other_race_lit,
	unknown02,
	race_white,
	race_black,
	race_amer_indian,
	race_asian_indian,
	race_chinese,
	race_filipino,
	race_japanese,
	race_korean,
	race_vietnamese,
	race_other_asian,
	race_native_hawaiian,
	race_guam,
	race_samoan,
	race_other_pacific,
	race_other,
	race_native_american_lit,
	race_other_asian_lit,
	race_other_pacific_lit,
	race_other_lit,
	race_not_obtainable,
	race_unknown,
	race_refused,
	unknown03,
	education,
	age_unit,
	age,
	birth_year,
	birth_month,
	birth_day,
	gender,
	birth_state,
	citizen_of,
	marital_status,
	ssn,
	occupation,
	industry,
	resident_state,
	resident_city,
	resident_county,
	resident_address,
	apt_number,
	zip_code,
	father_last_name,
	mother_last_name,
	mother_suffix,
	mother_first_name,
	mother_middle_name,
	method_of_disposition,
	unknown04,
	certifier_type,
	coroner_contacted,
	manner_of_death,
	nchs_icd10,
	immediate_cause,
	first_consequence,
	second_consequence,
	third_consequence,
	other_consequences,
	communicable_disease,
	autopsy_performed,
	tobacco_use,
	female_pregnant,
	injury_at_work,
	injury_place,
	transportation_injury,
	transportation_injury_lit,
	unknown05,
	birth_year_2,
	birth_state_file_number,
	supermicar1,
	supermicar2,
	supermicar3,
	supermicar4,
	supermicar5,
	supermicar6,
	supermicar7,
	supermicar8,
	supermicar9,
	supermicar10,
	supermicar11,
	supermicar12,
	supermicar13,
	supermicar14,
	supermicar15,
	supermicar16,
	supermicar17,
	supermicar18,
	supermicar19,
	supermicar20,
	unknown06,
	hispanic_code,
	unknown07,
	bridged_race,
	unknown08,
	death_year_2,
	unknown09,
	state_file_number,
	army,
	unknown10,
	birth_country_fips,
	unknown11,
	birth_state_fips,
	unknown12,
	resident_city_2,
	unknown13,
	resident_county_fips,
	unknown14,
	resident_state_2,
	unknown15,
	resident_country,
	unknown16,
	death_state
FROM vital.deaths_buffer;
GO



IF IndexProperty(Object_Id('vital.deaths'),
	'vital_deaths_state_file_number', 'IndexId') IS NOT NULL
	DROP INDEX vital_deaths_state_file_number
		ON vital.deaths;
CREATE INDEX vital_deaths_state_file_number
	ON vital.deaths( state_file_number );

--	
--	IF IndexProperty(Object_Id('vital.deaths'),
--		'vital_deaths__mother_res_zip', 'IndexId') IS NOT NULL
--		DROP INDEX vital_deaths__mother_res_zip
--			ON vital.deaths;
--	IF COL_LENGTH('vital.deaths','_mother_res_zip') IS NOT NULL
--		ALTER TABLE vital.deaths DROP COLUMN _mother_res_zip;
--	ALTER TABLE vital.deaths ADD _mother_res_zip AS CAST( mother_res_zip AS VARCHAR ) PERSISTED;
--	CREATE INDEX vital_deaths__mother_res_zip
--		ON vital.deaths( _mother_res_zip );
--	


--	IF IndexProperty(Object_Id('vital.deaths'),
--		'vital_deaths_mother_res_zip', 'IndexId') IS NOT NULL
--		DROP INDEX vital_deaths_mother_res_zip
--			ON vital.deaths;
--	CREATE INDEX vital_deaths_mother_res_zip
--		ON vital.deaths( mother_res_zip );


