USE master;
IF db_id('chirp_dev1') IS NOT NULL
	DROP DATABASE chirp_dev1;
CREATE DATABASE chirp_dev1;
GO
USE chirp_dev1
GO

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


--Database diagram support objects cannot be installed because this database does not have a valid owner. To continue, first use the Files page of the Database Properties dialog box or the ALTER AUTHORIZATION statement to set the database owner to a valid login, then add the database diagram support objects.
--Wanted to see these Database Diagrams and this seemed to work.
--This changes the database owner to [sa]. I'd prefer to keep it.
--ALTER AUTHORIZATION ON DATABASE::chirp TO [sa];





IF OBJECT_ID ( 'bin.add_imported_at_column_to_table', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_at_column_to_table;
GO
CREATE PROCEDURE bin.add_imported_at_column_to_table(@schema VARCHAR(255),@table VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @cmd VARCHAR(255);
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

	DECLARE @cmd VARCHAR(255);
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







--IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_table_health_lab_newborn_screening', 'P' ) IS NOT NULL
--	DROP PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screening;
--GO
--CREATE PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screening
--AS
--BEGIN
--	SET NOCOUNT ON;
--
--	INSERT INTO dbo.observations
--		(chirp_id, provider_id, started_at,
--			concept, value, units, source_schema, source_table, downloaded_at)
--		SELECT chirp_id, provider_id, started_at,
--			cav.concept, cav.value, cav.units, source_schema, source_table, downloaded_at
--		FROM (
--			SELECT i.chirp_id, n.date_of_birth AS started_at,
--				'789' AS provider_id,
--				testresults1, testresults2, testresults3, testresults4, testresults5,
--				'health_lab' AS source_schema,
--				'newborn_screening' AS source_table,
--				n.imported_at AS downloaded_at
--			FROM health_lab.newborn_screening n
--			JOIN private.identifiers i
--				ON    i.source_id     = n.id
--					AND i.source_column = 'id'
--					AND i.source_table  = 'newborn_screening'
--					AND i.source_schema = 'health_lab'
--			WHERE n.imported_to_dw = 'FALSE'
--		) unimported_newborn_screening_data
--		CROSS APPLY ( VALUES
--			( 'TR1', testresults1, 'cm' ),
--			( 'TR2', testresults2, 'in' ),
--			( 'TR3', testresults3, 'Degrees' ),
--			( 'TR4', testresults4, 'mm Hg' ),
--			( 'TR5', testresults5, '%' )
--		) cav ( concept, value, units )
--		WHERE cav.value IS NOT NULL
--
--	UPDATE n
--		SET imported_to_dw = 'TRUE'
--		FROM health_lab.newborn_screening n
--		JOIN private.identifiers i
--			ON  i.source_id     = n.id
--			AND i.source_column = 'id'
--			AND i.source_table  = 'newborn_screening'
--			AND i.source_schema = 'health_lab'
--		WHERE imported_to_dw = 'FALSE'
--			AND i.id IS NOT NULL
--
--END	--	CREATE PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screening
--GO



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
		) unimported_birth_record_data
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
			('mom_rzip', bin.decode('vital','births','mom_rzip',mom_rzip), NULL),
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
			('plurality', bin.decode('vital','births','plurality',plurality), NULL),
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
			AND field = @codeset

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
			"Manually : "+@schema1+" "+@table1+" "+@column1+" "+@value1
		FROM private.identifiers i
		WHERE i.source_schema = @schema1
			AND i.source_table  = @table1
			AND i.source_column = @column1
			AND i.source_id     = @value1

END	--	bin.manually_link
GO



IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='private')
	EXEC('CREATE SCHEMA private')
GO
IF OBJECT_ID('private.identifiers', 'U') IS NOT NULL
	DROP TABLE private.identifiers;
CREATE TABLE private.identifiers (
	id INT IDENTITY(1,1),
	CONSTRAINT private_identifiers_id PRIMARY KEY CLUSTERED (id ASC),
	chirp_id      INT NOT NULL,
	source_schema VARCHAR(50) NOT NULL,
	source_table  VARCHAR(50) NOT NULL,
	source_column VARCHAR(50) NOT NULL,
	source_id     VARCHAR(255) NOT NULL,
	match_method  VARCHAR(255),
	created_at    DATETIME 
		CONSTRAINT private_identifiers_created_at_default 
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT unique_source_identifiers
		UNIQUE (source_schema,source_table,source_column,source_id)
);
GO
--4*255=1020. Its unlikely that any of these will be 255 chars. Shrinking.
--Warning! The maximum key length is 900 bytes. The index 'unique_source_identifiers' has maximum length of 1020 bytes. For some combination of large values, the insert/update operation will fail.


--Can't use RAND() in function. This is a workaround.
--http://blog.sqlauthority.com/2012/11/20/sql-server-using-rand-in-user-defined-functions-udf/
IF OBJECT_ID ( 'private.rand_view', 'V' ) IS NOT NULL
	DROP VIEW private.rand_view;
GO
CREATE VIEW private.rand_view AS SELECT RAND() AS number
GO

IF OBJECT_ID ( 'private.create_unique_chirp_id', 'FN' ) IS NOT NULL
	DROP FUNCTION private.create_unique_chirp_id;
GO
CREATE FUNCTION private.create_unique_chirp_id()
	RETURNS INT
BEGIN
	DECLARE @minid INT = 1e9;
	DECLARE @maxid INT = POWER(2.,31)-1;
	DECLARE @tempid INT = 0;
	DECLARE @rand DECIMAL(18,18)

	WHILE ((@tempid = 0) OR
		EXISTS (SELECT * FROM private.identifiers WHERE chirp_id=@tempid))
	BEGIN
		SELECT @rand = number FROM private.rand_view
		-- By using a min of 1e9, no need for leading zeroes.
		SET @tempid = CAST(
			(@minid + (@rand * (@maxid-@minid)))
			AS INTEGER);
	END

	RETURN @tempid
END
GO


IF OBJECT_ID('dbo.concepts', 'U') IS NOT NULL
	DROP TABLE dbo.concepts;
CREATE TABLE dbo.concepts (
	id INT IDENTITY(1,1),
	code VARCHAR(255),
	CONSTRAINT concept_code PRIMARY KEY CLUSTERED (code ASC),
	path VARCHAR(255),	-- Remnant from I2B2. Will we have a use for this?
	description VARCHAR(MAX)
);

--	CONSTRAINT unique_code 
--		UNIQUE (code)	-- Is this necessary? No
-- Examples:
-- code: ICD10CM:M71.432, description: Calcium deposit in bursa, left wrist
-- code: HCPC:0356T, description: INSERTION OF DRUG-ELUTING IMPLANT ....
-- code: LOINC:8302-2, description: Body Height (LOINC:8302-2)
-- code: LOINC:3141-9, description: Body Weight (LOINC:3141-9)
-- code: DEM:Race, description: Race
-- code: DEM:Language, description: Language


--BULK INSERT requires a format file? for column selection
--Using a view works just as well.
IF OBJECT_ID ( 'dbo.cc', 'V' ) IS NOT NULL
	DROP VIEW dbo.cc;
GO
CREATE VIEW dbo.cc AS SELECT code, path, description FROM dbo.concepts;
GO


-- ll *concept_codes.csv
-- -rwx------ 1 jakewendt  2105675 Mar 17 12:59 hcpc_concept_codes.csv
-- -rwx------ 1 jakewendt  7869583 Mar 17 12:59 icd10dx_concept_codes.csv
-- -rwx------ 1 jakewendt  1023195 Apr 28 13:04 icd10pcs_concept_codes.csv
-- -rwx------ 1 jakewendt  1223532 Mar 17 12:59 icd9dx_concept_codes.csv
-- -rwx------ 1 jakewendt   267271 Mar 17 12:59 icd9sg_concept_codes.csv
-- -rwx------ 1 jakewendt 16960137 Mar 17 12:59 ndc_concept_codes.csv
-- cat *concept_codes.csv > ../all_concept_codes.csv

--
--  14567 ICD9DX
--   3882 ICD9SG
--  18449 subtotal
--
--  16710 HCPC
--  69834 ICD10DX
--      5 DEM (manually added for testing)
--  86549 subtotal
--
--   2026 ICD10 PCS
-- 107024 subtotal
--
-- 192355 NDC
-- -   18 NDC duplicates extras
-- -    2 NDC triplicate extras
-- 299359 subTOTAL concepts
--
--	     2 2 more DEM codes, Language and Zipcode
-- 299361 TOTAL concepts
--

--UNIX line feeds don\'t work well in MS so need dynamic sql 
--However, ALL the double quotes in the description are preserved
--This would require a series of UPDATEs, STUFFs and/or REPLACEs.
--Still faster that dealing with SSIS.
--	FROM ''C:\Users\gwendt\Desktop\all_concept_codes.csv''
BEGIN TRY
	--A GO call apparently undeclare variables, so redeclare here
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT cc
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\all_concept_codes.csv''
	WITH (
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = '''+CHAR(10)+''',
		TABLOCK
	)';
	EXEC(@bulk_cmd);
END TRY BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH
IF OBJECT_ID ( 'dbo.cc', 'V' ) IS NOT NULL
	DROP VIEW dbo.cc;	-- only needed this for the import.
GO

--
-- FIXED
--
--The ICD10PCS codes weren't trimmed far enough so will end
--up with a leading double quote. Removing it here.
--UPDATE dbo.concepts
--	SET path = STUFF(path, 1,1,'')
--	WHERE path LIKE '"%';


-- some of these records are actually wrapped in a quotes
-- ->"blah blah blah ""something quoted"" blah blah"<-
-- so replace the wrappers together

UPDATE dbo.concepts
	SET description = SUBSTRING ( description, 2, LEN(description)-2 )
	WHERE description LIKE '"%"';

-- and the double double quotes LAST
-- ->blah blah blah ""something quoted"" blah blah<-
UPDATE dbo.concepts
	SET description = REPLACE(description, '""', '"')
	WHERE description LIKE '%""%';
















IF OBJECT_ID('dbo.providers', 'U') IS NOT NULL
	DROP TABLE dbo.providers;
CREATE TABLE dbo.providers (
	id INT IDENTITY(1,1),
	CONSTRAINT provider_id PRIMARY KEY CLUSTERED (id ASC)
);



/*

--Not sure what purpose this table can serve.

IF OBJECT_ID('dbo.encounters', 'U') IS NOT NULL
	DROP TABLE dbo.encounters;
CREATE TABLE dbo.encounters (
	id INT IDENTITY(1,1),
	CONSTRAINT encounter_id PRIMARY KEY CLUSTERED (id ASC)
);
*/



