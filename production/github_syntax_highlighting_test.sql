





-- syntax highlighting shows "decode" as blue. Reserved?

IF OBJECT_ID ( 'bin.decode', 'FN' ) IS NOT NULL
	DROP FUNCTION bin.decode;
GO
CREATE FUNCTION bin.decode( @schema VARCHAR(50), @table VARCHAR(50), @field VARCHAR(50), @code VARCHAR(255) )
	RETURNS VARCHAR(255)
BEGIN
	DECLARE @value VARCHAR(255);
	IF ISNUMERIC(@code) = 1 BEGIN
		-- Don't put functions in WHERE clause. Performance issues.
		-- Something about being called for every row. Unless you need that.
		-- We don't need that here.
		DECLARE @codeset VARCHAR(255) = bin.codeset(@schema,@table,@field);
		SELECT @value = value FROM dbo.codes
			WHERE _schema = @schema
				AND _table = @table
				AND codeset = @codeset
				AND code = @code
	END ELSE
		SET @value = @code
	RETURN ISNULL(@value,CAST(@code AS VARCHAR(255)))
END
GO

IF OBJECT_ID ( 'bin.codeset', 'FN' ) IS NOT NULL
	DROP FUNCTION bin.codeset;
GO
CREATE FUNCTION bin.codeset( @schema VARCHAR(50), @table VARCHAR(50), @field VARCHAR(255) )
	RETURNS VARCHAR(255)
BEGIN
	DECLARE @codeset VARCHAR(255);
	SELECT @codeset = codeset FROM dbo.dictionary
		WHERE _schema = @schema
			AND _table = @table
			AND field = @field
	RETURN ISNULL(@codeset, @field)
END
GO

IF OBJECT_ID ( 'bin.label', 'FN' ) IS NOT NULL
	DROP FUNCTION bin.label;
GO
CREATE FUNCTION bin.label( @schema VARCHAR(50), @table VARCHAR(50), @field VARCHAR(255) )
	RETURNS VARCHAR(255)
BEGIN
	DECLARE @label VARCHAR(255);
	SELECT @label = label FROM dbo.dictionary
		WHERE _schema = @schema
			AND _table = @table
			AND field = @field
	-- If label is blank, just return the given field
	RETURN ISNULL(@label, @field)
END
GO

IF OBJECT_ID ( 'bin.description', 'FN' ) IS NOT NULL
	DROP FUNCTION bin.description;
GO
CREATE FUNCTION bin.description( @schema VARCHAR(50), @table VARCHAR(50), @field VARCHAR(255) )
	RETURNS VARCHAR(255)
BEGIN
	DECLARE @description VARCHAR(255);
	SELECT @description = description FROM dbo.dictionary
		WHERE _schema = @schema
			AND _table = @table
			AND field = @field
	-- If description is blank return label
	RETURN ISNULL(@description, bin.label(@schema,@table,@field))
END
GO


IF OBJECT_ID ( 'bin.codes', 'TF' ) IS NOT NULL
	DROP FUNCTION bin.codes;
GO
CREATE FUNCTION bin.codes( @schema VARCHAR(50), @table VARCHAR(50), @field VARCHAR(50) )
	RETURNS @codes TABLE ( code VARCHAR(255), value VARCHAR(255) )
BEGIN
	DECLARE @codeset VARCHAR(255) = bin.codeset(@schema,@table,@field);

	INSERT INTO @codes
		SELECT code, value FROM dbo.codes
		WHERE _schema = @schema
			AND _table = @table
			AND codeset = @codeset

	RETURN
END
GO



--	PRINT bin.decode('vital','births','race',1)
--	PRINT bin.label('vital','births','race')
--	PRINT bin.description('vital','births','race')
--	PRINT bin.codeset('vital','births','race')
--	SELECT * FROM bin.codes('vital','births','race')


