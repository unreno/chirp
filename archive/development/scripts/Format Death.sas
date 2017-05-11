
/*Format for values Death*/

proc format;
	value sex
		1 = 'Male'
		2 = 'Female'
		9 = 'Unknown'
	;

/*Used for the following variables: death_st, res_st birth_st */
	value state
		1 = 'AL'
		2 = 'AK'
		3 = 'AZ'
		4 = 'AR'
		5 = 'CA'
		6 = 'CO'
		7 = 'CT'
		8 = 'DE'
		9 = 'DC'
		10 = 'FL'
		11 = 'GA'
		12 = 'HI'	
		13 = 'ID'
		14 = 'IL'
		15 = 'IN'
		16 = 'IA'
		17 = 'KS'
		18 = 'KY'
		19 = 'LA'	
		20 = 'ME'
		21 = 'MD'
		22 = 'MA'
		23 = 'MI'
		24 = 'MN'
		25 = 'MS'
		26 = 'MO'
		27 = 'MT'
		28 = 'NE'
		29 = 'NV'
		30 = 'NH'
		31 = 'NJ'
		32 = 'NM'
		33 = 'NY'
		34 = 'NC'
		35 = 'ND'
		36 = 'OH'
		37 = 'OK'
		38 = 'OR'
		39 = 'PA'
		40 = 'RI'
		41 = 'SC'
		42 = 'SD'
		43 = 'TN'
		44 = 'TX'
		45 = 'UT'
		46 = 'VT'
		47 = 'VA'
		48 = 'WA'
		49 = 'WV'
		50 = 'WI'
		51 = 'WY'
		52 = 'PR'
		53 = 'VI'
		54 = 'GU'
		55 = 'Canada'
		56 = 'Cuba'
		57 = 'Mexico'
		59 = 'Remainder of the World'
		60 = 'United States'
		99 = 'Unknown'
	;
/*Used for the following variables: death_ci, res_ci */
	value city
		1 = 'Carson City'
		2 = 'Henderson'
		3 = 'Las Vegas'
		4 = 'North Las Vegas'
		5 = 'Reno'
		6 = 'Sparks'
		11 = 'Austin'
		17 = 'Battle Mountain'
		23 = 'Boulder City'
		25 = 'Caliente'
		31 = 'Dayton'
		48 = 'Dresslerville'
		49 = 'Duckwater'
		55 = 'Elko'
		56 = 'Ely'
		58 = 'Eureka'
		59 = 'Fallon'
		60 = 'Fernley'
		63 = 'Gardnerville'
		72 = 'Goldfield'
		75 = 'Hawthorne'
		80 = 'Incline Village'
		82 = 'Ione (Yomba)'
		95 = 'Lee'
		101 = 'Lovelock'
		107 = 'McDermitt'
		108 = 'McGill'
		113 = 'Minden'
		115 = 'Moapa'
		122 = 'Nixon'
		131 = 'Owyhee'
		135 = 'Pahrump'
		137 = 'Pioche'
		144 = 'Ruby Valley'
		147 = 'Schurz'
		160 = 'Stateline'
		162 = 'Stewart'
		170 = 'Tippett'
		171 = 'Tonopah'
		177 = 'Virginia City'
		187 = 'Wells'
		191 = 'Winnemucca'
		192 = 'Yerington'
		193 = 'Zephyr Cove'
		700 = 'Other Carson City Towns'
		701 = 'Other Churchill Towns'
		702 = 'Other Clark Towns'
		703 = 'Other Douglas Towns'
		704 = 'Other Elko Towns'
		705 = 'Other Esmeralda Towns'
		706 = 'Other Eureka Towns'
		707 = 'Other Humboldt Towns'
		708 = 'Other Lander Towns'
		709 = 'Other Lincoln Towns'
		710 = 'Other Lyon Towns'
		711 = 'Other Mineral Towns'
		712 = 'Other Nye Towns'
		713 = 'Other Pershing Towns'
		714 = 'Other Storey Towns'
		715 = 'Other Washoe Towns'
		716 = 'Other White Pine Towns'
		888 = 'Out of State'
		999 = 'Unknown'
	;
/*Used for the following variables: death_co, res_co*/
	value county
		1 = 'Carson City'
		2 = 'Churchill'
		3 = 'Clark'
		4 = 'Douglas'
		5 = 'Elko'
		6 = 'Esmeralda'
		7 = 'Eureka'
		8 = 'Humboldt'
		9 = 'Lander'
		10 = 'Lincoln'
		11 = 'Lyon'
		12 = 'Mineral'
		13 = 'Nye'
		14 = 'Pershing'
		15 = 'Storey'
		16 = 'Washoe'
		17 = 'White Pine'
		88 = 'Out of State'
		99 = 'Unknown'
	;

 /*Race and Ethnicity Used for file from 1975-2007*/
	value race
		0 = 'Other' 
		1 = 'White' 
		2 = 'Black' 
		3 = 'Native American' 
		4 = 'Chinese' 
		5 = 'Japanese' 
		6 = 'Hawaiian' 
		7 = 'Flipino' 
		8 = 'Other Asian' 
		9 = 'Unknown' 
	;
	value ethnic
		0 = 'Non-Hispanic' 
		1 = 'Mexican' 
		2 = 'Puerto Rican' 
		3 = 'Cuban' 
		4 = 'Central/South America' 
		5 = 'Spanish' 
		9 = 'Unknown' 
	;
