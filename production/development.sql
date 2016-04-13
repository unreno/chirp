
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
END
GO

IF OBJECT_ID ( 'dev.random_varchar', 'FN' ) IS NOT NULL
	DROP FUNCTION dev.random_varchar;
GO
CREATE FUNCTION dev.random_varchar()
	RETURNS VARCHAR(255)
BEGIN
	RETURN ( CAST( dev.random_newid() AS VARCHAR(255) ) )
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







IF OBJECT_ID ( 'dev.create_newborn_screening_for_each_birth_record', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.create_newborn_screening_for_each_birth_record;
GO
CREATE PROCEDURE dev.create_newborn_screening_for_each_birth_record
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
			( @count, CAST(RAND()*1e9 AS INT), 
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












IF OBJECT_ID ( 'dev.link_newborn_screening_to_births', 'P' ) IS NOT NULL
	DROP PROCEDURE dev.link_newborn_screening_to_births;
GO
CREATE PROCEDURE dev.link_newborn_screening_to_births
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
			PRINT 'Found multiple matches!?'
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

