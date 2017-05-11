proc format;
	value sex
		1 = 'Male'
		2 = 'Female'
		9 = 'Unknown'
	;
/*Used for the following variables: birth_st, mom_rst, mom_bst, fa_bst*/
	value state
		1 = 'AL'			2 = 'AK'			3 = 'AZ'			4 = 'AR'			5 = 'CA'
		6 = 'CO'			7 = 'CT'			8 = 'DE'			9 = 'DC'			10 = 'FL'
		11 = 'GA'			12 = 'HI'			13 = 'ID'			14 = 'IL'			15 = 'IN'
		16 = 'IA'			17 = 'KS'			18 = 'KY'			19 = 'LA'			20 = 'ME'
		21 = 'MD'			22 = 'MA'			23 = 'MI'			24 = 'MN'			25 = 'MS'
		26 = 'MO'			27 = 'MT'			28 = 'NE'			29 = 'NV'			30 = 'NH'
		31 = 'NJ'			32 = 'NM'			33 = 'NY'			34 = 'NC'			35 = 'ND'
		36 = 'OH'			37 = 'OK'			38 = 'OR'			39 = 'PA'			40 = 'RI'
		41 = 'SC'			42 = 'SD'			43 = 'TN'			44 = 'TX'			45 = 'UT'
		46 = 'VT'			47 = 'VA'			48 = 'WA'			49 = 'WV'			50 = 'WI'
		51 = 'WY'			52 = 'PR'			53 = 'VI'			54 = 'GU'			55 = 'Canada'
		56 = 'Cuba'			57 = 'Mexico'		59 = 'Remainder of the World'			60 = 'United States'
		99 = 'Unknown'
	;
/*Used for the following variables: birth_co, mom_rco*/
	value county
		1 = 'Carson City'				2 = 'Churchill'					3 = 'Clark'
		4 = 'Douglas'					5 = 'Elko'						6 = 'Esmeralda'
		7 = 'Eureka'					8 = 'Humboldt'					9 = 'Lander'
		10 = 'Lincoln'					11 = 'Lyon'						12 = 'Mineral'
		13 = 'Nye'						14 = 'Pershing'					15 = 'Storey'
		16 = 'Washoe'					17 = 'White Pine'				88 = 'Out of State'
		99 = 'Unknown'
	;
/*Used for the following variables: birth_ci mom_rci*/
	VALUE city
		1 = "Carson City"				2 = "Henderson"						3 = "Las Vegas"					4 = "North Las Vegas"
		5 = "Reno"						6  = "Sparks"						11 = "Austin"					17 = "Battle Mountain"
		23 = "Boulder City"				25 = "Caliente"						48 = "Dresslerville"			49 = "Duckwater"
		55 = "Elko"						56 = "Ely"							58 = "Eureka"					59 = "Fallon"
		60 = "Fernley"					63 = "Gardnerville"					72 = "Goldfield"				75 = "Hawthorne"
		80 = "Incline Village"			82 = "Ione (Yomba)"					95 = "Lee"						101= "Lovelock"
		107 = "McDermitt"				108 = "McGill"						113 = "Minden"					115 = "Moapa"
		122 = "Nixon"					131 = "Owyhee"						137 = "Pioche"					144 = "Ruby Valley"
		147 = "Schurz"					160 = "Stateline"					162 = "Stewart"					170 = "Tippett"
		171 = "Tonopah"					177 = "Virginia City"				187 = "Wells"					191 = "Winnemucca"
		192 = "Yerington"				193 = "Zephyr Cove"					700 = "Other Carson City Towns"	701 = "Other Churchill Towns"
		702 = "Other Clark Towns"		703 = "Other Douglas Towns"			704 = "Other Elko Towns"		705 = "Other Esmeralda Towns"
		706 = "Other Eureka Towns"		707 = "Other Humboldt Towns"		708 = "Other Lander Towns"		709 = "Other Lincoln Towns"
		710 = "Other Lyon Towns"		711 = "Other Mineral Towns"			712 = "Other Nye Towns"			713 = "Other Pershing Towns"
		714 = "Other Storey Towns"		715 = "Other Washoe Towns"			716 = "Other White Pine Towns"	888 = "Out of State"
		999 = "Unknown"
	;
/*Use for 1975-2009*/
	value place_prior
		1 = 'Hospital'
		2 = 'Birth Center'
		3 = 'Clinic/Dr.Office'
		4 = 'Residence' 
		5 = 'Other'
		9 = 'Unknown'
	;
