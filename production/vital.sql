
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
	source_record_number INT IDENTITY(1,1),	-- Sadly, BULK INSERT does NOT preserve file order so this is moot.
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