/*Used for the following variables: race_nchsbrg (for certificate years 2008-current - had a new system for collection in 2008) */
	value race_nchsbrg
		1  = 'White'
		2  = 'Black'
		3  = 'American Indian/Alaskan Native'
		4  = 'Asian Indian'
		5  = 'Chinese'
		6  = 'Filipino'
		7  = 'Japanese'
		8  = 'Korean'
		9  = 'Vietnamese'
		10  = 'Other Asian'
		11  = 'Native Hawaiian'
		12  = 'Guamanian'
		13  = 'Samoan'
		14  = 'Other Pacific Islander'
		15  = 'Other'
		21  = 'Bridged White'
		22  = 'Bridged Black'
		23  = 'Bridged American Indian/Alaskan Native'
		24  = 'Bridged Asian or Pacilic Islander'
		99  = 'Unknown'
	;

/*Used for the following variables: ethnicnchs (for certificate year 2008-current - had a new system for collection in 2008) */
	value ethnicnchs
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
/*Used for the following variables: hisp_nchs (for certificate year 2008-current - had a new system for collection in 2008) */
	Value hisp_nchs
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
/*Used for the following variables: race_eth (combined race and ethnicity for both data collections types) all years*/
	value race_eth
		1 = 'White'
		2 = 'Black'
		3 = 'Native American'
		4 = 'Asian'
		5 = 'Hispanic'
		8 = 'Other'
		9 = 'Unknown'
	;
/*Used for the following variables: Place of Death */
	value doa_inpa
		1 = 'Inpatient (Hospital, Clinic, Medical Center)'
		2 = 'Out-Patient, ER or Trauma Center'
		3 = 'DOA (dead on Arrival)'
		5 = 'Nursing Homes, Convalescent Centers, and Other Patient Care'
		6 = 'Home'
		7 = 'All Other Reported Entries/Not Classifable'
		9 = 'Unknown'
	;
