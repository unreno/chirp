-- MS Sets these before every “CREATE TRIGGER”
-- Not sure if calling them once will suffice.
-- Needed?
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='bin')
	EXEC('CREATE SCHEMA bin')
GO

/*
--Database diagram support objects cannot be installed because this database does not have a valid owner. To continue, first use the Files page of the Database Properties dialog box or the ALTER AUTHORIZATION statement to set the database owner to a valid login, then add the database diagram support objects.
--Wanted to see these Database Diagrams and this seemed to work.
--This changes the database owner to [sa]. I'd prefer to keep it.
--ALTER AUTHORIZATION ON DATABASE::chirp TO [sa];

-- It is really hard to believe, but sometimes apostrophes inside -- comments
-- really mess up github's syntax highlighter parser. Wrapping -- comments in asterisk-slash chars helps.
*/


IF OBJECT_ID ( 'bin.add_imported_at_column_to_table', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_at_column_to_table;
GO
CREATE PROCEDURE bin.add_imported_at_column_to_table(@schema VARCHAR(255),@table VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @cmd VARCHAR(8000);
	DECLARE @cname VARCHAR(255);

	SELECT @cname = @schema + '_' + @table + '_imported_at_default';

/*
	--Remove constraint if exists
	SELECT @cmd = 'IF OBJECT_ID(''[' + @schema + '].[' + @cname + ']'') IS NOT NULL ' +
		'ALTER TABLE ' + @schema + '.[' + @table +'] DROP CONSTRAINT ' + @cname + ';'
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

	--Remove column if exists
	SELECT @cmd = 'IF COL_LENGTH(''[' + @schema + '].[' + @table +
		']'',''imported_at'') IS NOT NULL '+
		'ALTER TABLE ' + @schema + '.[' + @table + '] DROP COLUMN imported_at;'
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

	--Add column with constraint
	SELECT @cmd = 'ALTER TABLE [' + @schema + '].[' + @table +
		'] ADD imported_at DATETIME CONSTRAINT '
		+ @cname + ' DEFAULT CURRENT_TIMESTAMP NOT NULL ;';
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!
*/

	--Add column with constraint if doesn't exist
	SELECT @cmd = 'IF COL_LENGTH(''[' + @schema + '].[' + @table +
		']'',''imported_at'') IS NULL '+
		'ALTER TABLE [' + @schema + '].[' + @table +
		'] ADD imported_at DATETIME CONSTRAINT '
		+ @cname + ' DEFAULT CURRENT_TIMESTAMP NOT NULL ;';
	EXEC (@cmd);	--	Parenthese required here!

END
GO


IF OBJECT_ID ( 'bin.add_imported_at_column_to_tables_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_at_column_to_tables_by_schema;
GO
CREATE PROCEDURE bin.add_imported_at_column_to_tables_by_schema(@schema VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @table VARCHAR(255);

	DECLARE tables CURSOR FOR SELECT t.name
		FROM sys.tables AS t
		INNER JOIN sys.schemas AS s
		ON t.schema_id = s.schema_id
		WHERE s.name = @schema;

	OPEN tables;
	WHILE(1=1)BEGIN
		FETCH tables INTO @table;
		IF(@@FETCH_STATUS <> 0) BREAK
--		PRINT @table
		EXEC bin.add_imported_at_column_to_table @schema, @table
	END
	CLOSE tables;
	DEALLOCATE tables;
END
GO


IF OBJECT_ID ( 'bin.add_imported_to_dw_column_to_table', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_to_dw_column_to_table;
GO
CREATE PROCEDURE bin.add_imported_to_dw_column_to_table(@schema VARCHAR(255),@table VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @cmd VARCHAR(8000);
	DECLARE @cname VARCHAR(255);

	SELECT @cname = @schema + '_' + @table + '_imported_to_dw_default';

/*
	--Remove constraint if exists
	SELECT @cmd = 'IF OBJECT_ID(''[' + @schema + '].[' + @cname + ']'') IS NOT NULL ' +
		'ALTER TABLE ' + @schema + '.[' + @table +'] DROP CONSTRAINT ' + @cname + ';'
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

	--Remove column if exists
	SELECT @cmd = 'IF COL_LENGTH(''[' + @schema + '].[' + @table +
		']'',''imported_to_dw'') IS NOT NULL '+
		'ALTER TABLE ' + @schema + '.[' + @table + '] DROP COLUMN imported_to_dw;'
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

	--Add column with constraint
	SELECT @cmd = 'ALTER TABLE [' + @schema + '].[' + @table +
		'] ADD imported_to_dw BIT CONSTRAINT '
		+ @cname + ' DEFAULT ''FALSE'' NOT NULL ;';
--	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!
*/

	--Add column with constraint if doesn't exist
	SELECT @cmd = 'IF COL_LENGTH(''[' + @schema + '].[' + @table +
		']'',''imported_to_dw'') IS NULL '+
		'ALTER TABLE [' + @schema + '].[' + @table +
		'] ADD imported_to_dw BIT CONSTRAINT '
		+ @cname + ' DEFAULT ''FALSE'' NOT NULL ;';
	EXEC (@cmd);	--	Parenthese required here!

END
GO


IF OBJECT_ID ( 'bin.add_imported_to_dw_column_to_tables_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_to_dw_column_to_tables_by_schema;
GO
CREATE PROCEDURE bin.add_imported_to_dw_column_to_tables_by_schema(@schema VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @table VARCHAR(255);

	DECLARE tables CURSOR FOR SELECT t.name
		FROM sys.tables AS t
		INNER JOIN sys.schemas AS s
		ON t.schema_id = s.schema_id
		WHERE s.name = @schema;

	OPEN tables;
	WHILE(1=1)BEGIN
		FETCH tables INTO @table;
		IF(@@FETCH_STATUS <> 0)
			BREAK
--		PRINT @table
		EXEC bin.add_imported_to_dw_column_to_table @schema, @table
	END
	CLOSE tables;
	DEALLOCATE tables;

END
GO



--INSERT INTO vital.births (birthid,imported_to_dw) VALUES (1,'true');  -- 'true'=1
--INSERT INTO vital.births (birthid,imported_to_dw) VALUES (1,'false'); -- 'false'=0
--INSERT INTO vital.births (birthid,imported_to_dw) VALUES (1,'blahblahblah');
--INSERT INTO vital.births (birthid) values (1);
--Conversion failed when converting the varchar value 'blahblahblah' to data type bit







IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_table_health_lab_newborn_screenings', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screenings;
GO
CREATE PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screenings
AS
BEGIN
	SET NOCOUNT ON;



	-- Be advised that the newborn screening records are in triplicate.
	-- For the moment, everything added here will also be in triplicate.



	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, source_schema, source_table, source_id, downloaded_at)
		SELECT chirp_id, provider_id, started_at,
			cav.concept, cav.value, cav.units, source_schema, source_table, source_id, downloaded_at
		FROM (
			SELECT i.chirp_id, s.birth_date AS started_at,	-- I hope that the actual data include date lab performed
				0 AS provider_id,
				'health_lab' AS source_schema,
				'newborn_screenings' AS source_table,
				s.id AS source_id,
				s.*,
				imported_at AS downloaded_at
			FROM health_lab.newborn_screenings s
			JOIN private.identifiers i
				ON  i.source_id     = s.accession_kit_number
				AND i.source_column = 'accession_kit_number'
				AND i.source_table  = 'newborn_screenings'
				AND i.source_schema = 'health_lab'
			WHERE imported_to_dw = 'FALSE'
		) unimported_data
		CROSS APPLY ( VALUES
			('DEM:ZIP', CAST(zip_code AS VARCHAR(255)), NULL)
		) cav ( concept, value, units )
		WHERE cav.value IS NOT NULL

	UPDATE s
		SET imported_to_dw = 'TRUE'
		FROM health_lab.newborn_screenings s
		JOIN private.identifiers i
			ON  i.source_id     = s.accession_kit_number
			AND i.source_column = 'accession_kit_number'
			AND i.source_table  = 'newborn_screenings'
			AND i.source_schema = 'health_lab'
		WHERE imported_to_dw = 'FALSE'
			AND i.id IS NOT NULL

END	--	CREATE PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screenings
GO



IF OBJECT_ID ( 'bin.weight_from_lbs_and_oz', 'FN' ) IS NOT NULL
	DROP FUNCTION bin.weight_from_lbs_and_oz;
GO
CREATE FUNCTION bin.weight_from_lbs_and_oz( @lbs INT, @oz INT )
	RETURNS FLOAT
BEGIN
	DECLARE @w FLOAT;
	IF @lbs IS NOT NULL AND @oz IS NOT NULL
		SET @w = CAST(@lbs AS FLOAT) + CAST(@oz AS FLOAT)/16
	RETURN @w
END
GO



IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_table_vital_births', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse_by_table_vital_births;
GO
CREATE PROCEDURE bin.import_into_data_warehouse_by_table_vital_births
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, source_schema, source_table, source_id, downloaded_at)
		SELECT chirp_id, provider_id, started_at,
			cav.concept, cav.value, cav.units, source_schema, source_table, source_id, downloaded_at
		FROM (
			SELECT i.chirp_id, bth_date AS started_at,
				0 AS provider_id,
				'vital' AS source_schema,
				'births' AS source_table,
				b.id AS source_id,
				b.*,
				imported_at AS downloaded_at
			FROM vital.births b
			JOIN private.identifiers i
				ON i.source_id = cert_year_num
				AND i.source_column = 'cert_year_num'
				AND i.source_table = 'births'
				AND i.source_schema = 'vital'
			WHERE imported_to_dw = 'FALSE'
		) unimported_data
		CROSS APPLY ( VALUES
			('ac_anemia', bin.decode('vital','births','ac_anemia',ac_anemia), NULL),
			('ac_antisepis', bin.decode('vital','births','ac_antisepis',ac_antisepis), NULL),
			('ac_bthinjury', bin.decode('vital','births','ac_bthinjury',ac_bthinjury), NULL),
			('ac_fas', bin.decode('vital','births','ac_fas',ac_fas), NULL),
			('ac_hyaline', bin.decode('vital','births','ac_hyaline',ac_hyaline), NULL),
			('ac_mecon', bin.decode('vital','births','ac_mecon',ac_mecon), NULL),
			('ac_nicu', bin.decode('vital','births','ac_nicu',ac_nicu), NULL),
			('ac_none', bin.decode('vital','births','ac_none',ac_none), NULL),
			('ac_oth', bin.decode('vital','births','ac_oth',ac_oth), NULL),
			('ac_othlit', ac_othlit, NULL),
			('ac_seizures', bin.decode('vital','births','ac_seizures',ac_seizures), NULL),
			('ac_surf', bin.decode('vital','births','ac_surf',ac_surf), NULL),
			('ac_ventless', bin.decode('vital','births','ac_ventless',ac_ventless), NULL),
			('ac_ventmore', bin.decode('vital','births','ac_ventmore',ac_ventmore), NULL),
			('acn_anencep', bin.decode('vital','births','acn_anencep',acn_anencep), NULL),
			('acn_cdit', bin.decode('vital','births','acn_cdit',acn_cdit), NULL),
			('acn_chromoth', bin.decode('vital','births','acn_chromoth',acn_chromoth), NULL),
			('acn_chromothlit', acn_chromothlit, NULL),
			('acn_circ', bin.decode('vital','births','acn_circ',acn_circ), NULL),
			('acn_cirlit', acn_cirlit, NULL),
			('acn_cleftlip', bin.decode('vital','births','acn_cleftlip',acn_cleftlip), NULL),
			('acn_cleftpalate', bin.decode('vital','births','acn_cleftpalate',acn_cleftpalate), NULL),
			('acn_clubft', bin.decode('vital','births','acn_clubft',acn_clubft), NULL),
			('acn_diaphhern', bin.decode('vital','births','acn_diaphhern',acn_diaphhern), NULL),
			('acn_downs', bin.decode('vital','births','acn_downs',acn_downs), NULL),
			('acn_gastro', bin.decode('vital','births','acn_gastro',acn_gastro), NULL),
			('acn_gastrolit', acn_gastrolit, NULL),
			('acn_gastrosch', bin.decode('vital','births','acn_gastrosch',acn_gastrosch), NULL),
			('acn_hrtdis', bin.decode('vital','births','acn_hrtdis',acn_hrtdis), NULL),
			('acn_hrtmal', bin.decode('vital','births','acn_hrtmal',acn_hrtmal), NULL),
			('acn_hypos', bin.decode('vital','births','acn_hypos',acn_hypos), NULL),
			('acn_limbred', bin.decode('vital','births','acn_limbred',acn_limbred), NULL),
			('acn_malgen', bin.decode('vital','births','acn_malgen',acn_malgen), NULL),
			('acn_micro', bin.decode('vital','births','acn_micro',acn_micro), NULL),
			('acn_muscle', bin.decode('vital','births','acn_muscle',acn_muscle), NULL),
			('acn_musclelit', acn_musclelit, NULL),
			('acn_nervous', bin.decode('vital','births','acn_nervous',acn_nervous), NULL),
			('acn_nervouslit', acn_nervouslit, NULL),
			('acn_none', bin.decode('vital','births','acn_none',acn_none), NULL),
			('acn_omphal', bin.decode('vital','births','acn_omphal',acn_omphal), NULL),
			('acn_oth', bin.decode('vital','births','acn_oth',acn_oth), NULL),
			('acn_othlit', acn_othlit, NULL),
			('acn_polydact', bin.decode('vital','births','acn_polydact',acn_polydact), NULL),
			('acn_rectal', bin.decode('vital','births','acn_rectal',acn_rectal), NULL),
			('acn_renal', bin.decode('vital','births','acn_renal',acn_renal), NULL),
			('acn_spina', bin.decode('vital','births','acn_spina',acn_spina), NULL),
			('acn_tracheo', bin.decode('vital','births','acn_tracheo',acn_tracheo), NULL),
			('acn_urogen', bin.decode('vital','births','acn_urogen',acn_urogen), NULL),
			('acn_urogenlit', acn_urogenlit, NULL),
			('alcohol', bin.decode('vital','births','alcohol',alcohol), NULL),
			('apgar_10', CAST(apgar_10 AS VARCHAR(255)), NULL),
			('apgar_5', CAST(apgar_5 AS VARCHAR(255)), NULL),
			('attendant', bin.decode('vital','births','attendant',attendant), NULL),
			('birth_ci', bin.decode('vital','births','birth_ci',birth_ci), NULL),
			('birth_co', bin.decode('vital','births','birth_co',birth_co), NULL),
			('birth_da', CAST(birth_da AS VARCHAR(255)), NULL),
			('birth_mo', CAST(birth_mo AS VARCHAR(255)), NULL),
			('birth_rco', bin.decode('vital','births','birth_rco',birth_rco), NULL),
			('birth_st', bin.decode('vital','births','birth_st',birth_st), NULL),
			('birth_yr', CAST(birth_yr AS VARCHAR(255)), NULL),
			('born_alive', bin.decode('vital','births','born_alive',born_alive), NULL),
			('breastfeeding', bin.decode('vital','births','breastfeeding',breastfeeding), NULL),
--			('bth_date', CAST(bth_date AS VARCHAR(255)), NULL),
			('bth_order', bin.decode('vital','births','bth_order',bth_order), NULL),
			('bth_present', bin.decode('vital','births','bth_present',bth_present), NULL),
			('bth_route', bin.decode('vital','births','bth_route',bth_route), NULL),
-- identifiable?
			('bth_time', CAST(bth_time AS VARCHAR(255)), NULL),
			('bthwt_unit', bin.decode('vital','births','bthwt_unit',bthwt_unit), NULL),
			('bwt_grp', bin.decode('vital','births','bwt_grp',bwt_grp), NULL),
			('cer_da',   CAST(cer_da AS VARCHAR(255)), NULL),
			('cer_date', CAST(cer_date AS VARCHAR(255)), NULL),
			('cer_mo',   CAST(cer_mo AS VARCHAR(255)), NULL),
			('cer_yr',   CAST(cer_yr AS VARCHAR(255)), NULL),
-- identifiable
--			('cert_num', bin.decode('vital','births','cert_num',cert_num), NULL),
--			('cert_yr', bin.decode('vital','births','cert_yr',cert_yr), NULL),
			('certifier', bin.decode('vital','births','certifier',certifier), NULL),
			('cig_pck', bin.decode('vital','births','cig_pck',cig_pck), NULL),
			('cld_abrplac', bin.decode('vital','births','cld_abrplac',cld_abrplac), NULL),
			('cld_anesth', bin.decode('vital','births','cld_anesth',cld_anesth), NULL),
			('cld_antibiotic', bin.decode('vital','births','cld_antibiotic',cld_antibiotic), NULL),
			('cld_aug', bin.decode('vital','births','cld_aug',cld_aug), NULL),
			('cld_bleed', bin.decode('vital','births','cld_bleed',cld_bleed), NULL),
			('cld_cephpelv', bin.decode('vital','births','cld_cephpelv',cld_cephpelv), NULL),
			('cld_chorio', bin.decode('vital','births','cld_chorio',cld_chorio), NULL),
			('cld_cordpro', bin.decode('vital','births','cld_cordpro',cld_cordpro), NULL),
			('cld_dysfunc', bin.decode('vital','births','cld_dysfunc',cld_dysfunc), NULL),
			('cld_epi', bin.decode('vital','births','cld_epi',cld_epi), NULL),
			('cld_febrile', bin.decode('vital','births','cld_febrile',cld_febrile), NULL),
			('cld_fetalintol', bin.decode('vital','births','cld_fetalintol',cld_fetalintol), NULL),
			('cld_induc', bin.decode('vital','births','cld_induc',cld_induc), NULL),
			('cld_mecon', bin.decode('vital','births','cld_mecon',cld_mecon), NULL),
			('cld_none', bin.decode('vital','births','cld_none',cld_none), NULL),
			('cld_nonvert', bin.decode('vital','births','cld_nonvert',cld_nonvert), NULL),
			('cld_oth', bin.decode('vital','births','cld_oth',cld_oth), NULL),
			('cld_othlit', cld_othlit, NULL),
			('cld_placprev', bin.decode('vital','births','cld_placprev',cld_placprev), NULL),
			('cld_seizures', bin.decode('vital','births','cld_seizures',cld_seizures), NULL),
			('cld_steroid', bin.decode('vital','births','cld_steroid',cld_steroid), NULL),
			('dat_concep', CAST(dat_concep AS VARCHAR(255)), NULL),
			('death_cert', bin.decode('vital','births','death_cert',death_cert), NULL),
			('death_date', CAST(death_date AS VARCHAR(255)), NULL),
			('death_match', bin.decode('vital','births','death_match',death_match), NULL),
			('del_wt', bin.decode('vital','births','del_wt',del_wt), 'lbs'),
			('drink_wk', bin.decode('vital','births','drink_wk',drink_wk), 'drinks'),
			('drug_use', bin.decode('vital','births','drug_use',drug_use), NULL),
			('du_otc', bin.decode('vital','births','du_otc',du_otc), NULL),
			('du_other', bin.decode('vital','births','du_other',du_other), NULL),
			('du_otherlit', du_otherlit, NULL),
			('du_prscr', bin.decode('vital','births','du_prscr',du_prscr), NULL),
			('fa_age', bin.decode('vital','births','fa_age',fa_age), 'years'),
			('fa_age1', bin.decode('vital','births','fa_age1',fa_age1), NULL),
			('fa_amind', bin.decode('vital','births','fa_amind',fa_amind), NULL),
			('fa_amindlit', fa_amindlit, NULL),
			('fa_asian', bin.decode('vital','births','fa_asian',fa_asian), NULL),
			('fa_asianlit', fa_asianlit, NULL),
			('fa_asianoth', bin.decode('vital','births','fa_asianoth',fa_asianoth), NULL),
			('fa_black', bin.decode('vital','births','fa_black',fa_black), NULL),
			('fa_bst', bin.decode('vital','births','fa_bst',fa_bst), NULL),
			('fa_bus', bin.decode('vital','births','fa_bus',fa_bus), NULL),
			('fa_busines1', bin.decode('vital','births','fa_busines1',fa_busines1), NULL),
			('fa_chinese', bin.decode('vital','births','fa_chinese',fa_chinese), NULL),
			('fa_cu', bin.decode('vital','births','fa_cu',fa_cu), NULL),
			('fa_dob', CAST(fa_dob AS VARCHAR(255)), NULL),
			('fa_edu', bin.decode('vital','births','fa_edu',fa_edu), NULL),
			('fa_ethnic_nchs', bin.decode('vital','births','fa_ethnic_nchs',fa_ethnic_nchs), NULL),
			('fa_ethoth', bin.decode('vital','births','fa_ethoth',fa_ethoth), NULL),
			('fa_ethothlit', fa_ethothlit, NULL),
			('fa_filipino', bin.decode('vital','births','fa_filipino',fa_filipino), NULL),
-- identifiable
--			('fa_fname', bin.decode('vital','births','fa_fname',fa_fname), NULL),
			('fa_guam', bin.decode('vital','births','fa_guam',fa_guam), NULL),
			('fa_hawaiian', bin.decode('vital','births','fa_hawaiian',fa_hawaiian), NULL),
			('fa_his', bin.decode('vital','births','fa_his',fa_his), NULL),
			('fa_husb', bin.decode('vital','births','fa_husb',fa_husb), NULL),
			('fa_japanese', bin.decode('vital','births','fa_japanese',fa_japanese), NULL),
			('fa_korean', bin.decode('vital','births','fa_korean',fa_korean), NULL),
			('fa_mex', bin.decode('vital','births','fa_mex',fa_mex), NULL),
-- identifiable
--			('fa_mname', bin.decode('vital','births','fa_mname',fa_mname), NULL),
			('fa_occ', bin.decode('vital','births','fa_occ',fa_occ), NULL),
			('fa_occup1', bin.decode('vital','births','fa_occup1',fa_occup1), NULL),
			('fa_pacisl', bin.decode('vital','births','fa_pacisl',fa_pacisl), NULL),
			('fa_pacisllit', fa_pacisllit, NULL),
			('fa_pr', bin.decode('vital','births','fa_pr',fa_pr), NULL),
			('fa_race1', bin.decode('vital','births','fa_race1',fa_race1), NULL),
			('fa_race16', bin.decode('vital','births','fa_race16',fa_race16), NULL),
			('fa_race18', bin.decode('vital','births','fa_race18',fa_race18), NULL),
			('fa_race2', bin.decode('vital','births','fa_race2',fa_race2), NULL),
			('fa_race20', bin.decode('vital','births','fa_race20',fa_race20), NULL),
			('fa_race22', bin.decode('vital','births','fa_race22',fa_race22), NULL),
			('fa_race3', bin.decode('vital','births','fa_race3',fa_race3), NULL),
			('fa_race4', bin.decode('vital','births','fa_race4',fa_race4), NULL),
			('fa_race5', bin.decode('vital','births','fa_race5',fa_race5), NULL),
			('fa_race6', bin.decode('vital','births','fa_race6',fa_race6), NULL),
			('fa_race7', bin.decode('vital','births','fa_race7',fa_race7), NULL),
			('fa_race8', bin.decode('vital','births','fa_race8',fa_race8), NULL),
			('fa_raceoth', bin.decode('vital','births','fa_raceoth',fa_raceoth), NULL),
			('fa_raceothlit', fa_raceothlit, NULL),
			('fa_raceref', bin.decode('vital','births','fa_raceref',fa_raceref), NULL),
			('fa_raceunk', bin.decode('vital','births','fa_raceunk',fa_raceunk), NULL),
			('fa_samoan', bin.decode('vital','births','fa_samoan',fa_samoan), NULL),
			('fa_signpat', bin.decode('vital','births','fa_signpat',fa_signpat), NULL),
-- identifiable
--			('fa_sname', bin.decode('vital','births','fa_sname',fa_sname), NULL),
--			('fa_ssn', bin.decode('vital','births','fa_ssn',fa_ssn), NULL),
			('fa_vietnamese', bin.decode('vital','births','fa_vietnamese',fa_vietnamese), NULL),
			('fa_white', bin.decode('vital','births','fa_white',fa_white), NULL),
-- identifiable
--			('fa_xname', bin.decode('vital','births','fa_xname',fa_xname), NULL),
			('facility', bin.decode('vital','births','facility',facility), NULL),
			('fahisp_nchs', bin.decode('vital','births','fahisp_nchs',fahisp_nchs), NULL),
			('farace_ethnchs', bin.decode('vital','births','farace_ethnchs',farace_ethnchs), NULL),
			('farace_nchsbrg', bin.decode('vital','births','farace_nchsbrg',farace_nchsbrg), NULL),
--			('filler10', bin.decode('vital','births','filler10',filler10), NULL),
--			('filler14', bin.decode('vital','births','filler14',filler14), NULL),
--			('filler15', bin.decode('vital','births','filler15',filler15), NULL),
--			('filler16', bin.decode('vital','births','filler16',filler16), NULL),
--			('filler17', bin.decode('vital','births','filler17',filler17), NULL),
--			('filler7', bin.decode('vital','births','filler7',filler7), NULL),
--			('filler8', bin.decode('vital','births','filler8',filler8), NULL),
--			('filler9', bin.decode('vital','births','filler9',filler9), NULL),
			('first_cig', bin.decode('vital','births','first_cig',first_cig), NULL),
			('first_pck', bin.decode('vital','births','first_pck',first_pck), NULL),
			('gest_days', bin.decode('vital','births','gest_days',gest_days), 'days'),
			('gest_est', bin.decode('vital','births','gest_est',gest_est), 'weeks'),
			('gest_grp', bin.decode('vital','births','gest_grp',gest_grp), NULL),
			('gest_wks', CAST(gest_wks AS VARCHAR(255)), 'weeks'),
--			('grams', CAST(grams AS VARCHAR(255)), 'grams'),
			('incity', bin.decode('vital','births','incity',incity), NULL),
			('inf_chlam', bin.decode('vital','births','inf_chlam',inf_chlam), NULL),
			('inf_cmv', bin.decode('vital','births','inf_cmv',inf_cmv), NULL),
			('inf_genherpes', bin.decode('vital','births','inf_genherpes',inf_genherpes), NULL),
			('inf_gonor', bin.decode('vital','births','inf_gonor',inf_gonor), NULL),
			('inf_hepb', bin.decode('vital','births','inf_hepb',inf_hepb), NULL),
			('inf_hepc', bin.decode('vital','births','inf_hepc',inf_hepc), NULL),
			('inf_hivaids', bin.decode('vital','births','inf_hivaids',inf_hivaids), NULL),
-- identifiable
--			('inf_hospnum', bin.decode('vital','births','inf_hospnum',inf_hospnum), NULL),
			('inf_hpv', bin.decode('vital','births','inf_hpv',inf_hpv), NULL),
			('inf_liv', bin.decode('vital','births','inf_liv',inf_liv), NULL),
			('inf_none', bin.decode('vital','births','inf_none',inf_none), NULL),
			('inf_oth', bin.decode('vital','births','inf_oth',inf_oth), NULL),
			('inf_othlit', inf_othlit, NULL),
			('inf_rubella', bin.decode('vital','births','inf_rubella',inf_rubella), NULL),
			('inf_syph', bin.decode('vital','births','inf_syph',inf_syph), NULL),
			('inf_toxo', bin.decode('vital','births','inf_toxo',inf_toxo), NULL),
			('inf_trans', bin.decode('vital','births','inf_trans',inf_trans), NULL),
			('inf_tuber', bin.decode('vital','births','inf_tuber',inf_tuber), NULL),
			('last_cig', bin.decode('vital','births','last_cig',last_cig), NULL),
			('last_pck', bin.decode('vital','births','last_pck',last_pck), NULL),
--			('lbs', bin.decode('vital','births','lbs',lbs), NULL),
			('live_bthdead', bin.decode('vital','births','live_bthdead',live_bthdead), NULL),
			('live_bthliv', bin.decode('vital','births','live_bthliv',live_bthliv), NULL),
			('lm_da',   CAST(lm_da AS VARCHAR(255)), NULL),
			('lm_date', CAST(lm_date AS VARCHAR(255)), NULL),
			('lm_mo',   CAST(lm_mo AS VARCHAR(255)), NULL),
			('lm_yr',   CAST(lm_yr AS VARCHAR(255)), NULL),
-- identifiable
--			('maiden_n', bin.decode('vital','births','maiden_n',maiden_n), NULL),
			('married_betw', bin.decode('vital','births','married_betw',married_betw), NULL),
			('match_certnum', bin.decode('vital','births','match_certnum',match_certnum), NULL),
			('md_forcepsattpt', bin.decode('vital','births','md_forcepsattpt',md_forcepsattpt), NULL),
			('md_vaccumattpt', bin.decode('vital','births','md_vaccumattpt',md_vaccumattpt), NULL),
			('mm_hyster', bin.decode('vital','births','mm_hyster',mm_hyster), NULL),
			('mm_icu', bin.decode('vital','births','mm_icu',mm_icu), NULL),
			('mm_none', bin.decode('vital','births','mm_none',mm_none), NULL),
			('mm_perilac', bin.decode('vital','births','mm_perilac',mm_perilac), NULL),
			('mm_ruputerus', bin.decode('vital','births','mm_ruputerus',mm_ruputerus), NULL),
			('mm_trnsfusion', bin.decode('vital','births','mm_trnsfusion',mm_trnsfusion), NULL),
			('mm_unk', bin.decode('vital','births','mm_unk',mm_unk), NULL),
			('mm_unploper', bin.decode('vital','births','mm_unploper',mm_unploper), NULL),
-- identifiable
--			('mom_address', bin.decode('vital','births','mom_address',mom_address), NULL),
			('mom_age', bin.decode('vital','births','mom_age',mom_age), 'years'),
			('mom_age1', bin.decode('vital','births','mom_age1',mom_age1), NULL),
			('mom_amind', bin.decode('vital','births','mom_amind',mom_amind), NULL),
			('mom_amindlit', mom_amindlit, NULL),
-- identifiable
--			('mom_apt', bin.decode('vital','births','mom_apt',mom_apt), NULL),
			('mom_asian', bin.decode('vital','births','mom_asian',mom_asian), NULL),
			('mom_asianlit', mom_asianlit, NULL),
			('mom_asianoth', bin.decode('vital','births','mom_asianoth',mom_asianoth), NULL),
			('mom_black', bin.decode('vital','births','mom_black',mom_black), NULL),
			('mom_bst', bin.decode('vital','births','mom_bst',mom_bst), NULL),
			('mom_bthcntry_fips', mom_bthcntry_fips, NULL),
			('mom_bthstate_fips', mom_bthstate_fips, NULL),
			('mom_bus', bin.decode('vital','births','mom_bus',mom_bus), NULL),
			('mom_busines1', bin.decode('vital','births','mom_busines1',mom_busines1), NULL),
			('mom_chinese', bin.decode('vital','births','mom_chinese',mom_chinese), NULL),
			('mom_cu', bin.decode('vital','births','mom_cu',mom_cu), NULL),
			('mom_dob', CAST(mom_dob AS VARCHAR(255)), NULL),
			('mom_edu', bin.decode('vital','births','mom_edu',mom_edu), NULL),
			('mom_ethnic_nchs', bin.decode('vital','births','mom_ethnic_nchs',mom_ethnic_nchs), NULL),
			('mom_ethoth', bin.decode('vital','births','mom_ethoth',mom_ethoth), NULL),
			('mom_ethothlit', mom_ethothlit, NULL),
			('mom_everm', bin.decode('vital','births','mom_everm',mom_everm), NULL),
			('mom_filipino', bin.decode('vital','births','mom_filipino',mom_filipino), NULL),
-- identifiable
--			('mom_fnam', bin.decode('vital','births','mom_fnam',mom_fnam), NULL),
			('mom_guam', bin.decode('vital','births','mom_guam',mom_guam), NULL),
			('mom_hawaiian', bin.decode('vital','births','mom_hawaiian',mom_hawaiian), NULL),
			('mom_his', bin.decode('vital','births','mom_his',mom_his), NULL),
-- identifiable
--			('mom_hospnum', bin.decode('vital','births','mom_hospnum',mom_hospnum), NULL),
			('mom_htft', bin.decode('vital','births','mom_htft',mom_htft), 'feet'),
			('mom_htinch', bin.decode('vital','births','mom_htinch',mom_htinch), 'inches'),
			('mom_japanese', bin.decode('vital','births','mom_japanese',mom_japanese), NULL),
			('mom_korean', bin.decode('vital','births','mom_korean',mom_korean), NULL),
			('mom_mex', bin.decode('vital','births','mom_mex',mom_mex), NULL),
-- identifiable
--			('mom_mnam', bin.decode('vital','births','mom_mnam',mom_mnam), NULL),
			('mom_occ', bin.decode('vital','births','mom_occ',mom_occ), NULL),
			('mom_occup1', bin.decode('vital','births','mom_occup1',mom_occup1), NULL),
			('mom_pacisl', bin.decode('vital','births','mom_pacisl',mom_pacisl), NULL),
			('mom_pacisllit', mom_pacisllit, NULL),
			('mom_pr', bin.decode('vital','births','mom_pr',mom_pr), NULL),
			('mom_race1', bin.decode('vital','births','mom_race1',mom_race1), NULL),
			('mom_race16', bin.decode('vital','births','mom_race16',mom_race16), NULL),
			('mom_race18', bin.decode('vital','births','mom_race18',mom_race18), NULL),
			('mom_race2', bin.decode('vital','births','mom_race2',mom_race2), NULL),
			('mom_race20', bin.decode('vital','births','mom_race20',mom_race20), NULL),
			('mom_race22', bin.decode('vital','births','mom_race22',mom_race22), NULL),
			('mom_race3', bin.decode('vital','births','mom_race3',mom_race3), NULL),
			('mom_race4', bin.decode('vital','births','mom_race4',mom_race4), NULL),
			('mom_race5', bin.decode('vital','births','mom_race5',mom_race5), NULL),
			('mom_race6', bin.decode('vital','births','mom_race6',mom_race6), NULL),
			('mom_race7', bin.decode('vital','births','mom_race7',mom_race7), NULL),
			('mom_race8', bin.decode('vital','births','mom_race8',mom_race8), NULL),
			('mom_raceoth', bin.decode('vital','births','mom_raceoth',mom_raceoth), NULL),
			('mom_raceothlit', mom_raceothlit, NULL),
			('mom_raceref', bin.decode('vital','births','mom_raceref',mom_raceref), NULL),
			('mom_raceunk', bin.decode('vital','births','mom_raceunk',mom_raceunk), NULL),
			('mom_rci', bin.decode('vital','births','mom_rci',mom_rci), NULL),
			('mom_rco', bin.decode('vital','births','mom_rco',mom_rco), NULL),
			('mom_rst', bin.decode('vital','births','mom_rst',mom_rst), NULL),
--			('mom_rzip', bin.decode('vital','births','mom_rzip',mom_rzip), NULL),
			('mom_samoan', bin.decode('vital','births','mom_samoan',mom_samoan), NULL),
-- identifiable
--			('mom_snam', bin.decode('vital','births','mom_snam',mom_snam), NULL),
--			('mom_ssn', bin.decode('vital','births','mom_ssn',mom_ssn), NULL),
			('mom_trans', bin.decode('vital','births','mom_trans',mom_trans), NULL),
			('mom_vietnamese', bin.decode('vital','births','mom_vietnamese',mom_vietnamese), NULL),
			('mom_white', bin.decode('vital','births','mom_white',mom_white), NULL),
-- identifiable
--			('mom_xnam', bin.decode('vital','births','mom_xnam',mom_xnam), NULL),
			('momhisp_nchs', bin.decode('vital','births','momhisp_nchs',momhisp_nchs), NULL),
			('momrace_ethnchs', bin.decode('vital','births','momrace_ethnchs',momrace_ethnchs), NULL),
			('momrace_nchsbrg', bin.decode('vital','births','momrace_nchsbrg',momrace_nchsbrg), NULL),
			('mpv_cal', bin.decode('vital','births','mpv_cal',mpv_cal), NULL),
			('mpv_days_cal', bin.decode('vital','births','mpv_days_cal',mpv_days_cal), NULL),
			('mres_city_fips', bin.decode('vital','births','mres_city_fips',mres_city_fips), NULL),
			('mres_cntry_fips', mres_cntry_fips, NULL),
			('mres_cnty_fips', bin.decode('vital','births','mres_cnty_fips',mres_cnty_fips), NULL),
			('mres_st_fips', mres_st_fips, NULL),
			('mrf_anemia', bin.decode('vital','births','mrf_anemia',mrf_anemia), NULL),
			('mrf_assistrep', bin.decode('vital','births','mrf_assistrep',mrf_assistrep), NULL),
			('mrf_cardiac', bin.decode('vital','births','mrf_cardiac',mrf_cardiac), NULL),
			('mrf_eclampsia', bin.decode('vital','births','mrf_eclampsia',mrf_eclampsia), NULL),
			('mrf_gestdiab', bin.decode('vital','births','mrf_gestdiab',mrf_gestdiab), NULL),
			('mrf_hemoglob', bin.decode('vital','births','mrf_hemoglob',mrf_hemoglob), NULL),
			('mrf_hydra', bin.decode('vital','births','mrf_hydra',mrf_hydra), NULL),
			('mrf_hypergest', bin.decode('vital','births','mrf_hypergest',mrf_hypergest), NULL),
			('mrf_hypert', bin.decode('vital','births','mrf_hypert',mrf_hypert), NULL),
			('mrf_hypertchr', bin.decode('vital','births','mrf_hypertchr',mrf_hypertchr), NULL),
			('mrf_incompcerv', bin.decode('vital','births','mrf_incompcerv',mrf_incompcerv), NULL),
			('mrf_infdrugs', bin.decode('vital','births','mrf_infdrugs',mrf_infdrugs), NULL),
			('mrf_inftreat', bin.decode('vital','births','mrf_inftreat',mrf_inftreat), NULL),
			('mrf_lungdis', bin.decode('vital','births','mrf_lungdis',mrf_lungdis), NULL),
			('mrf_none', bin.decode('vital','births','mrf_none',mrf_none), NULL),
			('mrf_oth', bin.decode('vital','births','mrf_oth',mrf_oth), NULL),
			('mrf_othlit', mrf_othlit, NULL),
			('mrf_poorout', bin.decode('vital','births','mrf_poorout',mrf_poorout), NULL),
			('mrf_prediab', bin.decode('vital','births','mrf_prediab',mrf_prediab), NULL),
			('mrf_prev4000', bin.decode('vital','births','mrf_prev4000',mrf_prev4000), NULL),
			('mrf_prevces', bin.decode('vital','births','mrf_prevces',mrf_prevces), NULL),
			('mrf_prevcesnum', bin.decode('vital','births','mrf_prevcesnum',mrf_prevcesnum), NULL),
			('mrf_prevpreterm', bin.decode('vital','births','mrf_prevpreterm',mrf_prevpreterm), NULL),
			('mrf_renaldis', bin.decode('vital','births','mrf_renaldis',mrf_renaldis), NULL),
			('mrf_rhsensit', bin.decode('vital','births','mrf_rhsensit',mrf_rhsensit), NULL),
			('mrf_utbleed', bin.decode('vital','births','mrf_utbleed',mrf_utbleed), NULL),
-- identifiable
--			('name_fir', bin.decode('vital','births','name_fir',name_fir), NULL),
--			('name_mid', bin.decode('vital','births','name_mid',name_mid), NULL),
--			('name_sur', bin.decode('vital','births','name_sur',name_sur), NULL),
--			('name_sux', bin.decode('vital','births','name_sux',name_sux), NULL),
			('ob_amnio', bin.decode('vital','births','ob_amnio',ob_amnio), NULL),
			('ob_cephfail', bin.decode('vital','births','ob_cephfail',ob_cephfail), NULL),
			('ob_cephsucess', bin.decode('vital','births','ob_cephsucess',ob_cephsucess), NULL),
			('ob_cercl', bin.decode('vital','births','ob_cercl',ob_cercl), NULL),
			('ob_fetalmon', bin.decode('vital','births','ob_fetalmon',ob_fetalmon), NULL),
			('ob_none', bin.decode('vital','births','ob_none',ob_none), NULL),
			('ob_oth', bin.decode('vital','births','ob_oth',ob_oth), NULL),
			('ob_othlit', ob_othlit, NULL),
			('ob_toco', bin.decode('vital','births','ob_toco',ob_toco), NULL),
			('ob_ultrasnd', bin.decode('vital','births','ob_ultrasnd',ob_ultrasnd), NULL),
			('ol_none', bin.decode('vital','births','ol_none',ol_none), NULL),
			('ol_preciplbr', bin.decode('vital','births','ol_preciplbr',ol_preciplbr), NULL),
			('ol_prerom', bin.decode('vital','births','ol_prerom',ol_prerom), NULL),
			('ol_prolonglbr', bin.decode('vital','births','ol_prolonglbr',ol_prolonglbr), NULL),
--			('oz', bin.decode('vital','births','oz',oz), NULL),
			('pat_complete', bin.decode('vital','births','pat_complete',pat_complete), NULL),
			('place', bin.decode('vital','births','place',place), NULL),
			('plurality', CAST(plurality AS VARCHAR(255)), NULL),
			('pre_begda', CAST(pre_begda AS VARCHAR(255)), NULL),
			('pre_begin', CAST(pre_begin AS VARCHAR(255)), NULL),
			('pre_begmo', CAST(pre_begmo AS VARCHAR(255)), NULL),
			('pre_begyr', CAST(pre_begyr AS VARCHAR(255)), NULL),
			('pre_end',   CAST(pre_end AS VARCHAR(255)), NULL),
			('pre_endda', CAST(pre_endda AS VARCHAR(255)), NULL),
			('pre_endmo', CAST(pre_endmo AS VARCHAR(255)), NULL),
			('pre_endyr', CAST(pre_endyr AS VARCHAR(255)), NULL),
			('prenatal', bin.decode('vital','births','prenatal',prenatal), NULL),
			('prepreg_cig', bin.decode('vital','births','prepreg_cig',prepreg_cig), NULL),
			('prepreg_pck', bin.decode('vital','births','prepreg_pck',prepreg_pck), NULL),
			('prepreg_wt', bin.decode('vital','births','prepreg_wt',prepreg_wt), 'lbs'),
			('prv_livebth', bin.decode('vital','births','prv_livebth',prv_livebth), NULL),
			('prv_livebthdte', CAST(prv_livebthdte AS VARCHAR(255)), NULL),
			('prv_term', bin.decode('vital','births','prv_term',prv_term), NULL),
			('pv_trims_cal', bin.decode('vital','births','pv_trims_cal',pv_trims_cal), NULL),
			('reg_da',   CAST(reg_da AS VARCHAR(255)), NULL),
			('reg_date', CAST(reg_date AS VARCHAR(255)), NULL),
			('reg_mo',   CAST(reg_mo AS VARCHAR(255)), NULL),
			('reg_yr',   CAST(reg_yr AS VARCHAR(255)), NULL),
			('sec_cig', bin.decode('vital','births','sec_cig',sec_cig), NULL),
			('sec_pck', bin.decode('vital','births','sec_pck',sec_pck), NULL),
			('sex', bin.decode('vital','births','sex',sex), NULL),
			('source_pay', bin.decode('vital','births','source_pay',source_pay), NULL),
-- identifiable
--			('ssn_child', bin.decode('vital','births','ssn_child',ssn_child), NULL),
			('ssn_date', CAST(ssn_date AS VARCHAR(255)), NULL),
			('ssn_request', bin.decode('vital','births','ssn_request',ssn_request), NULL),
			('term_dte', CAST(term_dte AS VARCHAR(255)), NULL),
			('tobacco', bin.decode('vital','births','tobacco',tobacco), NULL),
			('tot_visits', bin.decode('vital','births','tot_visits',tot_visits), NULL),
			('trial_lbr', bin.decode('vital','births','trial_lbr',trial_lbr), NULL),
--			('void', bin.decode('vital','births','void',void), NULL),
			('wic', bin.decode('vital','births','wic',wic), NULL),
			('wt_gain', bin.decode('vital','births','wt_gain',wt_gain), 'lbs'),

			('DEM:DOB', CAST(bth_date AS VARCHAR(255)), NULL),
			('birth_qtr',CAST(DATEPART(q,bth_date) AS VARCHAR(255)),NULL),
			('DEM:ZIP', CAST(mom_rzip AS VARCHAR(255)), NULL),
			('DEM:Weight', CAST(grams AS VARCHAR(255)), 'grams'),
			('DEM:Weight', CAST(
				bin.weight_from_lbs_and_oz( lbs, oz ) AS VARCHAR(255)), 'lbs')
		) cav ( concept, value, units )
		WHERE cav.value IS NOT NULL

	UPDATE b
		SET imported_to_dw = 'TRUE'
		FROM vital.births b
		JOIN private.identifiers i
			ON  i.source_id     = b.cert_year_num
			AND i.source_column = 'cert_year_num'
			AND i.source_table  = 'births'
			AND i.source_schema = 'vital'
		WHERE imported_to_dw = 'FALSE'
			AND i.id IS NOT NULL

END -- CREATE PROCEDURE bin.import_into_data_warehouse_by_table_vital_births
GO


IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse_by_schema;
GO
CREATE PROCEDURE bin.import_into_data_warehouse_by_schema( @schema VARCHAR(50) )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @table VARCHAR(250)
	DECLARE @proc VARCHAR(250)

	DECLARE tables CURSOR FOR SELECT t.name
		FROM sys.tables AS t
		INNER JOIN sys.schemas AS s
		ON t.schema_id = s.schema_id
		WHERE s.name = @schema;

	OPEN tables
	WHILE(1=1)BEGIN
		FETCH tables INTO @table;
		IF(@@FETCH_STATUS <> 0) BREAK

		SET @proc = 'bin.import_into_data_warehouse_by_table_' + @schema + '_' + @table

		IF OBJECT_ID ( @proc, 'P' ) IS NOT NULL
		BEGIN
--			PRINT 'Importing select fields from ' + @schema + '.' + @table
			EXEC @proc
		END
--		ELSE
--			PRINT 'Ignoring table ' + @schema + '.' + @table

	END
	CLOSE tables;
	DEALLOCATE tables;

END	--	bin.import_into_data_warehouse_by_schema
GO

IF OBJECT_ID ( 'bin.import_into_data_warehouse', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse;
GO
CREATE PROCEDURE bin.import_into_data_warehouse
AS
BEGIN
	SET NOCOUNT ON;

--	DECLARE @schemas TABLE ( name VARCHAR(50) )
--	INSERT INTO @schemas VALUES ( 'vital' )
--
--	DECLARE schemas CURSOR FOR SELECT s.name FROM @schemas s
--
--	DECLARE @schema VARCHAR(50)
--
--	OPEN schemas
--	WHILE(1=1)BEGIN
--		FETCH schemas INTO @schema;
--		IF(@@FETCH_STATUS <> 0) BREAK
--		PRINT @schema
--		EXEC bin.import_into_data_warehouse_by_schema @schema

		--Until there are more than a dozen, this above is a bit excessive!
		EXEC bin.import_into_data_warehouse_by_schema 'vital'
		EXEC bin.import_into_data_warehouse_by_schema 'health_lab'
		EXEC bin.import_into_data_warehouse_by_schema 'fakedoc1'

--	END
--	CLOSE schemas;
--	DEALLOCATE schemas;

END	--	bin.import_into_data_warehouse
GO











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




IF OBJECT_ID ( 'bin.link_screening_records_to_screening_records', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.link_screening_records_to_screening_records;
GO
CREATE PROCEDURE bin.link_screening_records_to_screening_records
AS
BEGIN
	SET NOCOUNT ON;

	SELECT i1.chirp_id,
		s1.mom_birth_date, s2.mom_birth_date, s1.last_name, s2.last_name,
		s1.first_name, s2.first_name, s1.mom_surname, s2.mom_surname,
		s1.address, s2.address, s1.zip_code, s2.zip_code
	FROM private.identifiers i1

	JOIN health_lab.newborn_screenings s1
		ON i1.source_id = s1.accession_kit_number
	JOIN health_lab.newborn_screenings s2
		ON  s1.patient_id  = s2.patient_id
		AND s1.birth_date  = s2.birth_date
		AND s1.mom_surname = s2.mom_surname
	LEFT JOIN private.identifiers i2
		ON  i2.source_id     = s2.accession_kit_number
		AND i2.source_schema = 'health_lab'
		AND i2.source_table  = 'newborn_screenings'
		AND i2.source_column = 'accession_kit_number'

	WHERE i1.source_schema = 'health_lab'
		AND i1.source_table  = 'newborn_screenings'
		AND i1.source_column = 'accession_kit_number'
		AND i2.chirp_id IS NULL
	ORDER BY i1.chirp_id

END	--	bin.link_screening_records_to_screening_records
GO

