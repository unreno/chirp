
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='vital_records')
	EXEC('CREATE SCHEMA vital_records')
GO

IF OBJECT_ID('vital_records.birth', 'U') IS NOT NULL
	DROP TABLE vital_records.birth;
CREATE TABLE vital_records.birth (
	birthid INT NOT NULL,
	birth2id INT,
	medicalid INT,
	hearingbid INT,
	event_year INT,
	local_file_number VARCHAR(15),
	state_file_number VARCHAR(11),
	local_reg_number VARCHAR(15),
	user_location VARCHAR(10),
	hos_number VARCHAR(30),
	case_file_number VARCHAR(15),
	reg_type_code VARCHAR(3),
	record_status VARCHAR(25),
	record_is_complete VARCHAR(1),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT,
	modify_user_name VARCHAR(51),
	create_date DATETIME,
	name_first VARCHAR(250),
	name_first_normal_char VARCHAR(250),
	name_middle VARCHAR(250),
	name_middle_normal_char VARCHAR(250),
	name_last VARCHAR(250),
	name_last_soundex VARCHAR(10),
	name_last_normal_char VARCHAR(250),
	name_suffix VARCHAR(4),
	date_of_birth DATETIME,
	time_of_birth VARCHAR(4),
	sex VARCHAR(1),
	ssn_child VARCHAR(9),
	plurality VARCHAR(2),
	birth_order VARCHAR(2),
	facid INT,
	fac_name VARCHAR(50),
	fac_type_code INT,
	fac_type_name VARCHAR(35),
	fac_city_fips VARCHAR(5),
	fac_number VARCHAR(10),
	fac_country_name VARCHAR(40),
	fac_county_name VARCHAR(40),
	fac_city_name VARCHAR(40),
	fac_zipcode VARCHAR(9),
	fac_cnty_fips VARCHAR(3),
	fac_state VARCHAR(50),
	fac_npi VARCHAR(20),
	fac_stateid INT,
	fac_state_name_abbr VARCHAR(25),
	infant_deceased VARCHAR(1),
	death_matched VARCHAR(1),
	death_state_file_number VARCHAR(15),
	death_oos_sfn VARCHAR(20),
	death_state VARCHAR(25),
	death_date DATETIME,
	death_age VARCHAR(3),
	death_age_units VARCHAR(10),
	mother_name_first VARCHAR(250),
	mother_name_middle VARCHAR(250),
	mother_name_last VARCHAR(250),
	mother_name_suffix VARCHAR(6),
	mother_name_first_p VARCHAR(250),
	mother_name_middle_p VARCHAR(250),
	mother_name_last_p VARCHAR(250),
	mother_name_suffix_p VARCHAR(6),
	mother_birth_country VARCHAR(50),
	mother_birth_countryid INT,
	mother_birth_stateid INT,
	mother_birth_state VARCHAR(25),
	mother_ssn VARCHAR(9),
	mother_res_addr1 VARCHAR(40),
	mother_res_apt VARCHAR(10),
	mother_res_country VARCHAR(50),
	mother_res_countryid INT,
	mother_res_state VARCHAR(25),
	mother_res_stateid INT,
	mother_res_county VARCHAR(40),
	mother_res_cnty_fips VARCHAR(3),
	mother_res_mun VARCHAR(40),
	mother_res_city_fips VARCHAR(5),
	mother_res_zipcodeid INT,
	mother_res_zip VARCHAR(9),
	mother_res_nchs_geo VARCHAR(5),
	mother_res_incity VARCHAR(1),
	mother_mail_same_as_res VARCHAR(1),
	mother_mail_addr1 VARCHAR(40),
	mother_mail_addr2 VARCHAR(50),
	mother_mail_apt VARCHAR(10),
	mother_mail_country VARCHAR(50),
	mother_mail_countryid INT,
	mother_birth_country_fips VARCHAR(2),
	mother_mail_stateid INT,
	mother_mail_state VARCHAR(25),
	mother_mail_city VARCHAR(40),
	mother_mail_zip VARCHAR(9),
	mother_mail_zipcodeid INT,
	mother_phone VARCHAR(10),
	mother_phone_ext VARCHAR(7),
	father_name_first VARCHAR(250),
	father_name_middle VARCHAR(250),
	father_name_last VARCHAR(250),
	father_name_suffix VARCHAR(4),
	father_birth_country VARCHAR(50),
	father_birth_countryid INT,
	father_birth_country_fips VARCHAR(2),
	father_birth_stateid INT,
	father_birth_state VARCHAR(25),
	father_res_same_mother VARCHAR(1),
	father_res_addr1 VARCHAR(40),
	father_res_apt VARCHAR(10),
	father_res_country VARCHAR(50),
	father_res_countryid INT,
	father_res_stateid INT,
	father_res_state VARCHAR(25),
	father_res_county VARCHAR(40),
	father_res_mun VARCHAR(40),
	father_res_zip VARCHAR(9),
	father_res_zipcodeid INT,
	father_res_incity VARCHAR(1),
	father_mail_same_as_res VARCHAR(1),
	father_mail_addr1 VARCHAR(40),
	father_mail_apt VARCHAR(10),
	father_mail_country VARCHAR(50),
	father_mail_countryid INT,
	father_mail_stateid INT,
	father_mail_state VARCHAR(25),
	father_mail_county VARCHAR(50),
	father_mail_city VARCHAR(40),
	father_mail_zip VARCHAR(9),
	father_mail_zipcodeid INT,
	father_ssn VARCHAR(9),
	father_phone VARCHAR(10),
	mother_occupation VARCHAR(50),
	mother_occupation_cd VARCHAR(3),
	mother_industry VARCHAR(50),
	mother_industry_cd VARCHAR(3),
	father_occupation VARCHAR(50),
	father_occupation_cd VARCHAR(3),
	father_industry VARCHAR(50),
	father_industry_cd VARCHAR(3),
	live_births_living VARCHAR(2),
	live_births_dead VARCHAR(2),
	live_births_date_mmyyyy VARCHAR(6),
	term_number VARCHAR(2),
	term_date_mmyyyy VARCHAR(6),
	mother_married VARCHAR(1),
	father_is_husband VARCHAR(1),
	father_and_husband_sign VARCHAR(1),
	father_sign_pat_affidavit VARCHAR(1),
	menses_date DATETIME,
	gestation_weeks INT,
	birth_weight_grams INT,
	birth_weight_oz INT,
	birth_weight_lbs INT,
	birth_weight_unit VARCHAR(1),
	apgar_10 VARCHAR(2),
	apgar_5 VARCHAR(2),
	trans_infant VARCHAR(1),
	trans_infant_fac VARCHAR(50),
	trans_infant_facid INT,
	registrar_name_lfm VARCHAR(50),
	registrarid INT,
	registrar_regis_date DATETIME,
	registrar_sign VARCHAR(1),
	registrar_sig INT,
	informant_name_first VARCHAR(250),
	informant_name_middle VARCHAR(250),
	informant_name_last VARCHAR(250),
	informant_name_suffix VARCHAR(6),
	informant_relationship VARCHAR(50),
	informant_addr1 VARCHAR(100),
	informant_addr2 VARCHAR(100),
	informant_city VARCHAR(50),
	informant_state VARCHAR(20),
	informant_zip VARCHAR(5),
	informant_phone VARCHAR(14),
	attendant_name_lfm VARCHAR(100),
	attendantid INT,
	attendanttitleid INT,
	attendant_title VARCHAR(35),
	attendant_title_code VARCHAR(2),
	attendant_addr1 VARCHAR(100),
	attendant_state VARCHAR(35),
	attendant_zipcode VARCHAR(5),
	certifierid INT,
	certifier_name_lfm VARCHAR(100),
	certifier_date_comp DATETIME,
	certifiertitleid INT,
	certifier_title VARCHAR(35),
	certifier_addr1 VARCHAR(100),
	certifier_state VARCHAR(35),
	certifier_zipcode VARCHAR(5),
	certifier_sign VARCHAR(1),
	certifier_sig INT,
	stop_flag VARCHAR(1),
	stop_date DATETIME,
	ok_to_print VARCHAR(1),
	ok_to_comment VARCHAR(250),
	date_last_ccc DATETIME,
	ssn_requested VARCHAR(1),
	nchs_ready VARCHAR(1),
	nchs_date_sent DATETIME,
	ssa_date_sent DATETIME,
	alert_count INT,
	print_number INT,
	oos_year VARCHAR(4),
	oos_b_num VARCHAR(15),
	death_occurred VARCHAR(1),
	hospital_paternity_flag VARCHAR(1),
	court_info VARCHAR(50),
	record_right VARCHAR(1),
	action_flag_comments VARCHAR(250),
	qualifying_info VARCHAR(250),
	record_is_complete_date DATETIME,
	menses_date_string VARCHAR(10),
	birth_weight_grams_bypass VARCHAR(1),
	gestation_weeks_bypass VARCHAR(1),
	plurality_bypass VARCHAR(1),
	mother_mail_county VARCHAR(50),
	paternity_sign_date DATETIME,
	attendant_city VARCHAR(50),
	attendant_county VARCHAR(50),
	certifier_city VARCHAR(50),
	certifier_county VARCHAR(50),
	ssa_verified_date DATETIME,
	ssa_ready VARCHAR(1),
	name_full_l_suf_f_m VARCHAR(100),
	apgar_1 VARCHAR(2),
	void_flag VARCHAR(1),
	fac_nv_code VARCHAR(10),
	live_births_total VARCHAR(2),
	mother_res_country_fips VARCHAR(2),
	fac_country_fips VARCHAR(2),
	event_name VARCHAR(20),
	certifier_date_comp_str VARCHAR(10),
	registrar_regis_date_str VARCHAR(10),
	date_of_birth_str VARCHAR(10),
	mother_res_st_alpha_fips VARCHAR(2),
	mother_res_st_fips VARCHAR(2),
	errors_pending VARCHAR(1),
	ije_sent VARCHAR(1),
	ije_sent_date DATETIME,
	ije_import VARCHAR(1),
	ije_import_date DATETIME,
	fac_cnty_nv_old VARCHAR(2),
	fac_city_nv_old VARCHAR(3),
	fac_city_name_foreign VARCHAR(40),
	fac_st_nv_old VARCHAR(2),
	mother_res_city_nv_old VARCHAR(3),
	mother_res_cnty_nv_old VARCHAR(3),
	mother_mail_city_nv_old VARCHAR(3),
	mother_mail_cnty_nv_old VARCHAR(2),
	registrar_sign_by VARCHAR(30),
	reg_sign_cnty VARCHAR(1)
);
GO