/*Use for 2010 - current*/
	value place
		1 = "Hospital"
		2 = "Freestanding Birth Center"
		3 = "Home (Intended)"
		4 = "Home (Not Intended)"
		5 = "Home (Unknown if Intended)"
		6 = "Clinic/Doctor's Office"
		7 = "Other"
		9 = "Unknown"
	;
/*Same of the facilities have changed names for example: Renown Regional Medical Center was Washe Medical Center*/
	value facility
		3 = "Home"																	4 = "Other"
		5 = "Enroute"																9 = "Unknown"
		101 = "Carson Tahoe Regional Medical Center"								103 = "Sierra Surgery Hospital"
		104 = "Continuecare Hospital of Carson Tahoe, Inc. "						105 = "Carson Tahoe Specialty Medical Center"
		201 = "Banner Churchill Community Hospital"									301 = "Boulder City Hospital"
		302 = "Desert Springs Hospital"												304 = "North Vista Hospital"
		306 = "St. Rose Dominican De Lima Campus"									307 = "University Medical Center"
		308 = "Sunrise Hospital Medical Center"										309 = "Valley Hospital Medical Center"
		311 = "Mike O'Callaghan Federal Hospital"									314 = "Montevista Hospital"
		316 = "Horizon Specialty Center Las Vegas"									317 = "Healthsouth Rehab of Las Vegas"
		318 = "Kindred Hospital Las Vegas"											319 = "Mountain View Hospital"
		320 = "Odyssey Harbor House"												321 = "Summerlin Hospital Medical Center"
		322 = "St. Rose Dominican Siena Campus"										323 = "Spring Valley Hospital Medical Center"
		324 = "Southern Hills Medical Center"										325 = "Mesa View Regional Hospital"
		326 = "Desert View Regional Medical Center"									327 = "Red Rock Behavioral Hospital"
		328 = "Westcare Mental Health Crisis Unit"									329 = "Progressive Hospital"
		330 = "St. Rose Dominican San Martin Campus"								331 = "Centennial Hills Hospital Medical Center"
		332 = "Southern Nevada Adult Mental Health Services"						333 = "Springs Mountain Treatment Center"
		334 = "Kindred Hospital LV at Desert Springs Hospital"						335 = "Kindred Hospital Las Vegas Flamingo Campus"
		336 = "Healthsouth Rehab of Henderson"										337 = "Desert Willow Treatment Center"
		338 = "Desert Canyon Rehabilitation Hospital"								339 = "Seven Hills Behavioral Institute"
		340 = "Spring Mountain Sahara"												341 = "Harmon Medical & Rehab Hospital"
		342 = "UMC Rancho Rehabilitation Center"									501 = "Northeastern Nevada Regional Health"
		801 = "	Humboldt General Hospital"											901 = "	Battle Mountain General Hospital"
		1001 = "Grover C Dils Medical Center"										1101 = "South Lyon Medical Center"
		1102 = "Carson Valley Medical Center"										1201 = "Mount Grant General Hospital"
		1301 = "Nye Regional Medical Center"										1302 = "Pahrump Family Medical Center"
		1401 = "Pershing General Hospital"											1602 = "St. Mary's Regional Medical Center"
		1603 = "Renown Regional Medical Center"										1604 = "Veteran's Hospital"
		1605 = "Incline Village Medical Center"										1606 = "Northern Nevada Medical Center"
		1607 = "Renown Medical Center Rehab Hospital"								1609 = "BHC Westhills Hospital"
		1610 = "Tahoe Pacific Hospital Meadows"										1612 = "Willow Springs Center"
		1613 = "Renown South Meadows Medical Center"								1614 = "Tahoe Pacific Hospital West"
		1616 = "Lake's Crossing Center"												1617 = "Dini Townsend Hospital at NNAMHS"
		1701 = "William B Ririe Hospital"											2001 = "Licensed Skilled Nursing Facilities"
		2002 = "Licensed Intermediate Care Facilities"								2003 = "Licensed Group Care Facilities"
		2004 = "Licensed Alcohol/Drug Treatment"									2005 = "Licensed Child Care Facilities"
		2006 = "Miscellaneous Licensed Facilities"									2007 = "All Licensed Out of State Facilities"
	;
/*Used for the following variables: attendent and certifier*/
	value attendant
		1 =	"MD"
		2 =	"DO"
		3 =	"CNM/CM"
		4 = "Other Midwife"
		5 =	"Other"
		9 =	"Unknown"
	;
