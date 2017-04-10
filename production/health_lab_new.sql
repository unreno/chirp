
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='health_lab_new')
	EXEC('CREATE SCHEMA health_lab_new')
GO


-- July 2015 - December 2015
-- "Accession Number","Kit Number","Patient ID","Last Name","First Name","Maiden Name","Birth Date","Place of birth","Address 1","City","State","Zip Code","Phone no. 1","Phone no. 2","Location","Entry Mode","Rank","Mother's surname","Mother's first name","Mother's maiden name","Mother's date of birth","Contact facility","Contact Address 1"

-- January 2016 -
-- "Accession Number","Kit Number","Patient ID","Last Name","First Name","Birth Date","Address 1","City","State","Zip Code","Phone no. 1","Weight  Birth","Mother's surname","Mother's first name","Mother's maiden name","Mother's date of birth","Contact facility","Contact Address 1"

-- Minus a few, plus "Weight Birth"

-- Where are the results????

--IF OBJECT_ID('health_lab_new.newborn_screenings', 'U') IS NOT NULL
--	DROP TABLE health_lab_new.newborn_screening_specimens;
--CREATE TABLE health_lab_new.newborn_screening_specimens (
--	id INT IDENTITY(1,1),
--	CONSTRAINT health_lab_new_newborn_screening_specimens_id PRIMARY KEY CLUSTERED (id ASC),
---- SpecimenID,AccessionNumber,KitNumber,OrigKitNumber,TimeReceived,Unsat1,Unsat2,ParentRefused,Adopted,Deceased,DeceasedDate,ConsentGiven,BabyLast,BabyFirst,BirthDate,BirthDateNotGiven,BirthTime,BirthTimeNotGiven,BirthWeight,CollectionDate,CollectionDateNotGiven,CollectionTime,CollectionTimeNotGiven,CurrentWeight,BabySex,CollectedBy,CollectionAge,MedicalRecord,BirthType,BirthOrder,RaceWhite,RaceAfrAmer,RaceAmerInd,RaceAsian,RaceOther,RaceHispanic,BreastFeedOnly,MilkFeedOnly,SoyFeedOnly,BreastMilkFeed,BreastSoyFeed,TPN,NotFed,GestationAge,Meconiumileus,NICU,Antibiotic,BloodTransfusion,TrasfusionDate,BirthHospitalFacility,BirthHospitalFirstName,BirthHospitalLastName,BirthHospitalCode,BirthHospitalNotGiven,CollectionFacilityFacility,CollectionFacilityFirstName,CollectionFacilityLastName,CollectionFacilityCode,CollectionFacilityNotGiven,ReportToFacility,ReportToFirstName,ReportToLastName,ReportToCode,ReportToNotGiven,ReportToAddress,ReportToCity,ReportToState,ReportToZip,MotherLastName,MotherFirstName,MotherDOB,MotherMaidenName,MotherAddress,MotherCity,MotherState,MotherZip,Phone,EmergencyPhone,FatherName,FatherPhone,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel
--
--
--	source_filename VARCHAR(255),
--	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
--	--	If remove, remove code that RESEED ID
--	--	Actually, despite saying it doesn't, it seems to preserve the order.
--	source_record_number INT,
--
--	imported_at DATETIME
--		CONSTRAINT health_lab_new_newborn_screenings_imported_at_default
--		DEFAULT CURRENT_TIMESTAMP NOT NULL,
--	imported_to_observations BIT
--		CONSTRAINT health_lab_new_newborn_screenings_imported_to_observations_default
--		DEFAULT 'FALSE' NOT NULL,
--);
--GO

IF OBJECT_ID('health_lab_new.newborn_screening_specimens_buffer', 'U') IS NOT NULL
	DROP TABLE health_lab_new.newborn_screening_specimens_buffer;