/*Used for the following variables: Facility of Death */
	value instit
		3 = "Home"
		4 = "Other"
		5 = "Enroute" 
		9 = "Unknown"
		101 = "Carson Tahoe Regional Medical Center"
		103 = "Sierra Surgery Hospital"
		104 = "Continuecare Hospital of Carson Tahoe, Inc."
		105 = "Carson Tahoe Specialty Medical Center"
		201 = "Banner Churchill Community Hospital"
		301 = "Boulder City Hospital"
		302 = "Desert Springs Hospital"
		304 = "North Vista Hospital"
		306 = "St. Rose Dominican De Lima Campus"
		307 = "University Medical Center"
		308 = "Sunrise Hospital Medical Center"
		309 = "Valley Hospital Medical Center"
		311 = "Mike O'Callaghan Federal Hospital"
		314 = "Montevista Hospital"
		316 = "Horizon Specialty Center Las Vegas"
		317 = "Healthsouth Rehab of Las Vegas"
		318 = "Kindred Hospital Las Vegas"
		319 = "Mountain View Hospital"
		320 = "Odyssey Harbor House"
		321 = "Summerlin Hospital Medical Center"
		322 = "St. Rose Dominican Siena Campus"
		323 = "Spring Valley Hospital Medical Center"
		324 = "Southern Hills Medical Center"
		325 = "Mesa View Regional Hospital"
		326 = "Desert View Regional Medical Center"
		327 = "Red Rock Behavioral Hospital"
		328 = "Westcare Mental Health Crisis Unit"
		329 = "Progressive Hospital"
		330 = "St. Rose Dominican San Martin Campus"
		331 = "Centennial Hills Hospital Medical Center"
		332 = "Southern Nevada Adult Mental Health Services"
		333 = "Springs Mountain Treatment Center"
		334 = "Kindred Hospital LV at Desert Springs Hospital"
		335 = "Kindred Hospital Las Vegas Flamingo Campus"
		336 = "Healthsouth Rehab of Henderson"
		337 = "Desert Willow Treatment Center"
		338 = "Desert Canyon Rehabilitation Hospital"
		339 = "Seven Hills Behavioral Institute"
		340 = "Spring Mountain Sahara"
		341 = "Harmon Medical & Rehab Hospital"
		342 = "UMC Rancho Rehabilitation Center"
		501 = "Northeastern Nevada Regional Health"
		801 = "Humboldt General Hospital"
		901 = "Battle Mountain General Hospital"
		1001 = "Grover C Dils Medical Center"
		1101 = "South Lyon Medical CenterF"
		1102 = "Carson Valley Meidcal Center"
		1201 = "Mount Grant General Hospital"
		1301 = "Nye Regional Medical Center"
		1302 = "Pahrump Family Medical Center"
		1401 = "Pershing General Hospital"
		1602 = "St. Mary's Regional Medical Center"
		1603 = "Renown Regional Medical Center"
		1604 = "Veteran's Hospital"
		1606 = "Northern Nevada Medical Center"
		1607 = "Renown Medical Center Rehab Hospital"
		1609 = "BHC Westhills Hospital"
		1610 = "Tahoe Pacific Hospital Meadows"
		1612 = "Willow Springs Center"
		1613 = "Renown South Meadows Medical Center"
		1614 = "Tahoe Pacific Hospital West"
		1615 = "Incline Village Medical Center"
		1616 = "Lake's Crossing Center"
		1617 = "Dini Townsend Hospital at NNAMHS"
		1701 = "William B Ririe Hospital"
		2001 = "Licensed Skilled Nursing Facilities"
		2002 = "Licensed Intermediate Care Facilities"
		2003 = "Licensed Group Care Facilities"
		2004 = "Licensed Alcohol/Drug Treatment"
		2005 = "Licensed Child Care Facilities"
		2006 = "Miscellaneous Licensed Facilities"
		2007 = "All Licensed Out of State Facilities"
	;
	value age_unit
		0 = 'Years Less than 100'
		1 = 'Years 100 or More'
		2 = 'Months'
		3 = 'Weeks'
		4 = 'Days'
		5 = 'Hours'
		6 = 'Minutes'
		9 = 'Unknown'
	;
	value age1_groups
		1 = '<1'
		2 =	'1-4'
		3 = '5-14'
		4 = '15-24'
		5 = '25-34'
		6 = '35-44'
		7 = '45-54'
		8 = '55-64'
		9 = '65-74'
		10 = '75-84'
		11 = '85+'
		99 = 'Unknown'
	;
	value age2_groups
		1 = '<10'
		2 =	'10-19'
		3 = '20-29'
		4 = '30-39'
		5 = '40-49'
		6 = '50-59'
		7 = '60-69'
		8 = '70-79'
		9 = '80-89'
		10 = '90+'
		99 = 'Unknown'
	;
	value age3_groups
		1 = '<1'
		2 =	'1-4'
		3 = '5-9'
		4 = '10-14'
		5 = '15-19'
		6 = '20-24'
		7= '25-29'
		8= '30-34'
		9 = '35-39'
		10= '40-44'
		11= '45-49'
		12= '50-54'
		13= '55-59'
		14= '60-64'
		15= '65-69'
		16 = '70-74'
		17= '75-79'
		18= '80-84'
		19= '85-89'
		99 = 'Unknown'
	;
	value age4_groups
		1 = 'Neonatal(<28 days)'
		2 =	'Postneonatal (Between 28 and 365 days)'
		9 = 'Unknown'
	;
	value age5_groups
		1 = 'Perinatal (Under 7 days)'
		2 =	'Postperinatal (Between 7 and 365 days)'
		9 = 'Unknown'
	;

	value icd1_grp	
		1  = 'Salmonella infections'                  
		2  = 'Shigellosis and amebiasis'
		3  = 'Certain other intestinal infections'
		4  = 'Tuberculosis'
		5  = 'Whooping cough' 
		6  = 'Scarlet fever and erysipelas'
		7  = 'Meningococcal infection'            
		8  = 'Septicemia'
		9  = 'Syphilis'                             
		10 = 'Acute poliomyelitis'
		11 = 'Arthropod-borne viral encephalitis'
		12 = 'Measles'
		13 = 'Viral hepatitis'
		14 = 'HIV'
		15 = 'Malaria'
		16 = 'Other infectious and parasitic diseases'
		17 = 'Malignant neoplasms'
		18 = 'Benign neoplasms'
		19 = 'Anemias'
		20 = 'Diabetes mellitus'
		21 = 'Nutritional deficiencies'
		22 = 'Meningitis'
		23 = 'Parkinsons disease'
		24 = 'Alzheimers disease'
		25 = 'Diseases of heart'
		26 = 'Essential Hypertensive Renal Disease'
		27 = 'Cerebrovascular diseases'
		28 = 'Atherosclerosis'
		29 = 'Other diseases of circulatory system'
		30 = 'Other disorders of cirulatory system'
		31 = 'Influenza and pneumonia'
		32 = 'Other acute lower respiratory infections'
		33 = 'Chronic lower respiratory diseases'
		34 = 'Pneumoconioses and chemical effects'
		35 = 'Pneumonitis due to solids and liquids'
		36 = 'Other diseases of respiratory system'
		37 = 'Peptic ulcer'
		38 = 'Diseases of appendix'
		39 = 'Hernia'
		40 = 'Chronic liver disease and cirrhosis'
		41 = 'Cholelithiasis and other disorders of gallbladder'
		42 = 'Nephritis, nephrotic syndrome and nephrosis'
		43 = 'Infections of kidney'
		44 = 'Hyperplasia of prostate'
		45 = 'Inflammatory diseases of female pelvic organs'
		46 = 'Pregnancy, childbirth and the puerperium'
		47 = 'Perinatal period conditions'
		48 = 'Congenital malformations abnormalities'
		49 = 'Symptoms, signs, not elsewhere classified'
		50 = 'Transport accidents'
		51 = 'Nontransport accidents'
		52 = 'Intentional self-harm (suicide)'
		53 = 'Assault (homicide)'
		54 = 'Legal intervention' 
		55 = 'Events of undetermined intent'
		56 = 'Operations of war and their sequelae'
		57 = 'Complications of medical/surgical care'
		99 = 'All other diseases (residual)'
		999 = 'System Missing or Undefined'
	;
	value icd2_grp
		1 = 'Diseases of the Heart'
		2 = 'Malignant Neoplasms (Cancer)'
		3 = 'Cerebrovascular Diseases (Stroke)'
		4 = 'Chronic Lower Respiratory Diseases'
		5 = 'Accidents'                    
		6 = 'Influenza and Pneumonia'
		7 = 'Diabetes Mellitus'
		8 = 'Essential Hypertensive Renal Disease' /*HIV-Aids in 1975-2004*/
		9 = 'Intentional Self-harm (Suicide)'
		10 = 'Chronic Liver Disease and Cirrhosis'
		11 = 'Nephritis, Nephrotic Syndrome and Nephrosis'
		12 = 'Septicemia'
		13 = 'Alzheimers Disease'
		14 = 'Assault (Homicide) & Legal Intervention'
		15 = 'Atherosclerosis'
		16 = 'All Others'
		99 = 'Unknown'
	;
	value icd3_grp
		1 = 'Lip, Oral Cavity and Pharynx'
		2 = 'Esophagus'
		3 = 'Stomach'
		4 = 'Colon, Rectum and Anus'
		5 = 'Liver and Intrahepatic Bile Ducts'
		6 = 'Pancreas'
		7 = 'Larynx'
		8 = 'Trachea, Bronchus and Lung'
		9 = 'Skin'                             
		10 = 'Breast'
		11 = 'Cervix Uteri'
		12 = 'Corpus Uteri and Uterus, Part Unspecified'
		13 = 'Ovary'
		14 = 'Prostate'
		15 = 'Kidney and Renal Pelvis'      
		16 = 'Bladder'
		17 = 'Brain and Other Central Nervous System'
		18 = 'Hodgkins Disease'
		19 = 'Non-Hodgkins Lymphoma'       
		20 = 'Leukemia'
		21 = 'Multiple Myeloma and Immunoproliferative Neoplasms'
		22 = 'Other of Lymphoid and Related Tissue'
		23 = 'Other and Unspecified Cancers'
	;
	value icd4_grp
		 1 ='Motor Vehicle Accidents'
		 2 =	'Other Land Transport Accidents'
		 3 =	'Water, Air and Space, and Other Transport Accidents'
		 4 =	'Falls'
		 5 =	'Firearms'
		 6 =	'Drowning and Submersion'
		 7 =	'Smoke, Fire and Flames'
		 8 =	'Poisoning'
		 9 =	'Other Nontransport Accidents' 
 	;	
	value icd5_grp
		1 =	'Acute Rheumatic fever & Chronic Rheumatic HD'
		2 =	'Hypertensive Heart Disease'
		3 =	'Hypertensive Heart & Renal Disease'
		4 =	'Ischemic Heart Disease'
		5 =	'Other Heart Diseases'
		6 = 'Essential Hypertension & Hypertensive Renal Disease'
		7 =	'Cerebrovascular Diseases'
		8 =	'Atherosclerosis'
		9 =	'Aortic Aneurysm and Dissection'
		10 = 'Other Diseases of Arteries, Arterioles and Capillaries'
		11 = 'Other Disorders of Circulatory System'
	;
	value icd6_grp
		1 =	'Poisoning by Solid, Liquid or Gaseous Substances'                   
		2 =	'Hanging/ Strangulation/ Suffocation'
		3 =	'Drowning/ Submersion'     
		4 =	'Firearms/ Explosives'
		5 =	'Cutting/ Stabbing'                          
		6 =	'Jumped from Height'
		7 =	'Others'
	;
	value icd7_grp
		1 =	"Pedestrian"	
		2 =	"Pedal cyclist"	
		3 =	"Motorcyclist"	
		4 =	"Motor Vehicle Occupant"	
		5 =	"Animal-Rider or Animal-Drawn Vehicle"	
		6 =	"Train or Railway Vehicle"	
		7 =	"Streetcar or Cablecar"	
		8 =	"Industrial, Agriculture & Construction Vehicle"	
		9 =	"Watercraft Accidents"	
		10 = "Aircraft & Spacecraft Accidents"	
		11 = "Sequelae of Accidents"	
		99 = "Other/Unknown Mode of Transportation"
	;
