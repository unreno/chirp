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


IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_table_webiz_immunizations', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse_by_table_webiz_immunizations;
GO
CREATE PROCEDURE bin.import_into_data_warehouse_by_table_webiz_immunizations
AS
BEGIN
	SET NOCOUNT ON;

--	Changing the concept to NOT match the field complication count extraction

	INSERT INTO dbo.observations WITH (TABLOCK)
		(chirp_id, provider_id, started_at, ended_at,
			concept, raw, value, units, source_schema, source_table, source_id, downloaded_at)
		SELECT chirp_id, provider_id, started_at, started_at,
			'vaccination_desc' AS concept, raw,
			CASE WHEN c.value IS NOT NULL THEN c.value ELSE vaccination_desc END AS value,
			c.units AS units, source_schema, source_table, source_id, downloaded_at
		FROM (
			SELECT i.chirp_id, 
				vaccination_date AS started_at,
				vaccination_desc AS raw,
				'webiz' AS source_schema,
				'immunizations' AS source_table,
				b.id AS source_id,
				b.*,
				imported_at AS downloaded_at
			FROM webiz.immunizations b
			JOIN private.identifiers i
				ON i.source_id = patient_id
				AND i.source_column = 'patient_id'
				AND i.source_table = 'immunizations'
				AND i.source_schema = 'webiz'
			WHERE imported_to_observations = 'FALSE'
		) unimported_data
		LEFT JOIN dbo.dictionary d
			ON  d._schema = 'webiz'
			AND d._table = 'immunizations'
			AND d.field = 'vaccination_desc'
		LEFT JOIN dbo.codes c
			ON  c._schema = 'webiz'
			AND c._table = 'immunizations'
			AND d.codeset = c.codeset
			AND CAST(c.code AS VARCHAR(255)) = vaccination_desc

	UPDATE b
		SET imported_to_observations = 'TRUE'
		FROM webiz.immunizations b
		JOIN private.identifiers i
			ON  i.source_id     = b.patient_id
			AND i.source_column = 'patient_id'
			AND i.source_table  = 'immunizations'
			AND i.source_schema = 'webiz'
		WHERE imported_to_observations = 'FALSE'
			AND i.id IS NOT NULL

END -- CREATE PROCEDURE bin.import_into_data_warehouse_by_table_webiz_immunizations
GO


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

	INSERT INTO dbo.observations WITH (TABLOCK)
		(chirp_id, provider_id, started_at, ended_at, concept, value, raw,
			units, source_schema, source_table, source_id, downloaded_at)
		SELECT chirp_id, provider_id, started_at, started_at, concept, value, value,
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

