
--SET NOEXEC OFF

--IF db_id('chirp') IS NOT NULL
--	DROP DATABASE chirp;

--CREATE DATABASE chirp;
--USE chirp;

--Wanted to see these Database Diagrams and this seemed to work.
ALTER AUTHORIZATION ON DATABASE::chirp TO [sa];






--SET NOEXEC ON
-- NOTHING ELSE SHOULD EXECUTE
--That does not work as advertised. Only works to next "GO"


--Ways to not execute the rest of a script.
--
--SET NOEXEC ON (code still gets parsed so could get weird.)
--	OR
--GOTO STATEMENT (need to define the final statement.)
--	OR
--RAISEERROR	(error can be caught, in theory.)
--
--
--GOTO FinalStateMent;
--
--FinalStatement:
--     Select @CoumnName from TableName




-- MS Sets these before every “CREATE TRIGGER”
-- Not sure if calling them once will suffice.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('debug_log', 'U') IS NOT NULL
	DROP TABLE debug_log;
CREATE TABLE debug_log ( message text, logged_at DATETIME DEFAULT CURRENT_TIMESTAMP );
GO
IF OBJECT_ID ( 'log', 'P' ) IS NOT NULL
	DROP PROCEDURE log;
GO
CREATE PROCEDURE log(@msg TEXT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO debug_log ( message )
	VALUES ( @msg );
END
GO


IF OBJECT_ID('births', 'U') IS NOT NULL
	DROP TABLE births;
CREATE TABLE births (
	id int IDENTITY(1,1) PRIMARY KEY,
	number VARCHAR(255) NOT NULL,
	birthid INT,  -- probably unique
	birth2id INT,  -- probably unique
	medicalid INT,
	hearingbid INT,
	event_year INT,
	local_file_number VARCHAR(15),  -- probably unique
	state_file_number VARCHAR(11),  -- probably unique
	local_reg_number VARCHAR(15),  -- probably unique
	dob DATE,
	first_name VARCHAR(255),
	middle_name VARCHAR(255),
	last_name VARCHAR(255),
	sex VARCHAR(1),
	imported_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- I could put these constraints in the "create table" specs, 
-- but having them here helps show how to add more later.
ALTER TABLE births
	ADD CONSTRAINT unique_births_number UNIQUE (number);

CREATE UNIQUE INDEX unique_births_birthid ON births(birthid)
	WHERE birthid IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_births_birth2id ON births(birth2id)
	WHERE birth2id IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_births_local_file_number ON births(local_file_number)
	WHERE local_file_number IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_births_state_file_number ON births(state_file_number)
	WHERE state_file_number IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_births_local_reg_number ON births(local_reg_number)
	WHERE local_reg_number IS NOT NULL;
GO


IF OBJECT_ID('birth2s', 'U') IS NOT NULL
	DROP TABLE birth2s;
CREATE TABLE birth2s (
	id int IDENTITY(1,1) PRIMARY KEY,
	birthid INT,  -- probably unique
	birth2id INT  -- probably unique
);
CREATE UNIQUE INDEX unique_birth2s_birthid ON birth2s(birthid)
	WHERE birthid IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_birth2s_birth2id ON birth2s(birth2id)
	WHERE birth2id IS NOT NULL;
GO


IF OBJECT_ID('deaths', 'U') IS NOT NULL
	DROP TABLE deaths;
CREATE TABLE deaths (
	id int IDENTITY(1,1) PRIMARY KEY,
	number VARCHAR(255) NOT NULL,
	deathid INT,  -- probably unique
	death2id INT,  -- probably unique
	event_year INT,
	state_file_number VARCHAR(11),  -- probably unique
	local_file_number VARCHAR(15),  -- probably unique
	record_status VARCHAR(30),
	reg_type_code VARCHAR(10),
	local_reg_number VARCHAR(15),  -- probably unique
	permit_number VARCHAR(15),
	dob DATE,
	first_name VARCHAR(255),
	middle_name VARCHAR(255),
	last_name VARCHAR(255),
	sex VARCHAR(1),
	imported_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX unique_deaths_deathid ON deaths(deathid)
	WHERE deathid IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_deaths_death2id ON deaths(death2id)
	WHERE death2id IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_deaths_state_file_number ON deaths(state_file_number)
	WHERE state_file_number IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_deaths_local_file_number ON deaths(local_file_number)
	WHERE local_file_number IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_deaths_local_reg_number ON deaths(local_reg_number)
	WHERE local_reg_number IS NOT NULL;
GO



IF OBJECT_ID('death2s', 'U') IS NOT NULL
	DROP TABLE death2s;
CREATE TABLE death2s (
	id int IDENTITY(1,1) PRIMARY KEY,
	deathid INT,  -- probably unique
	death2id INT  -- probably unique
);
CREATE UNIQUE INDEX unique_death2s_deathid ON death2s(deathid)
	WHERE deathid IS NOT NULL;
GO
CREATE UNIQUE INDEX unique_death2s_death2id ON death2s(death2id)
	WHERE death2id IS NOT NULL;
GO

IF OBJECT_ID('renowns', 'U') IS NOT NULL
	DROP TABLE renowns;
CREATE TABLE renowns (
	id int IDENTITY(1,1) PRIMARY KEY,
	number VARCHAR(255) NOT NULL,
	dob DATE,
	first_name VARCHAR(255),
	middle_name VARCHAR(255),
	last_name VARCHAR(255),
	sex VARCHAR(1),
	imported_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

/*

	Our chirp_id is, currently, a random integer roughly between 1 and 2 billion
	so it is 10 digits.  As it is computed as an integer, keep it as an integer?
	Or convert it to a VARCHAR(10)?

*/

IF OBJECT_ID('identifiers', 'U') IS NOT NULL
	DROP TABLE identifiers;
CREATE TABLE identifiers (
	id int IDENTITY(1,1) PRIMARY KEY,
--	chirp_id VARCHAR(255) NOT NULL,				--- WHY IS THIS VARCHAR AND NOT INT?
-- Why is it VARCHAR and not INT?
--	chirp_id VARCHAR(10) NOT NULL,				--- WHY IS THIS VARCHAR AND NOT INT?
-- If it should be VARCHAR, why 255?  Its only 10 digits?
-- VARCHAR or INT.  Both seem to work in this little demo.
	chirp_id INT NOT NULL,				--- WHY IS THIS VARCHAR AND NOT INT?
	source_name VARCHAR(255) NOT NULL,
	source_id VARCHAR(255) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE identifiers
	ADD CONSTRAINT unique_source_name_and_id UNIQUE (source_name,source_id);

GO

/*
IF OBJECT_ID ( 'identifiers_after_insert', 'TR' ) IS NOT NULL
	DROP TRIGGER identifiers_after_insert;
GO
CREATE TRIGGER identifiers_after_insert ON identifiers AFTER INSERT AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE identifiers
		SET created_at = CURRENT_TIMESTAMP
		FROM inserted i
		WHERE identifiers.id = i.id;
END

GO

IF OBJECT_ID ( 'renowns_after_insert', 'TR' ) IS NOT NULL
	DROP TRIGGER renowns_after_insert;
GO
CREATE TRIGGER renowns_after_insert ON renowns AFTER INSERT AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE renowns
		SET imported_at = CURRENT_TIMESTAMP
		FROM inserted i
		WHERE renowns.id = i.id;
END

GO

IF OBJECT_ID ( 'births_after_insert', 'TR' ) IS NOT NULL
	DROP TRIGGER births_after_insert;
GO
CREATE TRIGGER births_after_insert ON births AFTER INSERT AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE births
		SET imported_at = CURRENT_TIMESTAMP
		FROM inserted i
		WHERE births.id = i.id;
END

GO

IF OBJECT_ID ( 'deaths_after_insert', 'TR' ) IS NOT NULL
	DROP TRIGGER deaths_after_insert;
GO
CREATE TRIGGER deaths_after_insert ON deaths AFTER INSERT AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE deaths
		SET imported_at = CURRENT_TIMESTAMP
		FROM inserted i
		WHERE deaths.id = i.id;
END

*/

GO

IF OBJECT_ID ( 'births_after_insert', 'TR' ) IS NOT NULL
	DROP TRIGGER births_after_insert;
GO
CREATE TRIGGER births_after_insert ON births AFTER INSERT AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @MINID INT = 1e9;
	DECLARE @MAXID INT = POWER(2.,31)-1;
	DECLARE @TEMPID INT = 0;
	DECLARE @MSG VARCHAR(MAX);

	WHILE ((@TEMPID = 0) OR
		EXISTS (SELECT * FROM identifiers WHERE chirp_id=@TEMPID))

-- Would adding this condition speed up or slow down?
-- AND source_name = 'birth'	

	BEGIN
		SELECT @MSG = 'Setting unique CHIRP_ID for identifier id :' + 
			CAST(id AS VARCHAR(255)) FROM inserted;
		EXEC log @MSG;

		-- By using a min of 1e9, no need for leading zeroes.
		SET @TEMPID = CAST(
			(@MINID + (RAND() * (@MAXID-@MINID)))
			AS INTEGER);
--			AS VARCHAR(10) );
	END
 
	DECLARE @NUMB VARCHAR(255);
	SELECT @NUMB = b.number FROM births b
		JOIN inserted i ON i.id = b.id;

--	Why? The 'birth' value seems sufficient.
--	INSERT INTO identifiers
--		( chirp_id, source_name, source_id )
--		VALUES ( @TEMPID, 'chirp', @TEMPID );

	INSERT INTO identifiers
		( chirp_id, source_name, source_id )
		VALUES ( @TEMPID, 'birth', @NUMB );
END;

GO


IF OBJECT_ID ( 'populate', 'P' ) IS NOT NULL
	DROP PROCEDURE populate;
GO
CREATE PROCEDURE populate
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @count INT = 0;

	WHILE @count < 10
	BEGIN
		SET @count = @count + 1;
		INSERT INTO births ( number, state_file_number )
			VALUES ( CAST(RAND()*1e18 AS BIGINT), @count*4 );
	END

	SET @count = 0;
	WHILE @count < 10
	BEGIN
		SET @count = @count + 1;
		INSERT INTO deaths ( number, state_file_number )
			VALUES ( CAST(RAND()*1e18 AS BIGINT), @count*3 );
	END


	-- Multiple matching renown records will only be linked to the first birth record.

	INSERT INTO births ( number, dob, last_name, sex )
		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-5', 'Wendt', 'M' );
	INSERT INTO renowns ( number, dob, last_name, sex )
		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-5', 'Wendt', 'm' );
	INSERT INTO renowns ( number, dob, last_name, sex )
		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-4', 'Wendt', 'm' );
	INSERT INTO renowns ( number, dob, last_name, sex )
		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-5', 'Wend', 'm' );
	INSERT INTO renowns ( number, dob, last_name, sex )
		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-5', 'Wendt', 'f' );
END
GO


IF OBJECT_ID ( 'linkdeaths', 'P' ) IS NOT NULL
	DROP PROCEDURE linkdeaths;
GO
CREATE PROCEDURE linkdeaths
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
--	DECLARE @cid VARCHAR(255);	--	WHY VARCHAR AND NOT INT?
--	DECLARE @cid VARCHAR(10);	--	WHY VARCHAR AND NOT INT?
	DECLARE @cid INT;
	DECLARE @dn VARCHAR(255);
	DECLARE @ds VARCHAR(11);
	DECLARE @di INT;

	--	Only those deaths without a matching identifier record.
	DECLARE unlinked_death_record CURSOR FOR SELECT d.id,number,state_file_number
		FROM deaths d
		LEFT JOIN identifiers i
		ON i.source_id = d.number AND i.source_name = 'death'
		WHERE i.id IS NULL;
	OPEN unlinked_death_record;
	FETCH unlinked_death_record INTO @di,@dn,@ds;
	WHILE( @@FETCH_STATUS = 0 )
	BEGIN
		SET @cid = NULL;	--	this will remember the last loop?
		SELECT TOP 1 @cid = chirp_id
			FROM identifiers i JOIN births b
			ON i.source_name = 'birth' AND i.source_id = b.number
			WHERE b.state_file_number = @ds;
		IF ( @cid IS NOT NULL )
			INSERT INTO identifiers ( chirp_id, source_name, source_id )
				VALUES ( @cid, 'death', @dn );
		FETCH unlinked_death_record INTO @di,@dn,@ds;
	END
	CLOSE unlinked_death_record;
	DEALLOCATE unlinked_death_record;
END;

GO


IF OBJECT_ID ( 'linkrenowns', 'P' ) IS NOT NULL
	DROP PROCEDURE linkrenowns;
GO
CREATE PROCEDURE linkrenowns
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	DECLARE @cid VARCHAR(255);	--	WHY VARCHAR AND NOT INT?
--	DECLARE @cid VARCHAR(10);	--	WHY VARCHAR AND NOT INT?
	DECLARE @cid INT;	--	WHY VARCHAR AND NOT INT?
	DECLARE @rnum VARCHAR(255);
	DECLARE @rlname VARCHAR(255);
	DECLARE @rsex VARCHAR(1);
	DECLARE @rdob DATE;
	DECLARE @rid INT;

	--	Only those renowns without a matching identifier record.
	DECLARE unlinked_renown_record CURSOR FOR SELECT r.id,number,last_name,dob,sex
		FROM renowns r
		LEFT JOIN identifiers i
		ON i.source_id = r.number AND i.source_name = 'renown'
		WHERE i.id IS NULL;

	OPEN unlinked_renown_record;
	FETCH unlinked_renown_record INTO @rid,@rnum,@rlname,@rdob,@rsex;

-- I don't like that the FETCH command is in 2 places. Not exactly DRY.
-- Could make this a WHILE(1=1) loop, with an internal condition and BREAK.
-- Or perhaps I can squeeze the actualy fetch in the while condition?

-- WHILE( FETCH unlinked_renown_record INTO @rid,@rnum,@rlname,@rdob,@rsex && @@FETCH_STATUS = 0 )???
--WHILE(1=1)BEGIN
--   FETCH NEXT FROM abc;
--   IF(@@FETCH_STATUS <> 0)
--     BREAK
--END

	WHILE ( @@FETCH_STATUS = 0 )
	BEGIN
		SET @cid = NULL;	--	this will remember the last loop?
		SELECT @cid = chirp_id
			FROM identifiers i JOIN births b
			ON i.source_name = 'birth' AND i.source_id = b.number
			WHERE b.last_name = @rlname
				AND b.dob = @rdob
				AND b.sex = @rsex;
		-- Currently, this seems to be case insensitive.  M = m
		IF ( @cid IS NOT NULL )
			INSERT INTO identifiers ( chirp_id, source_name, source_id )
				VALUES ( @cid, 'renown', @rnum );
		FETCH unlinked_renown_record INTO @rid,@rnum,@rlname,@rdob,@rsex;
	END
	CLOSE unlinked_renown_record;
	DEALLOCATE unlinked_renown_record;
END
GO






EXEC populate;
EXEC linkdeaths;
EXEC linkdeaths;  -- should do nothing
EXEC linkrenowns;
EXEC linkrenowns; -- should do nothing

SELECT TOP 100 * FROM births;
SELECT TOP 100 * FROM deaths;
SELECT TOP 100 * FROM identifiers;
SELECT TOP 100 * FROM renowns;


-- http://www.techonthenet.com/sql_server/loops/while.php