IF OBJECT_ID('vital_records.birth2', 'U') IS NOT NULL
	DROP TABLE vital_records.birth2;
CREATE TABLE vital_records.birth2 (
	birth2id INT NOT NULL,
	isactive VARCHAR(1),
	event_year INT,
	mother_ethnic_yesno VARCHAR(1),
	mother_mexican VARCHAR(1),
	mother_pr VARCHAR(1),
	mother_cuban VARCHAR(1),
	mother_ethnic_other VARCHAR(1),
	mother_ethnic VARCHAR(50),
	mother_race_white VARCHAR(1),
	mother_race_black VARCHAR(1),
	mother_race_am_indian VARCHAR(1),
	mother_race_am_ind_lit VARCHAR(50),
	mother_race_am_ind_lit2 VARCHAR(50),
	mother_race_chinese VARCHAR(1),
	mother_race_filipino VARCHAR(1),
	mother_race_japanese VARCHAR(1),
	mother_race_korean VARCHAR(1),
	mother_race_vietnamese VARCHAR(1),
	mother_race_asian_ind VARCHAR(1),
	mother_race_asian_oth VARCHAR(1),
	mother_race_asian_lit VARCHAR(50),
	mother_race_asian_lit2 VARCHAR(50),
	mother_race_hawaiian VARCHAR(1),
	mother_race_guam VARCHAR(1),
	mother_race_samoan VARCHAR(1),
	mother_race_pac_other VARCHAR(1),
	mother_race_pac_lit VARCHAR(50),
	mother_race_pac_lit2 VARCHAR(50),
	mother_race_other VARCHAR(1),
	mother_race_other_lit VARCHAR(50),
	mother_race_other_lit2 VARCHAR(50),
	mother_race_not_obtain VARCHAR(1),
	mother_race_refused VARCHAR(1),
	mother_race_unknown_mvr VARCHAR(1),
	mother_race_unknown VARCHAR(1),
	mother_race_legacy VARCHAR(100),
	tobacco_use VARCHAR(1),
	mother_cig_prev VARCHAR(2),
	mother_cig_prev_pack VARCHAR(2),
	mother_cig_first_tri VARCHAR(2),
	mother_cig_first_pack VARCHAR(2),
	mother_cig_second_tri VARCHAR(2),
	mother_cig_second_pack VARCHAR(2),
	mother_cig_last_tri VARCHAR(2),
	mother_cig_last_pack VARCHAR(2),
	mother_cig_or_pack VARCHAR(1),
	mother_wic_yesno VARCHAR(1),
	mother_wt_at_deliv VARCHAR(3),
	mother_wt_at_deliv_bypass VARCHAR(1),
	mother_height_feet VARCHAR(1),
	mother_height_inch VARCHAR(2),
	mother_height_feet_bypass VARCHAR(1),
	mother_pre_preg_wt VARCHAR(3),
	mother_pre_preg_wt_bypass VARCHAR(1),
	mother_dob DATETIME,
	mother_dob_string VARCHAR(10),
	mother_dob_string_bypass VARCHAR(1),
	mother_age VARCHAR(3),
	father_dob DATETIME,
	father_dob_string VARCHAR(10),
	father_dob_string_bypass VARCHAR(1),
	father_age VARCHAR(3),
	mother_ever_married VARCHAR(1),
	father_ethnic_yesno VARCHAR(1),
	father_mexican VARCHAR(1),
	father_pr VARCHAR(1),
	father_cuban VARCHAR(1),
	father_ethnic_other VARCHAR(1),
	father_ethnic VARCHAR(25),
	father_race_white VARCHAR(1),
	father_race_black VARCHAR(1),
	father_race_am_indian VARCHAR(1),
	father_race_am_ind_lit VARCHAR(50),
	father_race_am_ind_lit2 VARCHAR(50),
	father_race_asian VARCHAR(1),
	father_race_chinese VARCHAR(1),
	father_race_filipino VARCHAR(1),
	father_race_japanese VARCHAR(1),
	father_race_korean VARCHAR(1),
	father_race_vietnamese VARCHAR(1),
	father_race_asian_oth VARCHAR(1),
	father_race_asian_lit VARCHAR(50),
	father_race_asian_lit2 VARCHAR(50),
	father_race_hawaiian VARCHAR(1),
	father_race_guam VARCHAR(1),
	father_race_samoan VARCHAR(1),
	father_race_pac VARCHAR(1),
	father_race_pac_lit VARCHAR(50),
	father_race_pac_lit2 VARCHAR(50),
	father_race_other VARCHAR(1),
	father_race_other_lit VARCHAR(50),
	father_race_other_lit2 VARCHAR(50),
	father_race_not_obtain VARCHAR(1),
	father_race_refused VARCHAR(1),
	father_race_unknown_mvr VARCHAR(1),
	father_race_unknown VARCHAR(1),
	father_race_legacy VARCHAR(100),
	father_ed VARCHAR(50),
	father_edcode VARCHAR(1),
	father_ed_bypass VARCHAR(1),
	mother_edcode VARCHAR(1),
	mother_ed_bypass VARCHAR(1),
	prenatal_yesno VARCHAR(1),
	prenatal_date_begin DATETIME,
	prenatal_date_beg_string VARCHAR(10),
	prenatal_date_end DATETIME,
	prenatal_date_end_string VARCHAR(10),
	prenat_tot_visits VARCHAR(2),
	prenat_tot_visits_bypass VARCHAR(2),
	trans_mother VARCHAR(1),
	trans_mother_fac VARCHAR(50),
	trans_mother_facid INT,
	trans_date_string VARCHAR(30),
	birroute_desc VARCHAR(50),
	birroute_code VARCHAR(1),
	birpresent_desc VARCHAR(50),
	birpresent_code VARCHAR(1),
	birth_number VARCHAR(2),
	infant_living VARCHAR(1),
	mother_ed VARCHAR(50),
	match_number INT,
	born_alive VARCHAR(2),
	source_payment VARCHAR(50),
	source_pay_code VARCHAR(1),
	notes VARCHAR(250),
	mail_exclusion VARCHAR(1),
	frace1e VARCHAR(25),
	frace2e VARCHAR(25),
	frace3e VARCHAR(25),
	frace4e VARCHAR(25),
	frace5e VARCHAR(25),
	frace6e VARCHAR(25),
	frace7e VARCHAR(25),
	frace8e VARCHAR(25),
	frace16e VARCHAR(25),
	frace18e VARCHAR(25),
	frace20e VARCHAR(25),
	frace22e VARCHAR(25),
	mrace1e VARCHAR(25),
	mrace2e VARCHAR(25),
	mrace3e VARCHAR(25),
	mrace4e VARCHAR(25),
	mrace5e VARCHAR(25),
	mrace6e VARCHAR(25),
	mrace7e VARCHAR(25),
	mrace8e VARCHAR(25),
	mrace16e VARCHAR(25),
	mrace18e VARCHAR(25),
	mrace20e VARCHAR(25),
	mrace22e VARCHAR(25),
	immun_vacc_literal VARCHAR(30),
	immun_vacc_date DATETIME,
	immun_vacc_time VARCHAR(4),
	immun_vacc_manuf VARCHAR(20),
	immun_vacc_lot VARCHAR(15),
	immun_vacc_site VARCHAR(25),
	immun_vacc_literal_2 VARCHAR(35),
	immun_vacc_date_2 DATETIME,
	immun_vacc_time_2 VARCHAR(4),
	immun_vacc_manuf_2 VARCHAR(20),
	immun_vacc_lot_2 VARCHAR(15),
	immun_vacc_site_2 VARCHAR(25),
	immun_refused VARCHAR(1),
	immuniz_sent VARCHAR(1),
	immuniz_date DATETIME,
	immun_provider_name VARCHAR(50),
	adopt_county VARCHAR(50),
	adopt_state VARCHAR(25),
	adopt_date_filed DATETIME,
	adopt_attorney_name VARCHAR(50),
	adopt_att_addr VARCHAR(75),
	adopt_att_csz VARCHAR(50),
	adopt_step_parent VARCHAR(1),
	adopt_adult VARCHAR(1),
	delay_doc_1 VARCHAR(80),
	delay_doc_2 VARCHAR(80),
	delay_doc_3 VARCHAR(80),
	delay_doc_4 VARCHAR(80),
	delay_ver_date_1 VARCHAR(20),
	delay_ver_date_2 VARCHAR(20),
	delay_ver_date_3 VARCHAR(20),
	delay_ver_date_4 VARCHAR(20),
	record_status_pers_med VARCHAR(50),
	paternity_status VARCHAR(50),
	sealed_envelope_no VARCHAR(10),
	time_of_birth_12hr VARCHAR(30),
	hosp_paternity_complete VARCHAR(1),
	language_foreign VARCHAR(30),
	mother_ed_legacy VARCHAR(2),
	father_ed_legacy VARCHAR(2),
	prenatal_begin_month VARCHAR(1),
	prenatal_begin_calendar VARCHAR(2),
	prenatal_visits_1st_tri VARCHAR(2),
	prenatal_visits_2nd_tri VARCHAR(2),
	prenatal_visits_3rd_tri VARCHAR(2),
	marital_status VARCHAR(15),
	father_surname_code VARCHAR(1),
	reject_yn VARCHAR(1),
	reject_to VARCHAR(50),
	reject_from VARCHAR(50),
	reject_date DATETIME,
	reject_reason VARCHAR(50),
	reject_username VARCHAR(50),
	reject_resolution VARCHAR(50),
	reject_resolve_date DATETIME,
	reject_resolve_username VARCHAR(50),
	reject_yn1 VARCHAR(1),
	reject_to1 VARCHAR(50),
	reject_from1 VARCHAR(50),
	reject_date1 DATETIME,
	reject_reason1 VARCHAR(50),
	reject_username1 VARCHAR(50),
	reject_resolution1 VARCHAR(50),
	reject_resolve_date1 DATETIME,
	reject_resolve_username1 VARCHAR(50),
	paternity_recvd VARCHAR(1),
	immun_vacc_lot_exp DATETIME,
	immun_vacc_lot_exp_2 DATETIME,
	mother_surrogate VARCHAR(1),
	nchs_mo_ethnic_cd VARCHAR(3),
	nchs_mo_ethnic_lit_cd VARCHAR(3),
	nchs_fa_ethnic_cd VARCHAR(3),
	nchs_fa_ethnic_lit_cd VARCHAR(3),
	mo_bridged_race VARCHAR(2),
	fa_bridged_race VARCHAR(2),
	delay_race VARCHAR(50),
	mother_birth_cntry_nv VARCHAR(2),
	mother_state_code_nv VARCHAR(2),
	father_state_code_nv VARCHAR(2),
	father_birth_cntry_nv VARCHAR(2),
	delay_birthplace_1 VARCHAR(25),
	delay_birthplace_2 VARCHAR(25),
	delay_birthplace_3 VARCHAR(25),
	delay_birthplace_4 VARCHAR(25),
	delay_mother_name_1 VARCHAR(50),
	delay_mother_name_2 VARCHAR(50),
	delay_mother_name_3 VARCHAR(50),
	delay_mother_name_4 VARCHAR(50),
	delay_father_name_1 VARCHAR(50),
	delay_father_name_2 VARCHAR(50),
	delay_father_name_3 VARCHAR(50),
	delay_father_name_4 VARCHAR(50),
	delay_orig_info_1 VARCHAR(15),
	delay_orig_info_2 VARCHAR(15),
	delay_orig_info_3 VARCHAR(15),
	delay_orig_info_4 VARCHAR(15),
	delay_dob_info_1 VARCHAR(20),
	delay_dob_info_2 VARCHAR(20),
	delay_dob_info_3 VARCHAR(20),
	delay_dob_info_4 VARCHAR(20),
	delay_race_1 VARCHAR(20),
	delay_race_2 VARCHAR(20),
	delay_race_3 VARCHAR(20),
	delay_race_4 VARCHAR(20),
	immun_refused_2 VARCHAR(1),
	immuniz_sent_2 VARCHAR(1),
	immuniz_date_2 DATETIME,
	immun_provider_name_2 VARCHAR(50),
	hinfo_key VARCHAR(1)
);
GO