/*Infant Mortality Groupings */
	value inf1_grp
		1 =	"Newborn - incompetent cervix"
		2 =	"Newborn - premature rupture of membranes" 	
		3 =	"Newborn - multiple pregnancy" 	
		4 =	"Newborn - other maternal complications of pregnancy"	
		5 =	"Newborn - complications involving placenta" 	
		6 =	"Newborn - complications involving cord" 	
		7 =	"Newborn - chorioamnionitis"	
		8 =	"Newborn - other & unspec abnormality of membranes"	
		9 =	"Extremely low birth weight or extreme immaturity" 	
		10 = "Other low birth weight or preterm" 	
		11 = "Motor vehicle accidents" 	
		12 = "Other and unspecified transport accidents"
	;	
	value inf2_grp
		1 =	"Acute poliomyelitis"	
		2 =	"Varicella (chickenpox)"	
		3 =	"Measles"	
		4 =	"Human immunodeficiency virus (HIV) disease"	
		5 =	"Mumps"	
		6 =	"Other and unspecified viral diseases"	
		7 =	"Hodgkin's disease and non-Hodgkin's lymphomas"	
		8 =	"Leukemia"	
		9 =	"Other and unspecified malignant neoplasms"	
		10 = "Influenza"	
		11 = "Pneumonia"	
		12 = "Newborn - maternal hypertensive disorders"	
		13 = "Newborn - other maternal may unrelated to present pregnancy"	
		14 = "Newborn - maternal complications of pregnancy"	
		15 = "Newborn - complications of placenta, cord & membranes"	
		16 = "Newborn - other complications of labor and delivery"	
		17 = "Newborn - noxious influences via placenta/breast milk"	
		18 = "Slow fetal growth and fetal malnutrition"	
		19 = "Disorders related to short gestation & low birth weight, NEC"	
		20 = "Disorders related to long gestation and high birth weight"	
		21 = "Intrauterine hypoxia"	
		22 = "Birth asphyxia"	
		23 = "Congenital pneumonia"	
		24 = "Neonatal aspiration syndromes"	
		25 = "Interstitial emphysema & related from perinatal period"	
		26 = "Pulmonary hemorrhage originating in the perinatal period"	
		27 = "Chronic respiratory disease from perinatal period"	
		28 = "Atelectasis"	
		29 = "All other respiratory conditions from perinatal period"	
		30 = "Bacterial sepsis of newborn"	
		31 = "Omphalitis of newborn with or without mild hemorrhage"	
		32 = "All other infections specific to the perinatal period"	
		33 = "Neonatal hemorrhage"	
		34 = "Hemorrhagic disease of newborn"	
		35 = "Hemolytic disease - isoimmunization/other perinatal jaundice"	
		36 = "Hematological disorders"	
		37 = "Transport accidents"	
		38 = "Falls"	
		39 = "Accidental discharge of firearms"	
		40 = "Accidental drowning and submersion"	
		41 = "Accidental suffocation and strangulation in bed"	
		42 = "Other accidental suffocation and strangulation"	
		43 = "Accidental choking on food or other objects"	
		44 = "Accidents caused by exposure to smoke, fire and flames"	
		45 = "Accidental poisoning and exposure to noxious substances"	
		46 = "Other and unspecified accidents"	
		47 = "Assault (homicide) by hanging, strangulation and suffocation"	
		48 = "Assault (homicide) by discharge of firearms"	
		49 = "Neglect, abandonment and other maltreatment syndromes"	
		50 = "Assault (homicide) by other and unspecified means"
	;
	value inf3_grp
		1 = "Certain intestinal infectious diseases"	
		2 =	"Diarrhea and gastroenteritis of infectious origin"	
		3 = "Tuberculosis"	
		4 =	"Tetanus"	
		5 =	"Diptheria"	
		6 =	"Whooping cough"	
		7 =	"Meningococcal infection"	
		8 =	"Septicemia"	
		9 =	"Congenital syphilis"	
		10 = "Gonococcal infection"	
		11 = "Viral diseases"	
		12 = "Candidiasis"	
		13 = "Malaria"	
		14 = "Pneumocystosis"	
		15 = "All other and unspecified infectious and parasitic diseases"	
		16 = "Malignant neoplasms"	
		17 = "In situ, benign & unknown behavior neoplasms"	
		18 = "Anemias"	
		19 = "Other diseases of blood and blood-forming organs"	
		20 = "Certain disorders involving the immune mechanism"	
		21=  "Short stature, not elsewhere classified"	
		22 = "Malnutrition and other nutritional deficiencies"	
		23 = "Cystic fibrosis"	
		24 = "Volume depletion & fluid, electrolyte, Ph balance disorders"	
		25 = "All other endocrine, nutritional and metabolic diseases"	
		26 = "Meningitis"	
		27 = "Infantile spinal muscular atrophy, type I (Werdnig-Hoffman)"	
		28 = "Infantile cerebral palsy"	
		29 = "Anoxic brain damage, not elsewhere classified"	
		30 = "Other diseases of nervous system"	
		31 = "Pulmonary heart disease & diseases of pulmonary circulation"	
		32 = "Pericarditis, endocarditis and myocarditis"	
		33 = "Cardiomyopathy"	
		34 = "Cardiac arrest"	
		35 = "Cerebrovascular diseases"	
		36 = "All other diseases of circulatory system"	
		37 = "Acute upper respiratory infections"	
		38 = "Influenza and pneumonia"	
		39 = "Acute bronchitis and acute bronchiolitis"	
		40 = "Bronchitis, chronic and unspecified"	
		41 = "Asthma"	
		42 = "Pneumonitis due to solids and liquids"	
		43 = "Other and unspecified diseases of respiratory system"	
		44 = "Gastritis, duodenitis, & noninfective enteritis & colitis"	
		45 = "Hernia of abdominal cavity/intestinal obstruction w/o hernia"	
		46 = "All other and unspecified diseases of digestive system"	
		47 = "Renal failure and other disorders of kidney"	
		48 = "Other and unspecified diseases of genitourinary system"	
		49 = "Newborn affected by maternal factors & complications of PLD"	
		50 = "Disorders related to gestation & fetal malnutrition"	
		51 = "Birth trauma"	
		52 = "Intrauterine hypoxia and birth asphyxia"	
		53 = "Respiratory distress of newborn"	
		54 = "Other respiratory conditions from perinatal period"	
		55 = "Infections specific to the perinatal period"	
		56 = "Hemorrhagic and hematological disorders of newborn"	
		57 = "Infant of a diabetic mother & neonatal diabetes mellitus"	
		58 = "Necrotizing enterocolitis of newborn"	
		59 = "Hydrops fetalis not due to hemolytic disease"	
		60 = "Other perinatal conditions"	
		61 = "Anencephaly and similar malformations"	
		62 = "Congenital hydrocephalus"	
		63 = "Spina bifida"	
		64 = "Other congenital malformations of nervous system"	
		65 = "Congenital malformations of heart"	
		66 = "Other congenital malformations of circulatory system"	
		67 = "Congenital malformations of respiratory system"	
		68 = "Congenital malformations of digestive system"	
		69 = "Congenital malformations of genitourinary system"	
		70 = "Congenital MS malformations deformations, limbs & integument"	
		71 = "Down's syndrome"	
		72 = "Edward's syndrome"	
		73 = "Patau's syndrome"	
		74 = "Other congenital malformations and deformations"	
		75 = "Other chromosomal abnormalities, not elsewhere classified"	
		76 = "Sudden infant death syndrome (SIDS)"	
		77 = "Other symptoms, signs & abnormal clinical/lab findings, NEC"	
		78 = "Accidents (unintentional injuries)"	
		79 = "Assault (homicide)"	
		80 = "Complications of medical and surgical care"	
		81 = "Other external causes"
	;
	value inf4_grp
		1 =	"Certain infectious and parasitic diseases"	
		2 =	"Neoplasms"	
		3 =	"Blood & related organ diseases/disorders to immune mechanism"	
		4 =	"Endocrine, nutritional and metabolic diseases"	
		5 =	"Diseases of the nervous system"	
		6 =	"Diseases of the ear and mastoid process"	
		7 =	"Diseases of the circulatory system"	
		8 =	"Diseases of the respiratory system"	
		9 =	"Diseases of the digestive system"	
		10 = "Diseases of the genitourinary system"	
		11 = "Certain conditions originating in the perinatal period"	
		12 = "Congenital mal-, de-, formations & chromosomal abnormalities"	
		13 = "Symptoms, signs and abnormal clinical/lab findings, NEC"
		14 = "All other diseases"	
		15 = "External causes of mortality"
	;
	value inf5_grp
		1 =	'Sudden Infant Death Syndrome (SIDS)'	
		2 =	'Motor vehicle accidents'	
		3 =	'Disorders related to gestation & fetal malnutrition'	
		4 =	'Diseases of the respiratory system'	
		5 =	'Congenital malformations of heart'	
		6 =	'Respiratory distress of newborn'	
		7 =	'Accidental drowning and submersion'	
		8 =	'Diseases of the nervous system'	
		9 = 'Assault (homicide)'	
		10 = 'Diseases of the circulatory system'	
		11 = 'Malignant neoplasms'	
		12 = 'Newborn affected by maternal factors & complications of PLD'	
		13 = 'Other symptoms, signs & abnormal clinical/lab findings, NEC'	
		14 = 'Other respiratory conditions from perinatal period'	
		15 = 'Diseases of the digestive system'
		16 = 'All Others'
	; 
