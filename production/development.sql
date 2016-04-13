
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='dev')
	EXEC('CREATE SCHEMA dev')
GO


IF OBJECT_ID('dev.debug_log', 'U') IS NOT NULL
	DROP TABLE dev.debug_log;
CREATE TABLE dev.debug_log ( message text, logged_at DATETIME DEFAULT CURRENT_TIMESTAMP );
GO
IF OBJECT_ID ( 'dev.log', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.log;
GO
CREATE PROCEDURE dev.log(@msg TEXT)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dev.debug_log ( message )
	VALUES ( @msg );
END
GO


IF OBJECT_ID('dev.names', 'U') IS NOT NULL
	DROP TABLE dev.names;
CREATE TABLE dev.names ( name VARCHAR(255), type VARCHAR(255) );


IF OBJECT_ID ( 'dev.newid_view', 'V' ) IS NOT NULL
	DROP VIEW dev.newid_view;
GO
CREATE VIEW dev.newid_view AS SELECT NEWID() AS number
GO
--uniqueidentifier


IF OBJECT_ID ( 'dev.random_newid', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_newid;
GO
CREATE FUNCTION dev.random_newid()
	RETURNS uniqueidentifier
BEGIN
	RETURN ( SELECT number FROM dev.newid_view )
--Invalid use of a side-effecting operator 'newid' within a function.
--	RETURN ( SELECT NEWID() )
END
GO


IF OBJECT_ID ( 'dev.random_varchar', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_varchar;
GO
CREATE FUNCTION dev.random_varchar()
	RETURNS VARCHAR(255)
BEGIN
	RETURN ( CAST( dev.random_newid() AS VARCHAR(255) ) )
--Invalid use of a side-effecting operator 'newid' within a function.
--	RETURN ( CAST( NEWID() AS VARCHAR(255) ) )
END
GO


IF OBJECT_ID ( 'dev.random_name', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_name;
GO
CREATE FUNCTION dev.random_name( @type VARCHAR(255) )
	RETURNS VARCHAR(255)
BEGIN
	RETURN ( SELECT TOP 1 name FROM dev.names 
		WHERE type = @type 
		ORDER BY ( dev.random_newid() ) )
--Invalid use of a side-effecting operator 'newid' within a function.
--		ORDER BY NEWID() )
--		ORDER BY ( SELECT number FROM dev.newid_view ) )
END
GO


IF OBJECT_ID ( 'dev.random_female_name', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_female_name;
GO
CREATE FUNCTION dev.random_female_name()
	RETURNS VARCHAR(255)
BEGIN
	RETURN dev.random_name('female')
END
GO


IF OBJECT_ID ( 'dev.random_male_name', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_male_name;
GO
CREATE FUNCTION dev.random_male_name()
	RETURNS VARCHAR(255)
BEGIN
	RETURN dev.random_name('male')
END
GO


IF OBJECT_ID ( 'dev.random_last_name', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_last_name;
GO
CREATE FUNCTION dev.random_last_name()
	RETURNS VARCHAR(255)
BEGIN
	RETURN dev.random_name('last')
END
GO


--Can't use RAND() in function. This is a workaround.
--http://blog.sqlauthority.com/2012/11/20/sql-server-using-rand-in-user-defined-functions-udf/
IF OBJECT_ID ( 'dev.rand_view', 'V' ) IS NOT NULL
	DROP VIEW dev.rand_view;
GO
CREATE VIEW dev.rand_view AS SELECT RAND() AS number
GO


IF OBJECT_ID ( 'dev.random_sex', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_sex;
GO
CREATE FUNCTION dev.random_sex()
	RETURNS VARCHAR(1)
BEGIN
	--some languages are so complicated!
	--['M','F'][random(2)]
	DECLARE @sexes TABLE ( id INT, sex VARCHAR(1) )
	INSERT INTO @sexes VALUES (1,'M'),(2,'F')
	DECLARE @rand DECIMAL(18,18)
	SELECT @rand = number FROM dev.rand_view
	DECLARE @sex VARCHAR(1)
	SELECT @sex = sex FROM @sexes WHERE id = CAST(2*@rand AS INT)+1;
	RETURN @sex
END
GO


IF OBJECT_ID ( 'dev.random_date_in', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_date_in;
GO
CREATE FUNCTION dev.random_date_in(
	@from_date DATE = '2010-01-01', 
	@to_date   DATE = '2015-12-31' )
	RETURNS DATE
BEGIN
	DECLARE @rand DECIMAL(18,18)
	SELECT @rand = number FROM dev.rand_view
	RETURN DATEADD(day, 
		@rand*(1+DATEDIFF(DAY, @from_date, @to_date)), 
		@from_date)
END
GO
--NEED to pass 2 params. (default,default) uses the defaults. Duh!


--Create a different function that takes no params
--and have it call the other function with params
IF OBJECT_ID ( 'dev.random_date', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_date;
GO
CREATE FUNCTION dev.random_date()
	RETURNS DATE
BEGIN
	RETURN dev.random_date_in(default,default);
END
GO


IF OBJECT_ID ( 'dev.random_weight', 'FN' ) IS NOT NULL
  DROP FUNCTION dev.random_weight;
GO
CREATE FUNCTION dev.random_weight() -- pounds
  RETURNS FLOAT
BEGIN
	DECLARE @rand DECIMAL(18,18)
	SELECT @rand = number FROM dev.rand_view
  RETURN (SELECT @rand*20 + 5)
END
GO


IF OBJECT_ID ( 'dev.random_height', 'FN' ) IS NOT NULL
  DROP FUNCTION dev.random_height;
GO
CREATE FUNCTION dev.random_height()	-- inches
  RETURNS FLOAT
BEGIN
	DECLARE @rand DECIMAL(18,18)
	SELECT @rand = number FROM dev.rand_view
  RETURN (SELECT @rand*20 + 20)
END
GO


IF OBJECT_ID ( 'dev.unique_vital_record_state_file_number', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.unique_vital_record_state_file_number;
GO
CREATE FUNCTION dev.unique_vital_record_state_file_number()
	RETURNS VARCHAR(11)
BEGIN
	DECLARE @temp VARCHAR(11) = '';
	WHILE(1=1)BEGIN
		SELECT @temp = CAST( CAST(( number * 1e9 ) AS INT) AS VARCHAR(11)) FROM dev.rand_view 
		IF(NOT EXISTS (SELECT * FROM vital_records.birth WHERE state_file_number=@temp)) BREAK
	END
	RETURN @temp;
END
GO




IF OBJECT_ID ( 'dev.create_random_vital_records', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.create_random_vital_records;
GO
CREATE PROCEDURE dev.create_random_vital_records( @total INT = 1000 )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @count INT = 0

	WHILE @count < @total
	BEGIN
		SET @count = @count + 1;
		DECLARE @sex VARCHAR(1) = dev.random_sex()
		DECLARE @name_first VARCHAR(255)
		IF @sex = 'M'
			SET @name_first = dev.random_male_name()
		ELSE
			SET @name_first = dev.random_female_name()
		INSERT INTO vital_records.birth 
			( birthid, state_file_number, date_of_birth, sex, 
				name_first, name_last,
				birth_weight_lbs, birth_weight_oz )
			VALUES 
--			( @count, CAST(RAND()*1e9 AS INT), 
			( @count, dev.unique_vital_record_state_file_number(),
				dev.random_date(), @sex,
				@name_first, dev.random_last_name(),
				CAST(RAND()*5 AS INT)+5,
				CAST(RAND()*16 AS INT) 
			);
	END

--	SET @count = 0;
--	WHILE @count < 100
--	BEGIN
--		SET @count = @count + 1;
--		INSERT INTO vital_records.death ( deathid, state_file_number )
--			VALUES ( @count, CAST(RAND()*1e9 AS INT) );
--	END

	-- Multiple matching renown records will only be linked to the first birth record.

--	INSERT INTO birth ( number, dob, last_name, sex )
--		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-5', 'Wendt', 'M' );
--	INSERT INTO renowns ( number, dob, last_name, sex )
--		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-5', 'Wendt', 'm' );
--	INSERT INTO renowns ( number, dob, last_name, sex )
--		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-4', 'Wendt', 'm' );
--	INSERT INTO renowns ( number, dob, last_name, sex )
--		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-5', 'Wend', 'm' );
--	INSERT INTO renowns ( number, dob, last_name, sex )
--		VALUES ( CAST(RAND()*1e18 AS BIGINT), '1971-12-5', 'Wendt', 'f' );

END
GO


IF OBJECT_ID ( 'dev.create_FAKE_newborn_screening_for_each_birth_record', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.create_FAKE_newborn_screening_for_each_birth_record;
GO
CREATE PROCEDURE dev.create_FAKE_newborn_screening_for_each_birth_record
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO health_lab.newborn_screening
		( name_first, name_last, date_of_birth, sex, 
			testresults1, testresults2, testresults3, testresults4, testresults5 )
		SELECT name_first, name_last, date_of_birth, sex,
			dev.random_varchar(),
			dev.random_varchar(),
			dev.random_varchar(),
			dev.random_varchar(),
			dev.random_varchar()
		FROM vital_records.birth
END
GO


IF OBJECT_ID ( 'dev.link_FAKE_newborn_screening_to_births', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.link_FAKE_newborn_screening_to_births;
GO
CREATE PROCEDURE dev.link_FAKE_newborn_screening_to_births
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @count INT;
	DECLARE @cid INT;
	DECLARE @nid INT;
	DECLARE @nlname VARCHAR(255);
	DECLARE @nfname VARCHAR(255);
	DECLARE @nsex VARCHAR(1);
	DECLARE @ndob DATE;

	--	Only those record without a matching private.identifier record.
	DECLARE unlinked_newborn_screening CURSOR FOR SELECT n.id,name_first,name_last,date_of_birth,sex
		FROM health_lab.newborn_screening n
		LEFT JOIN private.identifiers i
		ON    i.source_id     = n.id 
			AND i.source_column = 'id'
			AND i.source_table  = 'newborn_screening'
			AND i.source_schema = 'health_lab'
		WHERE i.id IS NULL;	-- NULL meaning there isn't one!

	OPEN unlinked_newborn_screening;
	WHILE(1=1)BEGIN
		FETCH NEXT FROM unlinked_newborn_screening INTO @nid, @nfname, @nlname, @ndob, @nsex
		IF(@@FETCH_STATUS <> 0) BREAK

		SET @cid = NULL;	--	this will remember the last loop?
		SELECT @count = COUNT(chirp_id)
			FROM private.identifiers i JOIN vital_records.birth b
			ON    i.source_id     = b.state_file_number
				AND i.source_column = 'state_file_number' 
				AND i.source_table  = 'birth' 
				AND i.source_schema = 'vital_records' 
			WHERE b.name_last = @nlname
				AND b.name_first = @nfname
				AND b.date_of_birth = @ndob
				AND b.sex = @nsex;

--	What if there are multiple matches?
-- @cid would be assigned the LAST chirp_id

		IF( @count = 1 ) BEGIN
			SELECT @cid = chirp_id
				FROM private.identifiers i JOIN vital_records.birth b
				ON    i.source_id     = b.state_file_number
					AND i.source_column = 'state_file_number' 
					AND i.source_table  = 'birth' 
					AND i.source_schema = 'vital_records' 
				WHERE b.name_last = @nlname
					AND b.name_first = @nfname
					AND b.date_of_birth = @ndob
					AND b.sex = @nsex;
			IF ( @cid IS NOT NULL )	-- definitely shouldn't be after counting first
				INSERT INTO private.identifiers 
					( chirp_id, source_schema, source_table, source_column, source_id )
					VALUES ( @cid, 'health_lab', 'newborn_screening', 'id', @nid );
		END ELSE IF( @count >= 2 ) BEGIN
			PRINT 'Found multiple birth record matches!?'
			PRINT @nid
			PRINT @nfname
			PRINT @nlname
			PRINT @ndob
			PRINT @nsex
		END

	END

	CLOSE unlinked_newborn_screening;
	DEALLOCATE unlinked_newborn_screening;
END
GO






/*
--Creating a parameterized unique field function seems challenging
IF OBJECT_ID ( 'dev.unique_id_procedure', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.unique_id_procedure;
GO
-- apparently can't do this
--	@minid INT = 1e9,
--	@maxid INT = POWER(2.,31)-1,
-- INSERT EXEC not allowed in function
-- Invalid use of a side-effecting operator 'INSERT EXEC' within a function.
CREATE PROCEDURE dev.unique_id_procedure(
	@minid INT = 1000000000,
	@maxid INT = 2000000000,
	@table VARCHAR(255) = 'private.identifiers',
	@field VARCHAR(255) = 'chirp_id',
	@unique_id INT OUTPUT )
AS
BEGIN
	DECLARE @tempid INT = 0;
	DECLARE @rand DECIMAL(18,18);
	DECLARE @count INT;
	DECLARE @CountResults TABLE (CountReturned INT);

	WHILE(1=1)BEGIN

		SELECT @rand = number FROM dev.rand_view
		-- By using a min of 1e9, no need for leading zeroes.
		SET @tempid = CAST(
			(@minid + (@rand * (@maxid-@minid)))
			AS INTEGER);

		INSERT @CountResults EXEC('SELECT COUNT(*) FROM ' + @table + ' WHERE ' + @field + ' = ' + @tempid)
		SELECT @count = CountReturned FROM @CountResults
		DELETE FROM @CountResults

		IF( @tempid <> 0 AND @count = 0 ) BREAK;
	END

	SET @unique_id = @tempid
END
GO
*/

/*
Only functions and some extended stored procedures can be executed from within a function.
IF OBJECT_ID ( 'dev.unique_id', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.unique_id;
GO
-- apparently can't do this
--	@minid INT = 1e9,
--	@maxid INT = POWER(2.,31)-1,
-- INSERT EXEC not allowed in function
-- Invalid use of a side-effecting operator 'INSERT EXEC' within a function.
CREATE FUNCTION dev.unique_id(
	@minid INT = 1000000000,
	@maxid INT = 2000000000,
	@table VARCHAR(255) = 'private.identifiers',
	@field VARCHAR(255) = 'chirp_id' )
	RETURNS INT
BEGIN
	DECLARE @tempid INT = 0;
	EXEC dev.unique_id_procedure default, default, default, default, @tempid OUTPUT
	RETURN @tempid
END
GO
*/






/*
IF OBJECT_ID ( 'dev.unique_fakedoc1_record_number', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.unique_fakedoc1_record_number;
GO
CREATE FUNCTION dev.unique_fakedoc1_record_number()
	RETURNS INT
BEGIN
	DECLARE @minid INT = 1e9;
	DECLARE @maxid INT = POWER(2.,31)-1;
	DECLARE @tempid INT = 0;
	DECLARE @rand DECIMAL(18,18)

	WHILE ((@tempid = 0) OR
		EXISTS (SELECT * FROM fakedoc1.emrs WHERE record_number=@tempid))
	BEGIN
		SELECT @rand = number FROM dev.rand_view
		-- By using a min of 1e9, no need for leading zeroes.
		SET @tempid = CAST(
			(@minid + (@rand * (@maxid-@minid)))
			AS INTEGER);
	END

	RETURN @tempid
END
GO
*/

IF OBJECT_ID ( 'dev.unique_fakedoc1_record_number', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.unique_fakedoc1_record_number;
GO
CREATE FUNCTION dev.unique_fakedoc1_record_number()
	RETURNS VARCHAR(255)
BEGIN
	DECLARE @temp VARCHAR(255) = '';
	WHILE(1=1)BEGIN
		SELECT @temp = CAST(number AS VARCHAR(255)) FROM dev.newid_view 
		IF(NOT EXISTS (SELECT * FROM fakedoc1.emrs WHERE record_number=@temp)) BREAK
	END
	RETURN @temp;
END
GO


IF OBJECT_ID ( 'dev.create_FAKE_fakedoc1_emrs', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.create_FAKE_fakedoc1_emrs;
GO
CREATE PROCEDURE dev.create_FAKE_fakedoc1_emrs
AS
BEGIN
	SET NOCOUNT ON;

	--This creates 2 for each birth record

	INSERT INTO fakedoc1.emrs
		( record_number, name_first, name_last, date_of_birth, sex, code, value, service_at )
		SELECT
			record_number, name_first, name_last, date_of_birth, sex, code, value, service_at
		FROM (
			SELECT 
				dev.unique_fakedoc1_record_number() as record_number,
				name_first, name_last, date_of_birth, sex,
				CAST(dev.random_weight() AS VARCHAR(255)) AS [DEM:Weight],
				CAST(dev.random_height() AS VARCHAR(255)) AS [DEM:Height],
				dev.random_date() AS service_at
			FROM vital_records.birth
		) ignored1
		UNPIVOT (
			value FOR code IN ( [DEM:Height], [DEM:Weight] )
		) AS ignored2

	--This creates 2 for each emr record
	--Should be 6 emrs in total for each birth record now!

	INSERT INTO fakedoc1.emrs
		( record_number, name_first, name_last, date_of_birth, sex, code, value, service_at )
		SELECT
			record_number, name_first, name_last, date_of_birth, sex, code, value, service_at
		FROM (
			SELECT 
				record_number,
				name_first, name_last, date_of_birth, sex,
				CAST(dev.random_weight() AS VARCHAR(255)) AS [DEM:Weight],
				CAST(dev.random_height() AS VARCHAR(255)) AS [DEM:Height],
				dev.random_date() AS service_at
			FROM fakedoc1.emrs
		) ignored1
		UNPIVOT (
			value FOR code IN ( [DEM:Height], [DEM:Weight] )
		) AS ignored2


-- SELECT TOP 10 PERCENT *
--  FROM dev.names
--  ORDER BY NEWID()


END
GO


IF OBJECT_ID ( 'dev.link_FAKE_fakedoc1_emrs_to_births', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.link_FAKE_fakedoc1_emrs_to_births;
GO
CREATE PROCEDURE dev.link_FAKE_fakedoc1_emrs_to_births
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @count INT;
	DECLARE @cid INT;
	DECLARE @nrecord VARCHAR(255);
	DECLARE @nlname VARCHAR(255);
	DECLARE @nfname VARCHAR(255);
	DECLARE @nsex VARCHAR(1);
	DECLARE @ndob DATE;

	--	Only those record without a matching private.identifier record.
	DECLARE unlinked_fakedoc1_emrs CURSOR FOR SELECT n.record_number,name_first,name_last,date_of_birth,sex
		FROM fakedoc1.emrs n
		LEFT JOIN private.identifiers i
		ON    i.source_id     = n.record_number 
			AND i.source_column = 'record_number'
			AND i.source_table  = 'emrs'
			AND i.source_schema = 'fakedoc1'
		WHERE i.id IS NULL;	-- NULL meaning there isn't one!

	OPEN unlinked_fakedoc1_emrs;
	WHILE(1=1)BEGIN
		FETCH NEXT FROM unlinked_fakedoc1_emrs INTO @nrecord, @nfname, @nlname, @ndob, @nsex
		IF(@@FETCH_STATUS <> 0) BREAK

		SET @cid = NULL;	--	this will remember the last loop?
		SELECT @count = COUNT(chirp_id)
			FROM private.identifiers i JOIN vital_records.birth b
			ON    i.source_id     = b.state_file_number
				AND i.source_column = 'state_file_number' 
				AND i.source_table  = 'birth' 
				AND i.source_schema = 'vital_records' 
			WHERE b.name_last = @nlname
				AND b.name_first = @nfname
				AND b.date_of_birth = @ndob
				AND b.sex = @nsex;

--	What if there are multiple matches?
-- @cid would be assigned the LAST chirp_id

		IF( @count = 1 ) BEGIN
			SELECT @cid = chirp_id
				FROM private.identifiers i JOIN vital_records.birth b
				ON    i.source_id     = b.state_file_number
					AND i.source_column = 'state_file_number' 
					AND i.source_table  = 'birth' 
					AND i.source_schema = 'vital_records' 
				WHERE b.name_last = @nlname
					AND b.name_first = @nfname
					AND b.date_of_birth = @ndob
					AND b.sex = @nsex;
			IF ( @cid IS NOT NULL )	-- definitely shouldn't be after counting first
			BEGIN
				--	Check just in case as will be multiple records
				IF( NOT EXISTS( SELECT * FROM private.identifiers 
					WHERE source_schema = 'fakedoc1'
						AND source_table  = 'emrs'
						AND source_column = 'record_number'
						AND source_id = @nrecord ) )
					INSERT INTO private.identifiers 
						( chirp_id, source_schema, source_table, source_column, source_id )
						VALUES ( @cid, 'fakedoc1', 'emrs', 'record_number', @nrecord );
			END
		END ELSE IF( @count >= 2 ) BEGIN
			PRINT 'Found multiple birth record matches!?'
			PRINT @nrecord
			PRINT @nfname
			PRINT @nlname
			PRINT @ndob
			PRINT @nsex
		END

	END

	CLOSE unlinked_fakedoc1_emrs;
	DEALLOCATE unlinked_fakedoc1_emrs;
END
GO