CREATE TABLE health_lab_new.newborn_screening_specimens_buffer (
--	id INT IDENTITY(1,1),
--	CONSTRAINT health_lab_new_newborn_screening_specimens_id PRIMARY KEY CLUSTERED (id ASC),
-- SpecimenID,AccessionNumber,KitNumber,OrigKitNumber,TimeReceived,Unsat1,Unsat2,ParentRefused,Adopted,Deceased,DeceasedDate,ConsentGiven,BabyLast,BabyFirst,BirthDate,BirthDateNotGiven,BirthTime,BirthTimeNotGiven,BirthWeight,CollectionDate,CollectionDateNotGiven,CollectionTime,CollectionTimeNotGiven,CurrentWeight,BabySex,CollectedBy,CollectionAge,MedicalRecord,BirthType,BirthOrder,RaceWhite,RaceAfrAmer,RaceAmerInd,RaceAsian,RaceOther,RaceHispanic,BreastFeedOnly,MilkFeedOnly,SoyFeedOnly,BreastMilkFeed,BreastSoyFeed,TPN,NotFed,GestationAge,Meconiumileus,NICU,Antibiotic,BloodTransfusion,TrasfusionDate,BirthHospitalFacility,BirthHospitalFirstName,BirthHospitalLastName,BirthHospitalCode,BirthHospitalNotGiven,CollectionFacilityFacility,CollectionFacilityFirstName,CollectionFacilityLastName,CollectionFacilityCode,CollectionFacilityNotGiven,ReportToFacility,ReportToFirstName,ReportToLastName,ReportToCode,ReportToNotGiven,ReportToAddress,ReportToCity,ReportToState,ReportToZip,MotherLastName,MotherFirstName,MotherDOB,MotherMaidenName,MotherAddress,MotherCity,MotherState,MotherZip,Phone,EmergencyPhone,FatherName,FatherPhone,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel

	SpecimenID VARCHAR(10),
	AccessionNumber VARCHAR(15),
	KitNumber VARCHAR(15),
	OrigKitNumber VARCHAR(10),
	TimeReceived DATETIME,
	Unsat1 VARCHAR(10),
	Unsat2 VARCHAR(10),
	ParentRefused VARCHAR(10),
	Adopted VARCHAR(10),
	Deceased VARCHAR(10),
	DeceasedDate DATE,
	ConsentGiven VARCHAR(10),
	BabyLast VARCHAR(20),
	BabyFirst VARCHAR(10),
	BirthDate DATE,
	BirthDateNotGiven VARCHAR(10),
	BirthTime VARCHAR(10),
	BirthTimeNotGiven VARCHAR(10),
	BirthWeight VARCHAR(10),
	CollectionDate DATE,
	CollectionDateNotGiven VARCHAR(10),
	CollectionTime VARCHAR(10),
	CollectionTimeNotGiven VARCHAR(10),
	CurrentWeight VARCHAR(10),
	BabySex VARCHAR(10),
	CollectedBy VARCHAR(20),
	CollectionAge VARCHAR(10),
	MedicalRecord VARCHAR(10),
	BirthType VARCHAR(10),
	BirthOrder VARCHAR(10),
	RaceWhite VARCHAR(10),
	RaceAfrAmer VARCHAR(10),
	RaceAmerInd VARCHAR(10),
	RaceAsian VARCHAR(10),
	RaceOther VARCHAR(10),
	RaceHispanic VARCHAR(10),
	BreastFeedOnly VARCHAR(10),
	MilkFeedOnly VARCHAR(10),
	SoyFeedOnly VARCHAR(10),
	BreastMilkFeed VARCHAR(10),
	BreastSoyFeed VARCHAR(10),
	TPN VARCHAR(10),
	NotFed VARCHAR(10),
	GestationAge VARCHAR(10),
	Meconiumileus VARCHAR(10),
	NICU VARCHAR(10),
	Antibiotic VARCHAR(10),
	BloodTransfusion VARCHAR(10),
	TrasfusionDate VARCHAR(10),
	BirthHospitalFacility VARCHAR(50),
	BirthHospitalFirstName VARCHAR(40),
	BirthHospitalLastName VARCHAR(10),
	BirthHospitalCode VARCHAR(10),
	BirthHospitalNotGiven VARCHAR(10),
	CollectionFacilityFacility VARCHAR(50),
	CollectionFacilityFirstName VARCHAR(40),
	CollectionFacilityLastName VARCHAR(10),
	CollectionFacilityCode VARCHAR(10),
	CollectionFacilityNotGiven VARCHAR(10),
	ReportToFacility VARCHAR(40),
	ReportToFirstName VARCHAR(30),
	ReportToLastName VARCHAR(20),
	ReportToCode VARCHAR(20),
	ReportToNotGiven VARCHAR(10),
	ReportToAddress VARCHAR(40),
	ReportToCity VARCHAR(40),
	ReportToState VARCHAR(10),
	ReportToZip VARCHAR(10),
	MotherLastName VARCHAR(20),
	MotherFirstName VARCHAR(20),
	MotherDOB DATE,
	MotherMaidenName VARCHAR(10),
	MotherAddress VARCHAR(30),
	MotherCity VARCHAR(30),
	MotherState VARCHAR(5),
	MotherZip VARCHAR(10),
	Phone VARCHAR(10),
	EmergencyPhone VARCHAR(10),
	FatherName VARCHAR(30),
	FatherPhone VARCHAR(10),
	TestName VARCHAR(10),
	TestResultNumber VARCHAR(10),
	TestResultPlainValue VARCHAR(10),
	TestResultTextValue VARCHAR(10),
	MeasuredTime VARCHAR(10),
	AcceptedTime VARCHAR(10),
	TestPhase VARCHAR(10),
	TestStatus VARCHAR(10),
	ResultName VARCHAR(10),
	ResultLevel VARCHAR(10),

--	accession_number VARCHAR(15),	--Accession Number
--	kit_number VARCHAR(15),	--Kit Number
--	patient_id VARCHAR(30),	--Patient ID VARCHAR(15)
--	last_name VARCHAR(50),	--Last Name VARCHAR(15)
--	first_name VARCHAR(50),	--First Name VARCHAR(15)	-- MALE, FEMALE????
--	maiden_name VARCHAR(50),	--Maiden Name VARCHAR		-- All NULL in initial set
--	birth_date DATE,	--Birth Date DATE
--	place_of_birth VARCHAR(50),	--Place of birth VARCHAR		-- All NULL in initial set
--	address VARCHAR(50),	--Address 1 VARCHAR
--	city VARCHAR(50),	--City VARCHAR
--	state VARCHAR(50),	--State VARCHAR
--	zip_code VARCHAR(15),	--Zip Code VARCHAR
--	phone_1 VARCHAR(15),	--Phone no. 1 VARCHAR
--	phone_2 VARCHAR(15),	--Phone no. 2 VARCHAR
--	location VARCHAR(50),	--Location VARCHAR		-- (2/3='Default location',1/3=NULL)
--	entry_mode VARCHAR(50),	--Entry Mode VARCHAR (2/3='Reported',1/3 NULL, 3 are 'Linking')
--	rank VARCHAR(50),	--Rank VARCHAR			-- All NULL in initial set
--	mom_surname VARCHAR(50),	--Mother's surname VARCHAR
--	mom_first_name VARCHAR(50),	--Mother's first name VARCHAR
--	mom_maiden_name VARCHAR(50),	--Mother's maiden name VARCHAR
--	mom_birth_date DATE,	--Mother's date of birth DATE
--	contact_facility VARCHAR(75),	--Contact facility VARCHAR
--	contact_address VARCHAR(50),	--Contact Address 1 VARCHAR
--	birth_weight VARCHAR(10),	-- Weight Birth (looks like grams)	-- 2/3 NULL in initial set

	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT health_lab_new_newborn_screening_specimens_buffer_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT health_lab_new_newborn_screening_specimens_buffer_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL,
);
GO