/*
IF OBJECT_ID('dbo.locations', 'U') IS NOT NULL
	DROP TABLE dbo.locations;
CREATE TABLE dbo.locations (
	id INT IDENTITY(1,1),
	CONSTRAINT location_id PRIMARY KEY CLUSTERED (id ASC)
);
*/




--Can't declare foreign key constraints until those tables exist.
IF OBJECT_ID('dbo.observations', 'U') IS NOT NULL
	DROP TABLE dbo.observations;
CREATE TABLE dbo.observations (
	id INT IDENTITY(1,1),
	CONSTRAINT observation_id PRIMARY KEY CLUSTERED (id ASC),

	chirp_id        INT NOT NULL,
--	encounter_id    INT NOT NULL,
	provider_id     INT NOT NULL,
--	location_id     INT NOT NULL,
	concept         VARCHAR(255) NOT NULL,
	started_at      DATETIME NOT NULL,
	ended_at        DATETIME,
--	value_type      VARCHAR(1) NOT NULL,
--	n_value         DECIMAL(18,5),
--	s_value         VARCHAR(255),
--	l_value         VARCHAR(MAX),
--	d_value         DATE,
--	t_value         DATETIME,
	value           VARCHAR(255),
	units           VARCHAR(20),
	downloaded_at   DATETIME,
	source_schema   VARCHAR(50) NOT NULL,
	source_table    VARCHAR(50) NOT NULL,
	source_id       INT NOT NULL,
	imported_at     DATETIME
		CONSTRAINT dbo_observations_imported_at_default 
		DEFAULT CURRENT_TIMESTAMP NOT NULL,

--	CONSTRAINT fk_encounter_id
--		FOREIGN KEY (encounter_id) REFERENCES encounters(id),
--	CONSTRAINT fk_provider_id
--		FOREIGN KEY (provider_id) REFERENCES providers(id),
--	CONSTRAINT fk_location_id
--		FOREIGN KEY (location_id) REFERENCES locations(id),

--Temporarily skip concept codes
--	CONSTRAINT fk_concept_code
--		FOREIGN KEY (concept) REFERENCES concepts(code)

);

/*

ALTER TABLE dbo.observations NOCHECK CONSTRAINT fk_concept_code;
-- remove old and add new records
ALTER TABLE dbo.observations CHECK CONSTRAINT fk_concept_code;

--OR?

ALTER TABLE dbo.observations DROP CONSTRAINT fk_concept_code;
-- remove old and add new records
ALTER TABLE dbo.observations ADD CONSTRAINT fk_concept_code
	FOREIGN KEY (concept) REFERENCES concepts(code);


*/

--This would have been nice, but the referenced column
--	must be unique and this is not the case.
--
--There are no primary or candidate keys in the referenced table 'private.identifiers' 
--	that match the referencing column list in the foreign key 'fk_chirp_id'.
--
--ALTER TABLE dbo.observations ADD
--	CONSTRAINT fk_chirp_id
--		FOREIGN KEY (chirp_id) 
--		REFERENCES private.identifiers(chirp_id)
--
--Thought this would work, but no. 
--Subqueries are not allowed in this context. Only scalar expressions are allowed.
--
--ALTER TABLE dbo.observations 
--	ADD CONSTRAINT valid_chirp_id 
--	CHECK (chirp_id in (SELECT DISTINCT chirp_id FROM private.identifiers))
--

/*
-- These could have been included in the CREATE
ALTER TABLE dbo.observations ADD CONSTRAINT ck_value_type CHECK (
	value_type IN ('N','T','S')
--	value_type IN ('N','D','T','S','L')
);
ALTER TABLE dbo.observations ADD CONSTRAINT ck_n_value CHECK (
	( value_type <> 'N' AND n_value IS NULL ) OR
	( value_type = 'N' AND n_value IS NOT NULL )
);
--ALTER TABLE dbo.observations ADD CONSTRAINT ck_d_value CHECK (
--	( value_type <> 'D' AND d_value IS NULL ) OR
--	( value_type = 'D' AND d_value IS NOT NULL )
--);
ALTER TABLE dbo.observations ADD CONSTRAINT ck_t_value CHECK (
	( value_type <> 'T' AND t_value IS NULL ) OR
	( value_type = 'T' AND t_value IS NOT NULL )
);
-- The s_value can contain data when not Short Text type.
ALTER TABLE dbo.observations ADD CONSTRAINT ck_s_value CHECK (
	( value_type <> 'S' ) OR
	( value_type = 'S' AND s_value IS NOT NULL )
);
-- Can the l_value contain data when not Long Text type?
--ALTER TABLE dbo.observations ADD CONSTRAINT ck_l_value CHECK (
--	( value_type <> 'L' AND l_value IS NULL ) OR
--	( value_type = 'L' AND l_value IS NOT NULL )
--);
*/


-- SCHEMA, TABLE, GROUP and GROUPING are reserved words
IF OBJECT_ID('dbo.codes', 'U') IS NOT NULL
	DROP TABLE dbo.codes;
CREATE TABLE dbo.codes (
	_schema VARCHAR(50) NOT NULL,
	_table VARCHAR(50) NOT NULL,
	codeset VARCHAR(50) NOT NULL,
--	code INT NOT NULL,
	code VARCHAR(5) NOT NULL,	-- Some of the CDC Race Codes start with a letter
	value VARCHAR(255) NOT NULL, 	-- Isn't this comma needed?
	CONSTRAINT codes_unique_schema_table_codeset_code
		UNIQUE ( _schema, _table, codeset, code )
);
-- FYI The maximum key length is 900 bytes. For some combination of large values, the insert/update operation will fail.
IF OBJECT_ID ( 'dbo.bulk_insert_codes', 'V' ) IS NOT NULL
	DROP VIEW dbo.bulk_insert_codes;
GO
CREATE VIEW dbo.bulk_insert_codes AS SELECT code, value FROM dbo.codes;
GO




IF OBJECT_ID('dbo.dictionary', 'U') IS NOT NULL
	DROP TABLE dbo.dictionary;
CREATE TABLE dbo.dictionary (
	_schema VARCHAR(50) NOT NULL,
	_table VARCHAR(50) NOT NULL,
	field VARCHAR(50) NOT NULL,
	codeset VARCHAR(50),
--	concept VARCHAR(255),	-- add concept?
	label VARCHAR(255),
--	definition VARCHAR(255),
	description VARCHAR(MAX),	-- very verbose
	CONSTRAINT dictionary_unique_schema_table_field
		UNIQUE ( _schema, _table, field ),
	CONSTRAINT dictionary_unique_schema_table_field_codeset
		UNIQUE ( _schema, _table, field, codeset )
);

-- These files were created from a Windows file and hence had hidden CRLFs!
-- Had to "sed 's/^M//' birth_dictionary.csv" them to correct.

--BEGIN TRY
--		FIELDTERMINATOR = '','',
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT dbo.dictionary
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\birth_dictionary.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
--END TRY BEGIN CATCH
--	PRINT ERROR_MESSAGE()
--END CATCH
GO

--BEGIN TRY
--		FIELDTERMINATOR = '','',
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT dbo.dictionary
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\death_dictionary.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
--END TRY BEGIN CATCH
--	PRINT ERROR_MESSAGE()
--END CATCH
GO


IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='vital')
	EXEC('CREATE SCHEMA vital')
GO



-- This could cause issue inserting?
-- What if we get an updated record?
--	CONSTRAINT vital_births_cert_yr_cert_num
--		UNIQUE ( cert_yr, cert_num ),	
IF OBJECT_ID('vital.births', 'U') IS NOT NULL
	DROP TABLE vital.births;