IF OBJECT_ID('vital_records.death', 'U') IS NOT NULL
	DROP TABLE vital_records.death;
CREATE TABLE vital_records.death (
	deathid INT NOT NULL,
	event_year INT,
	state_file_number VARCHAR(11),
	local_file_number VARCHAR(15),
	record_status VARCHAR(30),
	reg_type_code VARCHAR(1),
	local_reg_number VARCHAR(15),
	permit_number VARCHAR(15),
	create_date DATETIME,
	create_username VARCHAR(51),
	create_userid INT,
	death_state VARCHAR(2),
	void_flag VARCHAR(1),
	name_first VARCHAR(50),
	name_middle VARCHAR(30),
	name_last VARCHAR(50),
	name_suffix VARCHAR(10),
	name_first_normal_char VARCHAR(50),
	name_middle_normal_char VARCHAR(50),
	name_last_normal_char VARCHAR(50),
	name_last_soundex VARCHAR(4),
	save_no_edit_flag VARCHAR(1),
	father_name_first VARCHAR(50),
	father_name_middle VARCHAR(50),
	father_name_last VARCHAR(50),
	father_name_suffix VARCHAR(10),
	sex VARCHAR(1),
	sex_bypass VARCHAR(1),
	ssn VARCHAR(9),
	age_type VARCHAR(15),
	age_type_code VARCHAR(1),
	age VARCHAR(3),
	age_bypass VARCHAR(1),
	date_of_birth DATETIME,
	dob_string VARCHAR(10),
	birth_country VARCHAR(50),
	birth_state VARCHAR(50),
	citizenship VARCHAR(50),
	citizen_cntry_nchs VARCHAR(50),
	citizen_cntry_nv VARCHAR(50),
	resid_address VARCHAR(50),
	resid_apt_no VARCHAR(10),
	resid_city VARCHAR(50),
	resid_city_nchs VARCHAR(5),
	resid_county VARCHAR(50),
	resid_county_nchs VARCHAR(3),
	resid_state VARCHAR(50),
	resid_state_nchs VARCHAR(2),
	resid_country VARCHAR(50),
	resid_country_nchs VARCHAR(2),
	resid_in_city VARCHAR(1),
	resid_zip VARCHAR(9),
	marital VARCHAR(25),
	marital_bypass VARCHAR(1),
	place_death VARCHAR(40),
	fac_name VARCHAR(200),
	fac_city VARCHAR(50),
	fac_county VARCHAR(50),
	fac_county_code VARCHAR(5),
	fac_cnty_nchs VARCHAR(4),
	fac_address VARCHAR(50),
	fac_state VARCHAR(50),
	fac_zip VARCHAR(9),
	facid INT,
	disposition VARCHAR(30),
	date_of_death DATETIME,
	dod_string VARCHAR(10),
	dod_signed_date DATETIME,
	time_of_death VARCHAR(12),
	time_of_death_indic VARCHAR(10),
	tod_military VARCHAR(5),
	old_education VARCHAR(5),
	education VARCHAR(50),
	education_bypass VARCHAR(1),
	education_code VARCHAR(1),
	race VARCHAR(50),
	race_nv_code VARCHAR(1),
	ancestory VARCHAR(50),
	ancestory_nv_code VARCHAR(2),
	occupat_lit VARCHAR(50),
	occupat_code VARCHAR(3),
	industry_lit VARCHAR(50),
	industry_code VARCHAR(3),
	birth_stateid INT,
	birth_sfn VARCHAR(11),
	birth_year VARCHAR(4),
	birth_city VARCHAR(50),
	birth_oos_sfn_nv VARCHAR(10),
	spouse_name_f VARCHAR(50),
	spouse_name_m VARCHAR(50),
	spouse_name_l VARCHAR(50),
	spouse_name_suf VARCHAR(10),
	mother_name_f VARCHAR(50),
	mother_name_m VARCHAR(50),
	mother_name_l VARCHAR(50),
	mother_name_suf VARCHAR(10),
	informant_name_f VARCHAR(50),
	informant_name_m VARCHAR(50),
	informant_name_l VARCHAR(50),
	informant_name_suf VARCHAR(10),
	informant_relation VARCHAR(50),
	informant_address VARCHAR(50),
	informant_city VARCHAR(50),
	informant_state VARCHAR(50),
	informant_zip VARCHAR(9),
	informant_phone VARCHAR(12),
	dispos_name VARCHAR(50),
	funer_name VARCHAR(200),
	funer_address VARCHAR(50),
	funer_city VARCHAR(50),
	funer_state VARCHAR(50),
	funer_zip VARCHAR(9),
	funer_license VARCHAR(20),
	funer_sign VARCHAR(1),
	funer_sign_date DATETIME,
	date_pronounced DATETIME,
	datex_pron_string VARCHAR(10),
	time_pronounced VARCHAR(12),
	time_pronounce_indic VARCHAR(10),
	tod_pron_military VARCHAR(5),
	date_pro_sig DATETIME,
	cert_sign_date DATETIME,
	cert_name_fml VARCHAR(150),
	cert_title VARCHAR(50),
	certid INT,
	cert_license VARCHAR(15),
	cert_date DATETIME,
	cert_addr VARCHAR(50),
	cert_city VARCHAR(50),
	cert_state VARCHAR(50),
	cert_zip VARCHAR(9),
	date_filed DATETIME,
	coroner_contacted VARCHAR(1),
	coroner_cont_reason VARCHAR(50),
	immed_cause_death VARCHAR(120),
	cause_interval VARCHAR(20),
	cause_units VARCHAR(10),
	consq1 VARCHAR(120),
	consq1_interval VARCHAR(20),
	consq1_units VARCHAR(10),
	consq2 VARCHAR(120),
	consq2_interval VARCHAR(20),
	consq2_units VARCHAR(10),
	consq3 VARCHAR(120),
	consq3_interval VARCHAR(20),
	consq3_units VARCHAR(10),
	oth_signf_conds VARCHAR(240),
	commun_disease_yn VARCHAR(1),
	autopsy_done VARCHAR(1),
	findings_used VARCHAR(1),
	fem_preg VARCHAR(60),
	manner_death VARCHAR(60),
	manner_deathid INT,
	tobacco_yn VARCHAR(1),
	injury_date DATETIME,
	injury_time VARCHAR(20),
	injury_time_indic VARCHAR(10),
	injury_time_mil VARCHAR(5),
	injury_place VARCHAR(100),
	injury_locat VARCHAR(100),
	injury_muni VARCHAR(40),
	injury_county VARCHAR(60),
	injury_state VARCHAR(40),
	injury_stateid INT,
	injury_zip VARCHAR(9),
	injury_zipid INT,
	injury_at_work VARCHAR(1),
	injury_how_occur VARCHAR(240),
	injury_transp VARCHAR(1),
	injury_transpl VARCHAR(50),
	injury_vehicle VARCHAR(50),
	nchs_age VARCHAR(3),
	nchs_ageunit VARCHAR(1),
	username VARCHAR(50),
	userlocation VARCHAR(100),
	emb_date DATETIME,
	cem_name VARCHAR(50),
	cem_mun VARCHAR(50),
	cem_state VARCHAR(50),
	cem_stateid INT,
	cor_phy_title VARCHAR(40),
	cor_phy_sig VARCHAR(1),
	att_phy_title VARCHAR(40),
	att_phy_sig VARCHAR(1),
	reg_sig VARCHAR(1),
	organ_cons VARCHAR(1),
	const_granted VARCHAR(2),
	correctionroll VARCHAR(15),
	cdecedentid VARCHAR(20),
	fac_in_city VARCHAR(1),
	preg42 VARCHAR(2),
	preg43 VARCHAR(2),
	census VARCHAR(6),
	queryflag VARCHAR(20),
	cstatecert VARCHAR(20),
	itemsqueried VARCHAR(10),
	ovs_send_stat VARCHAR(50),
	ovs_rtn_stat VARCHAR(50),
	ovs_trans_date DATETIME,
	ovs_verify_date DATETIME,
	ovs_case_numb VARCHAR(20),
	ovs_num_tries INT,
	ovs_was_verified_data VARCHAR(80),
	ovs_was_verified_flag VARCHAR(1),
	ssa_flag VARCHAR(1),
	ssa_date DATETIME,
	nchs_flag VARCHAR(1),
	nchs_date DATETIME,
	val_table_ind VARCHAR(1),
	plc_death_cd VARCHAR(1),
	birth_countryid INT,
	disp_code VARCHAR(1),
	ok_to_print VARCHAR(1),
	print_number INT,
	print_reason VARCHAR(150),
	birth_matched VARCHAR(1),
	chart_x_flg VARCHAR(1),
	chart_x_date DATETIME,
	alert_count INT,
	maritalid INT,
	death2id INT,
	userlocation_county VARCHAR(50),
	death3id INT,
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT,
	modify_user_name VARCHAR(51),
	date_cc_printed DATETIME,
	cert_degree VARCHAR(30),
	funer_sig INT,
	att_phy_sign VARCHAR(1),
	cor_phy_sign VARCHAR(1),
	reg_sign VARCHAR(1),
	death_oos_sfn VARCHAR(12),
	ssn_mvr VARCHAR(1),
	cert_email VARCHAR(50),
	education_test VARCHAR(50),
	event_name VARCHAR(20),
	fac_city_nchs VARCHAR(5)
);
GO