IF OBJECT_ID ( 'health_lab_new.bulk_insert_newborn_screening_specimens', 'V' ) IS NOT NULL
	DROP VIEW health_lab_new.bulk_insert_newborn_screening_specimens;
GO
CREATE VIEW health_lab_new.bulk_insert_newborn_screening_specimens AS SELECT
	SpecimenID,
	AccessionNumber,
	KitNumber,
	OrigKitNumber,
	TimeReceived,
	Unsat1,
	Unsat2,
	ParentRefused,
	Adopted,
	Deceased,
	DeceasedDate,
	ConsentGiven,
	BabyLast,
	BabyFirst,
	BirthDate,
	BirthDateNotGiven,
	BirthTime,
	BirthTimeNotGiven,
	BirthWeight,
	CollectionDate,
	CollectionDateNotGiven,
	CollectionTime,
	CollectionTimeNotGiven,
	CurrentWeight,
	BabySex,
	CollectedBy,
	CollectionAge,
	MedicalRecord,
	BirthType,
	BirthOrder,
	RaceWhite,
	RaceAfrAmer,
	RaceAmerInd,
	RaceAsian,
	RaceOther,
	RaceHispanic,
	BreastFeedOnly,
	MilkFeedOnly,
	SoyFeedOnly,
	BreastMilkFeed,
	BreastSoyFeed,
	TPN,
	NotFed,
	GestationAge,
	Meconiumileus,
	NICU,
	Antibiotic,
	BloodTransfusion,
	TrasfusionDate,
	BirthHospitalFacility,
	BirthHospitalFirstName,
	BirthHospitalLastName,
	BirthHospitalCode,
	BirthHospitalNotGiven,
	CollectionFacilityFacility,
	CollectionFacilityFirstName,
	CollectionFacilityLastName,
	CollectionFacilityCode,
	CollectionFacilityNotGiven,
	ReportToFacility,
	ReportToFirstName,
	ReportToLastName,
	ReportToCode,
	ReportToNotGiven,
	ReportToAddress,
	ReportToCity,
	ReportToState,
	ReportToZip,
	MotherLastName,
	MotherFirstName,
	MotherDOB,
	MotherMaidenName,
	MotherAddress,
	MotherCity,
	MotherState,
	MotherZip,
	Phone,
	EmergencyPhone,
	FatherName,
	FatherPhone,
	TestName,
	TestResultNumber,
	TestResultPlainValue,
	TestResultTextValue,
	MeasuredTime,
	AcceptedTime,
	TestPhase,
	TestStatus,
	ResultName,
	ResultLevel
