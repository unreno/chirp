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


--INSERT INTO vital.births (birthid,imported_to_observations) VALUES (1,'true');  -- 'true'=1
--INSERT INTO vital.births (birthid,imported_to_observations) VALUES (1,'false'); -- 'false'=0
--INSERT INTO vital.births (birthid,imported_to_observations) VALUES (1,'blahblahblah');
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

	--	In order to address the triplication of data from screening records,
	--	I've added the ROW_NUMBER() OVER ( PARTITION BY ... stuff
	--	This seems better that GROUP BY as it allows the ordering by
	--	one field (source_id) and selecting it and others (downloaded_at)

	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at, concept, value,
			units, source_schema, source_table, source_id, downloaded_at)
		SELECT chirp_id, provider_id, started_at, concept, value,
			units, source_schema, source_table, source_id, downloaded_at
		FROM (
			SELECT chirp_id, provider_id, started_at, cav.concept, cav.value,
				cav.units, source_schema, source_table, source_id, downloaded_at,
				ROW_NUMBER() OVER ( PARTITION BY
					chirp_id, started_at, cav.concept, cav.value, cav.units
					ORDER BY source_id ASC) AS row
			FROM (
				SELECT i.chirp_id,
					s.birth_date AS started_at,	-- I hope that the actual data include date lab performed
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
				WHERE imported_to_observations = 'FALSE'
			) unimported_data
			CROSS APPLY ( VALUES
				('DEM:ZIP', CAST(zip_code AS VARCHAR(255)), NULL)
			) cav ( concept, value, units )
			WHERE cav.value IS NOT NULL
		) rowed
		WHERE row = 1

	UPDATE s
		SET imported_to_observations = 'TRUE'
		FROM health_lab.newborn_screenings s
		JOIN private.identifiers i
			ON  i.source_id     = s.accession_kit_number
			AND i.source_column = 'accession_kit_number'
			AND i.source_table  = 'newborn_screenings'
			AND i.source_schema = 'health_lab'
		WHERE imported_to_observations = 'FALSE'
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