IF OBJECT_ID('vital_records.death050707', 'U') IS NOT NULL
	DROP TABLE vital_records.death050707;
CREATE TABLE vital_records.death050707 (
	col001 VARCHAR(8000),
	col002 VARCHAR(8000),
	col003 VARCHAR(8000),
	col004 VARCHAR(8000),
	col005 VARCHAR(8000),
	col006 VARCHAR(8000),
	col007 VARCHAR(8000)
);
GO


IF OBJECT_ID('vital_records.death2', 'U') IS NOT NULL
	DROP TABLE vital_records.death2;
CREATE TABLE vital_records.death2 (
	death2id INT NOT NULL,
	event_year INT,
	injury_date_string VARCHAR(10),
	d_to_p_print_date DATETIME,
	d_to_p_printed VARCHAR(1),
	paper_electronic VARCHAR(1),
	decedent_found VARCHAR(5),
	dod_known VARCHAR(1),
	doinjury_know VARCHAR(1),
	injury_date_known VARCHAR(1),
	injuryplace VARCHAR(1),
	activity_code VARCHAR(1),
	pend_investigat VARCHAR(1),
	resid_zipid_x INT,
	fac_zipid_x INT,
	dethnice VARCHAR(3),
	injury_placeid VARCHAR(2),
	injury_activity VARCHAR(1),
	hospice_yn VARCHAR(1),
	hospice_prg_code VARCHAR(8),
	hospice_prg VARCHAR(50),
	fh_id VARCHAR(10),
	fh_est_num VARCHAR(20),
	fh_countyc_nv VARCHAR(4),
	fh_cityc_nv VARCHAR(3),
	fh_complete VARCHAR(1),
	fh_compl_date DATETIME,
	fh_compl_user VARCHAR(50),
	fh_comment VARCHAR(250),
	fh_direct_name VARCHAR(50),
	fd_user_id VARCHAR(10),
	fd_license VARCHAR(10),
	fh_trade_name VARCHAR(200),
	fac_countyc_nv VARCHAR(4),
	fac_two_cntyc_nv VARCHAR(2),
	fac_cityc_nv VARCHAR(3),
	fac_complete VARCHAR(1),
	fac_compl_date DATETIME,
	fac_compl_user VARCHAR(51),
	fac_trade_name VARCHAR(200),
	dr_complete VARCHAR(1),
	dr_compl_date DATETIME,
	dr_compl_user VARCHAR(51),
	cor_complete VARCHAR(1),
	cor_compl_date DATETIME,
	cor_compl_user VARCHAR(51),
	cnty_complete VARCHAR(1),
	cnty_compl_date DATETIME,
	cnty_compl_user VARCHAR(51),
	st_complete VARCHAR(1),
	st_compl_date DATETIME,
	st_compl_user VARCHAR(51),
	registrar_name VARCHAR(50),
	registrar_id VARCHAR(5),
	registrar_sign INT,
	phy_assign VARCHAR(50),
	phy_filter_loc VARCHAR(3),
	phy_location VARCHAR(100),
	phy_loc_code VARCHAR(8),
	phy_county VARCHAR(30),
	type_certifier VARCHAR(20),
	deathnic5c VARCHAR(3),
	trade_call VARCHAR(200),
	trade_call_id VARCHAR(10),
	trade_call_trade_name VARCHAR(200),
	trade_address VARCHAR(50),
	trade_city VARCHAR(50),
	trade_state VARCHAR(50),
	trade_zip VARCHAR(10),
	trade_license VARCHAR(20),
	trade_phone VARCHAR(14),
	trade_yn VARCHAR(1),
	resid_countyc_nv VARCHAR(4),
	resid_two_cntyc_nv VARCHAR(2),
	resid_cityc_nv VARCHAR(3),
	resid_stc_nv VARCHAR(2),
	cert_type_code VARCHAR(1),
	uc_query VARCHAR(1),
	army_yesno VARCHAR(1),
	armed_forces_beg DATETIME,
	armed_forces_end DATETIME,
	armedf_beg_string VARCHAR(10),
	armedf_end_string VARCHAR(10),
	race1e VARCHAR(3),
	race2e VARCHAR(3),
	race3e VARCHAR(3),
	race4e VARCHAR(3),
	race5e VARCHAR(3),
	race6e VARCHAR(3),
	race7e VARCHAR(3),
	race8e VARCHAR(3),
	race16c VARCHAR(3),
	race17c VARCHAR(3),
	race18c VARCHAR(3),
	race19c VARCHAR(3),
	race20c VARCHAR(3),
	race21c VARCHAR(3),
	race22c VARCHAR(3),
	race23c VARCHAR(3),
	racebrg VARCHAR(2),
	smicar_shipment_number VARCHAR(3),
	smicar_receipt_date DATETIME,
	smicar_icd10 VARCHAR(5),
	smicar_axis_1 VARCHAR(8),
	smicar_axis_2 VARCHAR(8),
	smicar_axis_3 VARCHAR(8),
	smicar_axis_4 VARCHAR(8),
	smicar_axis_5 VARCHAR(8),
	smicar_axis_6 VARCHAR(8),
	smicar_axis_7 VARCHAR(8),
	smicar_axis_8 VARCHAR(8),
	smicar_axis_9 VARCHAR(8),
	smicar_axis_10 VARCHAR(8),
	smicar_axis_11 VARCHAR(8),
	smicar_axis_12 VARCHAR(8),
	smicar_axis_13 VARCHAR(8),
	smicar_axis_14 VARCHAR(8),
	smicar_axis_15 VARCHAR(8),
	smicar_axis_16 VARCHAR(8),
	smicar_axis_17 VARCHAR(8),
	smicar_axis_18 VARCHAR(8),
	smicar_axis_19 VARCHAR(8),
	smicar_axis_20 VARCHAR(8),
	acme1 VARCHAR(8),
	acme2 VARCHAR(8),
	acme3 VARCHAR(8),
	acme4 VARCHAR(8),
	acme5 VARCHAR(8),
	acme6 VARCHAR(8),
	acme7 VARCHAR(8),
	acme8 VARCHAR(8),
	acme9 VARCHAR(8),
	acme10 VARCHAR(8),
	acme11 VARCHAR(8),
	acme12 VARCHAR(8),
	acme13 VARCHAR(8),
	acme14 VARCHAR(8),
	acme15 VARCHAR(8),
	acme16 VARCHAR(8),
	acme17 VARCHAR(8),
	acme18 VARCHAR(8),
	acme19 VARCHAR(8),
	acme20 VARCHAR(8),
	ls1 VARCHAR(5),
	ls2 VARCHAR(5),
	ls3 VARCHAR(5),
	ls4 VARCHAR(5),
	ls5 VARCHAR(5),
	ls6 VARCHAR(5),
	ls7 VARCHAR(5),
	ls8 VARCHAR(5),
	ls9 VARCHAR(5),
	ls10 VARCHAR(5),
	ls11 VARCHAR(5),
	ls12 VARCHAR(5),
	ls13 VARCHAR(5),
	ls14 VARCHAR(5),
	ls15 VARCHAR(5),
	ls16 VARCHAR(5),
	ls17 VARCHAR(5),
	ls18 VARCHAR(5),
	ls19 VARCHAR(5),
	ls20 VARCHAR(5),
	noso_complete VARCHAR(1),
	noso_compl_date DATETIME,
	noso_user VARCHAR(51),
	geo_lat VARCHAR(10),
	geo_long VARCHAR(10),
	record_type VARCHAR(1),
	source VARCHAR(2),
	manual_underlying_code VARCHAR(5),
	acme_underlying_code VARCHAR(5),
	transax_conversion VARCHAR(1),
	transax_imported_yn VARCHAR(1),
	election_ready_flag VARCHAR(1),
	election_ready_date DATETIME,
	state_sent VARCHAR(1),
	state_sent_date DATETIME,
	intj_sent VARCHAR(1),
	intj_sent_date DATETIME,
	mcrf_sent VARCHAR(1),
	mcrf_sent_date DATETIME,
	geo_sent VARCHAR(1),
	geo_sent_date DATETIME,
	delayed_info_1 VARCHAR(80),
	delayed_info_2 VARCHAR(80),
	notes VARCHAR(250),
	sent_super VARCHAR(1),
	date_sent_super DATETIME,
	placetype_micar VARCHAR(1),
	supermicar_flag VARCHAR(1),
	supermicar_resend VARCHAR(1),
	supermicar_resend_date DATETIME,
	supermicar_sent VARCHAR(1),
	supermicar_sent_date DATETIME,
	icd10 VARCHAR(5),
	resend_yn VARCHAR(1),
	resend_date DATETIME,
	shipment_numb VARCHAR(20),
	verified_yn VARCHAR(1),
	verif_userid VARCHAR(20),
	verif_date DATETIME,
	occode_complete VARCHAR(1),
	occode_comp_date DATETIME,
	occode_user VARCHAR(51),
	reject_queue VARCHAR(1),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT,
	modify_user VARCHAR(51),
	rap_rpt_sent VARCHAR(1),
	rap_rpt_sent_date DATETIME,
	cancer_sent VARCHAR(1),
	cancer_sent_date DATETIME,
	rare_flag VARCHAR(1),
	rare_date DATETIME,
	unlike_flag VARCHAR(1),
	unlikedate DATETIME
);
GO