/*Used for the following variables: marital, marital_mf*/
	value marital
		1 = 'Married'
		2 = 'Never Married'
		3 = 'Widowed'
		4 = 'Divorced'
		5 = 'Separated'
		9 = 'Unknown'
	;
/*Used for the following variables: (only for 2009 - current)  mom_edu fa_edu, prior to 2009 the number represents the years in school */
	value education
		1 = '8th Grade or Less'
		2 = '9th through 12th Grade, no Diploma'
		3 = 'High School Graduate or GED'	
		4 = 'Some College, but no Degree'
		5 = 'Associate Degree'
		6 = 'Bachelors Degree'
		7 = 'Masters Degree'
		8 = 'Doctorate Degree'
		9 = 'Unknown'
	;
/*Used for the following variables: alcohol, drug_use */
	value standard1_yesno
		1 = 'Yes'
		2 = 'No'
		3 = 'Refused/Not Applicable'
		9 = 'Unknown'
	;
/*Used for the following variables: 
						incity paternity mom_everm married_betw fa_husb,mom_everm_ebrs mom_m_da married_betw_ebrs fa_husb_ebrs 
						prenatal prenatal_ebrs tobacco md_forcepsattpt md_vaccumattpt md_forcepsattpt_ebrs md_vaccumattpt_ebrs 
						wic wic_ebrs breastfeeding inf_liv inf_trans mom_trans ssn_request*/
	value standard2_yesno
		1 = 'Yes'
		2 = 'No'
		9 = 'Unknown'
	;
/*Used for the following variables: fa_signpat pat_complete fa_signpat_ebrs pat_complete_ebrs*/
	value standard3_yesno
		1 = "Yes"
		2 = "No"
		3 = "Refused"
		8 = "Not Applicable"
		9 = "Unknown"
	;
/*Used for the following variables: includes the files from 2009 with the same name + _ebrs
							mrf_none mrf_prediab mrf_gestdiab mrf_hypert mrf_hypertchr mrf_hypergest mrf_eclampsia mrf_prevpreterm mrf_poorout mrf_inftreat mrf_infdrugs 
							mrf_assistrep mrf_prevces mrf_anemia mrf_cardiac mrf_lungdis mrf_hydra mrf_hemoglob mrf_incompcerv mrf_prev4000 mrf_renaldis mrf_rhsensit 
							mrf_utbleed mrf_oth inf_none inf_gonor inf_syph inf_chlam inf_hepbinf_hepc inf_hpv inf_hivaids inf_cmv inf_rubella inf_toxo inf_genherpes 
							inf_tuber inf_oth ob_none ob_cercl ob_toco ob_amnio ob_fetalmon ob_cephsucess ob_cephfail ob_ultrasnd ob_oth ol_none ol_prerom ol_preciplbr 
							ol_prolonglbr cld_none cld_induc cld_aug cld_nonvert cld_steroid cld_antibiotic cld_chorio cld_mecon cld_fetalintol cld_epi cld_febrile 
							cld_abrplac cld_placprev cld_bleed cld_seizures cld_dysfunc cld_cephpelv cld_cordpro cld_anesth cld_oth trial_lbr mm_none mm_trnsfusion 
							mm_perilac mm_ruputerus mm_hyster mm_icu mm_unploper mm_unk ac_none ac_ventless ac_ventmore ac_nicu ac_surf ac_antisepis ac_seizures ac_anemia 
							ac_fas ac_hyaline ac_mecon ac_bthinjury ac_oth acn_none acn_anencep acn_spina acn_micro acn_nervous acn_hrtdis acn_hrtmal acn_circ acn_omphal 
							acn_gastrosch acn_rectal acn_tracheo acn_gastro acn_limbred acn_cleftlip acn_cleftpalate acn_polydact acn_clubft acn_diaphhern acn_muscle 
							acn_malgen acn_renal acn_hypos acn_urogen acn_chromoth acn_othmom_white mom_black mom_amind mom_asian mom_asianoth mom_chinese mom_filipino 
							mom_japanese mom_korean mom_vietnamese mom_hawaiian mom_guam mom_samoan mom_pacisl mom_raceoth mom_raceunk mom_raceref mom_his mom_mex mom_pr 
							mom_cu mom_ethoth fa_white fa_black fa_amind fa_asian fa_asianoth fa_chinese fa_filipino fa_japanese fa_korean fa_vietnamese fa_hawaiian fa_guam 
							fa_samoan fa_pacisl fa_raceoth fa_raceunk fa_raceref fa_his fa_mex fa_pr fa_cu fa_ethoth*/
	value standard4_yesno
		1 =	'Yes'
		2 =	 'No'
	;