CREATE TABLE vital.births (
	id INT IDENTITY(1,1),
	CONSTRAINT vital_births_id PRIMARY KEY CLUSTERED (id ASC),
	cert_yr INT,
	cert_num INT,
	void INT,
	name_sur VARCHAR(50),
	name_sux VARCHAR(50),
	name_fir VARCHAR(50),
	name_mid VARCHAR(50),
	sex INT,
	bth_date DATE,
	birth_mo INT,
	birth_da INT,
	birth_yr INT,
	bth_time INT,
	place INT,
	facility INT,
	birth_st INT,
	birth_ci INT,
	birth_co INT,
	attendant INT,
	mom_snam VARCHAR(50),
	mom_xnam VARCHAR(50),
	mom_fnam VARCHAR(50),
	mom_mnam VARCHAR(50),
	maiden_n VARCHAR(50),
	mom_dob DATE,
	mom_age INT,
	mom_age1 INT,
	mom_bst INT,
	mom_bthcntry_fips VARCHAR(2),
	mom_bthstate_fips VARCHAR(2),
	mom_rst INT,
	mom_rci INT,
	mom_rco INT,
	mom_address VARCHAR(250),
	mom_apt INT,
	mom_rzip INT,
	incity INT,
	mres_cntry_fips VARCHAR(2),
	mres_st_fips VARCHAR(2),
	mres_city_fips INT,
	mres_cnty_fips INT,
	mom_edu INT,
	mom_occ INT,
	mom_occup1 INT,
	mom_bus INT,
	mom_busines1 INT,
	mom_ssn VARCHAR(9),
	fa_sname VARCHAR(50),
	fa_xname VARCHAR(50),
	fa_fname VARCHAR(50),
	fa_mname VARCHAR(50),
	fa_dob DATE,
	fa_age INT,
	fa_age1 INT,
	fa_bst INT,
	fa_edu INT,
	fa_occ INT,
	fa_occup1 INT,
	fa_bus INT,
	fa_busines1 INT,
	fa_ssn VARCHAR(9),
	mom_everm INT,
	married_betw INT,
	fa_husb INT,
	fa_signpat INT,
	pat_complete INT,
	lm_date DATE,
	lm_mo INT,
	lm_da INT,
	lm_yr INT,
	prenatal INT,
	pre_begin DATE,
	pre_begmo INT,
	pre_begda INT,
	pre_begyr INT,
	pre_end DATE,
	pre_endmo INT,
	pre_endda INT,
	pre_endyr INT,
	tot_visits INT,
	gest_est INT,
	gest_days INT,
	dat_concep DATE,
	mpv_days_cal INT,
	mpv_cal INT,
	pv_trims_cal INT,
	mom_htft INT,
	mom_htinch INT,
	prepreg_wt INT,
	del_wt INT,
	wt_gain INT,
	prv_livebth INT,
	prv_livebthdte VARCHAR(15),	--badly coded dates
	live_bthliv INT,
	live_bthdead INT,
	prv_term INT,
	term_dte VARCHAR(15),	--badly coded dates 112003
	tobacco INT,
	cig_pck INT,
	prepreg_cig INT,
	prepreg_pck INT,
	first_cig INT,
	first_pck INT,
	sec_cig INT,
	sec_pck INT,
	last_cig INT,
	last_pck INT,
	alcohol INT,
	drink_wk INT,
	drug_use INT,
	du_prscr INT,
	du_otc INT,
	du_other INT,
	du_otherlit VARCHAR(50),
	mrf_none INT,
	mrf_prediab INT,
	mrf_gestdiab INT,
	mrf_hypert INT,
	mrf_hypertchr INT,
	mrf_hypergest INT,
	mrf_eclampsia INT,
	mrf_prevpreterm INT,
	mrf_poorout INT,
	mrf_inftreat INT,
	mrf_infdrugs INT,
	mrf_assistrep INT,
	mrf_prevces INT,
	mrf_prevcesnum INT,
	mrf_anemia INT,
	mrf_cardiac INT,
	mrf_lungdis INT,
	mrf_hydra INT,
	mrf_hemoglob INT,
	mrf_incompcerv INT,
	mrf_prev4000 INT,
	mrf_renaldis INT,
	mrf_rhsensit INT,
	mrf_utbleed INT,
	mrf_oth INT,
	mrf_othlit VARCHAR(50),
	inf_none INT,
	inf_gonor INT,
	inf_syph INT,
	inf_chlam INT,
	inf_hepb INT,
	inf_hepc INT,
	inf_hpv INT,
	inf_hivaids INT,
	inf_cmv INT,
	inf_rubella INT,
	inf_toxo INT,
	inf_genherpes INT,
	inf_tuber INT,
	inf_oth INT,
	inf_othlit VARCHAR(50),
	ob_none INT,
	ob_cercl INT,
	ob_toco INT,
	ob_amnio INT,
	ob_fetalmon INT,
	ob_cephsucess INT,
	ob_cephfail INT,
	ob_ultrasnd INT,
	ob_oth INT,
	ob_othlit VARCHAR(50),
	ol_none INT,
	ol_prerom INT,
	ol_preciplbr INT,
	ol_prolonglbr INT,
	cld_none INT,
	cld_induc INT,
	cld_aug INT,
	cld_nonvert INT,
	cld_steroid INT,
	cld_antibiotic INT,
	cld_chorio INT,
	cld_mecon INT,
	cld_fetalintol INT,
	cld_epi INT,
	cld_febrile INT,
	cld_abrplac INT,
	cld_placprev INT,
	cld_bleed INT,
	cld_seizures INT,
	cld_dysfunc INT,
	cld_cephpelv INT,
	cld_cordpro INT,
	cld_anesth INT,
	cld_oth INT,
	cld_othlit VARCHAR(50),
	md_forcepsattpt INT,
	md_vaccumattpt INT,
	bth_present INT,
	bth_route INT,
	trial_lbr INT,
	mm_none INT,
	mm_trnsfusion INT,
	mm_perilac INT,
	mm_ruputerus INT,
	mm_hyster INT,
	mm_icu INT,
	mm_unploper INT,
	mm_unk INT,
	apgar_5 INT,
	apgar_10 INT,
	gest_wks INT,
	gest_grp INT,
	bthwt_unit INT,
	grams INT,
	lbs INT,
	oz INT,
	bwt_grp INT,
	plurality INT,
	bth_order INT,
	born_alive INT,
	match_certnum INT,
	ac_none INT,
	ac_ventless INT,
	ac_ventmore INT,
	ac_nicu INT,
	ac_surf INT,
	ac_antisepis INT,
	ac_seizures INT,
	ac_anemia INT,
	ac_fas INT,
	ac_hyaline INT,
	ac_mecon INT,
	ac_bthinjury INT,
	ac_oth INT,
	ac_othlit VARCHAR(50),
	acn_none INT,
	acn_anencep INT,
	acn_spina INT,
	acn_micro INT,
	acn_nervous INT,
	acn_nervouslit VARCHAR(50),
	acn_hrtdis INT,
	acn_hrtmal INT,
	acn_circ INT,
	acn_cirlit VARCHAR(50),
	acn_omphal INT,
	acn_gastrosch INT,
	acn_rectal INT,
	acn_tracheo INT,
	acn_gastro INT,
	acn_gastrolit VARCHAR(50),
	acn_limbred INT,
	acn_cleftlip INT,
	acn_cleftpalate INT,
	acn_polydact INT,
	acn_clubft INT,
	acn_diaphhern INT,
	acn_muscle INT,
	acn_musclelit VARCHAR(50),
	acn_malgen INT,
	acn_renal INT,
	acn_hypos INT,
	acn_urogen INT,
	acn_urogenlit VARCHAR(50),
	acn_downs INT,
	acn_cdit INT,
	acn_chromoth INT,
	acn_chromothlit VARCHAR(50),
	acn_oth INT,
	acn_othlit VARCHAR(50),
	certifier INT,
	cer_date DATE,
	reg_date DATE,
	cer_yr INT,
	cer_mo INT,
	cer_da INT,
	reg_mo INT,
	reg_da INT,
	reg_yr INT,
	wic INT,
	source_pay INT,
	breastfeeding INT,
	inf_liv INT,
	inf_trans INT,
	mom_trans INT,
	ssn_request INT,
	ssn_child VARCHAR(9),
	ssn_date DATE,
	inf_hospnum VARCHAR(20),
	mom_hospnum VARCHAR(20),
	mom_his INT,
	mom_mex INT,
	mom_pr INT,
	mom_cu INT,
	mom_ethoth INT,
	mom_ethothlit VARCHAR(50),
	mom_white INT,
	mom_black INT,
	mom_amind INT,
	mom_amindlit VARCHAR(50),
	mom_asian INT,
	mom_asianoth INT,
	mom_asianlit VARCHAR(50),
	mom_chinese INT,
	mom_filipino INT,
	mom_japanese INT,
	mom_korean INT,
	mom_vietnamese INT,
	mom_hawaiian INT,
	mom_guam INT,
	mom_samoan INT,
	mom_pacisl INT,
	mom_pacisllit VARCHAR(50),
	mom_raceoth INT,
	mom_raceothlit VARCHAR(50),
	mom_raceunk INT,
	mom_raceref INT,
	mom_race1 INT,
	mom_race2 INT,
	mom_race3 INT,
	mom_race4 INT,
	mom_race5 INT,
	mom_race6 INT,
	mom_race7 INT,
	mom_race8 INT,
	mom_race16 INT,
	filler7 INT,
	mom_race18 INT,
	filler8 INT,
	mom_race20 INT,
	filler9 INT,
	mom_race22 INT,
	filler10 INT,
	momhisp_nchs INT,
	mom_ethnic_nchs INT,
	momrace_nchsbrg INT,
	momrace_ethnchs INT,
	fa_his INT,
	fa_mex INT,
	fa_pr INT,
	fa_cu INT,
	fa_ethoth INT,
	fa_ethothlit VARCHAR(50),
	fa_white INT,
	fa_black INT,
	fa_amind INT,
	fa_amindlit VARCHAR(50),
	fa_asian INT,
	fa_asianoth INT,
	fa_asianlit VARCHAR(50),
	fa_chinese INT,
	fa_filipino INT,
	fa_japanese INT,
	fa_korean INT,
	fa_vietnamese INT,
	fa_hawaiian INT,
	fa_guam INT,
	fa_samoan INT,
	fa_pacisl INT,
	fa_pacisllit VARCHAR(50),
	fa_raceoth INT,
	fa_raceothlit VARCHAR(50),
	fa_raceunk INT,
	fa_raceref INT,
	fa_race1 INT,
	fa_race2 INT,
	fa_race3 INT,
	fa_race4 INT,
	fa_race5 INT,
	fa_race6 INT,
	fa_race7 INT,
	fa_race8 INT,
	fa_race16 INT,
	filler14 INT,
	fa_race18 INT,
	filler15 INT,
	fa_race20 INT,
	filler16 INT,
	fa_race22 INT,
	filler17 INT,
	fahisp_nchs INT,
	fa_ethnic_nchs INT,
	farace_nchsbrg INT,
	farace_ethnchs INT,
	death_match INT,
	death_cert INT,
	death_date INT,
	birth_rco INT,
	source_filename VARCHAR(255),
	source_record_number INT,
--	imported_at DATETIME
--		CONSTRAINT vital_births_imported_at_default DEFAULT CURRENT_TIMESTAMP NOT NULL,
--	imported_to_dw BIT
--		CONSTRAINT vital_births_imported_to_dw_default DEFAULT 'FALSE' NOT NULL,
);
GO





IF OBJECT_ID('vital.births_buffer', 'U') IS NOT NULL
	DROP TABLE vital.births_buffer;