IF OBJECT_ID('vital_records.death3', 'U') IS NOT NULL
	DROP TABLE vital_records.death3;
CREATE TABLE vital_records.death3 (
	death3id INT NOT NULL,
	event_year INT,
	create_date DATETIME,
	user_location VARCHAR(10),
	case_file_number VARCHAR(11),
	name_lfms VARCHAR(36),
	record_status_pers VARCHAR(51),
	record_status_med VARCHAR(51),
	cert_phone VARCHAR(10),
	cert_extension VARCHAR(5),
	cert_email VARCHAR(60),
	cert_fax VARCHAR(10),
	cert_pref_contact VARCHAR(5),
	fun_phone VARCHAR(14),
	fun_extension VARCHAR(5),
	fun_email VARCHAR(60),
	fun_fax VARCHAR(10),
	fun_pref_contact VARCHAR(5),
	fun_contact_name VARCHAR(50),
	cor_tod_known VARCHAR(1),
	cor_prodod_knwn VARCHAR(1),
	cor_protod_knwn VARCHAR(1),
	coroner_case_num VARCHAR(10),
	tod_known VARCHAR(1),
	attending_name VARCHAR(50),
	attending_title VARCHAR(20),
	amendmt_yn VARCHAR(1),
	amendmt_total VARCHAR(2),
	alias_yn VARCHAR(1),
	resid_countryc_nv VARCHAR(2),
	death_code_nv VARCHAR(5),
	certificate_on_time VARCHAR(1),
	certificate_satifactory VARCHAR(1),
	death_state_code VARCHAR(2),
	birth_state_code VARCHAR(2),
	fac_inst_code VARCHAR(10),
	fac_nv_code VARCHAR(4),
	marital_code VARCHAR(1),
	marital_code_alpha VARCHAR(1),
	form_control_number VARCHAR(6),
	cem_address VARCHAR(50),
	cem_zip VARCHAR(9),
	cem_phone VARCHAR(14),
	cem_country VARCHAR(20),
	comm_disease_cert VARCHAR(1),
	burial_ok_cert VARCHAR(1),
	burial_ok_date DATETIME,
	burial_ok_by VARCHAR(51),
	burial_ok_user VARCHAR(51),
	disp_ok VARCHAR(1),
	inform_info_verified VARCHAR(1),
	permit_print_num VARCHAR(1),
	permit_print_date DATETIME,
	imported_yn VARCHAR(1),
	regis_st_cnty VARCHAR(12),
	medical_record_num VARCHAR(15),
	case_started_by VARCHAR(50),
	reject_yn VARCHAR(1),
	reject_fr_to VARCHAR(50),
	rejected_date VARCHAR(50),
	rejected_by VARCHAR(50),
	rejected_to_name VARCHAR(50),
	rejected_fr_code VARCHAR(1),
	rejected_to_code VARCHAR(1),
	rejected_to_name1 VARCHAR(50),
	rejected_reason_code VARCHAR(3),
	rejected_reason VARCHAR(50),
	rejected_comments VARCHAR(100),
	co_judge VARCHAR(50),
	co_judge_cnty VARCHAR(50),
	co_case_number VARCHAR(12),
	co_file_dt_str VARCHAR(10),
	co_file_date DATETIME,
	race_nchs VARCHAR(1),
	race_white VARCHAR(1),
	race_black VARCHAR(1),
	race_am_indian VARCHAR(1),
	race_asian VARCHAR(1),
	race_chinese VARCHAR(1),
	race_filipino VARCHAR(1),
	race_japanese VARCHAR(1),
	race_korean VARCHAR(1),
	race_vietnamese VARCHAR(1),
	race_oth_asian VARCHAR(1),
	race_hawaiian VARCHAR(1),
	race_guam VARCHAR(1),
	race_samoan VARCHAR(1),
	race_oth_pac_isl VARCHAR(1),
	race_other VARCHAR(1),
	race_am_ind_lit VARCHAR(50),
	race_am_ind_lit2 VARCHAR(50),
	race_oth_asian_lit VARCHAR(50),
	race_oth_asian_lit2 VARCHAR(50),
	race_oth_pac_isl_lit VARCHAR(50),
	race_oth_pac_isl_lit2 VARCHAR(50),
	race_other_lit VARCHAR(50),
	race_other_lit2 VARCHAR(50),
	race_mvr VARCHAR(1),
	race_unknown VARCHAR(1),
	race_unknown_mvr VARCHAR(1),
	ethnic_yesno VARCHAR(1),
	ethnic_mexican VARCHAR(1),
	ethnic_pr VARCHAR(1),
	ethnic_cuban VARCHAR(1),
	ethnic_other VARCHAR(1),
	ethnic_other_lit VARCHAR(50),
	ancestory_nchs VARCHAR(2),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT,
	modify_user_name VARCHAR(50),
	burial_permit_recvd VARCHAR(1),
	alert_1 VARCHAR(50),
	alert_2 VARCHAR(50),
	alert_3 VARCHAR(50),
	oos_death_state VARCHAR(10),
	resend_nchs_yn VARCHAR(1),
	resend_nchs_date DATETIME,
	hofficer_name VARCHAR(50),
	hofficer_date DATETIME,
	hofficer_yn VARCHAR(2),
	hofficer_notes VARCHAR(255),
	intraining VARCHAR(1),
	last_status VARCHAR(30),
	ud_axis1 VARCHAR(10),
	ud_axis2 VARCHAR(10),
	attending_id VARCHAR(10),
	fun_contact_id VARCHAR(20),
	co_amend_nbr VARCHAR(12),
	ud_axis3 VARCHAR(10),
	ud_axis4 VARCHAR(10),
	ud_axis5 VARCHAR(10),
	ud_axis6 VARCHAR(10),
	ud_axis7 VARCHAR(10),
	ud_axis8 VARCHAR(10),
	ud_axis9 VARCHAR(10),
	ud_axis10 VARCHAR(10),
	ud_axis11 VARCHAR(10),
	ud_axis12 VARCHAR(10),
	ud_axis13 VARCHAR(10),
	ud_axis14 VARCHAR(10),
	ud_axis15 VARCHAR(10),
	ud_axis16 VARCHAR(10),
	ud_axis17 VARCHAR(10),
	ud_axis18 VARCHAR(10),
	ud_axis19 VARCHAR(10),
	ud_axis20 VARCHAR(10),
	res_latitude VARCHAR(50),
	res_longitude VARCHAR(50),
	geo_out_census VARCHAR(100),
	geo_out_county_fips VARCHAR(50),
	geo_out_score VARCHAR(100),
	geo_out_msa VARCHAR(50),
	geo_out_full VARCHAR(50),
	geo_out_error VARCHAR(255),
	fac_latitude VARCHAR(50),
	fac_longitude VARCHAR(50),
	fac_geo_out_census VARCHAR(50),
	fac_geo_out_county_fips VARCHAR(50),
	fac_geo_out_score VARCHAR(50),
	fac_geo_out_msa VARCHAR(50),
	fac_geo_out_full VARCHAR(50),
	fac_geo_out_error VARCHAR(255),
	age_yr_print VARCHAR(3),
	age_mon_print VARCHAR(2),
	age_day_print VARCHAR(2),
	age_hr_print VARCHAR(2),
	age_min_print VARCHAR(2),
	race_not_obtainable VARCHAR(1),
	race_refused VARCHAR(1),
	res_country_fips VARCHAR(2),
	res_state_fips VARCHAR(2),
	res_county_fips VARCHAR(3),
	res_city_fips VARCHAR(5),
	injury_country_fips VARCHAR(2),
	injury_state_fips VARCHAR(2),
	injury_county_fips VARCHAR(3),
	injury_city_fips VARCHAR(5),
	birth_country_fips VARCHAR(2),
	birth_state_fips VARCHAR(2),
	birth_county_fips VARCHAR(3),
	birth_city_fips VARCHAR(5),
	death_country_fips VARCHAR(2),
	death_state_fips VARCHAR(2),
	death_county_fips VARCHAR(3),
	death_city_fips VARCHAR(5),
	sos_sent VARCHAR(1),
	sos_sent_date DATETIME,
	dmv_sent VARCHAR(1),
	dmv_sent_date DATETIME,
	infant_dob_yr INT,
	alias_code_nv VARCHAR(1),
	reg_code_nv VARCHAR(1),
	age_wk_print VARCHAR(2),
	bp_reg_ok_sign VARCHAR(1),
	bp_reg_ok_sig INT,
	bp_reg_name VARCHAR(30),
	bp_reg_date DATETIME,
	bp_reg_by VARCHAR(30),
	bp_reg_id INT,
	race_nchshisp VARCHAR(3),
	bp_ok_by_fml VARCHAR(50)
);
GO