/*Used for the following variables: pdl pdd pre_bir*/
	value standard5_yesno
		0  = 'none'
		77 = 'blank'
		99 = 'unknown'
	;
/*Used for the following variables: mrf1 mrf2 mrf3 mrf4 mrf5 mrf1_mf mrf2_mf mrf3_mf mrf4_mf mrf5_mf*/
	value risk
		0  = 'None'
		1  = 'Anemia (Hct. <30/Hgb.<10)'
		2  = 'Cardiac Disease'
		3  = 'Acute or Chronic Lung Disease'
		4  = 'Diabetes'
		5  = 'Genital Herpes'
		6  = 'Hydramnios/Oligogydramnios'
		7  = 'Hemoglobinopathy'
		8  = 'Hypertension, Chronic'
		9  = 'Hypertension Pregnancy Associated'
		10 = 'Eclampsia'
		11 = 'Incompetent Cervix'
		12 = 'Previous Infant 4,000+ Gram'
		13 = 'Previous Preterm or Small for Gestational Age'
		14 = 'Renal Disease'
		15 = 'Rh Sensitization'
		16 = 'Uterine Bleeding'
		17 = 'Other'
		99 = 'Unknown'
	;
/*Used for the following variables: ob_pr1 ob_pr2 ob_pr3 ob_pr4 ob_pr5 ob_pr1_mf ob_pr2_mf ob_pr3_mf ob_pr4_mf ob_pr5_mf*/
	value ob_proc
		0  = 'None'
		1  = 'Amniocentesis'
		2  = 'Electronic Fetal Monitoring'
		3  = 'Induction of Labor'
		4  = 'Stimulation of Labor'
		5  = 'Tocolysis'
		6  = 'Ultrasound'
		7  = 'Other'
		99 = 'Unknown'
	;
/*Used for the following variables: cld1 cld2 cld3 cld4 cld5 cld1_mf cld2_mf cld3_mf cld4_mf cld5_mf*/
	value c_l_d
		0  = 'None'
		1  = 'Febrile (>100F or 38C)'
		2  = 'Meconuim, Moderate/Heavy'
		3  = 'Premature Rupture of Membrane (>12Hrs)'
		4  = 'Abruption Placenta'
		5  = 'Placenta Previa'
		6  = 'Other Excessive Bleeding'
		7  = 'Seizures During Labor'
		8  = 'Precipitous Labor (<3 Hrs)'
		9  = 'Prolonged Labor (>20 Hrs)'
		10 = 'Dysfunctional Labor'
		11 = 'Breech/Malpresentation'
		12 = 'Cephalopelvic Disproportion'
		13 = 'Cord Prolapse'
		14 = 'Anesthetic Complications'
		15 = 'Fetal Distress'
		16 = 'Other'
		99 = 'Unknown'
	;
/*Used for the following variables: met_del1 met_del2 met_del3 met_del4 met_del5 met_del1_mf met_del2_mf met_del3_mf met_del4_mf met_del5_mf*/
	value method
		1  = 'Vaginal'
		2  = 'Vaginal birth after Previous C-section'
		3  = 'C-Section'
		4  = 'Repeat C-Section'
		5  = 'Forceps'
		6  = 'Vacuum'
		99 = 'Unknown'
	;
	value presentation
		1 =	"Cephalic"
		2 = "Breech"      
		3 =	"Other"
	;
	/*Used for the following variable: bth_route*/
	value route
		1 =	"Vaginal/Spontaneous"
		2 =	"Vaginal/Forceps"
		3 =	"Vaginal/Vacuum"
		4 =	"Cesarean"
	;
/*Used for the following variables: acn1 acn2 acn3 acn4 acn5 acn1_mf acn2_mf acn3_mf acn4_mf acn5_mf*/
	value abnormal
		0 = 'None'
		1 = 'Anemia (<39/Hgb <13)'
		2 = 'Birth Injury'
		3 = 'Fetal Alcohol Syndrome'
		4 = 'Hyaline Membrane Disease/Rds'
		5 = 'Meconium Aspiration Syndrome'
		6 = 'Assisted Ventilation < 30 Min'
		7 = 'Assisted Ventilaion >= 30 Min'
		8 = 'Seizures'
		9 = 'Other'
		99 = 'Unknown'
	;