CREATE TABLE vital.births_buffer (
--	id INT IDENTITY(1,1),
--	CONSTRAINT vital_births_id PRIMARY KEY CLUSTERED (id ASC),
	cert_yr INT,
	cert_num INT,
-- This could cause issue inserting?
-- What if we get an updated record?
--	CONSTRAINT vital_births_cert_yr_cert_num
--		UNIQUE ( cert_yr, cert_num ),	
	void INT,
	name_sur VARCHAR(50),
	name_sux VARCHAR(50),
	name_fir VARCHAR(50),
	name_mid VARCHAR(50),
	sex INT,
	bth_date DATE,
	birth_mo INT,
	birth_da INT,
	birth_yr INT,
	bth_time INT,
	place INT,
	facility INT,
	birth_st INT,
	birth_ci INT,
	birth_co INT,
	attendant INT,
	mom_snam VARCHAR(50),
	mom_xnam VARCHAR(50),
	mom_fnam VARCHAR(50),
	mom_mnam VARCHAR(50),
	maiden_n VARCHAR(50),
	mom_dob DATE,
	mom_age INT,
	mom_age1 INT,
	mom_bst INT,
	mom_bthcntry_fips VARCHAR(2),
	mom_bthstate_fips VARCHAR(2),
	mom_rst INT,
	mom_rci INT,
	mom_rco INT,
	mom_address VARCHAR(250),
	mom_apt INT,
	mom_rzip INT,
	incity INT,
	mres_cntry_fips VARCHAR(2),
	mres_st_fips VARCHAR(2),
	mres_city_fips INT,
	mres_cnty_fips INT,
	mom_edu INT,
	mom_occ INT,
	mom_occup1 INT,
	mom_bus INT,
	mom_busines1 INT,
	mom_ssn VARCHAR(9),
	fa_sname VARCHAR(50),
	fa_xname VARCHAR(50),
	fa_fname VARCHAR(50),
	fa_mname VARCHAR(50),
	fa_dob DATE,
	fa_age INT,
	fa_age1 INT,
	fa_bst INT,
	fa_edu INT,
	fa_occ INT,
	fa_occup1 INT,
	fa_bus INT,
	fa_busines1 INT,
	fa_ssn VARCHAR(9),
	mom_everm INT,
	married_betw INT,
	fa_husb INT,
	fa_signpat INT,
	pat_complete INT,
	lm_date DATE,
	lm_mo INT,
	lm_da INT,
	lm_yr INT,
	prenatal INT,
	pre_begin DATE,
	pre_begmo INT,
	pre_begda INT,
	pre_begyr INT,
	pre_end DATE,
	pre_endmo INT,
	pre_endda INT,
	pre_endyr INT,
	tot_visits INT,
	gest_est INT,
	gest_days INT,
	dat_concep DATE,
	mpv_days_cal INT,
	mpv_cal INT,
	pv_trims_cal INT,
	mom_htft INT,
	mom_htinch INT,
	prepreg_wt INT,
	del_wt INT,
	wt_gain INT,
	prv_livebth INT,
	prv_livebthdte VARCHAR(15),	--badly coded dates
	live_bthliv INT,
	live_bthdead INT,
	prv_term INT,
	term_dte VARCHAR(15),	--badly coded dates 112003
	tobacco INT,
	cig_pck INT,
	prepreg_cig INT,
	prepreg_pck INT,
	first_cig INT,
	first_pck INT,
	sec_cig INT,
	sec_pck INT,
	last_cig INT,
	last_pck INT,
	alcohol INT,
	drink_wk INT,
	drug_use INT,
	du_prscr INT,
	du_otc INT,
	du_other INT,
	du_otherlit VARCHAR(50),
	mrf_none INT,
	mrf_prediab INT,
	mrf_gestdiab INT,
	mrf_hypert INT,
	mrf_hypertchr INT,
	mrf_hypergest INT,
	mrf_eclampsia INT,
	mrf_prevpreterm INT,
	mrf_poorout INT,
	mrf_inftreat INT,
	mrf_infdrugs INT,
	mrf_assistrep INT,
	mrf_prevces INT,
	mrf_prevcesnum INT,
	mrf_anemia INT,
	mrf_cardiac INT,
	mrf_lungdis INT,
	mrf_hydra INT,
	mrf_hemoglob INT,
	mrf_incompcerv INT,
	mrf_prev4000 INT,
	mrf_renaldis INT,
	mrf_rhsensit INT,
	mrf_utbleed INT,
	mrf_oth INT,
	mrf_othlit VARCHAR(50),
	inf_none INT,
	inf_gonor INT,
	inf_syph INT,
	inf_chlam INT,
	inf_hepb INT,
	inf_hepc INT,
	inf_hpv INT,
	inf_hivaids INT,
	inf_cmv INT,
	inf_rubella INT,
	inf_toxo INT,
	inf_genherpes INT,
	inf_tuber INT,
	inf_oth INT,
	inf_othlit VARCHAR(50),
	ob_none INT,
	ob_cercl INT,
	ob_toco INT,
	ob_amnio INT,
	ob_fetalmon INT,
	ob_cephsucess INT,
	ob_cephfail INT,
	ob_ultrasnd INT,
	ob_oth INT,
	ob_othlit VARCHAR(50),
	ol_none INT,
	ol_prerom INT,
	ol_preciplbr INT,
	ol_prolonglbr INT,
	cld_none INT,
	cld_induc INT,
	cld_aug INT,
	cld_nonvert INT,
	cld_steroid INT,
	cld_antibiotic INT,
	cld_chorio INT,
	cld_mecon INT,
	cld_fetalintol INT,
	cld_epi INT,
	cld_febrile INT,
	cld_abrplac INT,
	cld_placprev INT,
	cld_bleed INT,
	cld_seizures INT,
	cld_dysfunc INT,
	cld_cephpelv INT,
	cld_cordpro INT,
	cld_anesth INT,
	cld_oth INT,
	cld_othlit VARCHAR(50),
	md_forcepsattpt INT,
	md_vaccumattpt INT,
	bth_present INT,
	bth_route INT,
	trial_lbr INT,
	mm_none INT,
	mm_trnsfusion INT,
	mm_perilac INT,
	mm_ruputerus INT,
	mm_hyster INT,
	mm_icu INT,
	mm_unploper INT,
	mm_unk INT,
	apgar_5 INT,
	apgar_10 INT,
	gest_wks INT,
	gest_grp INT,
	bthwt_unit INT,
	grams INT,
	lbs INT,
	oz INT,
	bwt_grp INT,
	plurality INT,
	bth_order INT,
	born_alive INT,
	match_certnum INT,
	ac_none INT,
	ac_ventless INT,
	ac_ventmore INT,
	ac_nicu INT,
	ac_surf INT,
	ac_antisepis INT,
	ac_seizures INT,
	ac_anemia INT,
	ac_fas INT,
	ac_hyaline INT,
	ac_mecon INT,
	ac_bthinjury INT,
	ac_oth INT,
	ac_othlit VARCHAR(50),
	acn_none INT,
	acn_anencep INT,
	acn_spina INT,
	acn_micro INT,
	acn_nervous INT,
	acn_nervouslit VARCHAR(50),
	acn_hrtdis INT,
	acn_hrtmal INT,
	acn_circ INT,
	acn_cirlit VARCHAR(50),
	acn_omphal INT,
	acn_gastrosch INT,
	acn_rectal INT,
	acn_tracheo INT,
	acn_gastro INT,
	acn_gastrolit VARCHAR(50),
	acn_limbred INT,
	acn_cleftlip INT,
	acn_cleftpalate INT,
	acn_polydact INT,
	acn_clubft INT,
	acn_diaphhern INT,
	acn_muscle INT,
	acn_musclelit VARCHAR(50),
	acn_malgen INT,
	acn_renal INT,
	acn_hypos INT,
	acn_urogen INT,
	acn_urogenlit VARCHAR(50),
	acn_downs INT,
	acn_cdit INT,
	acn_chromoth INT,
	acn_chromothlit VARCHAR(50),
	acn_oth INT,
	acn_othlit VARCHAR(50),
	certifier INT,
	cer_date DATE,
	reg_date DATE,
	cer_yr INT,
	cer_mo INT,
	cer_da INT,
	reg_mo INT,
	reg_da INT,
	reg_yr INT,
	wic INT,
	source_pay INT,
	breastfeeding INT,
	inf_liv INT,
	inf_trans INT,
	mom_trans INT,
	ssn_request INT,
	ssn_child VARCHAR(9),
	ssn_date DATE,
	inf_hospnum VARCHAR(20),
	mom_hospnum VARCHAR(20),
	mom_his INT,
	mom_mex INT,
	mom_pr INT,
	mom_cu INT,
	mom_ethoth INT,
	mom_ethothlit VARCHAR(50),
	mom_white INT,
	mom_black INT,
	mom_amind INT,
	mom_amindlit VARCHAR(50),
	mom_asian INT,
	mom_asianoth INT,
	mom_asianlit VARCHAR(50),
	mom_chinese INT,
	mom_filipino INT,
	mom_japanese INT,
	mom_korean INT,
	mom_vietnamese INT,
	mom_hawaiian INT,
	mom_guam INT,
	mom_samoan INT,
	mom_pacisl INT,
	mom_pacisllit VARCHAR(50),
	mom_raceoth INT,
	mom_raceothlit VARCHAR(50),
	mom_raceunk INT,
	mom_raceref INT,
	mom_race1 INT,
	mom_race2 INT,
	mom_race3 INT,
	mom_race4 INT,
	mom_race5 INT,
	mom_race6 INT,
	mom_race7 INT,
	mom_race8 INT,
	mom_race16 INT,
	filler7 INT,
	mom_race18 INT,
	filler8 INT,
	mom_race20 INT,
	filler9 INT,
	mom_race22 INT,
	filler10 INT,
	momhisp_nchs INT,
	mom_ethnic_nchs INT,
	momrace_nchsbrg INT,
	momrace_ethnchs INT,
	fa_his INT,
	fa_mex INT,
	fa_pr INT,
	fa_cu INT,
	fa_ethoth INT,
	fa_ethothlit VARCHAR(50),
	fa_white INT,
	fa_black INT,
	fa_amind INT,
	fa_amindlit VARCHAR(50),
	fa_asian INT,
	fa_asianoth INT,
	fa_asianlit VARCHAR(50),
	fa_chinese INT,
	fa_filipino INT,
	fa_japanese INT,
	fa_korean INT,
	fa_vietnamese INT,
	fa_hawaiian INT,
	fa_guam INT,
	fa_samoan INT,
	fa_pacisl INT,
	fa_pacisllit VARCHAR(50),
	fa_raceoth INT,
	fa_raceothlit VARCHAR(50),
	fa_raceunk INT,
	fa_raceref INT,
	fa_race1 INT,
	fa_race2 INT,
	fa_race3 INT,
	fa_race4 INT,
	fa_race5 INT,
	fa_race6 INT,
	fa_race7 INT,
	fa_race8 INT,
	fa_race16 INT,
	filler14 INT,
	fa_race18 INT,
	filler15 INT,
	fa_race20 INT,
	filler16 INT,
	fa_race22 INT,
	filler17 INT,
	fahisp_nchs INT,
	fa_ethnic_nchs INT,
	farace_nchsbrg INT,
	farace_ethnchs INT,
	death_match INT,
	death_cert INT,
	death_date INT,
	birth_rco INT,
	source_filename VARCHAR(255),
	source_record_number INT IDENTITY(1,1),
--	imported_at DATETIME
--		CONSTRAINT vital_births_buffer_imported_at_default DEFAULT CURRENT_TIMESTAMP NOT NULL,
--	imported_to_dw BIT
--		CONSTRAINT vital_births_buffer_imported_to_dw_default DEFAULT 'FALSE' NOT NULL,
);
GO

EXEC bin.add_imported_at_column_to_tables_by_schema 'vital';
EXEC bin.add_imported_to_dw_column_to_tables_by_schema 'vital';



IF OBJECT_ID ( 'vital.bulk_insert_births', 'V' ) IS NOT NULL
	DROP VIEW vital.bulk_insert_births;