IF OBJECT_ID('vital_records.death_alert', 'U') IS NOT NULL
	DROP TABLE vital_records.death_alert;
CREATE TABLE vital_records.death_alert (
	death_alertid INT,
	alert_desc VARCHAR(150),
	isactive VARCHAR(50),
	modify_date DATETIME,
	modify_userid INT
);
GO


IF OBJECT_ID('vital_records.death_cert_num', 'U') IS NOT NULL
	DROP TABLE vital_records.death_cert_num;
CREATE TABLE vital_records.death_cert_num (
	death_cert_numid INT,
	item VARCHAR(15),
	item_desc VARCHAR(150),
	field_name VARCHAR(255),
	event VARCHAR(10),
	isactive VARCHAR(50),
	modify_date DATETIME,
	modify_userid INT
);
GO


IF OBJECT_ID('vital_records.death_coroner', 'U') IS NOT NULL
	DROP TABLE vital_records.death_coroner;
CREATE TABLE vital_records.death_coroner (
	death_coronerid INT NOT NULL,
	coroner_reason VARCHAR(50),
	coroner_code VARCHAR(4),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT
);
GO


IF OBJECT_ID('vital_records.death_hpc', 'U') IS NOT NULL
	DROP TABLE vital_records.death_hpc;
CREATE TABLE vital_records.death_hpc (
	death_hpcid INT,
	hpc_code VARCHAR(10),
	nv_code_pre VARCHAR(3),
	nv_code_fac_old VARCHAR(4),
	hpc_name VARCHAR(100),
	aka VARCHAR(100),
	address1 VARCHAR(50),
	address2 VARCHAR(50),
	city VARCHAR(50),
	county VARCHAR(50),
	nv_county_code VARCHAR(3),
	state VARCHAR(2),
	zip VARCHAR(10),
	hpc_nchs_code VARCHAR(10),
	hpc_type_name VARCHAR(50),
	hpc_paper_elec VARCHAR(1),
	hpc_license VARCHAR(15),
	name_fml VARCHAR(50),
	name_lfm VARCHAR(50),
	name_first VARCHAR(25),
	name_middle VARCHAR(25),
	name_last VARCHAR(25),
	name_suffix VARCHAR(4),
	salutation VARCHAR(6),
	degree VARCHAR(10),
	phone VARCHAR(10),
	phone_extension VARCHAR(5),
	email VARCHAR(50),
	fax VARCHAR(10),
	preferred_method VARCHAR(10),
	year_voided INT,
	birth_fac VARCHAR(4),
	death_fac VARCHAR(4),
	acos_number VARCHAR(10),
	fips_state VARCHAR(2),
	fips_county VARCHAR(3),
	fips_city VARCHAR(5),
	fips_class_code VARCHAR(2),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT
);
GO


