USE chirp
GO

IF OBJECT_ID ( 'dbo.create_random_vital_records', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.create_random_vital_records;
GO
CREATE PROCEDURE dbo.create_random_vital_records( @total INT = 1000 )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @count INT = 0

	WHILE @count < @total
	BEGIN
		SET @count = @count + 1;
		DECLARE @sex VARCHAR(1) = dbo.random_sex()
		DECLARE @name_first VARCHAR(255)
		IF @sex = 'M'
			SET @name_first = dbo.random_male_name()
		ELSE
			SET @name_first = dbo.random_female_name()
		INSERT INTO vital_records.birth 
			( birthid, state_file_number, date_of_birth, sex, 
				name_first, name_last,
				birth_weight_lbs, birth_weight_oz )
			VALUES 
			( @count, CAST(RAND()*1e9 AS INT), 
				dbo.random_date(), @sex,
				@name_first, dbo.random_last_name(),
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