--	awk '{q="'"'"'"$0"'"'"'";printf( "%s%30s, %50s, NULL),\n","(",q,$0 )}' vital_birth_fields.txt 

	INSERT INTO dbo.observations WITH (TABLOCK)
		(chirp_id, provider_id, started_at, ended_at, raw,
			concept, value, units, source_schema, source_table, source_id, downloaded_at)
		SELECT chirp_id, provider_id, started_at, started_at, cav.value AS raw, cav.concept,
			CASE WHEN c.value IS NOT NULL THEN c.value ELSE cav.value END AS value,
			cav.units, source_schema, source_table, source_id, downloaded_at
		FROM (
			SELECT i.chirp_id,
				b._date_of_birth_date AS started_at,
				0 AS provider_id,
				'vital' AS source_schema,
				'births' AS source_table,
				b.id AS source_id,
				b.*,
				imported_at AS downloaded_at
			FROM vital.births b
			JOIN private.identifiers i
				ON i.source_id = state_file_number
				AND i.source_column = 'state_file_number'
				AND i.source_table = 'births'
				AND i.source_schema = 'vital'
			WHERE imported_to_observations = 'FALSE'
				AND mother_res_zip IN ( '89402', '89405', '89412', '89424', '89431', '89432', '89433', '89434', '89435', '89436', '89439', '89441', '89442', '89450', '89451', '89452', '89501', '89502', '89503', '89504', '89505', '89506', '89507', '89509', '89510', '89511', '89512', '89513', '89515', '89519', '89520', '89521', '89523', '89533', '89555', '89557', '89570', '89595', '89599', '89704')
		) unimported_data
		CROSS APPLY ( VALUES
--			(           'state_file_number',            CAST(state_file_number AS VARCHAR(255)), NULL),
--			(                   'void_flag',                    CAST(void_flag AS VARCHAR(255)), NULL),
--			(                   'name_last',                    CAST(name_last AS VARCHAR(255)), NULL),
--			(                 'name_suffix',                  CAST(name_suffix AS VARCHAR(255)), NULL),
--			(                  'name_first',                   CAST(name_first AS VARCHAR(255)), NULL),
--			(                 'name_middle',                  CAST(name_middle AS VARCHAR(255)), NULL),
			(                         'sex',                          CAST(sex AS VARCHAR(255)), NULL),
			(               'date_of_birth',                CAST(date_of_birth AS VARCHAR(255)), NULL),
			(               'time_of_birth',                CAST(time_of_birth AS VARCHAR(255)), NULL),
			(               'fac_type_code',                CAST(fac_type_code AS VARCHAR(255)), NULL),
			(                 'fac_nv_code',                  CAST(fac_nv_code AS VARCHAR(255)), NULL),
			(               'fac_st_nv_old',                CAST(fac_st_nv_old AS VARCHAR(255)), NULL),
			(             'fac_city_nv_old',              CAST(fac_city_nv_old AS VARCHAR(255)), NULL),
			(             'fac_cnty_nv_old',              CAST(fac_cnty_nv_old AS VARCHAR(255)), NULL),
			(        'attendant_title_code',         CAST(attendant_title_code AS VARCHAR(255)), NULL),
--			(            'mother_name_last',             CAST(mother_name_last AS VARCHAR(255)), NULL),
--			(          'mother_name_suffix',           CAST(mother_name_suffix AS VARCHAR(255)), NULL),
--			(           'mother_name_first',            CAST(mother_name_first AS VARCHAR(255)), NULL),
--			(          'mother_name_middle',           CAST(mother_name_middle AS VARCHAR(255)), NULL),
--			(          'mother_name_last_p',           CAST(mother_name_last_p AS VARCHAR(255)), NULL),
--			(        'mother_name_suffix_p',         CAST(mother_name_suffix_p AS VARCHAR(255)), NULL),
			(               'b2_mother_dob',                CAST(b2_mother_dob AS VARCHAR(255)), NULL),
			(               'b2_mother_age',                CAST(b2_mother_age AS VARCHAR(255)), NULL),
			('mbir_country_country_code_nv', CAST(mbir_country_country_code_nv AS VARCHAR(255)), NULL),
			(    'mbir_state_state_code_nv',     CAST(mbir_state_state_code_nv AS VARCHAR(255)), NULL),
			(    'mres_state_state_code_nv',     CAST(mres_state_state_code_nv AS VARCHAR(255)), NULL),
			(      'mother_res_city_nv_old',       CAST(mother_res_city_nv_old AS VARCHAR(255)), NULL),
			(      'mother_res_cnty_nv_old',       CAST(mother_res_cnty_nv_old AS VARCHAR(255)), NULL),
--			(            'mother_res_addr1',             CAST(mother_res_addr1 AS VARCHAR(255)), NULL),
--			(              'mother_res_apt',               CAST(mother_res_apt AS VARCHAR(255)), NULL),
			(              'mother_res_zip',               CAST(mother_res_zip AS VARCHAR(255)), NULL),
			(           'mother_res_incity',            CAST(mother_res_incity AS VARCHAR(255)), NULL),
			(                'b2_mother_ed',                 CAST(b2_mother_ed AS VARCHAR(255)), NULL),
			(        'mother_occupation_cd',         CAST(mother_occupation_cd AS VARCHAR(255)), NULL),
			(          'mother_industry_cd',           CAST(mother_industry_cd AS VARCHAR(255)), NULL),
--			(                  'mother_ssn',                   CAST(mother_ssn AS VARCHAR(255)), NULL),
--			(            'father_name_last',             CAST(father_name_last AS VARCHAR(255)), NULL),
--			(          'father_name_suffix',           CAST(father_name_suffix AS VARCHAR(255)), NULL),
--			(           'father_name_first',            CAST(father_name_first AS VARCHAR(255)), NULL),
--			(          'father_name_middle',           CAST(father_name_middle AS VARCHAR(255)), NULL),
			(               'b2_father_dob',                CAST(b2_father_dob AS VARCHAR(255)), NULL),
			(               'b2_father_age',                CAST(b2_father_age AS VARCHAR(255)), NULL),
			('fbir_country_country_code_nv', CAST(fbir_country_country_code_nv AS VARCHAR(255)), NULL),
			(    'fbir_state_state_code_nv',     CAST(fbir_state_state_code_nv AS VARCHAR(255)), NULL),
			(                'b2_father_ed',                 CAST(b2_father_ed AS VARCHAR(255)), NULL),
			(        'father_occupation_cd',         CAST(father_occupation_cd AS VARCHAR(255)), NULL),
			(          'father_industry_cd',           CAST(father_industry_cd AS VARCHAR(255)), NULL),
--			(                  'father_ssn',                   CAST(father_ssn AS VARCHAR(255)), NULL),
			(      'b2_mother_ever_married',       CAST(b2_mother_ever_married AS VARCHAR(255)), NULL),
			(              'mother_married',               CAST(mother_married AS VARCHAR(255)), NULL),
			(           'father_is_husband',            CAST(father_is_husband AS VARCHAR(255)), NULL),
			(   'father_sign_pat_affidavit',    CAST(father_sign_pat_affidavit AS VARCHAR(255)), NULL),
			(             'b2_trans_mother',              CAST(b2_trans_mother AS VARCHAR(255)), NULL),
			(                 'menses_date',                  CAST(menses_date AS VARCHAR(255)), NULL),
			(           'b2_prenatal_yesno',            CAST(b2_prenatal_yesno AS VARCHAR(255)), NULL),
			(      'b2_prenatal_date_begin',       CAST(b2_prenatal_date_begin AS VARCHAR(255)), NULL),
			(        'b2_prenatal_date_end',         CAST(b2_prenatal_date_end AS VARCHAR(255)), NULL),
			(        'b2_prenat_tot_visits',         CAST(b2_prenat_tot_visits AS VARCHAR(255)), NULL),
			(       'b2_mother_height_feet',        CAST(b2_mother_height_feet AS VARCHAR(255)), 'ft'),
			(       'b2_mother_height_inch',        CAST(b2_mother_height_inch AS VARCHAR(255)), 'inch'),
			(       'b2_mother_pre_preg_wt',        CAST(b2_mother_pre_preg_wt AS VARCHAR(255)), 'lb'),
			(       'b2_mother_wt_at_deliv',        CAST(b2_mother_wt_at_deliv AS VARCHAR(255)), 'lb'),
			(           'live_births_total',            CAST(live_births_total AS VARCHAR(255)), NULL),
			(     'live_births_date_mmyyyy',      CAST(live_births_date_mmyyyy AS VARCHAR(255)), NULL),
			(          'live_births_living',           CAST(live_births_living AS VARCHAR(255)), NULL),
			(            'live_births_dead',             CAST(live_births_dead AS VARCHAR(255)), NULL),
			(                 'term_number',                  CAST(term_number AS VARCHAR(255)), NULL),
			(            'term_date_mmyyyy',             CAST(term_date_mmyyyy AS VARCHAR(255)), NULL),
			(              'b2_tobacco_use',               CAST(b2_tobacco_use AS VARCHAR(255)), NULL),
			(       'b2_mother_cig_or_pack',        CAST(b2_mother_cig_or_pack AS VARCHAR(255)), NULL),
			(          'b2_mother_cig_prev',           CAST(b2_mother_cig_prev AS VARCHAR(255)), NULL),
			(     'b2_mother_cig_prev_pack',      CAST(b2_mother_cig_prev_pack AS VARCHAR(255)), NULL),
			(     'b2_mother_cig_first_tri',      CAST(b2_mother_cig_first_tri AS VARCHAR(255)), NULL),
			(    'b2_mother_cig_first_pack',     CAST(b2_mother_cig_first_pack AS VARCHAR(255)), NULL),
			(    'b2_mother_cig_second_tri',     CAST(b2_mother_cig_second_tri AS VARCHAR(255)), NULL),
			(   'b2_mother_cig_second_pack',    CAST(b2_mother_cig_second_pack AS VARCHAR(255)), NULL),
			(      'b2_mother_cig_last_tri',       CAST(b2_mother_cig_last_tri AS VARCHAR(255)), NULL),
			(     'b2_mother_cig_last_pack',      CAST(b2_mother_cig_last_pack AS VARCHAR(255)), NULL),
			(               'm_alcohol_use',                CAST(m_alcohol_use AS VARCHAR(255)), NULL),
			(        'm_alcohol_drink_week',         CAST(m_alcohol_drink_week AS VARCHAR(255)), NULL),
			(                  'm_drug_use',                   CAST(m_drug_use AS VARCHAR(255)), NULL),
			(         'm_drug_prescription',          CAST(m_drug_prescription AS VARCHAR(255)), NULL),
			(                  'm_drug_otc',                   CAST(m_drug_otc AS VARCHAR(255)), NULL),
			(                'm_drug_other',                 CAST(m_drug_other AS VARCHAR(255)), NULL),
			(            'm_drug_other_lit',             CAST(m_drug_other_lit AS VARCHAR(255)), NULL),
			(                   'm_mr_none',                    CAST(m_mr_none AS VARCHAR(255)), NULL),
			(                   'm_mr_diab',                    CAST(m_mr_diab AS VARCHAR(255)), NULL),
			(              'm_mr_diab_gest',               CAST(m_mr_diab_gest AS VARCHAR(255)), NULL),
			(             'm_mr_hypert_all',              CAST(m_mr_hypert_all AS VARCHAR(255)), NULL),
			(         'm_mr_hypert_chronic',          CAST(m_mr_hypert_chronic AS VARCHAR(255)), NULL),
			(            'm_mr_hypert_preg',             CAST(m_mr_hypert_preg AS VARCHAR(255)), NULL),
			(              'm_mr_eclampsia',               CAST(m_mr_eclampsia AS VARCHAR(255)), NULL),
			(           'm_mr_prev_preterm',            CAST(m_mr_prev_preterm AS VARCHAR(255)), NULL),
			(      'm_mr_prev_poor_outcome',       CAST(m_mr_prev_poor_outcome AS VARCHAR(255)), NULL),
			(    'm_mr_preg_from_treatment',     CAST(m_mr_preg_from_treatment AS VARCHAR(255)), NULL),
			(           'm_mr_infert_drugs',            CAST(m_mr_infert_drugs AS VARCHAR(255)), NULL),
			(        'm_mr_assist_rep_tech',         CAST(m_mr_assist_rep_tech AS VARCHAR(255)), NULL),
			(    'm_mr_prev_cesarean_yesno',     CAST(m_mr_prev_cesarean_yesno AS VARCHAR(255)), NULL),
			(          'm_mr_prev_ces_numb',           CAST(m_mr_prev_ces_numb AS VARCHAR(255)), NULL),
			(                 'm_mr_anemia',                  CAST(m_mr_anemia AS VARCHAR(255)), NULL),
			(                'm_mr_cardiac',                 CAST(m_mr_cardiac AS VARCHAR(255)), NULL),
			(           'm_mr_lung_disease',            CAST(m_mr_lung_disease AS VARCHAR(255)), NULL),
			(        'm_mr_hydraminos_olig',         CAST(m_mr_hydraminos_olig AS VARCHAR(255)), NULL),
			(       'm_mr_hemoglobinopathy',        CAST(m_mr_hemoglobinopathy AS VARCHAR(255)), NULL),
			(       'm_mr_incompent_cervix',        CAST(m_mr_incompent_cervix AS VARCHAR(255)), NULL),
			(         'm_mr_prev_4000_plus',          CAST(m_mr_prev_4000_plus AS VARCHAR(255)), NULL),
			(          'm_mr_renal_disease',           CAST(m_mr_renal_disease AS VARCHAR(255)), NULL),
			(              'm_mr_rh_sensit',               CAST(m_mr_rh_sensit AS VARCHAR(255)), NULL),
			(       'm_mr_uterine_bleeding',        CAST(m_mr_uterine_bleeding AS VARCHAR(255)), NULL),
			(                  'm_mr_other',                   CAST(m_mr_other AS VARCHAR(255)), NULL),
			(              'm_mr_other_lit',               CAST(m_mr_other_lit AS VARCHAR(255)), NULL),
--			(                   'unknown01',                    CAST(unknown01 AS VARCHAR(255)), NULL),
			(                  'm_inf_none',                   CAST(m_inf_none AS VARCHAR(255)), NULL),
			(             'm_inf_gonorrhea',              CAST(m_inf_gonorrhea AS VARCHAR(255)), NULL),
			(              'm_inf_syphilis',               CAST(m_inf_syphilis AS VARCHAR(255)), NULL),
			(             'm_inf_chlamydia',              CAST(m_inf_chlamydia AS VARCHAR(255)), NULL),
			(           'm_inf_hepatitis_b',            CAST(m_inf_hepatitis_b AS VARCHAR(255)), NULL),
			(           'm_inf_hepatitis_c',            CAST(m_inf_hepatitis_c AS VARCHAR(255)), NULL),
			(                   'm_inf_hpv',                    CAST(m_inf_hpv AS VARCHAR(255)), NULL),
			(              'm_inf_hiv_aids',               CAST(m_inf_hiv_aids AS VARCHAR(255)), NULL),
			(                   'm_inf_cmv',                    CAST(m_inf_cmv AS VARCHAR(255)), NULL),
			(               'm_inf_rubella',                CAST(m_inf_rubella AS VARCHAR(255)), NULL),
			(         'm_inf_toxoplasmosis',          CAST(m_inf_toxoplasmosis AS VARCHAR(255)), NULL),
			(        'm_inf_genital_herpes',         CAST(m_inf_genital_herpes AS VARCHAR(255)), NULL),
			(          'm_inf_tuberculosis',           CAST(m_inf_tuberculosis AS VARCHAR(255)), NULL),
			(                 'm_inf_other',                  CAST(m_inf_other AS VARCHAR(255)), NULL),
			(             'm_inf_other_lit',              CAST(m_inf_other_lit AS VARCHAR(255)), NULL),
--			(                   'unknown02',                    CAST(unknown02 AS VARCHAR(255)), NULL),
			(                   'm_ob_none',                    CAST(m_ob_none AS VARCHAR(255)), NULL),
			(               'm_ob_cerclage',                CAST(m_ob_cerclage AS VARCHAR(255)), NULL),
			(              'm_ob_tocolysis',               CAST(m_ob_tocolysis AS VARCHAR(255)), NULL),
			(                  'm_ob_amnio',                   CAST(m_ob_amnio AS VARCHAR(255)), NULL),
			(          'm_ob_fetal_monitor',           CAST(m_ob_fetal_monitor AS VARCHAR(255)), NULL),
			(       'm_ob_cephalic_success',        CAST(m_ob_cephalic_success AS VARCHAR(255)), NULL),
			(        'm_ob_cephalic_failed',         CAST(m_ob_cephalic_failed AS VARCHAR(255)), NULL),
			(             'm_ob_ultrasound',              CAST(m_ob_ultrasound AS VARCHAR(255)), NULL),
			(                  'm_ob_other',                   CAST(m_ob_other AS VARCHAR(255)), NULL),
			(              'm_ob_other_lit',               CAST(m_ob_other_lit AS VARCHAR(255)), NULL),
--			(                   'unknown03',                    CAST(unknown03 AS VARCHAR(255)), NULL),
			(                   'm_ol_none',                    CAST(m_ol_none AS VARCHAR(255)), NULL),
			(          'm_ol_premature_rom',           CAST(m_ol_premature_rom AS VARCHAR(255)), NULL),
			(           'm_ol_precip_labor',            CAST(m_ol_precip_labor AS VARCHAR(255)), NULL),
			(          'm_ol_prolong_labor',           CAST(m_ol_prolong_labor AS VARCHAR(255)), NULL),
			(                  'm_cld_none',                   CAST(m_cld_none AS VARCHAR(255)), NULL),
			(             'm_cld_induction',              CAST(m_cld_induction AS VARCHAR(255)), NULL),
			(               'm_cld_augment',                CAST(m_cld_augment AS VARCHAR(255)), NULL),
			(            'm_cld_non_vertex',             CAST(m_cld_non_vertex AS VARCHAR(255)), NULL),
			(               'm_cld_steroid',                CAST(m_cld_steroid AS VARCHAR(255)), NULL),
			(            'm_cld_antibiotic',             CAST(m_cld_antibiotic AS VARCHAR(255)), NULL),
			(           'm_cld_chorioamnio',            CAST(m_cld_chorioamnio AS VARCHAR(255)), NULL),
			(              'm_cld_meconium',               CAST(m_cld_meconium AS VARCHAR(255)), NULL),
			(     'm_cld_fetal_intolerance',      CAST(m_cld_fetal_intolerance AS VARCHAR(255)), NULL),
			(              'm_cld_epidural',               CAST(m_cld_epidural AS VARCHAR(255)), NULL),
			(               'm_cld_febrile',                CAST(m_cld_febrile AS VARCHAR(255)), NULL),
			(          'm_cld_abr_placenta',           CAST(m_cld_abr_placenta AS VARCHAR(255)), NULL),
			(       'm_cld_placenta_previa',        CAST(m_cld_placenta_previa AS VARCHAR(255)), NULL),
			(              'm_cld_bleeding',               CAST(m_cld_bleeding AS VARCHAR(255)), NULL),
			(              'm_cld_seizures',               CAST(m_cld_seizures AS VARCHAR(255)), NULL),
			(         'm_cld_dysfunctional',          CAST(m_cld_dysfunctional AS VARCHAR(255)), NULL),
			(         'm_cld_cephalopelvic',          CAST(m_cld_cephalopelvic AS VARCHAR(255)), NULL),
			(         'm_cld_cord_prolapse',          CAST(m_cld_cord_prolapse AS VARCHAR(255)), NULL),
			(            'm_cld_anesthetic',             CAST(m_cld_anesthetic AS VARCHAR(255)), NULL),
			(                 'm_cld_other',                  CAST(m_cld_other AS VARCHAR(255)), NULL),
			(             'm_cld_other_lit',              CAST(m_cld_other_lit AS VARCHAR(255)), NULL),
--			(                   'unknown04',                    CAST(unknown04 AS VARCHAR(255)), NULL),
			(        'm_md_forceps_attempt',         CAST(m_md_forceps_attempt AS VARCHAR(255)), NULL),
			(         'm_md_vacuum_attempt',          CAST(m_md_vacuum_attempt AS VARCHAR(255)), NULL),
			(          'b2_birpresent_code',           CAST(b2_birpresent_code AS VARCHAR(255)), NULL),
			(            'b2_birroute_code',             CAST(b2_birroute_code AS VARCHAR(255)), NULL),
			(      'm_md_ces_labor_attempt',       CAST(m_md_ces_labor_attempt AS VARCHAR(255)), NULL),
--			(                   'unknown05',                    CAST(unknown05 AS VARCHAR(255)), NULL),
			(                   'm_mm_none',                    CAST(m_mm_none AS VARCHAR(255)), NULL),
			(            'm_mm_transfusion',             CAST(m_mm_transfusion AS VARCHAR(255)), NULL),
			(       'm_mm_perineal_lacerat',        CAST(m_mm_perineal_lacerat AS VARCHAR(255)), NULL),
			(        'm_mm_ruptured_uterus',         CAST(m_mm_ruptured_uterus AS VARCHAR(255)), NULL),
			(           'm_mm_hysterectomy',            CAST(m_mm_hysterectomy AS VARCHAR(255)), NULL),
			(                    'm_mm_icu',                     CAST(m_mm_icu AS VARCHAR(255)), NULL),
			(                'm_mm_or_proc',                 CAST(m_mm_or_proc AS VARCHAR(255)), NULL),
			(                'm_mm_unknown',                 CAST(m_mm_unknown AS VARCHAR(255)), NULL),
			(                     'apgar_5',                      CAST(apgar_5 AS VARCHAR(255)), NULL),
			(                    'apgar_10',                     CAST(apgar_10 AS VARCHAR(255)), NULL),
			(           'birth_weight_unit',            CAST(birth_weight_unit AS VARCHAR(255)), NULL),
			(          'birth_weight_grams',           CAST(birth_weight_grams AS VARCHAR(255)), 'grams'),
			(            'birth_weight_lbs',             CAST(birth_weight_lbs AS VARCHAR(255)), 'lbs'),
			(             'birth_weight_oz',              CAST(birth_weight_oz AS VARCHAR(255)), 'oz'),
			(             'gestation_weeks',              CAST(gestation_weeks AS VARCHAR(255)), NULL),
			(                   'plurality',                    CAST(plurality AS VARCHAR(255)), NULL),
			(                 'birth_order',                  CAST(birth_order AS VARCHAR(255)), NULL),
			(               'b2_born_alive',                CAST(b2_born_alive AS VARCHAR(255)), NULL),
			(             'b2_match_number',              CAST(b2_match_number AS VARCHAR(255)), NULL),
			(                'trans_infant',                 CAST(trans_infant AS VARCHAR(255)), NULL),
			(            'b2_infant_living',             CAST(b2_infant_living AS VARCHAR(255)), NULL),
			(                   'm_ac_none',                    CAST(m_ac_none AS VARCHAR(255)), NULL),
			(           'm_ac_vent_less_30',            CAST(m_ac_vent_less_30 AS VARCHAR(255)), NULL),
			(           'm_ac_vent_more_30',            CAST(m_ac_vent_more_30 AS VARCHAR(255)), NULL),
			(                   'm_ac_nicu',                    CAST(m_ac_nicu AS VARCHAR(255)), NULL),
			(             'm_ac_surfactant',              CAST(m_ac_surfactant AS VARCHAR(255)), NULL),
			(      'm_ac_antibiotic_sepsis',       CAST(m_ac_antibiotic_sepsis AS VARCHAR(255)), NULL),
			(               'm_ac_seizures',                CAST(m_ac_seizures AS VARCHAR(255)), NULL),
			(                 'm_ac_anemia',                  CAST(m_ac_anemia AS VARCHAR(255)), NULL),
			(                    'm_ac_fas',                     CAST(m_ac_fas AS VARCHAR(255)), NULL),
			(                'm_ac_hyaline',                 CAST(m_ac_hyaline AS VARCHAR(255)), NULL),
			(            'm_ac_meconium_as',             CAST(m_ac_meconium_as AS VARCHAR(255)), NULL),
			(           'm_ac_birth_injury',            CAST(m_ac_birth_injury AS VARCHAR(255)), NULL),
			(                  'm_ac_other',                   CAST(m_ac_other AS VARCHAR(255)), NULL),
			(              'm_ac_other_lit',               CAST(m_ac_other_lit AS VARCHAR(255)), NULL),
--			(                   'unknown06',                    CAST(unknown06 AS VARCHAR(255)), NULL),
			(                 'm_anom_none',                  CAST(m_anom_none AS VARCHAR(255)), NULL),
			(              'm_anom_anencep',               CAST(m_anom_anencep AS VARCHAR(255)), NULL),
			(                'm_anom_spina',                 CAST(m_anom_spina AS VARCHAR(255)), NULL),
			(                'm_anom_micro',                 CAST(m_anom_micro AS VARCHAR(255)), NULL),
			(              'm_anom_nervous',               CAST(m_anom_nervous AS VARCHAR(255)), NULL),
			(          'm_anom_nervous_lit',           CAST(m_anom_nervous_lit AS VARCHAR(255)), NULL),
			(                'm_anom_heart',                 CAST(m_anom_heart AS VARCHAR(255)), NULL),
			(        'm_anom_heart_malform',         CAST(m_anom_heart_malform AS VARCHAR(255)), NULL),
			(                 'm_anom_circ',                  CAST(m_anom_circ AS VARCHAR(255)), NULL),
			(             'm_anom_circ_lit',              CAST(m_anom_circ_lit AS VARCHAR(255)), NULL),
			(               'm_anom_omphal',                CAST(m_anom_omphal AS VARCHAR(255)), NULL),
			(        'm_anom_gastroschisis',         CAST(m_anom_gastroschisis AS VARCHAR(255)), NULL),
			(               'm_anom_rectal',                CAST(m_anom_rectal AS VARCHAR(255)), NULL),
			(              'm_anom_tracheo',               CAST(m_anom_tracheo AS VARCHAR(255)), NULL),
			(               'm_anom_gastro',                CAST(m_anom_gastro AS VARCHAR(255)), NULL),
			(           'm_anom_gastro_lit',            CAST(m_anom_gastro_lit AS VARCHAR(255)), NULL),
			(          'm_anom_limb_reduct',           CAST(m_anom_limb_reduct AS VARCHAR(255)), NULL),
			(            'm_anom_cleft_lip',             CAST(m_anom_cleft_lip AS VARCHAR(255)), NULL),
			(         'm_anom_cleft_palate',          CAST(m_anom_cleft_palate AS VARCHAR(255)), NULL),
			(             'm_anom_polydact',              CAST(m_anom_polydact AS VARCHAR(255)), NULL),
			(            'm_anom_club_foot',             CAST(m_anom_club_foot AS VARCHAR(255)), NULL),
			(         'm_anom_diaph_hernia',          CAST(m_anom_diaph_hernia AS VARCHAR(255)), NULL),
			(               'm_anom_muscle',                CAST(m_anom_muscle AS VARCHAR(255)), NULL),
			(           'm_anom_muscle_lit',            CAST(m_anom_muscle_lit AS VARCHAR(255)), NULL),
			(       'm_anom_malf_genitalia',        CAST(m_anom_malf_genitalia AS VARCHAR(255)), NULL),
			(                'm_anom_renal',                 CAST(m_anom_renal AS VARCHAR(255)), NULL),
			(          'm_anom_hypospadias',           CAST(m_anom_hypospadias AS VARCHAR(255)), NULL),
			(           'm_anom_urogenital',            CAST(m_anom_urogenital AS VARCHAR(255)), NULL),
			(       'm_anom_urogenital_lit',        CAST(m_anom_urogenital_lit AS VARCHAR(255)), NULL),
			(           'm_anom_downs_code',            CAST(m_anom_downs_code AS VARCHAR(255)), NULL),
			(                 'm_anom_cdit',                  CAST(m_anom_cdit AS VARCHAR(255)), NULL),
			(          'm_anom_chrom_other',           CAST(m_anom_chrom_other AS VARCHAR(255)), NULL),
			(            'm_anom_chrom_lit',             CAST(m_anom_chrom_lit AS VARCHAR(255)), NULL),
			(                'm_anom_other',                 CAST(m_anom_other AS VARCHAR(255)), NULL),
			(            'm_anom_other_lit',             CAST(m_anom_other_lit AS VARCHAR(255)), NULL),
			(            'certifiertitleid',             CAST(certifiertitleid AS VARCHAR(255)), NULL),
			(         'certifier_date_comp',          CAST(certifier_date_comp AS VARCHAR(255)), NULL),
			(        'registrar_regis_date',         CAST(registrar_regis_date AS VARCHAR(255)), NULL),
			(         'b2_mother_wic_yesno',          CAST(b2_mother_wic_yesno AS VARCHAR(255)), NULL),
			(          'b2_source_pay_code',           CAST(b2_source_pay_code AS VARCHAR(255)), NULL),
			(             'm_breastfeeding',              CAST(m_breastfeeding AS VARCHAR(255)), NULL),
			(               'ssn_requested',                CAST(ssn_requested AS VARCHAR(255)), NULL),
--			(                  'hos_number',                   CAST(hos_number AS VARCHAR(255)), NULL),
--			(        'm_mother_med_rec_num',         CAST(m_mother_med_rec_num AS VARCHAR(255)), NULL),
			(  'b2_hosp_paternity_complete',   CAST(b2_hosp_paternity_complete AS VARCHAR(255)), NULL),
			(      'b2_mother_ethnic_yesno',       CAST(b2_mother_ethnic_yesno AS VARCHAR(255)), NULL),
			(           'b2_mother_mexican',            CAST(b2_mother_mexican AS VARCHAR(255)), NULL),
			(                'b2_mother_pr',                 CAST(b2_mother_pr AS VARCHAR(255)), NULL),
			(             'b2_mother_cuban',              CAST(b2_mother_cuban AS VARCHAR(255)), NULL),
			(      'b2_mother_ethnic_other',       CAST(b2_mother_ethnic_other AS VARCHAR(255)), NULL),
			(            'b2_mother_ethnic',             CAST(b2_mother_ethnic AS VARCHAR(255)), NULL),
			(        'b2_mother_race_white',         CAST(b2_mother_race_white AS VARCHAR(255)), NULL),
			(        'b2_mother_race_black',         CAST(b2_mother_race_black AS VARCHAR(255)), NULL),
			(    'b2_mother_race_am_indian',     CAST(b2_mother_race_am_indian AS VARCHAR(255)), NULL),
			(   'b2_mother_race_am_ind_lit',    CAST(b2_mother_race_am_ind_lit AS VARCHAR(255)), NULL),
			(    'b2_mother_race_asian_ind',     CAST(b2_mother_race_asian_ind AS VARCHAR(255)), NULL),
			(    'b2_mother_race_asian_oth',     CAST(b2_mother_race_asian_oth AS VARCHAR(255)), NULL),
			(    'b2_mother_race_asian_lit',     CAST(b2_mother_race_asian_lit AS VARCHAR(255)), NULL),
			(      'b2_mother_race_chinese',       CAST(b2_mother_race_chinese AS VARCHAR(255)), NULL),
			(     'b2_mother_race_filipino',      CAST(b2_mother_race_filipino AS VARCHAR(255)), NULL),
			(     'b2_mother_race_japanese',      CAST(b2_mother_race_japanese AS VARCHAR(255)), NULL),
			(       'b2_mother_race_korean',        CAST(b2_mother_race_korean AS VARCHAR(255)), NULL),
			(   'b2_mother_race_vietnamese',    CAST(b2_mother_race_vietnamese AS VARCHAR(255)), NULL),
			(     'b2_mother_race_hawaiian',      CAST(b2_mother_race_hawaiian AS VARCHAR(255)), NULL),
			(         'b2_mother_race_guam',          CAST(b2_mother_race_guam AS VARCHAR(255)), NULL),
			(       'b2_mother_race_samoan',        CAST(b2_mother_race_samoan AS VARCHAR(255)), NULL),
			(    'b2_mother_race_pac_other',     CAST(b2_mother_race_pac_other AS VARCHAR(255)), NULL),
			(      'b2_mother_race_pac_lit',       CAST(b2_mother_race_pac_lit AS VARCHAR(255)), NULL),
			(        'b2_mother_race_other',         CAST(b2_mother_race_other AS VARCHAR(255)), NULL),
			(    'b2_mother_race_other_lit',     CAST(b2_mother_race_other_lit AS VARCHAR(255)), NULL),
			(      'b2_mother_race_unknown',       CAST(b2_mother_race_unknown AS VARCHAR(255)), NULL),
			(      'b2_mother_race_refused',       CAST(b2_mother_race_refused AS VARCHAR(255)), NULL),
			(                  'b2_mrace1e',                   CAST(b2_mrace1e AS VARCHAR(255)), NULL),
			(                  'b2_mrace2e',                   CAST(b2_mrace2e AS VARCHAR(255)), NULL),
			(                  'b2_mrace3e',                   CAST(b2_mrace3e AS VARCHAR(255)), NULL),
			(                  'b2_mrace4e',                   CAST(b2_mrace4e AS VARCHAR(255)), NULL),
			(                  'b2_mrace5e',                   CAST(b2_mrace5e AS VARCHAR(255)), NULL),
			(                  'b2_mrace6e',                   CAST(b2_mrace6e AS VARCHAR(255)), NULL),
			(                  'b2_mrace7e',                   CAST(b2_mrace7e AS VARCHAR(255)), NULL),
			(                  'b2_mrace8e',                   CAST(b2_mrace8e AS VARCHAR(255)), NULL),
			(                 'b2_mrace16e',                  CAST(b2_mrace16e AS VARCHAR(255)), NULL),
--			(                   'unknown07',                    CAST(unknown07 AS VARCHAR(255)), NULL),
			(                 'b2_mrace18e',                  CAST(b2_mrace18e AS VARCHAR(255)), NULL),
--			(                   'unknown08',                    CAST(unknown08 AS VARCHAR(255)), NULL),
			(                 'b2_mrace20e',                  CAST(b2_mrace20e AS VARCHAR(255)), NULL),
--			(                   'unknown09',                    CAST(unknown09 AS VARCHAR(255)), NULL),
			(                 'b2_mrace22e',                  CAST(b2_mrace22e AS VARCHAR(255)), NULL),
--			(                   'unknown10',                    CAST(unknown10 AS VARCHAR(255)), NULL),
			(        'b2_nchs_mo_ethnic_cd',         CAST(b2_nchs_mo_ethnic_cd AS VARCHAR(255)), NULL),
			(    'b2_nchs_mo_ethnic_lit_cd',     CAST(b2_nchs_mo_ethnic_lit_cd AS VARCHAR(255)), NULL),
			(          'b2_mo_bridged_race',           CAST(b2_mo_bridged_race AS VARCHAR(255)), NULL),
			(      'b2_father_ethnic_yesno',       CAST(b2_father_ethnic_yesno AS VARCHAR(255)), NULL),
			(           'b2_father_mexican',            CAST(b2_father_mexican AS VARCHAR(255)), NULL),
			(                'b2_father_pr',                 CAST(b2_father_pr AS VARCHAR(255)), NULL),
			(             'b2_father_cuban',              CAST(b2_father_cuban AS VARCHAR(255)), NULL),
			(      'b2_father_ethnic_other',       CAST(b2_father_ethnic_other AS VARCHAR(255)), NULL),
			(            'b2_father_ethnic',             CAST(b2_father_ethnic AS VARCHAR(255)), NULL),
			(        'b2_father_race_white',         CAST(b2_father_race_white AS VARCHAR(255)), NULL),
			(        'b2_father_race_black',         CAST(b2_father_race_black AS VARCHAR(255)), NULL),
			(    'b2_father_race_am_indian',     CAST(b2_father_race_am_indian AS VARCHAR(255)), NULL),
			(   'b2_father_race_am_ind_lit',    CAST(b2_father_race_am_ind_lit AS VARCHAR(255)), NULL),
			(    'b2_father_race_asian_ind',     CAST(b2_father_race_asian_ind AS VARCHAR(255)), NULL),
			(    'b2_father_race_asian_oth',     CAST(b2_father_race_asian_oth AS VARCHAR(255)), NULL),
			(    'b2_father_race_asian_lit',     CAST(b2_father_race_asian_lit AS VARCHAR(255)), NULL),
			(      'b2_father_race_chinese',       CAST(b2_father_race_chinese AS VARCHAR(255)), NULL),
			(     'b2_father_race_filipino',      CAST(b2_father_race_filipino AS VARCHAR(255)), NULL),
			(     'b2_father_race_japanese',      CAST(b2_father_race_japanese AS VARCHAR(255)), NULL),
			(       'b2_father_race_korean',        CAST(b2_father_race_korean AS VARCHAR(255)), NULL),
			(   'b2_father_race_vietnamese',    CAST(b2_father_race_vietnamese AS VARCHAR(255)), NULL),
			(     'b2_father_race_hawaiian',      CAST(b2_father_race_hawaiian AS VARCHAR(255)), NULL),
			(         'b2_father_race_guam',          CAST(b2_father_race_guam AS VARCHAR(255)), NULL),
			(       'b2_father_race_samoan',        CAST(b2_father_race_samoan AS VARCHAR(255)), NULL),
			(          'b2_father_race_pac',           CAST(b2_father_race_pac AS VARCHAR(255)), NULL),
			(      'b2_father_race_pac_lit',       CAST(b2_father_race_pac_lit AS VARCHAR(255)), NULL),
			(        'b2_father_race_other',         CAST(b2_father_race_other AS VARCHAR(255)), NULL),
			(    'b2_father_race_other_lit',     CAST(b2_father_race_other_lit AS VARCHAR(255)), NULL),
			(      'b2_father_race_unknown',       CAST(b2_father_race_unknown AS VARCHAR(255)), NULL),
			(      'b2_father_race_refused',       CAST(b2_father_race_refused AS VARCHAR(255)), NULL),
			(                  'b2_frace1e',                   CAST(b2_frace1e AS VARCHAR(255)), NULL),
			(                  'b2_frace2e',                   CAST(b2_frace2e AS VARCHAR(255)), NULL),
			(                  'b2_frace3e',                   CAST(b2_frace3e AS VARCHAR(255)), NULL),
			(                  'b2_frace4e',                   CAST(b2_frace4e AS VARCHAR(255)), NULL),
			(                  'b2_frace5e',                   CAST(b2_frace5e AS VARCHAR(255)), NULL),
			(                  'b2_frace6e',                   CAST(b2_frace6e AS VARCHAR(255)), NULL),
			(                  'b2_frace7e',                   CAST(b2_frace7e AS VARCHAR(255)), NULL),
			(                  'b2_frace8e',                   CAST(b2_frace8e AS VARCHAR(255)), NULL),
			(                 'b2_frace16e',                  CAST(b2_frace16e AS VARCHAR(255)), NULL),
--			(                   'unknown11',                    CAST(unknown11 AS VARCHAR(255)), NULL),
			(                 'b2_frace18e',                  CAST(b2_frace18e AS VARCHAR(255)), NULL),
--			(                   'unknown12',                    CAST(unknown12 AS VARCHAR(255)), NULL),
			(                 'b2_frace20e',                  CAST(b2_frace20e AS VARCHAR(255)), NULL),
--			(                   'unknown13',                    CAST(unknown13 AS VARCHAR(255)), NULL),
			(                 'b2_frace22e',                  CAST(b2_frace22e AS VARCHAR(255)), NULL),
--			(                   'unknown14',                    CAST(unknown14 AS VARCHAR(255)), NULL),
			(        'b2_nchs_fa_ethnic_cd',         CAST(b2_nchs_fa_ethnic_cd AS VARCHAR(255)), NULL),
			(    'b2_nchs_fa_ethnic_lit_cd',     CAST(b2_nchs_fa_ethnic_lit_cd AS VARCHAR(255)), NULL),
			(          'b2_fa_bridged_race',           CAST(b2_fa_bridged_race AS VARCHAR(255)), NULL),
			(                  'event_year',                   CAST(event_year AS VARCHAR(255)), NULL),
			(                    'isactive',                     CAST(isactive AS VARCHAR(255)), NULL),
--			(                   'unknown15',                    CAST(unknown15 AS VARCHAR(255)), NULL),
			(          'mother_birth_state',           CAST(mother_birth_state AS VARCHAR(255)), NULL),
			(   'mother_birth_country_fips',    CAST(mother_birth_country_fips AS VARCHAR(255)), NULL),
--			(                   'unknown16',                    CAST(unknown16 AS VARCHAR(255)), NULL),
			(        'mother_res_city_fips',         CAST(mother_res_city_fips AS VARCHAR(255)), NULL),
--			(                   'unknown17',                    CAST(unknown17 AS VARCHAR(255)), NULL),
			(        'mother_res_cnty_fips',         CAST(mother_res_cnty_fips AS VARCHAR(255)), NULL),
--			(                   'unknown18',                    CAST(unknown18 AS VARCHAR(255)), NULL),
			(            'mother_res_state',             CAST(mother_res_state AS VARCHAR(255)), NULL),
--			(                   'unknown19',                    CAST(unknown19 AS VARCHAR(255)), NULL),
			(     'mother_res_country_fips',      CAST(mother_res_country_fips AS VARCHAR(255)), NULL),
--			(                   'unknown20',                    CAST(unknown20 AS VARCHAR(255)), NULL),
--			(                   'ssn_child',                    CAST(ssn_child AS VARCHAR(255)), NULL),
--			(                   'unknown21',                    CAST(unknown21 AS VARCHAR(255)), NULL),
			(               'death_matched',                CAST(death_matched AS VARCHAR(255)), NULL),
--			(     'death_state_file_number',      CAST(death_state_file_number AS VARCHAR(255)), NULL),
			(                  'death_date',                   CAST(death_date AS VARCHAR(255)), NULL),
			(    'fbir_state_fips_alpha_cd',     CAST(fbir_state_fips_alpha_cd AS VARCHAR(255)), NULL),
			(   'father_birth_country_fips',    CAST(father_birth_country_fips AS VARCHAR(255)), NULL),
--			(               'reg_type_code',                CAST(reg_type_code AS VARCHAR(255)), NULL)


--			('DEM:DOB'     , CAST( _date_of_birth_date AS VARCHAR(255))           , NULL),
--			('birth_qtr'   , CAST(DATEPART(q,_date_of_birth_date) AS VARCHAR(255)), NULL),
--			('DEM:ZIP'     , CAST(mother_res_zip AS VARCHAR(255))                 , NULL),
--			('DEM:Weight'  , CAST(birth_weight_grams AS VARCHAR(255))             , 'grams'),
--			('DEM:Weight'  , CAST(
--				bin.weight_from_lbs_and_oz( birth_weight_lbs, birth_weight_oz ) AS VARCHAR(255)), 'lbs')

--	Searched CASE expression:
--	Returns result_expression of the first Boolean_expression that evaluates to TRUE.

--	All those in the selected zip codes are in Washoe County. Kinda repetitive
--			('UNR:BirthCounty'  , 'Washoe', NULL),
--	What about 8888 ( ) or 9999 (Unknown)?
--	
			('birth_weight_group'  , CASE
					WHEN birth_weight_grams =  9999 THEN NULL	--	'Unknown 9999'
					WHEN birth_weight_grams =  8888 THEN NULL	--	'Unknown 8888'
--					WHEN birth_weight_grams >  8000 THEN 'High Birth Weight'
					WHEN birth_weight_grams >= 2500 THEN 'Normal Birth Weight (>=2,500g, <=8,000g)'
					WHEN birth_weight_grams >= 1500 THEN 'Low Birth Weight (>=1,500g, <2,500g)'
					ELSE 'Very Low Birth Weight (<1,500g)'
--					WHEN birth_weight_grams >= 1000 THEN 'Very Low Birth Weight (<1,500g)'
--					ELSE 'Extremely Low Birth Weight'
				END , NULL),
			('mother_age_group', CASE 
					WHEN b2_mother_age >= 45 THEN '45+'
					WHEN b2_mother_age >= 40 THEN '40-44'
					WHEN b2_mother_age >= 35 THEN '35-39'
					WHEN b2_mother_age >= 30 THEN '30-34'
					WHEN b2_mother_age >= 25 THEN '25-29'
					WHEN b2_mother_age >= 20 THEN '20-24'
					WHEN b2_mother_age >= 18 THEN '18-19'
					WHEN b2_mother_age >= 15 THEN '15-17'
					WHEN b2_mother_age >= 10 THEN '10-14'
					ELSE 'Under 10'
				END, NULL),
			('dob'          , CAST(_date_of_birth_date AS VARCHAR(255))            , NULL),
			('birth_quarter', CAST(DATEPART(q,_date_of_birth_date) AS VARCHAR(255)), NULL),
			('DEM:ZIP'      , CAST(mother_res_zip AS VARCHAR(255))                 , NULL),
			('birth_zip'    , CAST(mother_res_zip AS VARCHAR(255))                 , NULL),
			('birth_weight' , CAST(
				bin.weight_from_lbs_and_oz( birth_weight_lbs, birth_weight_oz ) AS VARCHAR(255)), 'lbs')

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
			ON  i.source_id     = b.state_file_number
			AND i.source_column = 'state_file_number'
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
		EXEC bin.import_into_data_warehouse_by_schema 'webiz'

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

	INSERT INTO private.identifiers WITH (TABLOCK)
		( chirp_id, source_schema,
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













IF OBJECT_ID ( 'bin.link_immunization_records_to_birth_records', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.link_immunization_records_to_birth_records;
GO
CREATE PROCEDURE bin.link_immunization_records_to_birth_records( @year INT = 2015, @month INT = 7 )
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#temp_identifiers_link', 'U') IS NOT NULL
		DROP TABLE #temp_identifiers_link;

	DECLARE @mid_this_month DATE = CAST(CAST(@year AS VARCHAR) + '-' + CAST(@month AS VARCHAR) + '-10' AS DATE);
	DECLARE @begin_prev_month DATE = DATEADD(m, DATEDIFF(m,0,@mid_this_month)-1,0);
	DECLARE @end_next_month DATE = DATEADD(s,-1,DATEADD(m, DATEDIFF(m,0,@mid_this_month)+2,0));

	-- NEED to assign aliases to all columns here that aren't variables, like these fixed value strings.
	SELECT DISTINCT chirp_id, 'webiz' AS ss, 'immunizations' AS st,
		'patient_id' AS sc, patient_id,
		'Matched to birth record with score of ' + CAST(score AS VARCHAR(10)) AS mm
	INTO #temp_identifiers_link
	FROM (

		SELECT chirp_id, patient_id,
				birth_score + num_score + address_score + zip_score +
					first_name_score + middle_name_score + last_name_score +
					mom_first_name_score + mom_maiden_name_score + mom_last_name_score AS score,
			RANK() OVER( PARTITION BY patient_id ORDER BY
				birth_score + num_score + address_score + zip_score +
					first_name_score + middle_name_score + last_name_score +
					mom_first_name_score + mom_maiden_name_score + mom_last_name_score DESC ) AS rank

		FROM (

			SELECT i.chirp_id, s.patient_id,
				CASE WHEN b._date_of_birth_date = s.dob THEN 1.0
--					WHEN b._date_of_birth_date BETWEEN DATEADD(day,-8,s.dob) AND DATEADD(day,8,s.dob) THEN 0.5
					ELSE 0.0 END AS birth_score,

				CASE WHEN b.mother_res_zip = a.zip_code THEN 0.5
					ELSE 0.0 END AS zip_score,

				CASE WHEN b._mother_res_addr1 IN ( a._address_line1, s._address_line1, a._address_line1_prehash THEN 1.0
					WHEN b._mother_res_addr1_pre IN ( a._address_line1_pre, s.street_number ) THEN 0.5
					WHEN b._mother_res_addr1_suf = a._address_line1_suf THEN 0.5
					ELSE 0.0 END AS address_score,

				CASE WHEN b.hos_number = l.local_id THEN 2.0
					WHEN b._hos_number_int = l._local_id_int THEN 1.0
					ELSE 0.0 END AS num_score,

				CASE WHEN b._name_first = s._first_name THEN 1.0
					ELSE 0.0 END AS first_name_score,
				CASE WHEN b._name_middle = s._middle_name THEN 1.0
					ELSE 0.0 END AS middle_name_score,
				CASE WHEN ( b._name_last IN ( s._last_name, s._last_name_pre, s._last_name_suf )
					OR b._name_last_pre IN ( s._last_name, s._last_name_pre, s._last_name_suf )
					OR b._name_last_suf IN ( s._last_name, s._last_name_pre, s._last_name_suf ) )
					THEN 1.0 ELSE 0.0 END AS last_name_score,

				CASE WHEN b._mother_name_first = s._mother_first_name THEN 1.0
					ELSE 0.0 END AS mom_first_name_score,
				CASE WHEN ( s._mother_last_name IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf )
					OR s._mother_last_name_pre IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf )
					OR s._mother_last_name_suf IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf ) )
					THEN 1.0 ELSE 0.0 END AS mom_last_name_score,
				CASE WHEN ( s._mother_maiden_name IN ( b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf )
					OR s._mother_maiden_name_pre IN ( b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf )
					OR s._mother_maiden_name_suf IN ( b._mother_name_last_p, b._mother_name_last_p_pre, b._mother_name_last_p_suf ) )
					THEN 1.0 ELSE 0.0 END AS mom_maiden_name_score

			FROM private.identifiers i
			JOIN vital.births b
				ON  i.source_id     = b.state_file_number
				AND i.source_column = 'state_file_number'
				AND i.source_table  = 'births'
				AND i.source_schema = 'vital'
			CROSS JOIN webiz.immunizations s
			LEFT JOIN webiz.local_ids l
				ON s.patient_id = l.patient_id
			LEFT JOIN webiz.addresses a
				ON s.patient_id = a.patient_id
			LEFT JOIN private.identifiers i2
				ON  i2.source_id     = s.patient_id
				AND i2.source_column = 'patient_id'
				AND i2.source_table  = 'immunizations'
				AND i2.source_schema = 'webiz'
			WHERE YEAR(b._date_of_birth_date) = @year AND MONTH(b._date_of_birth_date) = @month
				AND i2.chirp_id IS NULL

--			WHERE b._date_of_birth_year = @year AND b._date_of_birth_month = @month
--				AND s._dob_year = @year AND s._dob_month = @month
				AND s.dob BETWEEN @begin_prev_month AND @end_next_month

		) AS computing_scores
		WHERE birth_score + zip_score + address_score + num_score +
			middle_name_score + last_name_score + first_name_score +
			mom_first_name_score + mom_last_name_score + mom_maiden_name_score >= 4

	) AS ranked
	WHERE rank = 1;

	--	Insert those that DO NOT have multple birth records claiming them.
	INSERT INTO private.identifiers WITH (TABLOCK)
		( chirp_id, source_schema, source_table, source_column, source_id, match_method )
		SELECT * FROM #temp_identifiers_link WHERE patient_id NOT IN (
			SELECT patient_id FROM #temp_identifiers_link
				GROUP BY patient_id HAVING COUNT(1) > 1
		);

	IF OBJECT_ID('tempdb..#temp_identifiers_link', 'U') IS NOT NULL
		DROP TABLE #temp_identifiers_link;