GO
-- This is ugly as there are 383 fields.  Nevertheless.
CREATE VIEW vital.bulk_insert_births AS SELECT
	cert_yr,
	cert_num,
	void,
	name_sur,
	name_sux,
	name_fir,
	name_mid,
	sex,
	bth_date,
	birth_mo,
	birth_da,
	birth_yr,
	bth_time,
	place,
	facility,
	birth_st,
	birth_ci,
	birth_co,
	attendant,
	mom_snam,
	mom_xnam,
	mom_fnam,
	mom_mnam,
	maiden_n,
	mom_dob,
	mom_age,
	mom_age1,
	mom_bst,
	mom_bthcntry_fips,
	mom_bthstate_fips,
	mom_rst,
	mom_rci,
	mom_rco,
	mom_address,
	mom_apt,
	mom_rzip,
	incity,
	mres_cntry_fips,
	mres_st_fips,
	mres_city_fips,
	mres_cnty_fips,
	mom_edu,
	mom_occ,
	mom_occup1,
	mom_bus,
	mom_busines1,
	mom_ssn,
	fa_sname,
	fa_xname,
	fa_fname,
	fa_mname,
	fa_dob,
	fa_age,
	fa_age1,
	fa_bst,
	fa_edu,
	fa_occ,
	fa_occup1,
	fa_bus,
	fa_busines1,
	fa_ssn,
	mom_everm,
	married_betw,
	fa_husb,
	fa_signpat,
	pat_complete,
	lm_date,
	lm_mo,
	lm_da,
	lm_yr,
	prenatal,
	pre_begin,
	pre_begmo,
	pre_begda,
	pre_begyr,
	pre_end,
	pre_endmo,
	pre_endda,
	pre_endyr,
	tot_visits,
	gest_est,
	gest_days,
	dat_concep,
	mpv_days_cal,
	mpv_cal,
	pv_trims_cal,
	mom_htft,
	mom_htinch,
	prepreg_wt,
	del_wt,
	wt_gain,
	prv_livebth,
	prv_livebthdte,
	live_bthliv,
	live_bthdead,
	prv_term,
	term_dte,
	tobacco,
	cig_pck,
	prepreg_cig,
	prepreg_pck,
	first_cig,
	first_pck,
	sec_cig,
	sec_pck,
	last_cig,
	last_pck,
	alcohol,
	drink_wk,
	drug_use,
	du_prscr,
	du_otc,
	du_other,
	du_otherlit,
	mrf_none,
	mrf_prediab,
	mrf_gestdiab,
	mrf_hypert,
	mrf_hypertchr,
	mrf_hypergest,
	mrf_eclampsia,
	mrf_prevpreterm,
	mrf_poorout,
	mrf_inftreat,
	mrf_infdrugs,
	mrf_assistrep,
	mrf_prevces,
	mrf_prevcesnum,
	mrf_anemia,
	mrf_cardiac,
	mrf_lungdis,
	mrf_hydra,
	mrf_hemoglob,
	mrf_incompcerv,
	mrf_prev4000,
	mrf_renaldis,
	mrf_rhsensit,
	mrf_utbleed,
	mrf_oth,
	mrf_othlit,
	inf_none,
	inf_gonor,
	inf_syph,
	inf_chlam,
	inf_hepb,
	inf_hepc,
	inf_hpv,
	inf_hivaids,
	inf_cmv,
	inf_rubella,
	inf_toxo,
	inf_genherpes,
	inf_tuber,
	inf_oth,
	inf_othlit,
	ob_none,
	ob_cercl,
	ob_toco,
	ob_amnio,
	ob_fetalmon,
	ob_cephsucess,
	ob_cephfail,
	ob_ultrasnd,
	ob_oth,
	ob_othlit,
	ol_none,
	ol_prerom,
	ol_preciplbr,
	ol_prolonglbr,
	cld_none,
	cld_induc,
	cld_aug,
	cld_nonvert,
	cld_steroid,
	cld_antibiotic,
	cld_chorio,
	cld_mecon,
	cld_fetalintol,
	cld_epi,
	cld_febrile,
	cld_abrplac,
	cld_placprev,
	cld_bleed,
	cld_seizures,
	cld_dysfunc,
	cld_cephpelv,
	cld_cordpro,
	cld_anesth,
	cld_oth,
	cld_othlit,
	md_forcepsattpt,
	md_vaccumattpt,
	bth_present,
	bth_route,
	trial_lbr,
	mm_none,
	mm_trnsfusion,
	mm_perilac,
	mm_ruputerus,
	mm_hyster,
	mm_icu,
	mm_unploper,
	mm_unk,
	apgar_5,
	apgar_10,
	gest_wks,
	gest_grp,
	bthwt_unit,
	grams,
	lbs,
	oz,
	bwt_grp,
	plurality,
	bth_order,
	born_alive,
	match_certnum,
	ac_none,
	ac_ventless,
	ac_ventmore,
	ac_nicu,
	ac_surf,
	ac_antisepis,
	ac_seizures,
	ac_anemia,
	ac_fas,
	ac_hyaline,
	ac_mecon,
	ac_bthinjury,
	ac_oth,
	ac_othlit,
	acn_none,
	acn_anencep,
	acn_spina,
	acn_micro,
	acn_nervous,
	acn_nervouslit,
	acn_hrtdis,
	acn_hrtmal,
	acn_circ,
	acn_cirlit,
	acn_omphal,
	acn_gastrosch,
	acn_rectal,
	acn_tracheo,
	acn_gastro,
	acn_gastrolit,
	acn_limbred,
	acn_cleftlip,
	acn_cleftpalate,
	acn_polydact,
	acn_clubft,
	acn_diaphhern,
	acn_muscle,
	acn_musclelit,
	acn_malgen,
	acn_renal,
	acn_hypos,
	acn_urogen,
	acn_urogenlit,
	acn_downs,
	acn_cdit,
	acn_chromoth,
	acn_chromothlit,
	acn_oth,
	acn_othlit,
	certifier,
	cer_date,
	reg_date,
	cer_yr,
	cer_mo,
	cer_da,
	reg_mo,
	reg_da,
	reg_yr,
	wic,
	source_pay,
	breastfeeding,
	inf_liv,
	inf_trans,
	mom_trans,
	ssn_request,
	ssn_child,
	ssn_date,
	inf_hospnum,
	mom_hospnum,
	mom_his,
	mom_mex,
	mom_pr,
	mom_cu,
	mom_ethoth,
	mom_ethothlit,
	mom_white,
	mom_black,
	mom_amind,
	mom_amindlit,
	mom_asian,
	mom_asianoth,
	mom_asianlit,
	mom_chinese,
	mom_filipino,
	mom_japanese,
	mom_korean,
	mom_vietnamese,
	mom_hawaiian,
	mom_guam,
	mom_samoan,
	mom_pacisl,
	mom_pacisllit,
	mom_raceoth,
	mom_raceothlit,
	mom_raceunk,
	mom_raceref,
	mom_race1,
	mom_race2,
	mom_race3,
	mom_race4,
	mom_race5,
	mom_race6,
	mom_race7,
	mom_race8,
	mom_race16,
	filler7,
	mom_race18,
	filler8,
	mom_race20,
	filler9,
	mom_race22,
	filler10,
	momhisp_nchs,
	mom_ethnic_nchs,
	momrace_nchsbrg,
	momrace_ethnchs,
	fa_his,
	fa_mex,
	fa_pr,
	fa_cu,
	fa_ethoth,
	fa_ethothlit,
	fa_white,
	fa_black,
	fa_amind,
	fa_amindlit,
	fa_asian,
	fa_asianoth,
	fa_asianlit,
	fa_chinese,
	fa_filipino,
	fa_japanese,
	fa_korean,
	fa_vietnamese,
	fa_hawaiian,
	fa_guam,
	fa_samoan,
	fa_pacisl,
	fa_pacisllit,
	fa_raceoth,
	fa_raceothlit,
	fa_raceunk,
	fa_raceref,
	fa_race1,
	fa_race2,
	fa_race3,
	fa_race4,
	fa_race5,
	fa_race6,
	fa_race7,
	fa_race8,
	fa_race16,
	filler14,
	fa_race18,
	filler15,
	fa_race20,
	filler16,
	fa_race22,
	filler17,
	fahisp_nchs,
	fa_ethnic_nchs,
	farace_nchsbrg,
	farace_ethnchs,
	death_match,
	death_cert,
	death_date,
	birth_rco
FROM vital.births_buffer;
--FROM vital.births;
GO



IF IndexProperty(Object_Id('vital.births'),
	'vital_births_cert_year_num', 'IndexId') IS NOT NULL
	DROP INDEX vital_births_cert_year_num
		ON vital.births;
IF COL_LENGTH('vital.births','cert_year_num') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN cert_year_num;
ALTER TABLE vital.births ADD cert_year_num AS
	CAST(cert_yr AS VARCHAR(255)) + '-' + CAST(cert_num AS VARCHAR(255)) PERSISTED;
CREATE INDEX vital_births_cert_year_num
	ON vital.births( cert_year_num );

