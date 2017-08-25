
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='health_lab')
	EXEC('CREATE SCHEMA health_lab')
GO


IF OBJECT_ID('health_lab.prams_specimens', 'U') IS NOT NULL
	DROP TABLE health_lab.prams_specimens;
CREATE TABLE health_lab.prams_specimens (
	id INT IDENTITY(1,1),
	CONSTRAINT health_lab_prams_specimens_id PRIMARY KEY CLUSTERED (id ASC),
---- SpecimenID,AccessionNumber,KitNumber,OrigKitNumber,TimeReceived,Unsat1,Unsat2,ParentRefused,Adopted,Deceased,DeceasedDate,ConsentGiven,BabyLast,BabyFirst,BirthDate,BirthDateNotGiven,BirthTime,BirthTimeNotGiven,BirthWeight,CollectionDate,CollectionDateNotGiven,CollectionTime,CollectionTimeNotGiven,CurrentWeight,BabySex,CollectedBy,CollectionAge,MedicalRecord,BirthType,BirthOrder,RaceWhite,RaceAfrAmer,RaceAmerInd,RaceAsian,RaceOther,RaceHispanic,BreastFeedOnly,MilkFeedOnly,SoyFeedOnly,BreastMilkFeed,BreastSoyFeed,TPN,NotFed,GestationAge,Meconiumileus,NICU,Antibiotic,BloodTransfusion,TrasfusionDate,BirthHospitalFacility,BirthHospitalFirstName,BirthHospitalLastName,BirthHospitalCode,BirthHospitalNotGiven,CollectionFacilityFacility,CollectionFacilityFirstName,CollectionFacilityLastName,CollectionFacilityCode,CollectionFacilityNotGiven,ReportToFacility,ReportToFirstName,ReportToLastName,ReportToCode,ReportToNotGiven,ReportToAddress,ReportToCity,ReportToState,ReportToZip,MotherLastName,MotherFirstName,MotherDOB,MotherMaidenName,MotherAddress,MotherCity,MotherState,MotherZip,Phone,EmergencyPhone,FatherName,FatherPhone,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel



--	copy the buffer structure (once complete)





	source_filename VARCHAR(255),
	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT,	--	 IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT health_lab_prams_specimens_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT health_lab_prams_specimens_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL,
);
GO






IF OBJECT_ID('health_lab.prams_specimens_buffer', 'U') IS NOT NULL
	DROP TABLE health_lab.prams_specimens_buffer;