END	--	bin.link_immunization_records_to_birth_records
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
				CASE WHEN b._date_of_birth_date = s.birth_date THEN 1.0
					WHEN b._date_of_birth_date BETWEEN DATEADD(day,-8,s.birth_date) AND DATEADD(day,8,s.birth_date) THEN 0.5
					ELSE 0.0 END AS birth_score,
				CASE WHEN b._b2_mother_dob_date = s.mom_birth_date THEN 1.0
					WHEN ( b._b2_mother_dob_year = s._mom_birth_date_year AND b._b2_mother_dob_month = s._mom_birth_date_month ) THEN 0.5
					WHEN ( b._b2_mother_dob_day = s._mom_birth_date_day  AND b._b2_mother_dob_month = s._mom_birth_date_month) THEN 0.5
					WHEN ( b._b2_mother_dob_year = s._mom_birth_date_year AND b._b2_mother_dob_day = s._mom_birth_date_day)   THEN 0.5
					ELSE 0.0 END AS mom_birth_score,
				CASE WHEN b.mother_res_zip = s.zip_code     THEN 1.0 ELSE 0.0 END AS zip_score,
				CASE WHEN b._mother_res_addr1 = s._address  THEN 1.0
					WHEN b._mother_res_addr1_pre = s._address_pre THEN 0.5
					WHEN b._mother_res_addr1_suf = s._address_suf THEN 0.5
					ELSE 0.0 END AS address_score,
				CASE WHEN b.hos_number IN ( s.patient_id, s.patient_id_pre, s.patient_id_suf, s.patient_id_prex,
						s.patient_id_sufx, s.patient_id_prexi, s.patient_id_sufxi ) THEN 1.0
					WHEN s.patient_id LIKE '%' + b.hos_number + '%' THEN 0.5
					WHEN b.hos_number LIKE '%' + s.patient_id + '%' THEN 0.5
					ELSE 0.0 END AS num_score,
				CASE WHEN ( s._mom_surname IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf, b._mother_name_last_p,
						b._mother_name_last_p_pre, b._mother_name_last_p_suf, b._name_last, b._name_last_pre, b._name_last_suf )
					OR s._mom_surname_pre IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf, b._mother_name_last_p,
						b._mother_name_last_p_pre, b._mother_name_last_p_suf, b._name_last, b._name_last_pre, b._name_last_suf )
					OR s._mom_surname_suf IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf, b._mother_name_last_p,
						b._mother_name_last_p_pre, b._mother_name_last_p_suf, b._name_last, b._name_last_pre, b._name_last_suf )
					OR s._last_name IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf, b._mother_name_last_p,
						b._mother_name_last_p_pre, b._mother_name_last_p_suf, b._name_last, b._name_last_pre, b._name_last_suf )
					OR s._last_name_pre IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf, b._mother_name_last_p,
						b._mother_name_last_p_pre, b._mother_name_last_p_suf, b._name_last, b._name_last_pre, b._name_last_suf )
					OR s._last_name_suf IN ( b._mother_name_last, b._mother_name_last_pre, b._mother_name_last_suf, b._mother_name_last_p,
						b._mother_name_last_p_pre, b._mother_name_last_p_suf, b._name_last, b._name_last_pre, b._name_last_suf )
					) THEN 1.0 ELSE 0.0 END AS last_name_score,
				CASE WHEN b._name_first = s._first_name     THEN 0.5 ELSE 0.0 END AS first_name_score,
				CASE WHEN b._mother_name_first = s._mom_first_name THEN 1.0 ELSE 0.0 END AS mom_first_name_score