/*Used for the following variables: military, */
	value standard1_yesno
		1 = 'Yes'
		2 = 'No'
		9 = 'Unknown'
	;
	value citizen
		1 = 'USA'
		2 = 'Canada'
		3 = 'Mexico'
		4 = 'Remainder of the World'
		9 = 'Unknown'
	;
	value marital
		1 = 'Married'
		2 = 'Never Married'
		3 = 'Widowed'
		4 = 'Divorced'
		9 = 'Unknown'
	;
	value edu
		1 = '8th Grade or less'
		2 = '9th through 12th Grade, no diploma'
		3 = 'High School Graduates or GED'
		4 = 'Some College, but no Degree'
		5 = 'Assoiciate Degree, AA, AS'
		6 = 'Bachleors Degree, BA, AB, BS'
		7 = 'Masters Degree, MA, MS'
		8 = 'Doctorate Degree, PHD, EDD, MD'
		9 = 'Unknown'
	;

/*Based of the 1990 Occupation and Industry coding for the following*/
	value occup 
		7  = "Financial managers"	
		14 = "Administrators, education and related fields"	
		15 = "Mangers, medicine and health "	
		17 = "Managers, food serving and lodging establishments"	
		18 = "Managers, properties and real estate"	
		19 = "Funeral directors"	
		22 = "Managers and administrators, n.e.c."	
		23 = "Accountants and auditors"	
		53 = "Civil, Engineers"	
		84 = "Physicians"	
		85 = "Dentists"	
		86 = "Veterinarians"	
		95 = "Registered nurses"	
		97 = "Dietitians"	
		154 = "Postseconday teachers, subject not specified"	
		156 = "Teachers, elementary school"	
		157 = "Teachers, secondary school"	
		164 = "Librarians"	
		176 = "Clergy"	
		178 = "Lawyers"	
		207 = "Licensed practical nurses"	
		213 = "Electrical and electronic technicians"	
		229 = "Computer programmers"	
		243 = "Supervisors and proprietors, sales occupations"	
		253 = "Insurance sales occupations"	
		254 = "Real estate sales occupations"	
		263 = "Sales workers, motor vehicles and boats"	
		264 = "Sales workers, apparel"	
		276 = "Cashiers"	
		277 = "Street and door-to door sales workers"	
		308 = "Computer operators"	
		313 = "Secretaries"	
		319 = "Receptionists"	
		348 = "Telephone operators"	
		354 = "Postal clerk, exc. Mail carriers"	
		355 = "Mail carries, postal srvc."	
		364 = "Traffic, shipping, and receiving clerks"	
		379 = "General office clerks"	
		383 = "Bank Tellers"	
		387 = "Teacher's aides"	
		417 = "Firefighting occupations"	
		418 = "Police and detectives, public service"	
		423 = "Sheriffs, bailiffs, and other law enforcement officers"	
		424 = "Correctional institution officers"	
		433 = "Supervisors, food preparation and service occupations"	
		435 = "Waiters and waitresses"	
		436 = "Cooks, private household"	
		446 = "Health aides, except nursing"	
		447 = "Nursing aides, orderlies,and attendants"	
		453 = "Janitors and cleaners"	
		457 = "Barbers"	
		458 = "Hairdressers and cosmetologists"	
		466 = "Family child care providers"	
		467 = "Early childhood teacher's assistants"	
		468 = "Child care workers, n.e.c."	
		473 = "Farmers, exc. Horticultural"	
		479 = "Farm workers"	
		486 = "Groundskeepers and gardeners, except farm"	
		505 = "Automobile mechanics"	
		507 = "Bus, truck, and stationary engine mechanics"	
		514 = "Automobile body and related repairers"	
		563 = "Brickmasons and stonemasons"	
		567 = "Carpenters"	
		575 = "Electricians"	
		579 = "Painters, construction and maintenance"	
		585 = "Plumbers, pipefitters, and steamfitters"	
		686 = "Butchers and meat cutters"	
		748 = "Laundering and dry cleaning machine operators"	
		783 = "Welders and cutters"		
		804 = "Truck drivers"	
		823 = "Railroad conductors and yardmasters"	
		824 = "Locomotive operating occupations"	
		869 = "Construction laborers"	
		888 = "Hand packers and packagers"	
		889 = "Laborers, except construction"	
		914 = "Homemaker"	
		915 = "Student"	
		917 = "None"	
		990 = "Unknown"	
		991 = "Unknown"	
		999 = "Other/Unknown"
	;
	value occ_grp
		1 =	'Executive, Administrative, and Managerial'
		2 =	'Professional Specialty'
		3 =	'Technicians and Related Support'
		4 =	'Sales'
		5 =	'Administrative Support'
		6 =	'Service, Private Household'
		7 =	'Service, Protective Service'
		8 =	'Service, Rather than Private Hsehold & Protective Service'
		9 =	'Farming, Forestry and Fishing'
		10 = 'Precision Production, Craft and Repair'
		11 = 'Machine Operators, Assemblers and Inspectors'
		12 = 'Transportation and Material Moving'
		13 = 'Handers, Equipment Cleaners, Helpers and Laborers'
		14 = 'Military'
		15 = 'Experienced Unemployed, not classified'
		16 = 'Retired'
		17 = 'Homemaker'
		18 = 'Student'
		19 = 'None'
		99 = 'Unknown'
	;
	value business
		10 = "Agricultural production, crops"	
		11 = "Agricultural production, livestock"	
		60 = "Construction"	
		100 = "Manufacturing, Meat products"	
		110 = "Manufacturing, Grain mill products"	
		171 = "Manufacturing, Newspaper publishing and printing"	
		172 = "Manufacturing, Newspaper publishing and allied industries"		
		392 = "Manufacturing, Not specified Manufacturing, industries"	
		400 = "Railroads"	
		410 = "Trucking service"	
		412 = "U.S. postal services"	
		441 = "Telephone communications"	
		450 = "Electric light and power"	
		551 = "Wholesale trade, Farm-product raw materials"	
		580 = "Retail trade, Lumber and building material retailing"	
		591 = "Retail trade, Department stores"	
		601 = "Retail trade, Grocery stores"	
		612 = "Retail trade, Motor vehicle dealers"	
		621 = "Retail trade, Gasoline service stations"	
		623 = "Retail trade, Apparel and accessory stores, except shoe"	
		631 = "Retail trade, Furniture and home furnishings stores"	
		641 = "Retail trade, Eating and drinking places"	
		642 = "Retail trade, Drug stores"	
		700 = "Banking"	
		702 = "Credit agencies, n.e.c."	
		711 = "Insurance"	
		712 = "Real estate, including real estate-insurance offices"	
		732 = "Computer and data processing services"	
		751 = "Automotive repair and related services"	
		761 = "Private households"	
		762 = "Hotels and motels"	
		771 = "Laundry, cleaning and garment services"	
		772 = "Beauty shops"	
		780 = "Barber shops"	
		810 = "Misc. entertainment and recreation services"	
		812 = "Offices and clinics od physicians"	
		831 = "Hospitals"	
		832 = "Nursing and personal care facilities"	
		841 = "Legal services"	
		842 = "Elementary and secondary schools"	
		850 = "College and universities"	
		862 = "Child day care services"	
		863 = "Family child care homes"	
		880 = "Religious organizations, n.e.c."	
		890 = "Accounting, auditing, and bookkeeping services"	
		910 = "Justice, public order, and safety"	
		961 = "None"	
		990 = "Other/Unknown"
	;
	value industry
		1 =	'Agriculture, Forestry and Fisheries'
		2 =	'Mining'
		3 =	'Construction'
		4 =	'Manufacturing'
		5 =	'Transportation, Communications and Other Public Utilities'
		6 =	'Wholesale Trade'
		7 =	'Retail Trade'
		8 =	'Finance, Insurance and Real Estate'
		9 =	'Business and Repair Services'
		10 = 'Personal Services'
		11 = 'Entertainment and Recreation Services'
		12 = 'Professional and Related Services'
		13 = 'Public Administration'
		14 = 'None'
		16 = 'Unknown'
	;
	VALUE burial
		1 =	'Burial'
		2 =	'Cremation'
		3 =	'Removal'
		4 =	'Anatomical Donation'
		5 =	'Entombment'
		6 =	'Other'
		9 =	'Unknown'
	;