IF OBJECT_ID('vital_records.death_inform', 'U') IS NOT NULL
	DROP TABLE vital_records.death_inform;
CREATE TABLE vital_records.death_inform (
	death_informid INT,
	dth_inform_desc VARCHAR(50),
	modify_date DATETIME,
	modify_userid INT,
	isactive VARCHAR(1),
	event_filter VARCHAR(10)
);
GO


IF OBJECT_ID('vital_records.death_injury_place', 'U') IS NOT NULL
	DROP TABLE vital_records.death_injury_place;
CREATE TABLE vital_records.death_injury_place (
	death_injury_placeid INT NOT NULL,
	placetype_code VARCHAR(5),
	placetype_name VARCHAR(30),
	isactive VARCHAR(1),
	modify_userid INT,
	modify_date DATETIME,
	nv_codes VARCHAR(2),
	supermicar_code VARCHAR(1)
);
GO


IF OBJECT_ID('vital_records.death_marital', 'U') IS NOT NULL
	DROP TABLE vital_records.death_marital;
CREATE TABLE vital_records.death_marital (
	maritaldthid INT,
	marital_code VARCHAR(1),
	marital_desc VARCHAR(25),
	modify_date DATETIME,
	isactive VARCHAR(1),
	modify_userid INT,
	import_code VARCHAR(1)
);
GO