/*
IF COL_LENGTH('vital.births','_maiden_n_mom_snam') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _maiden_n_mom_snam;
ALTER TABLE vital.births ADD _maiden_n_mom_snam AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( maiden_n + mom_snam
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;

IF COL_LENGTH('vital.births','_maiden_n_name_sur') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _maiden_n_name_sur;
ALTER TABLE vital.births ADD _maiden_n_name_sur AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( maiden_n + name_sur
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
*/

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__name_sur', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__name_sur
--		ON vital.births;
IF COL_LENGTH('vital.births','_name_sur') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _name_sur;
ALTER TABLE vital.births ADD _name_sur AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( name_sur
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX vital_births__name_sur
--	ON vital.births( _name_sur );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__maiden_n', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__maiden_n
--		ON vital.births;
IF COL_LENGTH('vital.births','_maiden_n') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _maiden_n;
ALTER TABLE vital.births ADD _maiden_n AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( maiden_n
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX vital_births__maiden_n
--	ON vital.births( _maiden_n );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__mom_snam', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__mom_snam
--		ON vital.births;
IF COL_LENGTH('vital.births','_mom_snam') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _mom_snam;
ALTER TABLE vital.births ADD _mom_snam AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( mom_snam
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX vital_births__mom_snam
--	ON vital.births( _mom_snam );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__mom_fnam', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__mom_fnam
--		ON vital.births;
IF COL_LENGTH('vital.births','_mom_fnam') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _mom_fnam;
ALTER TABLE vital.births ADD _mom_fnam AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( mom_fnam
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX vital_births__mom_fnam
--	ON vital.births( _mom_fnam );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__name_fir', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__name_fir
--		ON vital.births;
IF COL_LENGTH('vital.births','_name_fir') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _name_fir;
ALTER TABLE vital.births ADD _name_fir AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( name_fir
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX vital_births__name_fir
--	ON vital.births( _name_fir );

IF IndexProperty(Object_Id('vital.births'),
	'vital_births__mom_rzip', 'IndexId') IS NOT NULL
	DROP INDEX vital_births__mom_rzip
		ON vital.births;
IF COL_LENGTH('vital.births','_mom_rzip') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _mom_rzip;
ALTER TABLE vital.births ADD _mom_rzip AS CAST( mom_rzip AS VARCHAR ) PERSISTED;
CREATE INDEX vital_births__mom_rzip
	ON vital.births( _mom_rzip );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__mom_address', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__mom_address
--		ON vital.births;
IF COL_LENGTH('vital.births','_mom_address') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _mom_address;
ALTER TABLE vital.births ADD _mom_address AS
	RTRIM( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( mom_address
		,' BOULEVARD',' ') ,' BLVD',' ') -- contains RD, so before RD extraction
		,' COURT',' ') ,' CT',' ') ,' STREET',' ') ,' ST',' ')
		,' DRIVE',' ') ,' DRIV',' ') ,' DRI',' ') ,' DR',' ')
		,' ROAD',' ') ,' RD',' ')
		,' CIRCLE',' ') ,' CIR',' ') ,' LANE',' ') ,' LN',' ')
		,' AVENUE',' ') ,' AVE',' ')
		,' MOUNT',' MT'),' PARKWAY',' '),' PKWY',' ')
		,'SOUTH','S') ,'NORTH','N') ,'EAST','E') ,'WEST','W') )
	PERSISTED;
--CREATE INDEX vital_births__mom_address
--	ON vital.births( _mom_address );


--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__maiden_n_pre', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__maiden_n_pre
--		ON vital.births;
IF COL_LENGTH('vital.births','_maiden_n_pre') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _maiden_n_pre;
ALTER TABLE vital.births ADD _maiden_n_pre AS
	REPLACE(SUBSTRING(maiden_n, 1,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(maiden_n,' ','-'))-1,-1),LEN(maiden_n))
	),' ','') PERSISTED;
--CREATE INDEX vital_births__maiden_n_pre
--	ON vital.births( _maiden_n_pre );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__maiden_n_suf', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__maiden_n_suf
--		ON vital.births;
IF COL_LENGTH('vital.births','_maiden_n_suf') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _maiden_n_suf;
ALTER TABLE vital.births ADD _maiden_n_suf AS
	REPLACE(SUBSTRING(maiden_n,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(maiden_n,' ','-'))+1,1),1),
		LEN(maiden_n)
	),' ','') PERSISTED;
--CREATE INDEX vital_births__maiden_n_suf
--	ON vital.births( _maiden_n_suf );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__mom_snam_pre', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__mom_snam_pre
--		ON vital.births;
IF COL_LENGTH('vital.births','_mom_snam_pre') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _mom_snam_pre;
ALTER TABLE vital.births ADD _mom_snam_pre AS
	REPLACE(SUBSTRING(mom_snam, 1,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(mom_snam,' ','-'))-1,-1),LEN(mom_snam))
	),' ','') PERSISTED;
--CREATE INDEX vital_births__mom_snam_pre
--	ON vital.births( _mom_snam_pre );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__mom_snam_suf', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__mom_snam_suf
--		ON vital.births;
IF COL_LENGTH('vital.births','_mom_snam_suf') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _mom_snam_suf;
ALTER TABLE vital.births ADD _mom_snam_suf AS
	REPLACE(SUBSTRING(mom_snam,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(mom_snam,' ','-'))+1,1),1),
		LEN(mom_snam)
	),' ','') PERSISTED;
--CREATE INDEX vital_births__mom_snam_suf
--	ON vital.births( _mom_snam_suf );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__name_sur_pre', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__name_sur_pre
--		ON vital.births;
IF COL_LENGTH('vital.births','_name_sur_pre') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _name_sur_pre;
ALTER TABLE vital.births ADD _name_sur_pre AS
	REPLACE(SUBSTRING(name_sur, 1,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(name_sur,' ','-'))-1,-1),LEN(name_sur))
	),' ','') PERSISTED;
--CREATE INDEX vital_births__name_sur_pre
--	ON vital.births( _name_sur_pre );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__name_sur_suf', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__name_sur_suf
--		ON vital.births;
IF COL_LENGTH('vital.births','_name_sur_suf') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _name_sur_suf;
ALTER TABLE vital.births ADD _name_sur_suf AS
	REPLACE(SUBSTRING(name_sur,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(name_sur,' ','-'))+1,1),1),
		LEN(name_sur)
	),' ','') PERSISTED;
--CREATE INDEX vital_births__name_sur_suf
--	ON vital.births( _name_sur_suf );


--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__mom_address_pre', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__mom_address_pre
--		ON vital.births;
IF COL_LENGTH('vital.births','_mom_address_pre') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _mom_address_pre;
ALTER TABLE vital.births ADD _mom_address_pre AS
	SUBSTRING(mom_address, 1,
		ISNULL(NULLIF(CHARINDEX(' ',mom_address)-1,-1),LEN(mom_address))
	) PERSISTED;
--CREATE INDEX vital_births__mom_address_pre
--	ON vital.births( _mom_address_pre );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births__mom_address_suf', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births__mom_address_suf
--		ON vital.births;
IF COL_LENGTH('vital.births','_mom_address_suf') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN _mom_address_suf;
ALTER TABLE vital.births ADD _mom_address_suf AS
	SUBSTRING(mom_address,
		ISNULL(NULLIF(CHARINDEX(' ',mom_address)+1,1),1),
		LEN(mom_address)
	) PERSISTED;
--CREATE INDEX vital_births__mom_address_suf
--	ON vital.births( _mom_address_suf );


--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births_mom_rzip', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births_mom_rzip
--		ON vital.births;
--CREATE INDEX vital_births_mom_rzip
--	ON vital.births( mom_rzip );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births_bth_date', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births_bth_date
--		ON vital.births;
--CREATE INDEX vital_births_bth_date
--	ON vital.births( bth_date );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births_mom_dob', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births_mom_dob
--		ON vital.births;
--CREATE INDEX vital_births_mom_dob
--	ON vital.births( mom_dob );


--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births_bth_date_day', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births_bth_date_day
--		ON vital.births;
IF COL_LENGTH('vital.births','bth_date_day') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN bth_date_day;
ALTER TABLE vital.births ADD bth_date_day AS
	DAY(bth_date) PERSISTED;
--CREATE INDEX vital_births_bth_date_day
--	ON vital.births( bth_date_day );

IF IndexProperty(Object_Id('vital.births'),
	'vital_births_bth_date_month', 'IndexId') IS NOT NULL
	DROP INDEX vital_births_bth_date_month
		ON vital.births;
IF COL_LENGTH('vital.births','bth_date_month') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN bth_date_month;
ALTER TABLE vital.births ADD bth_date_month AS
	MONTH(bth_date) PERSISTED;
CREATE INDEX vital_births_bth_date_month
	ON vital.births( bth_date_month );

IF IndexProperty(Object_Id('vital.births'),
	'vital_births_bth_date_year', 'IndexId') IS NOT NULL
	DROP INDEX vital_births_bth_date_year
		ON vital.births;
IF COL_LENGTH('vital.births','bth_date_year') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN bth_date_year;
ALTER TABLE vital.births ADD bth_date_year AS
	YEAR(bth_date) PERSISTED;
CREATE INDEX vital_births_bth_date_year
	ON vital.births( bth_date_year );


--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births_mom_dob_day', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births_mom_dob_day
--		ON vital.births;
IF COL_LENGTH('vital.births','mom_dob_day') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN mom_dob_day;
ALTER TABLE vital.births ADD mom_dob_day AS
	DAY(mom_dob) PERSISTED;
--CREATE INDEX vital_births_mom_dob_day
--	ON vital.births( mom_dob_day );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births_mom_dob_month', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births_mom_dob_month
--		ON vital.births;
IF COL_LENGTH('vital.births','mom_dob_month') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN mom_dob_month;
ALTER TABLE vital.births ADD mom_dob_month AS
	MONTH(mom_dob) PERSISTED;
--CREATE INDEX vital_births_mom_dob_month
--	ON vital.births( mom_dob_month );

--IF IndexProperty(Object_Id('vital.births'),
--	'vital_births_mom_dob_year', 'IndexId') IS NOT NULL
--	DROP INDEX vital_births_mom_dob_year
--		ON vital.births;
IF COL_LENGTH('vital.births','mom_dob_year') IS NOT NULL
	ALTER TABLE vital.births DROP COLUMN mom_dob_year;
ALTER TABLE vital.births ADD mom_dob_year AS
	YEAR(mom_dob) PERSISTED;
--CREATE INDEX vital_births_mom_dob_year
--	ON vital.births( mom_dob_year );