/*Used for the following variables: con_an1 con_an2 con_an3 con_an4 con_an5 con_an1_mf con_an2_mf con_an3_mf con_an4_mf con_an5_mf*/
	value congenital
		0  = 'None'
		1  = 'Anecephalus'
		2  = 'Spina Bifida/Meningocele'
		3  = 'Hydrocephalus'
		4  = 'Microcephalus'
		5  = 'Other Central Nervous System Anomalies'
		6  = 'Heart Malformation'
		7  = 'Other Circulatory/Respiratory Anomalies'
		8  = 'Rectal Atresia/Stenosis'
		9  = 'Tracheo-Esophageal Atresia'
		10 = 'Gastroschisis'
		11 = 'Other Gastrointestinal Anomalies'
		12 = 'Malformed Genitalia'
		13 = 'Renal Agenesis'
		14 = 'Other Urogenital Anomalies'
		15 = 'Cleft Lip/Palate'
		16 = 'Polydactyly/Syndactyly/adactyly'
		17 = 'Club Foot'
		18 = 'Diaphragmatic Hernia'
		19 = 'Other Musculoskeleletal/Integumental Anomalies'
		20 = 'Downs Syndrome'
		21 = 'Other Chromosomal Anomalies'
		22 = 'Other'
		99 = 'Unknown'
	;
/*Used for the following variables: acn_downs_ebrs acn_cdit_ebrs*/
	value karotype
		1 = 'Pending'
		2 = 'Confirmed'
		3 = 'No'
		9 = 'Unknown'
	;
/*Used for the following variables: cig_pck cig_pck_ebrs*/
	value cig_pck
		1 = 'Cigarettes'
		2 = 'Pack'
		8 = 'Not Applicable'
	;
	value bthwt_unit
		1 =	"Grams"
		2 =	"Pounds"
		9 = 'Unknown'
	;
	value bwt_grp
		1 = 'Normal Birth Weight (>=2,500g, <=8,000g)'
		2 = 'Low Birth Weight (>=1,500g, <2,500g)'
		3 = 'Very Low Birth Weight (<1.500g)'
		9 = 'Unknown'
	;
	value gest_grp
		1 = 'Under 20 Weeks'
		2 = 'Preterm (20 to 36 weeks)'
		3 = 'Term (37+ weeks)'
		9 = 'Unknown'
	;
/*Used for the following variables: pv_trims pv_trims_ebrs */
	value pv_trims
		0 = 'No Care'
		1 = 'First Trimester'
		2 = 'Second Trimester'
		3 = 'Third Trimester'
		4 = 'Had Care but Unknown Start Date'
		9 = 'Unknown'
	;
/*Used for the following variables: Kotelchuck Index: evindex indexsum*/
	value evindex
		0 = 'Data Missing/Unknown'
		1 = 'Inadequate' 
		2 = 'Intermediate'
		3 = 'Adequate'
		4 = 'Adequate Plus'
	;
/*Used for the following variables: No Prenatal Care Recieved*/
	value nopnc 
		1 = 'Not Recieved Care'
		2 = 'Received Care'
		3 = 'Data Missing/Unknown'
	;
/*Kessner Index*/	
	value kipca
		0 = 'No Care'
		1 = 'Adequate'
		2 = 'Intermediate'
		3 = 'Inadequate'
		9 = 'Unknown'
	;
/*Used for the following variables: mom_age1 fa_age1*/
	value age_groups
		1 = '10-14'
		2 = '15-17'
		3 = '18-19'
		4 = '20-24'
		5 = '25-29'
		6 = '30-34'
		7 = '35-39'
		8 = '40-44'
		9 = '45+'
		99 = 'Unknown'
	;
/*Used for the following variables: mom_ethn fa_ethn mom_ethn_mf fa_ethn_mf*/
	value ethnic
		0 = 'Non-Hispanic'
		1 = 'Mexican'
		2 = 'Puerto Rican'
		3 = 'Cuban'	
		4 = 'Central/south America'
		5 = 'Spanish'
		9 = 'Unknown'	
	;
/*Used for the following variables:mom_race fa_race mom_race_mf fa_race_mf*/
	value race
		0 = 'Other'
		1 = 'White'
		2 = 'Black'
		3 = 'Native American'	
		4 = 'Chinese'
		5 = 'Japanese'
		6 = 'Hawaiian'
		7 = 'Filipino'
		8 = 'Other Asian'
		9 = 'Unknown'
	;