IF OBJECT_ID('vital_records.death_place', 'U') IS NOT NULL
	DROP TABLE vital_records.death_place;
CREATE TABLE vital_records.death_place (
	death_placeid INT NOT NULL,
	place_of_death VARCHAR(40),
	nv_codes VARCHAR(1),
	place_of_death_code VARCHAR(1),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT,
	prime_input VARCHAR(1)
);
GO


IF OBJECT_ID('vital_records.death_reject', 'U') IS NOT NULL
	DROP TABLE vital_records.death_reject;
CREATE TABLE vital_records.death_reject (
	death_rejectid VARCHAR(2) NOT NULL,
	reject_reason_code VARCHAR(8),
	reject_originator VARCHAR(8),
	reject_reason_desc VARCHAR(50),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT
);
GO


IF OBJECT_ID('vital_records.death_reject_type', 'U') IS NOT NULL
	DROP TABLE vital_records.death_reject_type;
CREATE TABLE vital_records.death_reject_type (
	death_reject_typeid VARCHAR(2) NOT NULL,
	reject_originator VARCHAR(8),
	reject_assign_type VARCHAR(5),
	reject_reason_code VARCHAR(8),
	reject_reason_desc VARCHAR(50),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT
);
GO


IF OBJECT_ID('vital_records.death_status', 'U') IS NOT NULL
	DROP TABLE vital_records.death_status;
CREATE TABLE vital_records.death_status (
	death_statusid INT,
	dea_status_desc VARCHAR(25),
	dea_status_sect VARCHAR(10),
	isactive VARCHAR(1),
	modify_date DATETIME,
	modify_userid INT
);
GO



EXEC dbo.add_imported_at_column_to_tables_by_schema 'vital_records';
EXEC dbo.add_imported_to_dw_column_to_tables_by_schema 'vital_records';




--
--These constraints would REQUIRE that birth2 record exists BEFORE birth record.
--Not sure how we're gonna get them so ...
--
--ALTER TABLE birth
--	ADD CONSTRAINT fk_birth2id 
--		FOREIGN KEY (birth2id) REFERENCES birth2(birth2id);
--ALTER TABLE death
--	ADD CONSTRAINT fk_death2id 
--		FOREIGN KEY (death2id) REFERENCES death2(death2id);



