USE chirp
GO



IF OBJECT_ID ( 'create_random_vital_records', 'P' ) IS NOT NULL
	DROP PROCEDURE create_random_vital_records;
GO
CREATE PROCEDURE create_random_vital_records
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @count INT = 0
	DECLARE @random_date DATE
	DECLARE @sexes TABLE ( id INT IDENTITY(1,1), sex VARCHAR(1) )
	INSERT INTO @sexes VALUES ('M'),('F')
	DECLARE @sex VARCHAR(1)

	WHILE @count < 1000
	BEGIN
		SET @count = @count + 1;
		EXEC create_a_random_date @random_date OUTPUT
		SELECT @sex = sex FROM @sexes WHERE id = CAST(2*rand() AS INT)+1;
		INSERT INTO vital_records.birth 
			( birthid, state_file_number, date_of_birth, sex, birth_weight_lbs, birth_weight_oz )
			VALUES 
			( @count, CAST(RAND()*1e9 AS INT), @random_date, @sex,
				CAST(RAND()*5 AS INT)+5,
				CAST(RAND()*16 AS INT) 
			);
		--	weight 5 - 10 lbs
		--  oz 0-15 ozs
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