/*Used for the following variables: momrace_nchsbrg farace_nchsbrg momrace_nchsbrg_ebrs farace_nchsbrg_ebrs*/
	VALUE bridge_race
		01 = 'White'								
		02 = 'Black'			
		03 = 'American Indian/Alaskan Native'
		04 = 'Asian Indian'
		05 = 'Chinese'			
		06 = 'Filipino'
		07 = 'Japanese'									
		08 = 'Korean'
		09 = 'Vietnamese'
		10 = 'Other Asian'
		11 = 'Native Hawaiian'		
		12 = 'Guamanian'
		13 = 'Samoan'
		14 = 'Other Pacific Islander'
		15 = 'Other'
		21 = 'Bridged White'							
		22 = 'Bridged Black'			
		23 = 'Bridged American Indian/Alaskan Native'
		24 = 'Bridged Asian or Pacific Islander'
		99 = 'Unknown'
	;
/*Used for the following variables: momhisp_nchs fahisp_nchs momhisp_nchs_ebrs fahisp_nchs_ebrs*/
	value hisp_nchs
		100 = 'Non-Hispanic'
		200 = 'Spaniard'
		201 = 'Andalusian'
		202 = 'Austurian'
		203 = 'Castillian'
		204 = 'Catalonian'
		205 = 'Balearic Islander'
		206 = 'Gallego'
		207 = 'Valencian'
		208 = 'Canarian'					
		209 = 'Spanish Basque'
		210 = 'Mexican'
		211 = 'Mexican Checkbox'
		212 = 'Mexican American'
		213 = 'Mexicano'
		214 = 'Chicano'
		215 = 'La Raza'
		216 = 'Mexican American Indian'
		217 = 'Caribbean'
		218 = 'Mexico'
		220 = 'Central and South American'
		221 = 'Costa Rican'
		222 = 'Guatemalan'
		223 = 'Honduran'
		224 = 'Nicaraguan'
		225 = 'Panamanian'
		226 = 'Salvadoran'
		227 = 'Central American'
		228 = 'Central American Indian'
		229 = 'Canal Zone'
		231 = 'Argentinean'
		232 = 'Bolivian'
		233 = 'Chilean'
		234 = 'Columbian'
		235 = 'Ecuadorian'
		236 = 'Paraguayan'
		237 = 'Peruvian'
		238 = 'Uruguayan'
		239 = 'Venezuelan'
		240 = 'South American Indian'
		241 = 'Criollo'
		243 = 'South American'
		250 = 'Latin American'
		251 = 'Latin'
		252 = 'Latino'
		260 = 'Puerto Rican Checkbox'
		261 = 'Puerto Rican'
		270 = 'Cuban Checkbox'
		271 = 'Cuban'
		275 = 'Dominican'
		280 = 'Other Spanish Checkbox'	
		281 = 'Hispanic'
		282 = 'Spanish'
		283 = 'Californio'
		284 = 'Tejano'
		285 = 'Nuevo Mexicano'
		286 = 'Spanish American'
		287 = 'Spanish American Indian'
		288 = 'Meso American Indian'
		289 = 'Mestizo'
		291 = 'Multiple Hispanic Responses'
		299 = 'Other Spanish'
		996 = 'Uncodable'
		997 = 'Deferred'
		998 = 'Unknown'
		999 = 'First Pass Reject'
	;
/*Used for the following variables: mom_ethnic_nchs fa_ethnic_nchs mom_ethnic_nchs_ebrs fa_ethnic_nchs_ebrs*/
	VALUE ethnic_nchs
		0 = 'Non-Hispanic'
		1 = 'Spaniard'
		2 = 'Mexican'
		3 = 'Central South American'
		4 = 'Latin American'
		5 = 'Puerto Rican'
		6 = 'Cuban'
		7 = 'Dominican'
		8 = 'Other Spanish/Hispanic'
		9 = 'Unknown'
	;
/*Used for the following variables: 
				mom_r_e fa_r_e							momrace_ethnchs							farace_ethnchs 
				momrace_ethnchs_ebrs 					farace_ethnchs_ebrs 					mom_r_e_mf 
				fa_r_e_mf 								mom_racethnic 							fa_racethnic*/
	value race_ethnic
		1 = 'White'
		2 = 'Black'
		3 = 'Native American'
		4 = 'Asian'
		5 = 'Hispanic'
		8 = 'Other'
		9 = 'Unknown'
	;