--awk -F, 'BEGIN{OFS=","}(/^--/){print}(!/^--/){gsub(/^[ ]+/,"",$2);gsub(/[ ]+$/,"",$2); gsub(/CAST \(/,"CAST(",$2);printf "%-25s, %-45s,%s\n", $1, $2,$3}' temp

	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, source_schema, source_table, source_id, downloaded_at)
		SELECT chirp_id, provider_id, started_at, cav.concept,
			CASE WHEN c.value IS NOT NULL THEN c.value ELSE cav.value END AS value,
			cav.units, source_schema, source_table, source_id, downloaded_at
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
			WHERE imported_to_observations = 'FALSE'
		) unimported_data
		CROSS APPLY ( VALUES
			('ac_anemia'          , CAST(ac_anemia AS VARCHAR(255))              , NULL),
			('ac_antisepis'       , CAST(ac_antisepis AS VARCHAR(255))           , NULL),
			('ac_bthinjury'       , CAST(ac_bthinjury AS VARCHAR(255))           , NULL),
			('ac_fas'             , CAST(ac_fas AS VARCHAR(255))                 , NULL),
			('ac_hyaline'         , CAST(ac_hyaline AS VARCHAR(255))             , NULL),
			('ac_mecon'           , CAST(ac_mecon AS VARCHAR(255))               , NULL),
			('ac_nicu'            , CAST(ac_nicu AS VARCHAR(255))                , NULL),
			('ac_none'            , CAST(ac_none AS VARCHAR(255))                , NULL),
			('ac_oth'             , CAST(ac_oth AS VARCHAR(255))                 , NULL),
			('ac_othlit'          , ac_othlit                                    , NULL),
			('ac_seizures'        , CAST(ac_seizures AS VARCHAR(255))            , NULL),
			('ac_surf'            , CAST(ac_surf AS VARCHAR(255))                , NULL),
			('ac_ventless'        , CAST(ac_ventless AS VARCHAR(255))            , NULL),
			('ac_ventmore'        , CAST(ac_ventmore AS VARCHAR(255))            , NULL),
			('acn_anencep'        , CAST(acn_anencep AS VARCHAR(255))            , NULL),
			('acn_cdit'           , CAST(acn_cdit AS VARCHAR(255))               , NULL),
			('acn_chromoth'       , CAST(acn_chromoth AS VARCHAR(255))           , NULL),
			('acn_chromothlit'    , acn_chromothlit                              , NULL),
			('acn_circ'           , CAST(acn_circ AS VARCHAR(255))               , NULL),
			('acn_cirlit'         , acn_cirlit                                   , NULL),
			('acn_cleftlip'       , CAST(acn_cleftlip AS VARCHAR(255))           , NULL),
			('acn_cleftpalate'    , CAST(acn_cleftpalate AS VARCHAR(255))        , NULL),
			('acn_clubft'         , CAST(acn_clubft AS VARCHAR(255))             , NULL),
			('acn_diaphhern'      , CAST(acn_diaphhern AS VARCHAR(255))          , NULL),
			('acn_downs'          , CAST(acn_downs AS VARCHAR(255))              , NULL),
			('acn_gastro'         , CAST(acn_gastro AS VARCHAR(255))             , NULL),
			('acn_gastrolit'      , acn_gastrolit                                , NULL),
			('acn_gastrosch'      , CAST(acn_gastrosch AS VARCHAR(255))          , NULL),
			('acn_hrtdis'         , CAST(acn_hrtdis AS VARCHAR(255))             , NULL),
			('acn_hrtmal'         , CAST(acn_hrtmal AS VARCHAR(255))             , NULL),
			('acn_hypos'          , CAST(acn_hypos AS VARCHAR(255))              , NULL),
			('acn_limbred'        , CAST(acn_limbred AS VARCHAR(255))            , NULL),
			('acn_malgen'         , CAST(acn_malgen AS VARCHAR(255))             , NULL),
			('acn_micro'          , CAST(acn_micro AS VARCHAR(255))              , NULL),
			('acn_muscle'         , CAST(acn_muscle AS VARCHAR(255))             , NULL),
			('acn_musclelit'      , acn_musclelit                                , NULL),
			('acn_nervous'        , CAST(acn_nervous AS VARCHAR(255))            , NULL),
			('acn_nervouslit'     , acn_nervouslit                               , NULL),
			('acn_none'           , CAST(acn_none AS VARCHAR(255))               , NULL),
			('acn_omphal'         , CAST(acn_omphal AS VARCHAR(255))             , NULL),
			('acn_oth'            , CAST(acn_oth AS VARCHAR(255))                , NULL),
			('acn_othlit'         , acn_othlit                                   , NULL),
			('acn_polydact'       , CAST(acn_polydact AS VARCHAR(255))           , NULL),
			('acn_rectal'         , CAST(acn_rectal AS VARCHAR(255))             , NULL),
			('acn_renal'          , CAST(acn_renal AS VARCHAR(255))              , NULL),
			('acn_spina'          , CAST(acn_spina AS VARCHAR(255))              , NULL),
			('acn_tracheo'        , CAST(acn_tracheo AS VARCHAR(255))            , NULL),
			('acn_urogen'         , CAST(acn_urogen AS VARCHAR(255))             , NULL),
			('acn_urogenlit'      , acn_urogenlit                                , NULL),
			('alcohol'            , CAST(alcohol AS VARCHAR(255))                , NULL),
			('apgar_10'           , CAST(apgar_10 AS VARCHAR(255))               , NULL),
			('apgar_5'            , CAST(apgar_5 AS VARCHAR(255))                , NULL),
			('attendant'          , CAST(attendant AS VARCHAR(255))              , NULL),
			('birth_ci'           , CAST(birth_ci AS VARCHAR(255))               , NULL),
			('birth_co'           , CAST(birth_co AS VARCHAR(255))               , NULL),
--			('birth_da'           , CAST(birth_da AS VARCHAR(255))               , NULL),
--			('birth_mo'           , CAST(birth_mo AS VARCHAR(255))               , NULL),
			('birth_rco'          , CAST(birth_rco AS VARCHAR(255))              , NULL),
			('birth_st'           , CAST(birth_st AS VARCHAR(255))               , NULL),
--			('birth_yr'           , CAST(birth_yr AS VARCHAR(255))               , NULL),
			('born_alive'         , CAST(born_alive AS VARCHAR(255))             , NULL),
			('breastfeeding'      , CAST(breastfeeding AS VARCHAR(255))          , NULL),
--			('bth_date', CAST(bth_date AS VARCHAR(255)), NULL),
			('bth_order'          , CAST(bth_order AS VARCHAR(255))              , NULL),
			('bth_present'        , CAST(bth_present AS VARCHAR(255))            , NULL),
			('bth_route'          , CAST(bth_route AS VARCHAR(255))              , NULL),
-- identifiable?
			('bth_time'           , CAST(bth_time AS VARCHAR(255))               , NULL),
			('bthwt_unit'         , CAST(bthwt_unit AS VARCHAR(255))             , NULL),
			('bwt_grp'            , CAST(bwt_grp AS VARCHAR(255))                , NULL),
--			('cer_da'             , CAST(cer_da AS VARCHAR(255))                 , NULL),
			('cer_date'           , CAST(cer_date AS VARCHAR(255))               , NULL),
--			('cer_mo'             , CAST(cer_mo AS VARCHAR(255))                 , NULL),
--			('cer_yr'             , CAST(cer_yr AS VARCHAR(255))                 , NULL),
-- identifiable
--			('cert_num', CAST (cert_num AS VARCHAR(255)), NULL),
--			('cert_yr', CAST (cert_yr AS VARCHAR(255)), NULL),
			('certifier'          , CAST(certifier AS VARCHAR(255))              , NULL),
--			('cig_pck'            , CAST(cig_pck AS VARCHAR(255))                , NULL),
			('cld_abrplac'        , CAST(cld_abrplac AS VARCHAR(255))            , NULL),
			('cld_anesth'         , CAST(cld_anesth AS VARCHAR(255))             , NULL),
			('cld_antibiotic'     , CAST(cld_antibiotic AS VARCHAR(255))         , NULL),
			('cld_aug'            , CAST(cld_aug AS VARCHAR(255))                , NULL),
			('cld_bleed'          , CAST(cld_bleed AS VARCHAR(255))              , NULL),
			('cld_cephpelv'       , CAST(cld_cephpelv AS VARCHAR(255))           , NULL),
			('cld_chorio'         , CAST(cld_chorio AS VARCHAR(255))             , NULL),
			('cld_cordpro'        , CAST(cld_cordpro AS VARCHAR(255))            , NULL),
			('cld_dysfunc'        , CAST(cld_dysfunc AS VARCHAR(255))            , NULL),
			('cld_epi'            , CAST(cld_epi AS VARCHAR(255))                , NULL),
			('cld_febrile'        , CAST(cld_febrile AS VARCHAR(255))            , NULL),
			('cld_fetalintol'     , CAST(cld_fetalintol AS VARCHAR(255))         , NULL),
			('cld_induc'          , CAST(cld_induc AS VARCHAR(255))              , NULL),
			('cld_mecon'          , CAST(cld_mecon AS VARCHAR(255))              , NULL),
			('cld_none'           , CAST(cld_none AS VARCHAR(255))               , NULL),
			('cld_nonvert'        , CAST(cld_nonvert AS VARCHAR(255))            , NULL),
			('cld_oth'            , CAST(cld_oth AS VARCHAR(255))                , NULL),
			('cld_othlit'         , cld_othlit                                   , NULL),
			('cld_placprev'       , CAST(cld_placprev AS VARCHAR(255))           , NULL),
			('cld_seizures'       , CAST(cld_seizures AS VARCHAR(255))           , NULL),
			('cld_steroid'        , CAST(cld_steroid AS VARCHAR(255))            , NULL),
			('dat_concep'         , CAST(dat_concep AS VARCHAR(255))             , NULL),
			('death_cert'         , CAST(death_cert AS VARCHAR(255))             , NULL),
			('death_date'         , CAST(death_date AS VARCHAR(255))             , NULL),
			('death_match'        , CAST(death_match AS VARCHAR(255))            , NULL),
			('del_wt'             , CAST(del_wt AS VARCHAR(255))                 , 'lbs'),
			('drink_wk'           , CAST(drink_wk AS VARCHAR(255))               , 'drinks'),
			('drug_use'           , CAST(drug_use AS VARCHAR(255))               , NULL),
			('du_otc'             , CAST(du_otc AS VARCHAR(255))                 , NULL),
			('du_other'           , CAST(du_other AS VARCHAR(255))               , NULL),
			('du_otherlit'        , du_otherlit                                  , NULL),
			('du_prscr'           , CAST(du_prscr AS VARCHAR(255))               , NULL),
			('fa_age'             , CAST(fa_age AS VARCHAR(255))                 , 'years'),
			('fa_age1'            , CAST(fa_age1 AS VARCHAR(255))                , NULL),
			('fa_amind'           , CAST(fa_amind AS VARCHAR(255))               , NULL),
			('fa_amindlit'        , fa_amindlit                                  , NULL),
			('fa_asian'           , CAST(fa_asian AS VARCHAR(255))               , NULL),
			('fa_asianlit'        , fa_asianlit                                  , NULL),
			('fa_asianoth'        , CAST(fa_asianoth AS VARCHAR(255))            , NULL),
			('fa_black'           , CAST(fa_black AS VARCHAR(255))               , NULL),
			('fa_bst'             , CAST(fa_bst AS VARCHAR(255))                 , NULL),
			('fa_bus'             , CAST(fa_bus AS VARCHAR(255))                 , NULL),
			('fa_busines1'        , CAST(fa_busines1 AS VARCHAR(255))            , NULL),
			('fa_chinese'         , CAST(fa_chinese AS VARCHAR(255))             , NULL),
			('fa_cu'              , CAST(fa_cu AS VARCHAR(255))                  , NULL),
			('fa_dob'             , CAST(fa_dob AS VARCHAR(255))                 , NULL),
			('fa_edu'             , CAST(fa_edu AS VARCHAR(255))                 , NULL),
			('fa_ethnic_nchs'     , CAST(fa_ethnic_nchs AS VARCHAR(255))         , NULL),
			('fa_ethoth'          , CAST(fa_ethoth AS VARCHAR(255))              , NULL),
			('fa_ethothlit'       , fa_ethothlit                                 , NULL),
			('fa_filipino'        , CAST(fa_filipino AS VARCHAR(255))            , NULL),
-- identifiable
--			('fa_fname', CAST (fa_fname AS VARCHAR(255)), NULL),
			('fa_guam'            , CAST(fa_guam AS VARCHAR(255))                , NULL),
			('fa_hawaiian'        , CAST(fa_hawaiian AS VARCHAR(255))            , NULL),
			('fa_his'             , CAST(fa_his AS VARCHAR(255))                 , NULL),
			('fa_husb'            , CAST(fa_husb AS VARCHAR(255))                , NULL),
			('fa_japanese'        , CAST(fa_japanese AS VARCHAR(255))            , NULL),
			('fa_korean'          , CAST(fa_korean AS VARCHAR(255))              , NULL),
			('fa_mex'             , CAST(fa_mex AS VARCHAR(255))                 , NULL),
-- identifiable
--			('fa_mname', CAST (fa_mname AS VARCHAR(255)), NULL),
			('fa_occ'             , CAST(fa_occ AS VARCHAR(255))                 , NULL),
			('fa_occup1'          , CAST(fa_occup1 AS VARCHAR(255))              , NULL),
			('fa_pacisl'          , CAST(fa_pacisl AS VARCHAR(255))              , NULL),
			('fa_pacisllit'       , fa_pacisllit                                 , NULL),
			('fa_pr'              , CAST(fa_pr AS VARCHAR(255))                  , NULL),
			('fa_race1'           , CAST(fa_race1 AS VARCHAR(255))               , NULL),
			('fa_race16'          , CAST(fa_race16 AS VARCHAR(255))              , NULL),
			('fa_race18'          , CAST(fa_race18 AS VARCHAR(255))              , NULL),
			('fa_race2'           , CAST(fa_race2 AS VARCHAR(255))               , NULL),
			('fa_race20'          , CAST(fa_race20 AS VARCHAR(255))              , NULL),
			('fa_race22'          , CAST(fa_race22 AS VARCHAR(255))              , NULL),
			('fa_race3'           , CAST(fa_race3 AS VARCHAR(255))               , NULL),
			('fa_race4'           , CAST(fa_race4 AS VARCHAR(255))               , NULL),
			('fa_race5'           , CAST(fa_race5 AS VARCHAR(255))               , NULL),
			('fa_race6'           , CAST(fa_race6 AS VARCHAR(255))               , NULL),
			('fa_race7'           , CAST(fa_race7 AS VARCHAR(255))               , NULL),
			('fa_race8'           , CAST(fa_race8 AS VARCHAR(255))               , NULL),
			('fa_raceoth'         , CAST(fa_raceoth AS VARCHAR(255))             , NULL),
			('fa_raceothlit'      , fa_raceothlit                                , NULL),
			('fa_raceref'         , CAST(fa_raceref AS VARCHAR(255))             , NULL),
			('fa_raceunk'         , CAST(fa_raceunk AS VARCHAR(255))             , NULL),
			('fa_samoan'          , CAST(fa_samoan AS VARCHAR(255))              , NULL),
			('fa_signpat'         , CAST(fa_signpat AS VARCHAR(255))             , NULL),
-- identifiable
--			('fa_sname', CAST (fa_sname AS VARCHAR(255)), NULL),
--			('fa_ssn', CAST (fa_ssn AS VARCHAR(255)), NULL),
			('fa_vietnamese'      , CAST(fa_vietnamese AS VARCHAR(255))          , NULL),
			('fa_white'           , CAST(fa_white AS VARCHAR(255))               , NULL),
-- identifiable
--			('fa_xname', CAST (fa_xname AS VARCHAR(255)), NULL),
			('facility'           , CAST(facility AS VARCHAR(255))               , NULL),
			('fahisp_nchs'        , CAST(fahisp_nchs AS VARCHAR(255))            , NULL),
			('farace_ethnchs'     , CAST(farace_ethnchs AS VARCHAR(255))         , NULL),
			('farace_nchsbrg'     , CAST(farace_nchsbrg AS VARCHAR(255))         , NULL),
--			('filler10', CAST (filler10 AS VARCHAR(255)), NULL),
--			('filler14', CAST (filler14 AS VARCHAR(255)), NULL),
--			('filler15', CAST (filler15 AS VARCHAR(255)), NULL),
--			('filler16', CAST (filler16 AS VARCHAR(255)), NULL),
--			('filler17', CAST (filler17 AS VARCHAR(255)), NULL),
--			('filler7', CAST (filler7 AS VARCHAR(255)), NULL),
--			('filler8', CAST (filler8 AS VARCHAR(255)), NULL),
--			('filler9', CAST (filler9 AS VARCHAR(255)), NULL),
			('first_cig'          , CAST(first_cig AS VARCHAR(255))              , NULL),
--			('first_pck'          , CAST(first_pck AS VARCHAR(255))              , NULL),
			('gest_days'          , CAST(gest_days AS VARCHAR(255))              , 'days'),
			('gest_est'           , CAST(gest_est AS VARCHAR(255))               , 'weeks'),
			('gest_grp'           , CAST(gest_grp AS VARCHAR(255))               , NULL),
			('gest_wks'           , CAST(gest_wks AS VARCHAR(255))               , 'weeks'),
--			('grams', CAST(grams AS VARCHAR(255)), 'grams'),
			('incity'             , CAST(incity AS VARCHAR(255))                 , NULL),
			('inf_chlam'          , CAST(inf_chlam AS VARCHAR(255))              , NULL),
			('inf_cmv'            , CAST(inf_cmv AS VARCHAR(255))                , NULL),
			('inf_genherpes'      , CAST(inf_genherpes AS VARCHAR(255))          , NULL),
			('inf_gonor'          , CAST(inf_gonor AS VARCHAR(255))              , NULL),
			('inf_hepb'           , CAST(inf_hepb AS VARCHAR(255))               , NULL),
			('inf_hepc'           , CAST(inf_hepc AS VARCHAR(255))               , NULL),
			('inf_hivaids'        , CAST(inf_hivaids AS VARCHAR(255))            , NULL),
-- identifiable
--			('inf_hospnum', CAST (inf_hospnum AS VARCHAR(255)), NULL),
			('inf_hpv'            , CAST(inf_hpv AS VARCHAR(255))                , NULL),
			('inf_liv'            , CAST(inf_liv AS VARCHAR(255))                , NULL),
			('inf_none'           , CAST(inf_none AS VARCHAR(255))               , NULL),
			('inf_oth'            , CAST(inf_oth AS VARCHAR(255))                , NULL),
			('inf_othlit'         , inf_othlit                                   , NULL),
			('inf_rubella'        , CAST(inf_rubella AS VARCHAR(255))            , NULL),
			('inf_syph'           , CAST(inf_syph AS VARCHAR(255))               , NULL),
			('inf_toxo'           , CAST(inf_toxo AS VARCHAR(255))               , NULL),
			('inf_trans'          , CAST(inf_trans AS VARCHAR(255))              , NULL),
			('inf_tuber'          , CAST(inf_tuber AS VARCHAR(255))              , NULL),
			('last_cig'           , CAST(last_cig AS VARCHAR(255))               , NULL),
--			('last_pck'           , CAST(last_pck AS VARCHAR(255))               , NULL),
--			('lbs', CAST (lbs AS VARCHAR(255)), NULL),
			('live_bthdead'       , CAST(live_bthdead AS VARCHAR(255))           , NULL),
			('live_bthliv'        , CAST(live_bthliv AS VARCHAR(255))            , NULL),
--			('lm_da'              , CAST(lm_da AS VARCHAR(255))                  , NULL),
			('lm_date'            , CAST(lm_date AS VARCHAR(255))                , NULL),
--			('lm_mo'              , CAST(lm_mo AS VARCHAR(255))                  , NULL),
--			('lm_yr'              , CAST(lm_yr AS VARCHAR(255))                  , NULL),
-- identifiable
--			('maiden_n', CAST (maiden_n AS VARCHAR(255)), NULL),
			('married_betw'       , CAST(married_betw AS VARCHAR(255))           , NULL),
			('match_certnum'      , CAST(match_certnum AS VARCHAR(255))          , NULL),
			('md_forcepsattpt'    , CAST(md_forcepsattpt AS VARCHAR(255))        , NULL),
			('md_vaccumattpt'     , CAST(md_vaccumattpt AS VARCHAR(255))         , NULL),
			('mm_hyster'          , CAST(mm_hyster AS VARCHAR(255))              , NULL),
			('mm_icu'             , CAST(mm_icu AS VARCHAR(255))                 , NULL),
			('mm_none'            , CAST(mm_none AS VARCHAR(255))                , NULL),
			('mm_perilac'         , CAST(mm_perilac AS VARCHAR(255))             , NULL),
			('mm_ruputerus'       , CAST(mm_ruputerus AS VARCHAR(255))           , NULL),
			('mm_trnsfusion'      , CAST(mm_trnsfusion AS VARCHAR(255))          , NULL),
			('mm_unk'             , CAST(mm_unk AS VARCHAR(255))                 , NULL),
			('mm_unploper'        , CAST(mm_unploper AS VARCHAR(255))            , NULL),
-- identifiable
--			('mom_address', CAST (mom_address AS VARCHAR(255)), NULL),
			('mom_age'            , CAST(mom_age AS VARCHAR(255))                , 'years'),
			('mom_age1'           , CAST(mom_age1 AS VARCHAR(255))               , NULL),
			('mom_amind'          , CAST(mom_amind AS VARCHAR(255))              , NULL),
			('mom_amindlit'       , mom_amindlit                                 , NULL),
-- identifiable
--			('mom_apt', CAST (mom_apt AS VARCHAR(255)), NULL),
			('mom_asian'          , CAST(mom_asian AS VARCHAR(255))              , NULL),
			('mom_asianlit'       , mom_asianlit                                 , NULL),
			('mom_asianoth'       , CAST(mom_asianoth AS VARCHAR(255))           , NULL),
			('mom_black'          , CAST(mom_black AS VARCHAR(255))              , NULL),
			('mom_bst'            , CAST(mom_bst AS VARCHAR(255))                , NULL),
			('mom_bthcntry_fips'  , mom_bthcntry_fips                            , NULL),
			('mom_bthstate_fips'  , mom_bthstate_fips                            , NULL),
			('mom_bus'            , CAST(mom_bus AS VARCHAR(255))                , NULL),
			('mom_busines1'       , CAST(mom_busines1 AS VARCHAR(255))           , NULL),
			('mom_chinese'        , CAST(mom_chinese AS VARCHAR(255))            , NULL),
			('mom_cu'             , CAST(mom_cu AS VARCHAR(255))                 , NULL),
			('mom_dob'            , CAST(mom_dob AS VARCHAR(255))                , NULL),
			('mom_edu'            , CAST(mom_edu AS VARCHAR(255))                , NULL),
			('mom_ethnic_nchs'    , CAST(mom_ethnic_nchs AS VARCHAR(255))        , NULL),
			('mom_ethoth'         , CAST(mom_ethoth AS VARCHAR(255))             , NULL),
			('mom_ethothlit'      , mom_ethothlit                                , NULL),
			('mom_everm'          , CAST(mom_everm AS VARCHAR(255))              , NULL),
			('mom_filipino'       , CAST(mom_filipino AS VARCHAR(255))           , NULL),
-- identifiable
--			('mom_fnam', CAST (mom_fnam AS VARCHAR(255)), NULL),
			('mom_guam'           , CAST(mom_guam AS VARCHAR(255))               , NULL),
			('mom_hawaiian'       , CAST(mom_hawaiian AS VARCHAR(255))           , NULL),
			('mom_his'            , CAST(mom_his AS VARCHAR(255))                , NULL),
-- identifiable
--			('mom_hospnum', CAST (mom_hospnum AS VARCHAR(255)), NULL),
			('mom_htft'           , CAST(mom_htft AS VARCHAR(255))               , 'feet'),
			('mom_htinch'         , CAST(mom_htinch AS VARCHAR(255))             , 'inches'),
			('mom_japanese'       , CAST(mom_japanese AS VARCHAR(255))           , NULL),
			('mom_korean'         , CAST(mom_korean AS VARCHAR(255))             , NULL),
			('mom_mex'            , CAST(mom_mex AS VARCHAR(255))                , NULL),
-- identifiable
--			('mom_mnam', CAST (mom_mnam AS VARCHAR(255)), NULL),
			('mom_occ'            , CAST(mom_occ AS VARCHAR(255))                , NULL),
			('mom_occup1'         , CAST(mom_occup1 AS VARCHAR(255))             , NULL),
			('mom_pacisl'         , CAST(mom_pacisl AS VARCHAR(255))             , NULL),
			('mom_pacisllit'      , mom_pacisllit                                , NULL),
			('mom_pr'             , CAST(mom_pr AS VARCHAR(255))                 , NULL),
			('mom_race1'          , CAST(mom_race1 AS VARCHAR(255))              , NULL),
			('mom_race16'         , CAST(mom_race16 AS VARCHAR(255))             , NULL),
			('mom_race18'         , CAST(mom_race18 AS VARCHAR(255))             , NULL),
			('mom_race2'          , CAST(mom_race2 AS VARCHAR(255))              , NULL),
			('mom_race20'         , CAST(mom_race20 AS VARCHAR(255))             , NULL),
			('mom_race22'         , CAST(mom_race22 AS VARCHAR(255))             , NULL),
			('mom_race3'          , CAST(mom_race3 AS VARCHAR(255))              , NULL),
			('mom_race4'          , CAST(mom_race4 AS VARCHAR(255))              , NULL),
			('mom_race5'          , CAST(mom_race5 AS VARCHAR(255))              , NULL),
			('mom_race6'          , CAST(mom_race6 AS VARCHAR(255))              , NULL),
			('mom_race7'          , CAST(mom_race7 AS VARCHAR(255))              , NULL),
			('mom_race8'          , CAST(mom_race8 AS VARCHAR(255))              , NULL),
			('mom_raceoth'        , CAST(mom_raceoth AS VARCHAR(255))            , NULL),
			('mom_raceothlit'     , mom_raceothlit                               , NULL),
			('mom_raceref'        , CAST(mom_raceref AS VARCHAR(255))            , NULL),
			('mom_raceunk'        , CAST(mom_raceunk AS VARCHAR(255))            , NULL),
			('mom_rci'            , CAST(mom_rci AS VARCHAR(255))                , NULL),
			('mom_rco'            , CAST(mom_rco AS VARCHAR(255))                , NULL),
			('mom_rst'            , CAST(mom_rst AS VARCHAR(255))                , NULL),
--			('mom_rzip', CAST (mom_rzip AS VARCHAR(255)), NULL),
			('mom_samoan'         , CAST(mom_samoan AS VARCHAR(255))             , NULL),
-- identifiable
--			('mom_snam', CAST (mom_snam AS VARCHAR(255)), NULL),
--			('mom_ssn', CAST (mom_ssn AS VARCHAR(255)), NULL),
			('mom_trans'          , CAST(mom_trans AS VARCHAR(255))              , NULL),
			('mom_vietnamese'     , CAST(mom_vietnamese AS VARCHAR(255))         , NULL),
			('mom_white'          , CAST(mom_white AS VARCHAR(255))              , NULL),
-- identifiable
--			('mom_xnam', CAST (mom_xnam AS VARCHAR(255)), NULL),
			('momhisp_nchs'       , CAST(momhisp_nchs AS VARCHAR(255))           , NULL),
			('momrace_ethnchs'    , CAST(momrace_ethnchs AS VARCHAR(255))        , NULL),
			('momrace_nchsbrg'    , CAST(momrace_nchsbrg AS VARCHAR(255))        , NULL),
			('mpv_cal'            , CAST(mpv_cal AS VARCHAR(255))                , NULL),
			('mpv_days_cal'       , CAST(mpv_days_cal AS VARCHAR(255))           , NULL),
			('mres_city_fips'     , CAST(mres_city_fips AS VARCHAR(255))         , NULL),
			('mres_cntry_fips'    , mres_cntry_fips                              , NULL),
			('mres_cnty_fips'     , CAST(mres_cnty_fips AS VARCHAR(255))         , NULL),
			('mres_st_fips'       , mres_st_fips                                 , NULL),
			('mrf_anemia'         , CAST(mrf_anemia AS VARCHAR(255))             , NULL),
			('mrf_assistrep'      , CAST(mrf_assistrep AS VARCHAR(255))          , NULL),
			('mrf_cardiac'        , CAST(mrf_cardiac AS VARCHAR(255))            , NULL),
			('mrf_eclampsia'      , CAST(mrf_eclampsia AS VARCHAR(255))          , NULL),
			('mrf_gestdiab'       , CAST(mrf_gestdiab AS VARCHAR(255))           , NULL),
			('mrf_hemoglob'       , CAST(mrf_hemoglob AS VARCHAR(255))           , NULL),
			('mrf_hydra'          , CAST(mrf_hydra AS VARCHAR(255))              , NULL),
			('mrf_hypergest'      , CAST(mrf_hypergest AS VARCHAR(255))          , NULL),
			('mrf_hypert'         , CAST(mrf_hypert AS VARCHAR(255))             , NULL),
			('mrf_hypertchr'      , CAST(mrf_hypertchr AS VARCHAR(255))          , NULL),
			('mrf_incompcerv'     , CAST(mrf_incompcerv AS VARCHAR(255))         , NULL),
			('mrf_infdrugs'       , CAST(mrf_infdrugs AS VARCHAR(255))           , NULL),
			('mrf_inftreat'       , CAST(mrf_inftreat AS VARCHAR(255))           , NULL),
			('mrf_lungdis'        , CAST(mrf_lungdis AS VARCHAR(255))            , NULL),
			('mrf_none'           , CAST(mrf_none AS VARCHAR(255))               , NULL),
			('mrf_oth'            , CAST(mrf_oth AS VARCHAR(255))                , NULL),
			('mrf_othlit'         , mrf_othlit                                   , NULL),
			('mrf_poorout'        , CAST(mrf_poorout AS VARCHAR(255))            , NULL),
			('mrf_prediab'        , CAST(mrf_prediab AS VARCHAR(255))            , NULL),
			('mrf_prev4000'       , CAST(mrf_prev4000 AS VARCHAR(255))           , NULL),
			('mrf_prevces'        , CAST(mrf_prevces AS VARCHAR(255))            , NULL),
			('mrf_prevcesnum'     , CAST(mrf_prevcesnum AS VARCHAR(255))         , NULL),
			('mrf_prevpreterm'    , CAST(mrf_prevpreterm AS VARCHAR(255))        , NULL),
			('mrf_renaldis'       , CAST(mrf_renaldis AS VARCHAR(255))           , NULL),
			('mrf_rhsensit'       , CAST(mrf_rhsensit AS VARCHAR(255))           , NULL),
			('mrf_utbleed'        , CAST(mrf_utbleed AS VARCHAR(255))            , NULL),
-- identifiable,
--			('name_fir', CAST (name_fir AS VARCHAR(255)), NULL),
--			('name_mid', CAST (name_mid AS VARCHAR(255)), NULL),
--			('name_sur', CAST (name_sur AS VARCHAR(255)), NULL),
--			('name_sux', CAST (name_sux AS VARCHAR(255)), NULL),
			('ob_amnio'           , CAST(ob_amnio AS VARCHAR(255))               , NULL),
			('ob_cephfail'        , CAST(ob_cephfail AS VARCHAR(255))            , NULL),
			('ob_cephsucess'      , CAST(ob_cephsucess AS VARCHAR(255))          , NULL),
			('ob_cercl'           , CAST(ob_cercl AS VARCHAR(255))               , NULL),
			('ob_fetalmon'        , CAST(ob_fetalmon AS VARCHAR(255))            , NULL),
			('ob_none'            , CAST(ob_none AS VARCHAR(255))                , NULL),
			('ob_oth'             , CAST(ob_oth AS VARCHAR(255))                 , NULL),
			('ob_othlit'          , ob_othlit                                    , NULL),
			('ob_toco'            , CAST(ob_toco AS VARCHAR(255))                , NULL),
			('ob_ultrasnd'        , CAST(ob_ultrasnd AS VARCHAR(255))            , NULL),
			('ol_none'            , CAST(ol_none AS VARCHAR(255))                , NULL),
			('ol_preciplbr'       , CAST(ol_preciplbr AS VARCHAR(255))           , NULL),
			('ol_prerom'          , CAST(ol_prerom AS VARCHAR(255))              , NULL),
			('ol_prolonglbr'      , CAST(ol_prolonglbr AS VARCHAR(255))          , NULL),
--			('oz', CAST (oz AS VARCHAR(255)), NULL),
			('pat_complete'       , CAST(pat_complete AS VARCHAR(255))           , NULL),
			('place'              , CAST(place AS VARCHAR(255))                  , NULL),
			('plurality'          , CAST(plurality AS VARCHAR(255))              , NULL),
--			('pre_begda'          , CAST(pre_begda AS VARCHAR(255))              , NULL),
			('pre_begin'          , CAST(pre_begin AS VARCHAR(255))              , NULL),
--			('pre_begmo'          , CAST(pre_begmo AS VARCHAR(255))              , NULL),
--			('pre_begyr'          , CAST(pre_begyr AS VARCHAR(255))              , NULL),
			('pre_end'            , CAST(pre_end AS VARCHAR(255))                , NULL),
--			('pre_endda'          , CAST(pre_endda AS VARCHAR(255))              , NULL),
--			('pre_endmo'          , CAST(pre_endmo AS VARCHAR(255))              , NULL),
--			('pre_endyr'          , CAST(pre_endyr AS VARCHAR(255))              , NULL),
			('prenatal'           , CAST(prenatal AS VARCHAR(255))               , NULL),
			('prepreg_cig'        , CAST(prepreg_cig AS VARCHAR(255))            , NULL),
--			('prepreg_pck'        , CAST(prepreg_pck AS VARCHAR(255))            , NULL),
			('prepreg_wt'         , CAST(prepreg_wt AS VARCHAR(255))             , 'lbs'),
			('prv_livebth'        , CAST(prv_livebth AS VARCHAR(255))            , NULL),
			('prv_livebthdte'     , CAST(prv_livebthdte AS VARCHAR(255))         , NULL),
			('prv_term'           , CAST(prv_term AS VARCHAR(255))               , NULL),
			('pv_trims_cal'       , CAST(pv_trims_cal AS VARCHAR(255))           , NULL),
--			('reg_da'             , CAST(reg_da AS VARCHAR(255))                 , NULL),
			('reg_date'           , CAST(reg_date AS VARCHAR(255))               , NULL),
--			('reg_mo'             , CAST(reg_mo AS VARCHAR(255))                 , NULL),
--			('reg_yr'             , CAST(reg_yr AS VARCHAR(255))                 , NULL),
			('sec_cig'            , CAST(sec_cig AS VARCHAR(255))                , NULL),
--			('sec_pck'            , CAST(sec_pck AS VARCHAR(255))                , NULL),
			('sex'                , CAST(sex AS VARCHAR(255))                    , NULL),
			('source_pay'         , CAST(source_pay AS VARCHAR(255))             , NULL),
-- identifiable
--			('ssn_child', CAST (ssn_child AS VARCHAR(255)), NULL),
			('ssn_date'           , CAST(ssn_date AS VARCHAR(255))               , NULL),
			('ssn_request'        , CAST(ssn_request AS VARCHAR(255))            , NULL),
			('term_dte'           , CAST(term_dte AS VARCHAR(255))               , NULL),
			('tobacco'            , CAST(tobacco AS VARCHAR(255))                , NULL),
			('tot_visits'         , CAST(tot_visits AS VARCHAR(255))             , NULL),
			('trial_lbr'          , CAST(trial_lbr AS VARCHAR(255))              , NULL),
--			('void', CAST (void AS VARCHAR(255)), NULL),
			('wic'                , CAST(wic AS VARCHAR(255))                    , NULL),
			('wt_gain'            , CAST(wt_gain AS VARCHAR(255))                , 'lbs'),
			('DEM:DOB'            , CAST(bth_date AS VARCHAR(255))               , NULL),
			('birth_qtr'          , CAST(DATEPART(q,bth_date) AS VARCHAR(255))   , NULL),
			('DEM:ZIP'            , CAST(mom_rzip AS VARCHAR(255))               , NULL),
			('DEM:Weight'         , CAST(grams AS VARCHAR(255))                  , 'grams'),
			('DEM:Weight'         , CAST(
				bin.weight_from_lbs_and_oz( lbs, oz ) AS VARCHAR(255))             , 'lbs')
		) cav ( concept, value, units )
		LEFT JOIN dbo.dictionary d
			ON  d._schema = 'vital'
			AND d._table = 'births'
			AND d.field = cav.concept
		LEFT JOIN dbo.codes c
			ON  c._schema = 'vital'
			AND c._table = 'births'
			AND d.codeset = c.codeset
			AND CAST(c.code AS VARCHAR(255)) = cav.value
		WHERE cav.value IS NOT NULL

	UPDATE b
		SET imported_to_observations = 'TRUE'
		FROM vital.births b
		JOIN private.identifiers i
			ON  i.source_id     = b.cert_year_num
			AND i.source_column = 'cert_year_num'
			AND i.source_table  = 'births'
			AND i.source_schema = 'vital'
		WHERE imported_to_observations = 'FALSE'
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
					WHEN (b._mom_dob_year = s._mom_birth_date_year AND b._mom_dob_month = s._mom_birth_date_month) THEN 0.5
					WHEN (b._mom_dob_day  = s._mom_birth_date_day  AND b._mom_dob_month = s._mom_birth_date_month) THEN 0.5
					WHEN (b._mom_dob_year = s._mom_birth_date_year AND b._mom_dob_day   = s._mom_birth_date_day)   THEN 0.5
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
/*
	I think that using an edit distance function could be useful in comparing names
	that may be mispelled kinda like so ...

select name_sur, mom_snam,
1 - ( dbo.edit_distance(name_sur,mom_snam) /  (0.5 * ((LEN(name_sur) + LEN(mom_snam)) + ABS(LEN(name_sur) - LEN(mom_snam))) ))

from vital.births
*/
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
			WHERE b._bth_date_year = @year AND b._bth_date_month = @month
				AND i2.chirp_id IS NULL
/*
				AND s._birth_date_year = @year AND s._birth_date_month = @month
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



-- Called from a SSIS / BIDS project (Using SSIS seems to make this all more complicated.)
IF OBJECT_ID ( 'bin.reset_vital_births_buffer_identity', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.reset_vital_births_buffer_identity;
GO
CREATE PROCEDURE bin.reset_vital_births_buffer_identity
AS
BEGIN
	SET NOCOUNT ON;

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'vital.births_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'vital.births_buffer', RESEED, 0);


END	--	bin.reset_vital_births_buffer_identity
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
			'ROWTERMINATOR = '''+CHAR(10)+''', FIELDTERMINATOR = ''|'', FIRSTROW = 2, TABLOCK )';
--			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 2, TABLOCK )';

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'vital.births_buffer','U') AND last_value IS NOT NULL)
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

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'health_lab.newborn_screenings_buffer','U') AND last_value IS NOT NULL)
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

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'health_lab.newborn_screenings_buffer','U') AND last_value IS NOT NULL)
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

	-- do something similar to linking births to screenings with scoring and ranking

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