DECLARE @bulk_cmd VARCHAR(1000)
ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'abnormal' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\abnormal.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'age_groups' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\age_groups.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'attendant' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\attendant.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'bridge_race' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\bridge_race.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'bthwt_unit' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\bthwt_unit.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'business' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\business.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'bwt_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\bwt_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'c_l_d' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\c_l_d.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'cdc_race_code' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\cdc_race_code.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'cig_pck' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\cig_pck.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'city' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\city.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'congenital' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\congenital.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'county' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\county.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'education' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\education.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'ethnic' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\ethnic.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'ethnic_nchs' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\ethnic_nchs.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'evindex' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\evindex.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'facility' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\facility.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'gest_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\gest_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'hisp_nchs' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\hisp_nchs.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'industry' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\industry.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'karotype' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\karotype.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'kipca' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\kipca.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'marital' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\marital.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'method' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\method.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'nopnc' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\nopnc.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'ob_proc' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\ob_proc.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'occ' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\occ.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'occup' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\occup.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'place' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\place.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'place_prior' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\place_prior.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'presentation' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\presentation.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'pv_trims' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\pv_trims.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'race' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\race.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'race_ethnic' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\race_ethnic.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'risk' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\risk.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'route' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\route.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'sex' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\sex.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'source_pay' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\source_pay.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'standard1_yesno' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\standard1_yesno.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'standard2_yesno' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\standard2_yesno.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'standard3_yesno' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\standard3_yesno.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'standard4_yesno' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\standard4_yesno.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'standard5_yesno' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\standard5_yesno.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'births' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'state' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\births\state.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'age1_groups' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\age1_groups.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'age2_groups' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\age2_groups.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'age3_groups' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\age3_groups.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'age4_groups' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\age4_groups.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'age5_groups' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\age5_groups.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'age_unit' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\age_unit.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'autopsy' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\autopsy.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'burial' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\burial.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'business' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\business.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'certifier' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\certifier.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'citizen' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\citizen.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'city' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\city.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'coroner' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\coroner.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'county' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\county.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'doa_inpa' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\doa_inpa.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'edu' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\edu.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'ethnic' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\ethnic.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'ethnicnchs' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\ethnicnchs.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'fem_preg' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\fem_preg.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'funeral' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\funeral.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'hisp_nchs' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\hisp_nchs.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'icd1_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\icd1_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'icd2_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\icd2_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'icd3_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\icd3_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'icd4_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\icd4_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'icd5_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\icd5_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'icd6_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\icd6_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'icd7_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\icd7_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'industry' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\industry.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'inf1_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\inf1_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'inf2_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\inf2_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'inf3_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\inf3_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'inf4_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\inf4_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'inf5_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\inf5_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'injur_pl' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\injur_pl.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'injur_transp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\injur_transp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'injur_transplace' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\injur_transplace.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'injur_wk' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\injur_wk.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'instit' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\instit.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'manner' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\manner.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'marital' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\marital.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'occ_grp' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\occ_grp.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'occup' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\occup.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'race' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\race.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'race_eth' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\race_eth.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'race_nchsbrg' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\race_nchsbrg.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'sex' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\sex.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'standard1_yesno' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\standard1_yesno.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'state' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\state.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'vital' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'deaths' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'tobacco' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\deaths\tobacco.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;


IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='health_lab')
	EXEC('CREATE SCHEMA health_lab')
GO


-- July 2015 - December 2015
-- "Accession Number","Kit Number","Patient ID","Last Name","First Name","Maiden Name","Birth Date","Place of birth","Address 1","City","State","Zip Code","Phone no. 1","Phone no. 2","Location","Entry Mode","Rank","Mother's surname","Mother's first name","Mother's maiden name","Mother's date of birth","Contact facility","Contact Address 1"

-- January 2016 -
-- "Accession Number","Kit Number","Patient ID","Last Name","First Name","Birth Date","Address 1","City","State","Zip Code","Phone no. 1","Weight  Birth","Mother's surname","Mother's first name","Mother's maiden name","Mother's date of birth","Contact facility","Contact Address 1"

-- Minus a few, plus "Weight Birth"

-- Where are the results????

IF OBJECT_ID('health_lab.newborn_screenings', 'U') IS NOT NULL
	DROP TABLE health_lab.newborn_screenings;
CREATE TABLE health_lab.newborn_screenings (
	id INT IDENTITY(1,1),
	CONSTRAINT health_lab_newborn_screenings_id PRIMARY KEY CLUSTERED (id ASC),
	accession_number VARCHAR(15),	--Accession Number
	kit_number VARCHAR(15),	--Kit Number
	patient_id VARCHAR(30),	--Patient ID VARCHAR(15)
	last_name VARCHAR(50),	--Last Name VARCHAR(15)
	first_name VARCHAR(50),	--First Name VARCHAR(15)	-- MALE, FEMALE????
	maiden_name VARCHAR(50),	--Maiden Name VARCHAR		-- All NULL in initial set
	birth_date DATE,	--Birth Date DATE
	place_of_birth VARCHAR(50),	--Place of birth VARCHAR		-- All NULL in initial set
	address VARCHAR(50),	--Address 1 VARCHAR
	city VARCHAR(50),	--City VARCHAR
	state VARCHAR(50),	--State VARCHAR
	zip_code VARCHAR(15),	--Zip Code VARCHAR
	phone_1 VARCHAR(15),	--Phone no. 1 VARCHAR
	phone_2 VARCHAR(15),	--Phone no. 2 VARCHAR
	location VARCHAR(50),	--Location VARCHAR		-- (2/3='Default location',1/3=NULL)
	entry_mode VARCHAR(50),	--Entry Mode VARCHAR (2/3='Reported',1/3 NULL, 3 are 'Linking')
	rank VARCHAR(50),	--Rank VARCHAR			-- All NULL in initial set
	mom_surname VARCHAR(50),	--Mother's surname VARCHAR
	mom_first_name VARCHAR(50),	--Mother's first name VARCHAR
	mom_maiden_name VARCHAR(50),	--Mother's maiden name VARCHAR
	mom_birth_date DATE,	--Mother's date of birth DATE
	contact_facility VARCHAR(75),	--Contact facility VARCHAR
	contact_address VARCHAR(50),	--Contact Address 1 VARCHAR
	birth_weight VARCHAR(10)	-- Weight Birth (looks like grams)	-- 2/3 NULL in initial set
);
GO

--IF OBJECT_ID('health_lab.newborn_screening', 'U') IS NOT NULL
--	DROP TABLE health_lab.newborn_screening;
--CREATE TABLE health_lab.newborn_screening (
--	id INT IDENTITY(1,1),
--	CONSTRAINT health_lab_newborn_screening_id PRIMARY KEY CLUSTERED (id ASC),
--	name_first VARCHAR(250),
--	name_last VARCHAR(250),
--	date_of_birth DATETIME,
--	sex VARCHAR(1),
--	testresults1 VARCHAR(250),
--	testresults2 VARCHAR(250),
--	testresults3 VARCHAR(250),
--	testresults4 VARCHAR(250),
--	testresults5 VARCHAR(250),
--
----Congenital Adrenal Hyperplasia
----Congenital Hypothyroidism
----Sickle Cell Disease S/S
----Sickle Cell Disease S/C
----Thalassemia Major
----Biotinidase Deficiency
----Galactosemia
----Argininosuccinate Lyase Deficiency (ASA)
----Classic Citrullinemia
----Citrullinemia Type II
----Homocystinuria
----Hyperphenylalanemia, including Phenylketonuria
----Tyrosinemia, Type 1
----Tyrosinemia, Type 2
----Beta-Ketothiolase Deficiency
----Glutaric Aciduria, Type I (Glutaryl-CoA Dehydrogenase Deficiency)
----Isovaleryl-CoA Dehydrogenase Deficiency (Isovaleric Acidemia)
----Maple Syrup Urine Disease
----Methylmalonic Acidemia (MMA; 8 types)
----Methylmalonic Aciduria, Vitamin B-12 Responsive
----Methylmalonic Aciduria, Vitamin B-12 Nonresponsive
----Vitamin B12 Metabolic Defect with Methylmalonicacidemia and Homocystinuria
----Propionic Acidemia (PA)
----3-methylglutaconyl-CoA Hydratase Deficiency
----3-methylglutaconyl-CoA Aciduria Type I
----3-methylglutaconyl-CoA Aciduria Type II
----3-methylglutaconyl-CoA Aciduria Type III
----3-methylglutaconyl-CoA aciduria Type IV
----Multiple Carboxylase Deficiency
----Carnitine uUptake/Transporter Defects
----Carnitine-Acylcarnitine Translocase Deficiency
----Carnitine Transporter Defect
----Carnitine Palmitoyl Transferase I Deficiency (CPT I)
----Carnitine PalmitoylTransferase II Deficiency (CPT II)
----Glutaric Aciduria, Type II (Multiple Acyl-CoA Dehydrogenase Deficiency (MADD))
----Very Long Chain Acyl-CoA Dehydrogenase Deficiency (VLCADD)
----Long Chain L-3 Hydroxyacyl-CoA Dehydrogenase Deficiency (LCHADD)
----Medium Chain Acyl-CoA Dehydrogenase Deficiency (MCADD)
----Short Chain Acyl-CoA Dehydrogenase Deficiency (SCADD)
----Cystic Fibrosis
--
--);
--GO

EXEC bin.add_imported_at_column_to_tables_by_schema 'health_lab';
EXEC bin.add_imported_to_dw_column_to_tables_by_schema 'health_lab';



IF OBJECT_ID ( 'health_lab.bulk_insert_newborn_screenings_2015', 'V' ) IS NOT NULL
	DROP VIEW health_lab.bulk_insert_newborn_screenings_2015;
GO
CREATE VIEW health_lab.bulk_insert_newborn_screenings_2015 AS SELECT
	accession_number,
	kit_number,
	patient_id,
	last_name,
	first_name,
	maiden_name,
	birth_date,
	place_of_birth,
	address,
	city,
	state,
	zip_code,
	phone_1,
	phone_2,
	location,
	entry_mode,
	rank,
	mom_surname,
	mom_first_name,
	mom_maiden_name,
	mom_birth_date,
	contact_facility,
	contact_address
FROM health_lab.newborn_screenings;
GO

IF OBJECT_ID ( 'health_lab.bulk_insert_newborn_screenings_2016', 'V' ) IS NOT NULL
	DROP VIEW health_lab.bulk_insert_newborn_screenings_2016;
GO
CREATE VIEW health_lab.bulk_insert_newborn_screenings_2016 AS SELECT
	accession_number,
	kit_number,
	patient_id,
	last_name,
	first_name,
--	maiden_name,
	birth_date,
--	place_of_birth,
	address,
	city,
	state,
	zip_code,
	phone_1,
--	phone_2,
	birth_weight,	-- new field
--	location,
--	entry_mode,
--	rank,
	mom_surname,
	mom_first_name,
	mom_maiden_name,
	mom_birth_date,
	contact_facility,
	contact_address
FROM health_lab.newborn_screenings;
GO



--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id
--		ON health_lab.newborn_screenings;
--CREATE INDEX health_lab_newborn_screenings_patient_id
--	ON health_lab.newborn_screenings( patient_id );



IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_accession_kit_number', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_accession_kit_number
		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','accession_kit_number') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN accession_kit_number;
ALTER TABLE health_lab.newborn_screenings ADD accession_kit_number AS
	accession_number + '-' + kit_number;
CREATE INDEX health_lab_newborn_screenings_accession_kit_number
	ON health_lab.newborn_screenings( accession_kit_number );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_pre', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_pre
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_pre') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_pre;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_pre AS
	RTRIM(SUBSTRING(patient_id, 1,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))-1,-1),LEN(patient_id))
	)) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_pre
--	ON health_lab.newborn_screenings( patient_id_pre );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_suf', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_suf
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_suf') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_suf;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_suf AS
	LTRIM(SUBSTRING(patient_id,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))+1,1),1),
		LEN(patient_id)
	)) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_suf