/*Used for the following variables: source_pay source_pay_ebrs */
	value source_pay
		1 = 'Medicaid'
		2 = 'Private Insurance'
		3 = 'Self-Pay'
		4 = 'Indian Health Service'
		5 = 'Campus/Tricare'
		6 = 'Other Government (Federal, State, Local)'
		8 = 'Other'
		9 = 'Unknown'

	;
/*Notes:
lm_date, lm_mo lm_day lm_yr=last menses
prv_term=previous termination number
live_bthdead=previous live brths now dead
mrf=medical risk factors
ob_=obstetric procedures
cld_=complications of labor
bth_route=final route of delivery
mm_=maternal complications
ac_=abnormal conditions
acn_=anomalies



/*/*Based of the 1990 Occupation and Industry coding for the following:mom_occ mom_occup1 mom_bus mom_busines1  */
/*fa_occ fa_occup1 fa_bus fa_busines1 mom_occup1_ebrs mom_bus_ebrs mom_busines1_ebrs fa_occ_ebrs fa_occup1_ebrs fa_bus_ebrs fa_busines1_ebrs*/*/
/*	value occup */
/*		7  = "Financial managers"									14 = "Administrators, education and related fields"	*/
/*		15 = "Mangers, medicine and health "						17 = "Managers, food serving and lodging establishments"	*/
/*		18 = "Managers, properties and real estate"					19 = "Funeral directors"	*/
/*		22 = "Managers and administrators, n.e.c."					23 = "Accountants and auditors"	*/
/*		53 = "Civil, Engineers"										84 = "Physicians"	*/
/*		85 = "Dentists"												86 = "Veterinarians"	*/
/*		95 = "Registered nurses"									97 = "Dietitians"	*/
/*		154 = "Postseconday teachers, subject not specified"		156 = "Teachers, elementary school"	*/
/*		157 = "Teachers, secondary school"							164 = "Librarians"	*/
/*		176 = "Clergy"												178 = "Lawyers"	*/
/*		207 = "Licensed practical nurses"							213 = "Electrical and electronic technicians"	*/
/*		229 = "Computer programmers"								243 = "Supervisors and proprietors, sales occupations"	*/
/*		253 = "Insurance sales occupations"							254 = "Real estate sales occupations"	*/
/*		263 = "Sales workers, motor vehicles and boats"				264 = "Sales workers, apparel"	*/
/*		276 = "Cashiers"											277 = "Street and door-to door sales workers"	*/
/*		308 = "Computer operators"									313 = "Secretaries"	*/
/*		319 = "Receptionists"										348 = "Telephone operators"	*/
/*		354 = "Postal clerk, exc. Mail carriers"					355 = "Mail carries, postal srvc."	*/
/*		364 = "Traffic, shipping, and receiving clerks"				379 = "General office clerks"	*/
/*		383 = "Bank Tellers"										387 = "Teacher's aides"	*/
/*		417 = "Firefighting occupations"							418 = "Police and detectives, public service"	*/
/*		423 = "Sheriffs, bailiffs, and other law enforcement"		424 = "Correctional institution officers"	*/
/*		433 = "Supervisors, food preparation, service occupations"	435 = "Waiters and waitresses"	*/
/*		436 = "Cooks, private household"							446 = "Health aides, except nursing"	*/
/*		447 = "Nursing aides, orderlies,and attendants"				453 = "Janitors and cleaners"	*/
/*		457 = "Barbers"												458 = "Hairdressers and cosmetologists"	*/
/*		466 = "Family child care providers"							467 = "Early childhood teacher's assistants"	*/
/*		468 = "Child care workers, n.e.c."							473 = "Farmers, exc. Horticultural"	*/
/*		479 = "Farm workers"										486 = "Groundskeepers and gardeners, except farm"	*/
/*		505 = "Automobile mechanics"								507 = "Bus, truck, and stationary engine mechanics"	*/
/*		514 = "Automobile body and related repairers"				563 = "Brickmasons and stonemasons"	*/
/*		567 = "Carpenters"											575 = "Electricians"	*/
/*		579 = "Painters, construction and maintenance"				585 = "Plumbers, pipefitters, and steamfitters"	*/
/*		686 = "Butchers and meat cutters"							748 = "Laundering and dry cleaning machine operators"	*/
/*		783 = "Welders and cutters"									804 = "Truck drivers"	*/
/*		823 = "Railroad conductors and yardmasters"					824 = "Locomotive operating occupations"	*/
/*		869 = "Construction laborers"								888 = "Hand packers and packagers"	*/
/*		889 = "Laborers, except construction"						914 = "Homemaker"	*/
/*		915 = "Student"												917 = "None"	*/
/*		990 = "Unknown"												991 = "Unknown"	*/
/*		999 = "Other/Unknown"*/
/*	;*/
/*	value occ*/
/*		1 =	'Executive, Administrative, and Managerial'*/
/*		2 =	'Professional Specialty'*/
/*		3 =	'Technicians and Related Support'*/
/*		4 =	'Sales'*/
/*		5 =	'Administrative Support'*/
/*		6 =	'Service, Private Household'*/
/*		7 =	'Service, Protective Service'*/
/*		8 =	'Service, Rather than Private Hsehold & Protective Service'*/
/*		9 =	'Farming, Forestry and Fishing'*/
/*		10 = 'Precision Production, Craft and Repair'*/
/*		11 = 'Machine Operators, Assemblers and Inspectors'*/
/*		12 = 'Transportation and Material Moving'*/
/*		13 = 'Handers, Equipment Cleaners, Helpers and Laborers'*/
/*		14 = 'Military'*/
/*		15 = 'Experienced Unemployed, not classified'*/
/*		16 = 'Retired'*/
/*		17 = 'Homemaker'*/
/*		18 = 'Student'*/
/*		19 = 'None'*/
/*		99 = 'Unknown'*/
/*	;*/
/*	value business*/
/*		10 = "Agricultural production, crops"										11 = "Agricultural production, livestock"	*/
/*		60 = "Construction"															100 = "Manufacturing, Meat products"	*/
/*		110 = "Manufacturing, Grain mill products"									171 = "Manufacturing, Newspaper publishing and printing"	*/
/*		172 = "Manufacturing, Newspaper publishing and allied industries"			392 = "Manufacturing, Not specified Manufacturing, industries"	*/
/*		400 = "Railroads"															410 = "Trucking service"	*/
/*		412 = "U.S. postal services"												441 = "Telephone communications"	*/
/*		450 = "Electric light and power"											551 = "Wholesale trade, Farm-product raw materials"	*/
/*		580 = "Retail trade, Lumber and building material retailing"				591 = "Retail trade, Department stores"	*/
/*		601 = "Retail trade, Grocery stores"										612 = "Retail trade, Motor vehicle dealers"	*/
/*		621 = "Retail trade, Gasoline service stations"								623 = "Retail trade, Apparel and accessory stores, except shoe"	*/
/*		631 = "Retail trade, Furniture and home furnishings stores"					641 = "Retail trade, Eating and drinking places"	*/
/*		642 = "Retail trade, Drug stores"											700 = "Banking"	*/
/*		702 = "Credit agencies, n.e.c."												711 = "Insurance"	*/
/*		712 = "Real estate, including real estate-insurance offices"				732 = "Computer and data processing services"	*/
/*		751 = "Automotive repair and related services"								761 = "Private households"	*/
/*		762 = "Hotels and motels"													771 = "Laundry, cleaning and garment services"	*/
/*		772 = "Beauty shops"														780 = "Barber shops"	*/
/*		810 = "Misc. entertainment and recreation services"							812 = "Offices and clinics od physicians"	*/
/*		831 = "Hospitals"															832 = "Nursing and personal care facilities"	*/
/*		841 = "Legal services"														842 = "Elementary and secondary schools"	*/
/*		850 = "College and universities"											862 = "Child day care services"	*/
/*		863 = "Family child care homes"												880 = "Religious organizations, n.e.c."	*/
/*		890 = "Accounting, auditing, and bookkeeping services"						910 = "Justice, public order, and safety"	*/
/*		961 = "None"																990 = "Other/Unknown"*/
/*	;*/
/*	value industy*/
/*		1 =	'Agriculture, Forestry and Fisheries'*/
/*		2 =	'Mining'*/
/*		3 =	'Construction'*/
/*		4 =	'Manufacturing'*/
/*		5 =	'Transportation, Communications and Other Public Utilities'*/
/*		6 =	'Wholesale Trade'*/
/*		7 =	'Retail Trade'*/
/*		8 =	'Finance, Insurance and Real Estate'*/
/*		9 =	'Business and Repair Services'*/
/*		10 = 'Personal Services'*/
/*		11 = 'Entertainment and Recreation Services'*/
/*		12 = 'Professional and Related Services'*/
/*		13 = 'Public Administration'*/
/*		14 = 'None'*/
/*		16 = 'Unknown'*/
/*	;*/

run;