FROM health_lab_new.newborn_screening_specimens_buffer;
GO






IF OBJECT_ID('health_lab_new.newborn_screening_results_buffer', 'U') IS NOT NULL
	DROP TABLE health_lab_new.newborn_screening_results_buffer;
CREATE TABLE health_lab_new.newborn_screening_results_buffer (
--	id INT IDENTITY(1,1),
--	CONSTRAINT health_lab_new_newborn_screening_results_id PRIMARY KEY CLUSTERED (id ASC),
--	AccessionNumber,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel

	AccessionNumber VARCHAR(255),
	TestName VARCHAR(255),
	TestResultNumber VARCHAR(255),
	TestResultPlainValue VARCHAR(255),
	TestResultTextValue VARCHAR(255),
	MeasuredTime DATETIME,
	AcceptedTime DATETIME,
	TestPhase VARCHAR(255),
	TestStatus VARCHAR(255),
	ResultName VARCHAR(255),
	ResultLevel VARCHAR(255),

	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT health_lab_new_newborn_screening_results_buffer_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT health_lab_new_newborn_screening_results_buffer_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL,
);
GO

IF OBJECT_ID ( 'health_lab_new.bulk_insert_newborn_screening_results', 'V' ) IS NOT NULL
	DROP VIEW health_lab_new.bulk_insert_newborn_screening_results;
GO
CREATE VIEW health_lab_new.bulk_insert_newborn_screening_results AS SELECT
	AccessionNumber,
	TestName,
	TestResultNumber,
	TestResultPlainValue,
	TestResultTextValue,
	MeasuredTime,
	AcceptedTime,
	TestPhase,
	TestStatus,
	ResultName,
	ResultLevel
FROM health_lab_new.newborn_screening_results_buffer;
GO