/*
	I think that using an edit distance function could be useful in comparing names
	that may be mispelled kinda like so ...

select name_last, mother_name_last,
1 - ( dbo.edit_distance(name_last,mother_name_last) /  (0.5 * ((LEN(name_last) + LEN(mother_name_last)) + ABS(LEN(name_last) - LEN(mother_name_last))) ))

from vital.births


-- FYI, the max of 2 numbers is half the sum of them plus their absolute difference
-- SELECT 0.5 * ((4 + 7) + ABS(4 - 7))  as max
-- If used regularly, perhaps write a FUNCTION MAX_OF(....)


*/
			FROM private.identifiers i
			JOIN vital.births b
				ON  i.source_id     = b.state_file_number
				AND i.source_column = 'state_file_number'
				AND i.source_table  = 'births'
				AND i.source_schema = 'vital'
			CROSS JOIN health_lab.newborn_screenings s
			LEFT JOIN private.identifiers i2
				ON  i2.source_id     = s.accession_kit_number
				AND i2.source_column = 'accession_kit_number'
				AND i2.source_table  = 'newborn_screenings'
				AND i2.source_schema = 'health_lab'
--			WHERE RIGHT(b.date_of_birth,2) = @year AND LEFT(b.date_of_birth,2) = @month
			WHERE YEAR(b._date_of_birth_date) = @year AND MONTH(b._date_of_birth_date) = @month
				AND i2.chirp_id IS NULL