CREATE TABLE health_lab.prams_specimens_buffer (
-- SpecimenID,AccessionNumber,KitNumber,OrigKitNumber,TimeReceived,Unsat1,Unsat2,ParentRefused,Adopted,Deceased,DeceasedDate,ConsentGiven,BabyLast,BabyFirst,BirthDate,BirthDateNotGiven,BirthTime,BirthTimeNotGiven,BirthWeight,CollectionDate,CollectionDateNotGiven,CollectionTime,CollectionTimeNotGiven,CurrentWeight,BabySex,CollectedBy,CollectionAge,MedicalRecord,BirthType,BirthOrder,RaceWhite,RaceAfrAmer,RaceAmerInd,RaceAsian,RaceOther,RaceHispanic,BreastFeedOnly,MilkFeedOnly,SoyFeedOnly,BreastMilkFeed,BreastSoyFeed,TPN,NotFed,GestationAge,Meconiumileus,NICU,Antibiotic,BloodTransfusion,TrasfusionDate,BirthHospitalFacility,BirthHospitalFirstName,BirthHospitalLastName,BirthHospitalCode,BirthHospitalNotGiven,CollectionFacilityFacility,CollectionFacilityFirstName,CollectionFacilityLastName,CollectionFacilityCode,CollectionFacilityNotGiven,ReportToFacility,ReportToFirstName,ReportToLastName,ReportToCode,ReportToNotGiven,ReportToAddress,ReportToCity,ReportToState,ReportToZip,MotherLastName,MotherFirstName,MotherDOB,MotherMaidenName,MotherAddress,MotherCity,MotherState,MotherZip,Phone,EmergencyPhone,FatherName,FatherPhone,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel

	SpecimenID INTEGER,	--	VARCHAR(10),
	AccessionNumber VARCHAR(15),
	KitNumber VARCHAR(15),
	OrigKitNumber VARCHAR(15),
	TimeReceived DATETIME,
	Unsat1 VARCHAR(60),
	Unsat2 VARCHAR(60),
	ParentRefused VARCHAR(5),
	Adopted VARCHAR(5),
	Deceased VARCHAR(5),
	DeceasedDate DATE,
	ConsentGiven VARCHAR(15),
	BabyLast VARCHAR(35),
	BabyFirst VARCHAR(30),	--	VARCHAR(10),	--	14
	BirthDate DATE,	--	or DATETIME		--	15
	BirthDateNotGiven VARCHAR(5),
	BirthTime VARCHAR(10),
	BirthTimeNotGiven VARCHAR(5),
	BirthWeight VARCHAR(15),
	CollectionDate DATE,	--	or DATETIME
	CollectionDateNotGiven VARCHAR(5),
	CollectionTime VARCHAR(10),
	CollectionTimeNotGiven VARCHAR(5),
	CurrentWeight VARCHAR(15),		--	24
	BabySex VARCHAR(10),
	CollectedBy VARCHAR(35),
	CollectionAge INTEGER,	--	VARCHAR(10),
	MedicalRecord VARCHAR(30),
	BirthType VARCHAR(10),
	BirthOrder VARCHAR(5),
	RaceWhite VARCHAR(5),
	RaceAfrAmer VARCHAR(5),
	RaceAmerInd VARCHAR(5),
	RaceAsian VARCHAR(5),	--	34
	RaceOther VARCHAR(5),
	RaceHispanic VARCHAR(10),
	BreastFeedOnly VARCHAR(10),
	MilkFeedOnly VARCHAR(10),
	SoyFeedOnly VARCHAR(10),
	BreastMilkFeed VARCHAR(10),
	BreastSoyFeed VARCHAR(10),
	TPN VARCHAR(10),
	NotFed VARCHAR(10),
	GestationAge INTEGER,	--	VARCHAR(10),			--	44
	Meconiumileus VARCHAR(10),
	NICU VARCHAR(10),
	Antibiotic VARCHAR(10),
	BloodTransfusion VARCHAR(10),
	TrasfusionDate DATE,		--	VARCHAR(10),
	BirthHospitalFacility VARCHAR(60),
	BirthHospitalFirstName VARCHAR(40),
	BirthHospitalLastName VARCHAR(20),
	BirthHospitalCode VARCHAR(10),
	BirthHospitalNotGiven VARCHAR(10),		--	54
	CollectionFacilityFacility VARCHAR(60),
	CollectionFacilityFirstName VARCHAR(40),
	CollectionFacilityLastName VARCHAR(20),
	CollectionFacilityCode VARCHAR(10),
	CollectionFacilityNotGiven VARCHAR(10),
	ReportToFacility VARCHAR(60),
	ReportToFirstName VARCHAR(30),
	ReportToLastName VARCHAR(20),
	ReportToCode VARCHAR(20),
	ReportToNotGiven VARCHAR(10),				--	64
	ReportToAddress VARCHAR(40),
	ReportToCity VARCHAR(40),
	ReportToState VARCHAR(10),
	ReportToZip VARCHAR(10),
	MotherLastName VARCHAR(30),
	MotherFirstName VARCHAR(30),
	MotherDOB DATE,	--	or DATETIME
	MotherMaidenName VARCHAR(40),
	MotherAddress VARCHAR(45),
	MotherCity VARCHAR(25),				--	74
	MotherState VARCHAR(25),
	MotherZip VARCHAR(10),
	Phone VARCHAR(10),
	EmergencyPhone VARCHAR(15),
	FatherName VARCHAR(55),
	FatherPhone VARCHAR(75),	--	can be international with comments
		--	Don't think any of the following is included here? In PRAMS_RESULTS?
	TestName VARCHAR(30),
	TestResultNumber VARCHAR(25),
	TestResultPlainValue VARCHAR(10),		---	83
	TestResultTextValue VARCHAR(10),
	MeasuredTime VARCHAR(10),
	AcceptedTime VARCHAR(10),
	TestPhase VARCHAR(10),
	TestStatus VARCHAR(10),
	ResultName VARCHAR(10),


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
		CONSTRAINT health_lab_prams_specimens_buffer_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT health_lab_prams_specimens_buffer_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL,
);
GO