VALUE funeral
		0 = "Out of State Facilities"
		1 = "FitzHenry's Funeral Home (Carson)"
		2 =	"Walton's Funeral Home (Carson)"
		3 = "Smith Family Funeral Home"
		4 = "Bunkers Brothers Mortuary"
		5 = "Palm Downtown or Main"
		6 = "American Burial & Cremation"
		7 = "Burns Funeral Home"
		8 = "Albertsons"
		9 =	"Wiscombe Funeral Home"
		10 = "Freitas Funeral Home"
		11 = "Gunter's Funeral Home (Hawthorne)"
		12 = "Gunter's Funeral Home (Tonopah)"
		13 = "Lovelock Funeral Home"
		14 = "Ross, Burke, & Knobel (Sparks)"
		15 = "O'Brien, Rogers, & Crosby"
		16 = "Ross, Burke, & Knobel (Reno)"
		17 = "Walton's Funeral Home (Reno)"
		18 = "Walton's Funeral Home (Sparks)"
		19 = "Mountain Vista/Wilson Bates Funeral Home"
		20 = "University of Nevada Reno"
		21 = "Veterans Hospital"
		23 = "Palm Funeral Home (Henderson)"
		24 = "Palm Valley (Eastern)"
		25 = "Davis Funeral Home"
		26 = "Rose Manor"
		27 = "Nevada Memorial Cremation Society"
		28 = "Metcalf Funeral Home"
		29 = "Bunkers Eden Vale"
		30 = "Bunkers Memory Garden"
		31 = "John Sparks Memorial Chapel"
		32 = "Western Pacific Cremation Society"
		33 = "American National Cremation Society"
		34 = "Palm Jones Mortuary"
		35 = "Northern Nevada Memorial"
		36 = "Desert Memorial"
		37 = "Neptune Memorial Society of Nevada, Reno"
		38 = "Universal Funeraria Clark Co"
		39 = "Neptune Society of Pahrump"
		40 = "Virgin Valley Mortuary"
		41 = "Pahrump Family Mortuary"
		42 = "Telophase Cremation Society (Sparks)"
		43 = "Reno Memorial Funeral Service"
		44 = "Capital City Cremation & Burial"
		45 = "Affordable Cremation & Burial"
		46 = "Sunrise Memorial Park"
		47 = "Hines Funeral Home"
		48 = "FitzHenry's Carson Valley Funeral Home"
		49 = "Evergreen Funeral Home"
		50 = "FitzHenry's Funeral Home(Minden)"
		51 = "Palm Cheyenne"
		52 = "Hites Funeral Services"
		53 = "Walton's Funeral Home(Douglas Co)"
		54 = "New Horizon Mortuary"
		55 = "Harrison-Ross Mortuary"
		56 = "Valley Memorial"
		57 = "Garden Memorial"
		58 = "The Gardens"
		59 = "Desert Pines Funeral Home"
		60 = "King David Memorial of Las Vegas"
		61 = "Neptune Funeral Home"
		62 = "Sunrise Cremation & Burial Society"
		63 = "Boulder City Family Mortuary"
		64 = "Mountain View Mortuary"
		65 = "Truckee Meadows Cremation and Burial"
		66 = "Palm-Northwest"
		67 = "Final Wishes"
		68 = "Autumn Funeral Home"
		69 = "Nevada Funeral Service"
		70 = "Washoe Memorial Cremation & Burial"
		71 = "Moapa Valley Mortuary"
		72 = "Southern Nevada Mortuary"
		73 = "La Paloma Funeral Services"
		74 = "Thomas & Jones Funeral Home"
		75 = "Davis Funeral Home & Memorial Park"
		76 = "Lee Funeral Home & Cremation Service"
		77 = "Affinity Burial and Cremation"
		78 = "La Paloma Funeral Service -Reno"
		79 = "Kraft-Sussman Funeral Service, Inc"
		80 = "Simple Cremation and Burial Services"
		81 = "Simple Cremation Reno"
		82 = "McDermott Funeral Home"
		83 = "Reno Cremation and Burial Services"
		84 = "Simple Cremation and Burial Services, Durango"
		85 = "Simple Cremation and Burial Services, Carson City"
		98 = "Other"
		99 = "Unknown"
	;
	value certifier
		1 =	'Physician, DO, Med Examiner'
		2 =	'Coroner or Sheriff'
		5 =	'Unknown'
		9 =	'Other'
	;
	value coroner
		1 =	'Yes'
		2 = 'No'
		8 =	'Not on Certificate'
		9 =	'Unknown'
	;