/*
			WHERE b._bth_date_year = @year AND b._bth_date_month = @month
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

	--	Insert those that DO NOT have multple birth records claiming them.
	INSERT INTO private.identifiers WITH (TABLOCK)
		( chirp_id, source_schema, source_table, source_column, source_id, match_method )
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


IF OBJECT_ID ( 'bin.import_death_records', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_death_records;
GO
CREATE PROCEDURE bin.import_death_records( @file_with_path VARCHAR(255) )
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

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT vital.bulk_insert_deaths ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIELDTERMINATOR = ''|'', FIRSTROW = 2, TABLOCK )';
--			'ROWTERMINATOR = '''+CHAR(10)+''', FIRSTROW = 2, TABLOCK )';

	-- RESEEDing acts differently the first time it is called
	-- making the very first id 0. All calls after will set it to 1????
	-- So, basically, don't RESEED the very first time.
	IF EXISTS (SELECT * FROM sys.identity_columns WHERE object_id = OBJECT_ID( 'vital.deaths_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'vital.deaths_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE vital.deaths_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE vital.deaths_buffer DROP CONSTRAINT temp_source_filename;

END	--	bin.import_death_records
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












IF OBJECT_ID ( 'bin.import_webiz_addresses', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_webiz_addresses;
GO
CREATE PROCEDURE bin.import_webiz_addresses( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('webiz.addresses_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.addresses_buffer DROP CONSTRAINT addresses_buffer_temp_source_filename;

	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT webiz.bulk_insert_addresses ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIELDTERMINATOR = ''|'', FIRSTROW = 2, TABLOCK )';

	IF EXISTS (SELECT * FROM sys.identity_columns
		WHERE object_id = OBJECT_ID( 'webiz.addresses_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'webiz.addresses_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE webiz.addresses_buffer ' +
		'ADD CONSTRAINT addresses_buffer_temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);

	IF OBJECT_ID('webiz.addresses_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.addresses_buffer DROP CONSTRAINT addresses_buffer_temp_source_filename;

END	--	bin.import_webiz_addresses
GO

IF OBJECT_ID ( 'bin.import_webiz_immunizations', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_webiz_immunizations;
GO
CREATE PROCEDURE bin.import_webiz_immunizations( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('webiz.immunizations_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.immunizations_buffer DROP CONSTRAINT immunizations_buffer_temp_source_filename;

	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT webiz.bulk_insert_immunizations ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIELDTERMINATOR = ''|'', FIRSTROW = 2, TABLOCK )';

	IF EXISTS (SELECT * FROM sys.identity_columns
		WHERE object_id = OBJECT_ID( 'webiz.immunizations_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'webiz.immunizations_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE webiz.immunizations_buffer ' +
		'ADD CONSTRAINT immunizations_buffer_temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);

	IF OBJECT_ID('webiz.immunizations_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.immunizations_buffer DROP CONSTRAINT immunizations_buffer_temp_source_filename;

END	--	bin.import_webiz_immunizations
GO

IF OBJECT_ID ( 'bin.import_webiz_insurances', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_webiz_insurances;
GO
CREATE PROCEDURE bin.import_webiz_insurances( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('webiz.insurances_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.insurances_buffer DROP CONSTRAINT insurances_buffer_temp_source_filename;

	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT webiz.bulk_insert_insurances ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIELDTERMINATOR = ''|'', FIRSTROW = 2, TABLOCK )';

	IF EXISTS (SELECT * FROM sys.identity_columns
		WHERE object_id = OBJECT_ID( 'webiz.insurances_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'webiz.insurances_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE webiz.insurances_buffer ' +
		'ADD CONSTRAINT insurances_buffer_temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);

	IF OBJECT_ID('webiz.insurances_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.insurances_buffer DROP CONSTRAINT insurances_buffer_temp_source_filename;

END	--	bin.import_webiz_insurances
GO

IF OBJECT_ID ( 'bin.import_webiz_local_ids', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_webiz_local_ids;
GO
CREATE PROCEDURE bin.import_webiz_local_ids( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('webiz.local_ids_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.local_ids_buffer DROP CONSTRAINT local_ids_buffer_temp_source_filename;

	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT webiz.bulk_insert_local_ids ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIELDTERMINATOR = ''|'', FIRSTROW = 2, TABLOCK )';

	IF EXISTS (SELECT * FROM sys.identity_columns
		WHERE object_id = OBJECT_ID( 'webiz.local_ids_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'webiz.local_ids_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE webiz.local_ids_buffer ' +
		'ADD CONSTRAINT local_ids_buffer_temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);

	IF OBJECT_ID('webiz.local_ids_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.local_ids_buffer DROP CONSTRAINT local_ids_buffer_temp_source_filename;

END	--	bin.import_webiz_local_ids
GO

IF OBJECT_ID ( 'bin.import_webiz_races', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_webiz_races;
GO
CREATE PROCEDURE bin.import_webiz_races( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('webiz.races_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.races_buffer DROP CONSTRAINT races_buffer_temp_source_filename;

	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1,
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT webiz.bulk_insert_races ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', FIELDTERMINATOR = ''|'', FIRSTROW = 2, TABLOCK )';

	IF EXISTS (SELECT * FROM sys.identity_columns
		WHERE object_id = OBJECT_ID( 'webiz.races_buffer','U') AND last_value IS NOT NULL)
		DBCC CHECKIDENT( 'webiz.races_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE webiz.races_buffer ' +
		'ADD CONSTRAINT races_buffer_temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);

	IF OBJECT_ID('webiz.races_buffer_temp_source_filename') IS NOT NULL
		ALTER TABLE webiz.races_buffer DROP CONSTRAINT races_buffer_temp_source_filename;

END	--	bin.import_webiz_races
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


--	Any time cig_pck is 2 (pack), the cig counts exist also.
--	Using pack is redundant and as such these fields are not imported into observations above.
--	SELECT cig_pck, prepreg_cig, prepreg_pck, first_cig, first_pck, sec_cig, sec_pck, last_cig, last_pck FROM vital.births