--	ON health_lab.newborn_screenings( patient_id_suf );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_prex', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_prex
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_prex') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_prex;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_prex AS
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(patient_id, 1,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))-1,-1),LEN(patient_id))
	),' ',''),'M',''),'R',''),'D',''),'V','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_prex
--	ON health_lab.newborn_screenings( patient_id_prex );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_sufx', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_sufx
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_sufx') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_sufx;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_sufx AS
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(patient_id,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))+1,1),1),
		LEN(patient_id)
	),' ',''),'M',''),'R',''),'D',''),'V','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_sufx
--	ON health_lab.newborn_screenings( patient_id_sufx );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_prexi', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_prexi
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_prexi') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_prexi;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_prexi AS
	REPLACE(LTRIM(REPLACE(
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(patient_id, 1,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))-1,-1),LEN(patient_id))
	),' ',''),'M',''),'R',''),'D',''),'V','')
	, '0', ' ')), ' ', '0') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_prexi
--	ON health_lab.newborn_screenings( patient_id_prexi );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_patient_id_sufxi', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_patient_id_sufxi
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','patient_id_sufxi') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN patient_id_sufxi;
ALTER TABLE health_lab.newborn_screenings ADD patient_id_sufxi AS
	REPLACE(LTRIM(REPLACE(
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(patient_id,
		ISNULL(NULLIF(CHARINDEX('/',REPLACE(patient_id,'-','/'))+1,1),1),
		LEN(patient_id)
	),' ',''),'M',''),'R',''),'D',''),'V','')
	, '0', ' ')), ' ', '0') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_patient_id_sufxi
--	ON health_lab.newborn_screenings( patient_id_sufxi );



--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__mom_surname', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__mom_surname
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_mom_surname') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _mom_surname;
ALTER TABLE health_lab.newborn_screenings ADD _mom_surname AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( mom_surname
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__mom_surname
--	ON health_lab.newborn_screenings( _mom_surname );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__last_name', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__last_name
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_last_name') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _last_name;
ALTER TABLE health_lab.newborn_screenings ADD _last_name AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( last_name
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__last_name
--	ON health_lab.newborn_screenings( _last_name );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__mom_first_name', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__mom_first_name
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_mom_first_name') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _mom_first_name;
ALTER TABLE health_lab.newborn_screenings ADD _mom_first_name AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( mom_first_name
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__mom_first_name
--	ON health_lab.newborn_screenings( _mom_first_name );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__first_name', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__first_name
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_first_name') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _first_name;
ALTER TABLE health_lab.newborn_screenings ADD _first_name AS
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( first_name
		, '-','') , ' ','') ,'''','') ,'RR','R') ,'SS','S') ,'LL','L') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__first_name
--	ON health_lab.newborn_screenings( _first_name );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__address', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__address
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_address') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _address;
ALTER TABLE health_lab.newborn_screenings ADD _address AS
	RTRIM( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
	REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( address
		,' BOULEVARD',' ') ,' BLVD',' ') -- contains RD, so before RD extraction
		,' COURT',' ') ,' CT',' ') ,' STREET',' ') ,' ST',' ')
		,' DRIVE',' ') ,' DRIV',' ') ,' DRI',' ') ,' DR',' ')
		,' ROAD',' ') ,' RD',' ')
		,' CIRCLE',' ') ,' CIR',' ') ,' LANE',' ') ,' LN',' ')
		,' AVENUE',' ') ,' AVE',' ')
		,' MOUNT',' MT'), ' PARKWAY',' '),' PKWY',' ')
		,'SOUTH','S') ,'NORTH','N') ,'EAST','E') ,'WEST','W') )
	PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__address
--	ON health_lab.newborn_screenings( _address );



--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__last_name_pre', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__last_name_pre
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_last_name_pre') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _last_name_pre;
ALTER TABLE health_lab.newborn_screenings ADD _last_name_pre AS
	REPLACE(SUBSTRING(last_name, 1,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(last_name,' ','-'))-1,-1),LEN(last_name))
	),' ','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__last_name_pre
--	ON health_lab.newborn_screenings( _last_name_pre );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__last_name_suf', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__last_name_suf
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_last_name_suf') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _last_name_suf;
ALTER TABLE health_lab.newborn_screenings ADD _last_name_suf AS
	REPLACE(SUBSTRING(last_name,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(last_name,' ','-'))+1,1),1),
		LEN(last_name)
	),' ','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__last_name_suf
--	ON health_lab.newborn_screenings( _last_name_suf );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__mom_surname_pre', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__mom_surname_pre
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_mom_surname_pre') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _mom_surname_pre;
ALTER TABLE health_lab.newborn_screenings ADD _mom_surname_pre AS
	REPLACE(SUBSTRING(mom_surname, 1,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(mom_surname,' ','-'))-1,-1),LEN(mom_surname))
	),' ','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__mom_surname_pre
--	ON health_lab.newborn_screenings( _mom_surname_pre );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__mom_surname_suf', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__mom_surname_suf
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_mom_surname_suf') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _mom_surname_suf;
ALTER TABLE health_lab.newborn_screenings ADD _mom_surname_suf AS
	REPLACE(SUBSTRING(mom_surname,
		ISNULL(NULLIF(CHARINDEX('-',REPLACE(mom_surname,' ','-'))+1,1),1),
		LEN(mom_surname)
	),' ','') PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__mom_surname_suf
--	ON health_lab.newborn_screenings( _mom_surname_suf );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__address_pre', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__address_pre
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_address_pre') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _address_pre;
ALTER TABLE health_lab.newborn_screenings ADD _address_pre AS
	SUBSTRING(address, 1,
		ISNULL(NULLIF(CHARINDEX(' ',address)-1,-1),LEN(address))
	) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__address_pre
--	ON health_lab.newborn_screenings( _address_pre );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings__address_suf', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings__address_suf
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','_address_suf') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN _address_suf;
ALTER TABLE health_lab.newborn_screenings ADD _address_suf AS
	SUBSTRING(address,
		ISNULL(NULLIF(CHARINDEX(' ',address)+1,1),1),
		LEN(address)
	) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings__address_suf
--	ON health_lab.newborn_screenings( _address_suf );


IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_zip_code', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_zip_code
		ON health_lab.newborn_screenings;
CREATE INDEX health_lab_newborn_screenings_zip_code
	ON health_lab.newborn_screenings( zip_code );

IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_birth_date', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_birth_date
		ON health_lab.newborn_screenings;
CREATE INDEX health_lab_newborn_screenings_birth_date
	ON health_lab.newborn_screenings( birth_date );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_mom_birth_date', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_mom_birth_date
--		ON health_lab.newborn_screenings;
--CREATE INDEX health_lab_newborn_screenings_mom_birth_date
--	ON health_lab.newborn_screenings( mom_birth_date );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_birth_date_day', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_birth_date_day
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','birth_date_day') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN birth_date_day;
ALTER TABLE health_lab.newborn_screenings ADD birth_date_day AS
	DAY(birth_date) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_birth_date_day
--	ON health_lab.newborn_screenings( birth_date_day );

IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_birth_date_month', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_birth_date_month
		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','birth_date_month') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN birth_date_month;
ALTER TABLE health_lab.newborn_screenings ADD birth_date_month AS
	MONTH(birth_date) PERSISTED;
CREATE INDEX health_lab_newborn_screenings_birth_date_month
	ON health_lab.newborn_screenings( birth_date_month );

IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
	'health_lab_newborn_screenings_birth_date_year', 'IndexId') IS NOT NULL
	DROP INDEX health_lab_newborn_screenings_birth_date_year
		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','birth_date_year') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN birth_date_year;
ALTER TABLE health_lab.newborn_screenings ADD birth_date_year AS
	YEAR(birth_date) PERSISTED;
CREATE INDEX health_lab_newborn_screenings_birth_date_year
	ON health_lab.newborn_screenings( birth_date_year );


--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_mom_birth_date_day', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_mom_birth_date_day
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','mom_birth_date_day') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN mom_birth_date_day;
ALTER TABLE health_lab.newborn_screenings ADD mom_birth_date_day AS
	DAY(mom_birth_date) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_mom_birth_date_day
--	ON health_lab.newborn_screenings( mom_birth_date_day );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_mom_birth_date_month', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_mom_birth_date_month
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','mom_birth_date_month') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN mom_birth_date_month;
ALTER TABLE health_lab.newborn_screenings ADD mom_birth_date_month AS
	MONTH(mom_birth_date) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_mom_birth_date_month
--	ON health_lab.newborn_screenings( mom_birth_date_month );

--IF IndexProperty(Object_Id('health_lab.newborn_screenings'),
--	'health_lab_newborn_screenings_mom_birth_date_year', 'IndexId') IS NOT NULL
--	DROP INDEX health_lab_newborn_screenings_mom_birth_date_year
--		ON health_lab.newborn_screenings;
IF COL_LENGTH('health_lab.newborn_screenings','mom_birth_date_year') IS NOT NULL
	ALTER TABLE health_lab.newborn_screenings DROP COLUMN mom_birth_date_year;
ALTER TABLE health_lab.newborn_screenings ADD mom_birth_date_year AS
	YEAR(mom_birth_date) PERSISTED;
--CREATE INDEX health_lab_newborn_screenings_mom_birth_date_year
--	ON health_lab.newborn_screenings( mom_birth_date_year );


INSERT INTO dbo.concepts VALUES (
	'DEM:DOB',
	'/Demographics/DOB',
	'Demographics:DOB');
INSERT INTO dbo.concepts VALUES (
	'DEM:Sex',
	'/Demographics/Sex',
	'Demographics:Sex');
INSERT INTO dbo.concepts VALUES (
	'DEM:Height',
	'/Demographics/Height',
	'Demographics:Height');
INSERT INTO dbo.concepts VALUES (
	'DEM:Weight',
	'/Demographics/Weight',
	'Demographics:Weight');
INSERT INTO dbo.concepts VALUES (
	'DEM:Race',
	'/Demographics/Race',
	'Demographics:Race');
INSERT INTO dbo.concepts VALUES (
	'DEM:Language',
	'/Demographics/Language',
	'Demographics:Language');
INSERT INTO dbo.concepts VALUES (
	'DEM:Zipcode',
	'/Demographics/Zipcode',
	'Demographics:Zipcode');
INSERT INTO dbo.concepts VALUES (
	'DEM:Other',
	'/Demographics/Other',
	'Demographics:Other');