/*Value used for Manner of Death manner_death*/
	value manner
		1 =	'Natural Causes'
		2 =	'Accident'
		3 =	'Suicide'
		4 =	'Homicide'
		5 =	'Pending Investigation'
		6 =	'Could not be determined'
		7 = 'Natural with Injury'
		9 =	'Unknown'
	;
	value autopsy
		1 =	'Yes'
		2 =	'No'
		8 =	'Not on Certificate'
		9 =	'Unknown'
		;
	value tobacco
		1 =	'Yes'
		2 =	'No'
		3 =	'Probably'
		9 =	'Unknown'
	;
	value fem_preg
		1 =	'Not pregnant within last year'
		2 =	'Pregnant at time of death'
		3 =	'Not pregnant, but pregnant within 42 days of death'
		4 =	'Not pregnant, but pregnant 43 days to 1 year before death'
		8 =	'Not applicable'
		9 =	'Unknown'
	;
	value injur_wk
		1 =	'Yes'
		2 =	'No'
		9 =	'Not Reported'
	;
	value injur_pl
		0 =	'Other'
		1 =	'Desert'
		2 =	'Factory'
		3 =	'Farm'
		4 =	'Home'
		5 =	'Hotel'
		6 =	'Lake'
		7 =	'Mountain'
		8 =	'Office Bldg'
		9 =	'Parking Lot'
		10 = 'School'
		11 = 'Street'
		99 = 'Unknown'
	;
	value injur_transp
		1 =	'Yes'
		2 =	'No'
		9 =	'Unknown'
	;
	value injur_transplace
		1 =	'Driver/Operator'
		2 =	'Passenger'
		3 =	'Pestestrian'
		4 =	'Other'
		9 =	'Unknown'
	;
run;