--	
--	PRAMS_RESULTS_2017_3.csv
--	AccessionNumber,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel
--	xxxxxx,LEU,1,205.935,206,2017-02-28 09:39:29,2017-03-02 08:31:00,Repeat,Posted,LEU-C-00-Normal,Normal
--	xxxxxx,MET,1,21.324999999999999,21,2017-02-28 09:39:29,2017-03-02 08:31:00,Repeat,Posted,MET-C-00-Normal,Normal
--	
--	
--	PRAMS_SPECIMENS_2017_3.csv
--	SpecimenID,AccessionNumber,KitNumber,OrigKitNumber,TimeReceived,Unsat1,Unsat2,ParentRefused,Adopted,Deceased,DeceasedDate,ConsentGiven,BabyLast,BabyFirst,BirthDate,BirthDateNotGiven,BirthTime,BirthTimeNotGiven,BirthWeight,CollectionDate,CollectionDateNotGiven,CollectionTime,CollectionTimeNotGiven,CurrentWeight,BabySex,CollectedBy,CollectionAge,MedicalRecord,BirthType,BirthOrder,RaceWhite,RaceAfrAmer,RaceAmerInd,RaceAsian,RaceOther,RaceHispanic,BreastFeedOnly,MilkFeedOnly,SoyFeedOnly,BreastMilkFeed,BreastSoyFeed,TPN,NotFed,GestationAge,Meconiumileus,NICU,Antibiotic,BloodTransfusion,TrasfusionDate,BirthHospitalFacility,BirthHospitalFirstName,BirthHospitalLastName,BirthHospitalCode,BirthHospitalNotGiven,CollectionFacilityFacility,CollectionFacilityFirstName,CollectionFacilityLastName,CollectionFacilityCode,CollectionFacilityNotGiven,ReportToFacility,ReportToFirstName,ReportToLastName,ReportToCode,ReportToNotGiven,ReportToAddress,ReportToCity,ReportToState,ReportToZip,MotherLastName,MotherFirstName,MotherDOB,MotherMaidenName,MotherAddress,MotherCity,MotherState,MotherZip,Phone,EmergencyPhone,FatherName,FatherPhone,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel
--	XXX,XXX,XXX,,2017-03-01 00:00:00,,,,,,,Unkown,XXX,XXX,2015-10-25 00:00:00,False,04:09:00,False,5lbs 12oz,2017-02-26 00:00:00,False,07:30:00,False,19lbs 0oz,Female,XXX XXX,11763,,Single,,True,,,,,Unkown,,True,,,,,,,Unkown,Unkown,Unkown,Unkown,,NV EARLY INTERVENTION SERVICES-LAS VEGAS,,,NV7080,False,NV EARLY INTERVENTION SERVICES-LAS VEGAS,,,NV7080,False,NV EARLY INTERVENTION SERVICES-LAS VEGAS,,,NV7080,False,XXX XXX XXX XXX,XXX XXX,NV,XXX,XXX,XXX,1990-09-19 00:00:00,XXX,XXX XXX XXX,XXX XXX,NV,XXX,XXX,XXX,XXX XXX,XXX,,,,,,,,,,
--	XXX,XXX,XXX,,2017-03-01 00:00:00,,,,,,,Unkown,XXX,XXX,2017-02-25 00:00:00,False,09:32:00,False,3546 grams,2017-02-27 00:00:00,False,04:23:00,False,3348 grams,Male,206400,43,174528,Single,,,,,,True,No,True,,,,,,,,No,No,No,No,,BANNER CHURCHILL COMM HOSP INC,,,NV6009,False,BANNER CHURCHILL COMM HOSP INC,,,NV6009,False,XXX XXX, XXX,XXX,XXX,NV1774,False,XXX XXX XXX,XXX,XXX,XXX,XXX,XXX,1991-07-30 00:00:00,,XXX XXX XXX,XXX,NV,XXX,XXX,XXX,XXX XXX,,,,,,,,,,,
--	
--	
--	









IF OBJECT_ID ( 'bin.import_newborn_screening_specimens', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_newborn_screening_specimens;
GO
CREATE PROCEDURE bin.import_newborn_screening_specimens( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

/*
	-- Something in the following section of code mucks up github syntax highlighting.
	-- Using CHAR(92) instead of a \ which mucks up syntax highlighting as it "escapes" the closing quote
	-- DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
	--  ISNULL(NULLIF(CHARINDEX('\', @rf )-1,-1),LEN(@rf))))
	-- '  The previous line mucks up syntax highlighting by escaping the quote, so added one here.
*/
	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT health_lab_new.bulk_insert_newborn_screening_specimens ' +
		'FROM ''' + @file_with_path + ''' WITH ( FIELDTERMINATOR = '','', ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 2, TABLOCK )';

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'health_lab_new.newborn_screening_specimens_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'health_lab_new.newborn_screening_specimens_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE health_lab_new.newborn_screening_specimens_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE health_lab_new.newborn_screening_specimens_buffer
		DROP CONSTRAINT temp_source_filename;

END	--	bin.import_newborn_screening_specimens
GO


IF OBJECT_ID ( 'bin.import_newborn_screening_results', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_newborn_screening_results;
GO
CREATE PROCEDURE bin.import_newborn_screening_results( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

/*
	-- Something in the following section of code mucks up github syntax highlighting.
	-- Using CHAR(92) instead of a \ which mucks up syntax highlighting as it "escapes" the closing quote
	-- DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
	--  ISNULL(NULLIF(CHARINDEX('\', @rf )-1,-1),LEN(@rf))))
	-- '  The previous line mucks up syntax highlighting by escaping the quote, so added one here.
*/
	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT health_lab_new.bulk_insert_newborn_screening_results ' +
		'FROM ''' + @file_with_path + ''' WITH ( FIELDTERMINATOR = ''|'', ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 2, TABLOCK )';

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'health_lab_new.newborn_screening_specimens_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'health_lab_new.newborn_screening_specimens_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE health_lab_new.newborn_screening_specimens_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE health_lab_new.newborn_screening_specimens_buffer
		DROP CONSTRAINT temp_source_filename;

END	--	bin.import_newborn_screening_results
GO