IF OBJECT_ID ( 'health_lab.bulk_insert_prams_specimens', 'V' ) IS NOT NULL
	DROP VIEW health_lab.bulk_insert_prams_specimens;
GO
CREATE VIEW health_lab.bulk_insert_prams_specimens AS SELECT
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
FROM health_lab.prams_specimens_buffer;
GO






IF OBJECT_ID('health_lab.prams_results', 'U') IS NOT NULL
	DROP TABLE health_lab.prams_results;
CREATE TABLE health_lab.prams_results(
	id INT IDENTITY(1,1),
	CONSTRAINT health_lab_prams_results_id PRIMARY KEY CLUSTERED (id ASC),
--	AccessionNumber,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel

	

--	copy of buffer structure (once complete)





	source_filename VARCHAR(255),

	--	Sadly, BULK INSERT does NOT preserve file order so this is moot.
	--	If remove, remove code that RESEED ID
	--	Actually, despite saying it doesn't, it seems to preserve the order.
	source_record_number INT,	-- IDENTITY(1,1),

	imported_at DATETIME
		CONSTRAINT health_lab_prams_results_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT health_lab_prams_results_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL,
);
GO






IF OBJECT_ID('health_lab.prams_results_buffer', 'U') IS NOT NULL
	DROP TABLE health_lab.prams_results_buffer;
CREATE TABLE health_lab.prams_results_buffer (
--	id INT IDENTITY(1,1),
--	CONSTRAINT health_lab_new_newborn_screening_results_id PRIMARY KEY CLUSTERED (id ASC),
--	AccessionNumber,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel

	AccessionNumber VARCHAR(255),
	TestName VARCHAR(255),
	TestResultNumber INTEGER,	--	VARCHAR(255),
	TestResultPlainValue FLOAT,	--	VARCHAR(255),
	TestResultTextValue FLOAT,	--	VARCHAR(255),
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
		CONSTRAINT health_lab_prams_results_buffer_imported_at_default
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	imported_to_observations BIT
		CONSTRAINT health_lab_prams_results_buffer_imported_to_observations_default
		DEFAULT 'FALSE' NOT NULL,
);
GO

IF OBJECT_ID ( 'health_lab.bulk_insert_prams_results', 'V' ) IS NOT NULL
	DROP VIEW health_lab.bulk_insert_prams_results;
GO
CREATE VIEW health_lab.bulk_insert_prams_results AS SELECT
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
FROM health_lab.prams_results_buffer;
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









IF OBJECT_ID ( 'bin.import_prams_specimens', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_prams_specimens;
GO
CREATE PROCEDURE bin.import_prams_specimens( @file_with_path VARCHAR(255) )
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

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT health_lab.bulk_insert_prams_specimens ' +
		'FROM ''' + @file_with_path + ''' WITH ( FIELDTERMINATOR = ''|'', ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 1, TABLOCK )';

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'health_lab.prams_specimens_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'health_lab.prams_specimens_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE health_lab.prams_specimens_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE health_lab.prams_specimens_buffer
		DROP CONSTRAINT temp_source_filename;

END	--	bin.import_prams_specimens
GO


IF OBJECT_ID ( 'bin.import_prams_results', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_prams_results;
GO
CREATE PROCEDURE bin.import_prams_results( @file_with_path VARCHAR(255) )
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

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT health_lab.bulk_insert_prams_results ' +
		'FROM ''' + @file_with_path + ''' WITH ( FIELDTERMINATOR = ''|'', ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 1, TABLOCK )';

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'health_lab.prams_results_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'health_lab.prams_results_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE health_lab.prams_results_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE health_lab.prams_results_buffer
		DROP CONSTRAINT temp_source_filename;

END	--	bin.import_prams_results
GO



-- sed -re 's/,([^,]+, [^,]+),/,"\1",/g'
--	EXEC bin.import_newborn_screening_specimens 'C:\Users\gwendt\Desktop\Data\PRAMS\PRAMS_SPECIMENS_2017_1.csv'