-- 20160609 - FYI, this has yet to be tested.
IF OBJECT_ID ( 'bin.manually_link', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.manually_link;
GO
CREATE PROCEDURE bin.manually_link(
	@schema1 VARCHAR(50), @table1 VARCHAR(50), @column1 VARCHAR(50), @value1 VARCHAR(255),
	@schema2 VARCHAR(50), @table2 VARCHAR(50), @column2 VARCHAR(50), @value2 VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO private.identifiers ( chirp_id, source_schema,
		source_table, source_column, source_id, match_method )
		SELECT i.chirp_id, @schema2, @table2, @column2, @value2,
			'Manually : '+@schema1+' '+@table1+' '+@column1+' '+@value1
		FROM private.identifiers i
		WHERE i.source_schema = @schema1
			AND i.source_table  = @table1
			AND i.source_column = @column1
			AND i.source_id     = @value1;

END	--	bin.manually_link
GO





-- ADD PARAMETERS. Year, Month,

IF OBJECT_ID ( 'bin.link_screening_records_to_birth_records', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.link_screening_records_to_birth_records;
GO
CREATE PROCEDURE bin.link_screening_records_to_birth_records( @year INT = 2015, @month INT = 7 )
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#temp_identifiers_link', 'U') IS NOT NULL
		DROP TABLE #temp_identifiers_link;

	-- NEED to assign aliases to all columns here that aren't variables, like these fixed value strings.
	SELECT DISTINCT chirp_id, 'health_lab' AS ss, 'newborn_screenings' AS st,
		'accession_kit_number' AS sc, accession_kit_number,
		'Matched to birth record with score of ' + CAST(score AS VARCHAR(10)) AS mm
	INTO #temp_identifiers_link
	FROM (

		SELECT chirp_id, accession_kit_number,
			birth_score + mom_birth_score + zip_score + address_score + num_score +
				last_name_score + first_name_score + mom_first_name_score AS score,
			RANK() OVER( PARTITION BY accession_kit_number ORDER BY
				birth_score + mom_birth_score + zip_score + address_score + num_score +
					last_name_score + first_name_score + mom_first_name_score DESC ) AS rank
		FROM (

			SELECT i.chirp_id, s.accession_kit_number,
				CASE WHEN b.bth_date = s.birth_date    THEN 1.0
					WHEN b.bth_date BETWEEN DATEADD(day,-8,s.birth_date) AND DATEADD(day,8,s.birth_date) THEN 0.5
					ELSE 0.0 END AS birth_score,
				CASE WHEN b.mom_dob = s.mom_birth_date THEN 1.0
					WHEN (b.mom_dob_year = s.mom_birth_date_year AND b.mom_dob_month = s.mom_birth_date_month) THEN 0.5
					WHEN (b.mom_dob_day  = s.mom_birth_date_day  AND b.mom_dob_month = s.mom_birth_date_month) THEN 0.5
					WHEN (b.mom_dob_year = s.mom_birth_date_year AND b.mom_dob_day   = s.mom_birth_date_day)   THEN 0.5
					ELSE 0.0 END AS mom_birth_score,
				CASE WHEN b._mom_rzip = s.zip_code     THEN 1.0 ELSE 0.0 END AS zip_score,
				CASE WHEN b._mom_address = s._address  THEN 1.0
					WHEN b._mom_address_pre = s._address_pre THEN 0.5
					WHEN b._mom_address_suf = s._address_suf THEN 0.5
					ELSE 0.0 END AS address_score,
				CASE WHEN b.inf_hospnum IN ( s.patient_id, s.patient_id_pre, s.patient_id_suf, s.patient_id_prex,
						s.patient_id_sufx, s.patient_id_prexi, s.patient_id_sufxi ) THEN 1.0
					WHEN s.patient_id LIKE '%' + b.inf_hospnum + '%' THEN 0.5
					WHEN b.inf_hospnum LIKE '%' + s.patient_id + '%' THEN 0.5
					ELSE 0.0 END AS num_score,
				CASE WHEN ( s._mom_surname IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._mom_surname_pre IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._mom_surname_suf IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._last_name IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._last_name_pre IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					OR s._last_name_suf IN ( b._mom_snam, b._mom_snam_pre, b._mom_snam_suf, b._maiden_n,
						b._maiden_n_pre, b._maiden_n_suf, b._name_sur, b._name_sur_pre, b._name_sur_suf )
					) THEN 1.0 ELSE 0.0 END AS last_name_score,
				CASE WHEN b._name_fir = s._first_name     THEN 0.5 ELSE 0.0 END AS first_name_score,
				CASE WHEN b._mom_fnam = s._mom_first_name THEN 1.0 ELSE 0.0 END AS mom_first_name_score
			FROM private.identifiers i
			JOIN vital.births b
				ON  i.source_id     = b.cert_year_num
				AND i.source_column = 'cert_year_num'
				AND i.source_table  = 'births'
				AND i.source_schema = 'vital'
			CROSS JOIN health_lab.newborn_screenings s
			LEFT JOIN private.identifiers i2
				ON  i2.source_id     = s.accession_kit_number
				AND i2.source_column = 'accession_kit_number'
				AND i2.source_table  = 'newborn_screenings'
				AND i2.source_schema = 'health_lab'
			WHERE b.bth_date_year = @year AND b.bth_date_month = @month
				AND i2.chirp_id IS NULL
/*
				AND s.birth_date_year = @year AND s.birth_date_month = @month
				AND s.zip_code IN ( '89402', '89405', '89412', '89424', '89431', '89432', '89433',
					'89434', '89435', '89436', '89439', '89441', '89442', '89450', '89451', '89452',
					'89501', '89502', '89503', '89504', '89505', '89506', '89507', '89508', '89509',
					'89510', '89511', '89512', '89513', '89515', '89519', '89520', '89521', '89523',
					'89533', '89555', '89557', '89570', '89595', '89599', '89704' )
*/

		) AS computing_scores
		WHERE birth_score + mom_birth_score + zip_score + address_score + num_score +
			last_name_score + first_name_score + mom_first_name_score >= 4

	) AS ranked
	WHERE rank = 1;

	INSERT INTO private.identifiers (
		chirp_id, source_schema, source_table, source_column, source_id, match_method )
		SELECT * FROM #temp_identifiers_link WHERE accession_kit_number NOT IN (
			SELECT accession_kit_number FROM #temp_identifiers_link
				GROUP BY accession_kit_number HAVING COUNT(1) > 1
		);

	IF OBJECT_ID('tempdb..#temp_identifiers_link', 'U') IS NOT NULL
		DROP TABLE #temp_identifiers_link;

END	--	bin.link_screening_records_to_birth_records
GO





IF OBJECT_ID ( 'bin.import_birth_records', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_birth_records;
GO
CREATE PROCEDURE bin.import_birth_records( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT vital.bulk_insert_births ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 2, TABLOCK )';

	DBCC CHECKIDENT( 'vital.births_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE vital.births_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE vital.births_buffer DROP CONSTRAINT temp_source_filename;

END	--	bin.import_birth_records
GO


IF OBJECT_ID ( 'bin.import_newborn_screening_records_2015', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_newborn_screening_records_2015;
GO
CREATE PROCEDURE bin.import_newborn_screening_records_2015( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015 ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 2, TABLOCK )';

	DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE health_lab.newborn_screenings_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE health_lab.newborn_screenings_buffer
		DROP CONSTRAINT temp_source_filename;

END	--	bin.import_newborn_screening_records_2015
GO

-- Sadly, the format changed from 2015 to 2016

IF OBJECT_ID ( 'bin.import_newborn_screening_records_2016', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_newborn_screening_records_2016;
GO
CREATE PROCEDURE bin.import_newborn_screening_records_2016( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016 ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 2, TABLOCK )';

	DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE health_lab.newborn_screenings_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE health_lab.newborn_screenings_buffer
		DROP CONSTRAINT temp_source_filename;

END	--	bin.import_newborn_screening_records_2016
GO

