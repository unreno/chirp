#
#	I think that this is a good start, but is currently wrong. The fields don't look right.
#
BEGIN{
#	FIELDWIDTHS="10 1 21 4 16 16 1 8 4 1 4 2 3 2 1 21 4 16 16 21 4 8 2 2 2 2 3 2 40 10 9 1 1 3 3 9 21 4 16 16 8 2 2 2 1 3 3 9 1 1 1 1 1 8 1 8 8 2 1 2 3 3 2 6 2 2 2 6 1 1 2 2 2 2 2 2 2 2 1 2 1 1 1 1 30 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 1 4 2 2 2 2 2 2 6 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 30 1 1 1 30 1 1 1 1 1 30 1 1 1 1 1 1 1 30 1 1 1 1 30 1 1 1 30 1 30 1 8 8 1 1 1 1 20 20 1 1 1 1 1 1 20 1 1 1 30 1 1 30 1 1 1 1 1 1 1 1 1 30 1 30 1 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 1 1 1 1 1 20 1 1 1 30 1 1 30 1 1 1 1 1 1 1 1 1 30 1 30 1 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 4 1 2 2 5 3 2 2 9 1 10 8 2 2 20";
	FIELDWIDTHS="4 6 1 21 4 16 16 1 8 4 1 4 2 3 2 1 21 4 16 16 21 4 8 2 2 2 2 3 2 40 10 9 1 1 3 3 9 21 4 16 16 8 2 2 2 1 3 3 9 1 1 1 1 1 8 1 8 8 2 1 2 3 3 2 6 2 2 2 6 1 1 2 2 2 2 2 2 2 2 1 2 1 1 1 1 30 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 1 4 2 2 2 2 2 2 6 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 30 1 1 1 1 1 30 1 1 1 30 1 1 1 1 1 30 1 1 1 1 1 1 1 30 1 1 1 1 30 1 1 1 30 1 30 1 8 8 1 1 1 1 20 20 1 1 1 1 1 1 20 1 1 1 30 1 1 30 1 1 1 1 1 1 1 1 1 30 1 30 1 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 1 1 1 1 1 20 1 1 1 30 1 1 30 1 1 1 1 1 1 1 1 1 30 1 30 1 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 4 1 2 2 5 3 2 2 9 1 10 8 2 2 20";
	OFS="|";
#	print "STATE_FILE_NUMBER|VOID_FLAG|NAME_LAST|NAME_SUFFIX|NAME_FIRST|NAME_MIDDLE|SEX|DATE_OF_BIRTH|TIME_OF_BIRTH|FAC_TYPE_CODE|FAC_NV_CODE|FAC_ST_NV_OLD|FAC_CITY_NV_OLD|FAC_CNTY_NV_OLD|ATTENDANT_TITLE_CODE|MOTHER_NAME_LAST|MOTHER_NAME_SUFFIX|MOTHER_NAME_FIRST|MOTHER_NAME_MIDDLE|MOTHER_NAME_LAST_P|MOTHER_NAME_SUFFIX_P|B2_MOTHER_DOB|B2_MOTHER_AGE|MBIR_COUNTRY_COUNTRY_CODE_NV|MBIR_STATE_STATE_CODE_NV|MRES_STATE_STATE_CODE_NV|MOTHER_RES_CITY_NV_OLD|MOTHER_RES_CNTY_NV_OLD|MOTHER_RES_ADDR1|MOTHER_RES_APT|MOTHER_RES_ZIP|MOTHER_RES_INCITY|B2_MOTHER_ED|MOTHER_OCCUPATION_CD|MOTHER_INDUSTRY_CD|MOTHER_SSN|FATHER_NAME_LAST|FATHER_NAME_SUFFIX|FATHER_NAME_FIRST|FATHER_NAME_MIDDLE|B2_FATHER_DOB|B2_FATHER_AGE|FBIR_COUNTRY_COUNTRY_CODE_NV|FBIR_STATE_STATE_CODE_NV|B2_FATHER_ED|FATHER_OCCUPATION_CD|FATHER_INDUSTRY_CD|FATHER_SSN|B2_MOTHER_EVER_MARRIED|MOTHER_MARRIED|FATHER_IS_HUSBAND|FATHER_SIGN_PAT_AFFIDAVIT|B2_TRANS_MOTHER|MENSES_DATE|B2_PRENATAL_YESNO|B2_PRENATAL_DATE_BEGIN|B2_PRENATAL_DATE_END|B2_PRENAT_TOT_VISITS|B2_MOTHER_HEIGHT_FEET|B2_MOTHER_HEIGHT_INCH|B2_MOTHER_PRE_PREG_WT|B2_MOTHER_WT_AT_DELIV|LIVE_BIRTHS_TOTAL|LIVE_BIRTHS_DATE_MMYYYY|LIVE_BIRTHS_LIVING|LIVE_BIRTHS_DEAD|TERM_NUMBER|TERM_DATE_MMYYYY|B2_TOBACCO_USE|B2_MOTHER_CIG_OR_PACK|B2_MOTHER_CIG_PREV|B2_MOTHER_CIG_PREV_PACK|B2_MOTHER_CIG_FIRST_TRI|B2_MOTHER_CIG_FIRST_PACK|B2_MOTHER_CIG_SECOND_TRI|B2_MOTHER_CIG_SECOND_PACK|B2_MOTHER_CIG_LAST_TRI|B2_MOTHER_CIG_LAST_PACK|M_ALCOHOL_USE|M_ALCOHOL_DRINK_WEEK|M_DRUG_USE|M_DRUG_PRESCRIPTION|M_DRUG_OTC|M_DRUG_OTHER|M_DRUG_OTHER_LIT|M_MR_NONE|M_MR_DIAB|M_MR_DIAB_GEST|M_MR_HYPERT_ALL|M_MR_HYPERT_CHRONIC|M_MR_HYPERT_PREG|M_MR_ECLAMPSIA|M_MR_PREV_PRETERM|M_MR_PREV_POOR_OUTCOME|M_MR_PREG_FROM_TREATMENT|M_MR_INFERT_DRUGS|M_MR_ASSIST_REP_TECH|M_MR_PREV_CESAREAN_YESNO|M_MR_PREV_CES_NUMB|M_MR_ANEMIA|M_MR_CARDIAC|M_MR_LUNG_DISEASE|M_MR_HYDRAMINOS_OLIG|M_MR_HEMOGLOBINOPATHY|M_MR_INCOMPENT_CERVIX|M_MR_PREV_4000_PLUS|M_MR_RENAL_DISEASE|M_MR_RH_SENSIT|M_MR_UTERINE_BLEEDING|M_MR_OTHER|M_MR_OTHER_LIT|M_INF_NONE|M_INF_GONORRHEA|M_INF_SYPHILIS|M_INF_CHLAMYDIA|M_INF_HEPATITIS_B|M_INF_HEPATITIS_C|M_INF_HPV|M_INF_HIV_AIDS|M_INF_CMV|M_INF_RUBELLA|M_INF_TOXOPLASMOSIS|M_INF_GENITAL_HERPES|M_INF_TUBERCULOSIS|M_INF_OTHER|M_INF_OTHER_LIT|M_OB_NONE|M_OB_CERCLAGE|M_OB_TOCOLYSIS|M_OB_AMNIO|M_OB_FETAL_MONITOR|M_OB_CEPHALIC_SUCCESS|M_OB_CEPHALIC_FAILED|M_OB_ULTRASOUND|M_OB_OTHER|M_OB_OTHER_LIT|M_OL_NONE|M_OL_PREMATURE_ROM|M_OL_PRECIP_LABOR|M_OL_PROLONG_LABOR|M_CLD_NONE|M_CLD_INDUCTION|M_CLD_AUGMENT|M_CLD_NON_VERTEX|M_CLD_STEROID|M_CLD_ANTIBIOTIC|M_CLD_CHORIOAMNIO|M_CLD_MECONIUM|M_CLD_FETAL_INTOLERANCE|M_CLD_EPIDURAL|M_CLD_FEBRILE|M_CLD_ABR_PLACENTA|M_CLD_PLACENTA_PREVIA|M_CLD_BLEEDING|M_CLD_SEIZURES|M_CLD_DYSFUNCTIONAL|M_CLD_CEPHALOPELVIC|M_CLD_CORD_PROLAPSE|M_CLD_ANESTHETIC|M_CLD_OTHER|M_CLD_OTHER_LIT|M_MD_FORCEPS_ATTEMPT|M_MD_VACUUM_ATTEMPT|B2_BIRPRESENT_CODE|B2_BIRROUTE_CODE|M_MD_CES_LABOR_ATTEMPT|M_MM_NONE|M_MM_TRANSFUSION|M_MM_PERINEAL_LACERAT|M_MM_RUPTURED_UTERUS|M_MM_HYSTERECTOMY|M_MM_ICU|M_MM_OR_PROC|M_MM_UNKNOWN|APGAR_5|APGAR_10|BIRTH_WEIGHT_UNIT|BIRTH_WEIGHT_GRAMS|BIRTH_WEIGHT_LBS|BIRTH_WEIGHT_OZ|GESTATION_WEEKS|PLURALITY|BIRTH_ORDER|B2_BORN_ALIVE|B2_MATCH_NUMBER|TRANS_INFANT|B2_INFANT_LIVING|M_AC_NONE|M_AC_VENT_LESS_30|M_AC_VENT_MORE_30|M_AC_NICU|M_AC_SURFACTANT|M_AC_ANTIBIOTIC_SEPSIS|M_AC_SEIZURES|M_AC_ANEMIA|M_AC_FAS|M_AC_HYALINE|M_AC_MECONIUM_AS|M_AC_BIRTH_INJURY|M_AC_OTHER|M_AC_OTHER_LIT|M_ANOM_NONE|M_ANOM_ANENCEP|M_ANOM_SPINA|M_ANOM_MICRO|M_ANOM_NERVOUS|M_ANOM_NERVOUS_LIT|M_ANOM_HEART|M_ANOM_HEART_MALFORM|M_ANOM_CIRC|M_ANOM_CIRC_LIT|M_ANOM_OMPHAL|M_ANOM_GASTROSCHISIS|M_ANOM_RECTAL|M_ANOM_TRACHEO|M_ANOM_GASTRO|M_ANOM_GASTRO_LIT|M_ANOM_LIMB_REDUCT|M_ANOM_CLEFT_LIP|M_ANOM_CLEFT_PALATE|M_ANOM_POLYDACT|M_ANOM_CLUB_FOOT|M_ANOM_DIAPH_HERNIA|M_ANOM_MUSCLE|M_ANOM_MUSCLE_LIT|M_ANOM_MALF_GENITALIA|M_ANOM_RENAL|M_ANOM_HYPOSPADIAS|M_ANOM_UROGENITAL|M_ANOM_UROGENITAL_LIT|M_ANOM_DOWNS_CODE|M_ANOM_CDIT|M_ANOM_CHROM_OTHER|M_ANOM_CHROM_LIT|M_ANOM_OTHER|M_ANOM_OTHER_LIT|CERTIFIERTITLEID|CERTIFIER_DATE_COMP|REGISTRAR_REGIS_DATE|B2_MOTHER_WIC_YESNO|B2_SOURCE_PAY_CODE|M_BREASTFEEDING|SSN_REQUESTED|HOS_NUMBER|M_MOTHER_MED_REC_NUM|B2_HOSP_PATERNITY_COMPLETE|B2_MOTHER_ETHNIC_YESNO|B2_MOTHER_MEXICAN|B2_MOTHER_PR|B2_MOTHER_CUBAN|B2_MOTHER_ETHNIC_OTHER|B2_MOTHER_ETHNIC|B2_MOTHER_RACE_WHITE|B2_MOTHER_RACE_BLACK|B2_MOTHER_RACE_AM_INDIAN|B2_MOTHER_RACE_AM_IND_LIT|B2_MOTHER_RACE_ASIAN_IND|B2_MOTHER_RACE_ASIAN_OTH|B2_MOTHER_RACE_ASIAN_LIT|B2_MOTHER_RACE_CHINESE|B2_MOTHER_RACE_FILIPINO|B2_MOTHER_RACE_JAPANESE|B2_MOTHER_RACE_KOREAN|B2_MOTHER_RACE_VIETNAMESE|B2_MOTHER_RACE_HAWAIIAN|B2_MOTHER_RACE_GUAM|B2_MOTHER_RACE_SAMOAN|B2_MOTHER_RACE_PAC_OTHER|B2_MOTHER_RACE_PAC_LIT|B2_MOTHER_RACE_OTHER|B2_MOTHER_RACE_OTHER_LIT|B2_MOTHER_RACE_UNKNOWN|B2_MOTHER_RACE_REFUSED|B2_MRACE1E|B2_MRACE2E|B2_MRACE3E|B2_MRACE4E|B2_MRACE5E|B2_MRACE6E|B2_MRACE7E|B2_MRACE8E|B2_MRACE16E|B2_MRACE18E|B2_MRACE20E|B2_MRACE22E|B2_NCHS_MO_ETHNIC_CD|B2_NCHS_MO_ETHNIC_LIT_CD|B2_MO_BRIDGED_RACE|B2_FATHER_ETHNIC_YESNO|B2_FATHER_MEXICAN|B2_FATHER_PR|B2_FATHER_CUBAN|B2_FATHER_ETHNIC_OTHER|B2_FATHER_ETHNIC|B2_FATHER_RACE_WHITE|B2_FATHER_RACE_BLACK|B2_FATHER_RACE_AM_INDIAN|B2_FATHER_RACE_AM_IND_LIT|B2_FATHER_RACE_ASIAN_IND|B2_FATHER_RACE_ASIAN_OTH|B2_FATHER_RACE_ASIAN_LIT|B2_FATHER_RACE_CHINESE|B2_FATHER_RACE_FILIPINO|B2_FATHER_RACE_JAPANESE|B2_FATHER_RACE_KOREAN|B2_FATHER_RACE_VIETNAMESE|B2_FATHER_RACE_HAWAIIAN|B2_FATHER_RACE_GUAM|B2_FATHER_RACE_SAMOAN|B2_FATHER_RACE_PAC|B2_FATHER_RACE_PAC_LIT|B2_FATHER_RACE_OTHER|B2_FATHER_RACE_OTHER_LIT|B2_FATHER_RACE_UNKNOWN|B2_FATHER_RACE_REFUSED|B2_FRACE1E|B2_FRACE2E|B2_FRACE3E|B2_FRACE4E|B2_FRACE5E|B2_FRACE6E|B2_FRACE7E|B2_FRACE8E|B2_FRACE16E|B2_FRACE18E|B2_FRACE20E|B2_FRACE22E|B2_NCHS_FA_ETHNIC_CD|B2_NCHS_FA_ETHNIC_LIT_CD|B2_FA_BRIDGED_RACE|EVENT_YEAR|ISACTIVE|MOTHER_BIRTH_STATE|MOTHER_BIRTH_COUNTRY_FIPS|MOTHER_RES_CITY_FIPS|MOTHER_RES_CNTY_FIPS|MOTHER_RES_STATE|MOTHER_RES_COUNTRY_FIPS|SSN_CHILD|DEATH_MATCHED|DEATH_STATE_FILE_NUMBER|DEATH_DATE|FBIR_STATE_FIPS_ALPHA_CD|FATHER_BIRTH_COUNTRY_FIPS|REG_TYPE_CODE";
	print "STATE_FILE_NUMBER_YR|STATE_FILE_NUMBER_NUM|VOID_FLAG|NAME_LAST|NAME_SUFFIX|NAME_FIRST|NAME_MIDDLE|SEX|DATE_OF_BIRTH|TIME_OF_BIRTH|FAC_TYPE_CODE|FAC_NV_CODE|FAC_ST_NV_OLD|FAC_CITY_NV_OLD|FAC_CNTY_NV_OLD|ATTENDANT_TITLE_CODE|MOTHER_NAME_LAST|MOTHER_NAME_SUFFIX|MOTHER_NAME_FIRST|MOTHER_NAME_MIDDLE|MOTHER_NAME_LAST_P|MOTHER_NAME_SUFFIX_P|B2_MOTHER_DOB|B2_MOTHER_AGE|MBIR_COUNTRY_COUNTRY_CODE_NV|MBIR_STATE_STATE_CODE_NV|MRES_STATE_STATE_CODE_NV|MOTHER_RES_CITY_NV_OLD|MOTHER_RES_CNTY_NV_OLD|MOTHER_RES_ADDR1|MOTHER_RES_APT|MOTHER_RES_ZIP|MOTHER_RES_INCITY|B2_MOTHER_ED|MOTHER_OCCUPATION_CD|MOTHER_INDUSTRY_CD|MOTHER_SSN|FATHER_NAME_LAST|FATHER_NAME_SUFFIX|FATHER_NAME_FIRST|FATHER_NAME_MIDDLE|B2_FATHER_DOB|B2_FATHER_AGE|FBIR_COUNTRY_COUNTRY_CODE_NV|FBIR_STATE_STATE_CODE_NV|B2_FATHER_ED|FATHER_OCCUPATION_CD|FATHER_INDUSTRY_CD|FATHER_SSN|B2_MOTHER_EVER_MARRIED|MOTHER_MARRIED|FATHER_IS_HUSBAND|FATHER_SIGN_PAT_AFFIDAVIT|B2_TRANS_MOTHER|MENSES_DATE|B2_PRENATAL_YESNO|B2_PRENATAL_DATE_BEGIN|B2_PRENATAL_DATE_END|B2_PRENAT_TOT_VISITS|B2_MOTHER_HEIGHT_FEET|B2_MOTHER_HEIGHT_INCH|B2_MOTHER_PRE_PREG_WT|B2_MOTHER_WT_AT_DELIV|LIVE_BIRTHS_TOTAL|LIVE_BIRTHS_DATE_MMYYYY|LIVE_BIRTHS_LIVING|LIVE_BIRTHS_DEAD|TERM_NUMBER|TERM_DATE_MMYYYY|B2_TOBACCO_USE|B2_MOTHER_CIG_OR_PACK|B2_MOTHER_CIG_PREV|B2_MOTHER_CIG_PREV_PACK|B2_MOTHER_CIG_FIRST_TRI|B2_MOTHER_CIG_FIRST_PACK|B2_MOTHER_CIG_SECOND_TRI|B2_MOTHER_CIG_SECOND_PACK|B2_MOTHER_CIG_LAST_TRI|B2_MOTHER_CIG_LAST_PACK|M_ALCOHOL_USE|M_ALCOHOL_DRINK_WEEK|M_DRUG_USE|M_DRUG_PRESCRIPTION|M_DRUG_OTC|M_DRUG_OTHER|M_DRUG_OTHER_LIT|M_MR_NONE|M_MR_DIAB|M_MR_DIAB_GEST|M_MR_HYPERT_ALL|M_MR_HYPERT_CHRONIC|M_MR_HYPERT_PREG|M_MR_ECLAMPSIA|M_MR_PREV_PRETERM|M_MR_PREV_POOR_OUTCOME|M_MR_PREG_FROM_TREATMENT|M_MR_INFERT_DRUGS|M_MR_ASSIST_REP_TECH|M_MR_PREV_CESAREAN_YESNO|M_MR_PREV_CES_NUMB|M_MR_ANEMIA|M_MR_CARDIAC|M_MR_LUNG_DISEASE|M_MR_HYDRAMINOS_OLIG|M_MR_HEMOGLOBINOPATHY|M_MR_INCOMPENT_CERVIX|M_MR_PREV_4000_PLUS|M_MR_RENAL_DISEASE|M_MR_RH_SENSIT|M_MR_UTERINE_BLEEDING|M_MR_OTHER|M_MR_OTHER_LIT|M_INF_NONE|M_INF_GONORRHEA|M_INF_SYPHILIS|M_INF_CHLAMYDIA|M_INF_HEPATITIS_B|M_INF_HEPATITIS_C|M_INF_HPV|M_INF_HIV_AIDS|M_INF_CMV|M_INF_RUBELLA|M_INF_TOXOPLASMOSIS|M_INF_GENITAL_HERPES|M_INF_TUBERCULOSIS|M_INF_OTHER|M_INF_OTHER_LIT|M_OB_NONE|M_OB_CERCLAGE|M_OB_TOCOLYSIS|M_OB_AMNIO|M_OB_FETAL_MONITOR|M_OB_CEPHALIC_SUCCESS|M_OB_CEPHALIC_FAILED|M_OB_ULTRASOUND|M_OB_OTHER|M_OB_OTHER_LIT|M_OL_NONE|M_OL_PREMATURE_ROM|M_OL_PRECIP_LABOR|M_OL_PROLONG_LABOR|M_CLD_NONE|M_CLD_INDUCTION|M_CLD_AUGMENT|M_CLD_NON_VERTEX|M_CLD_STEROID|M_CLD_ANTIBIOTIC|M_CLD_CHORIOAMNIO|M_CLD_MECONIUM|M_CLD_FETAL_INTOLERANCE|M_CLD_EPIDURAL|M_CLD_FEBRILE|M_CLD_ABR_PLACENTA|M_CLD_PLACENTA_PREVIA|M_CLD_BLEEDING|M_CLD_SEIZURES|M_CLD_DYSFUNCTIONAL|M_CLD_CEPHALOPELVIC|M_CLD_CORD_PROLAPSE|M_CLD_ANESTHETIC|M_CLD_OTHER|M_CLD_OTHER_LIT|M_MD_FORCEPS_ATTEMPT|M_MD_VACUUM_ATTEMPT|B2_BIRPRESENT_CODE|B2_BIRROUTE_CODE|M_MD_CES_LABOR_ATTEMPT|M_MM_NONE|M_MM_TRANSFUSION|M_MM_PERINEAL_LACERAT|M_MM_RUPTURED_UTERUS|M_MM_HYSTERECTOMY|M_MM_ICU|M_MM_OR_PROC|M_MM_UNKNOWN|APGAR_5|APGAR_10|BIRTH_WEIGHT_UNIT|BIRTH_WEIGHT_GRAMS|BIRTH_WEIGHT_LBS|BIRTH_WEIGHT_OZ|GESTATION_WEEKS|PLURALITY|BIRTH_ORDER|B2_BORN_ALIVE|B2_MATCH_NUMBER|TRANS_INFANT|B2_INFANT_LIVING|M_AC_NONE|M_AC_VENT_LESS_30|M_AC_VENT_MORE_30|M_AC_NICU|M_AC_SURFACTANT|M_AC_ANTIBIOTIC_SEPSIS|M_AC_SEIZURES|M_AC_ANEMIA|M_AC_FAS|M_AC_HYALINE|M_AC_MECONIUM_AS|M_AC_BIRTH_INJURY|M_AC_OTHER|M_AC_OTHER_LIT|M_ANOM_NONE|M_ANOM_ANENCEP|M_ANOM_SPINA|M_ANOM_MICRO|M_ANOM_NERVOUS|M_ANOM_NERVOUS_LIT|M_ANOM_HEART|M_ANOM_HEART_MALFORM|M_ANOM_CIRC|M_ANOM_CIRC_LIT|M_ANOM_OMPHAL|M_ANOM_GASTROSCHISIS|M_ANOM_RECTAL|M_ANOM_TRACHEO|M_ANOM_GASTRO|M_ANOM_GASTRO_LIT|M_ANOM_LIMB_REDUCT|M_ANOM_CLEFT_LIP|M_ANOM_CLEFT_PALATE|M_ANOM_POLYDACT|M_ANOM_CLUB_FOOT|M_ANOM_DIAPH_HERNIA|M_ANOM_MUSCLE|M_ANOM_MUSCLE_LIT|M_ANOM_MALF_GENITALIA|M_ANOM_RENAL|M_ANOM_HYPOSPADIAS|M_ANOM_UROGENITAL|M_ANOM_UROGENITAL_LIT|M_ANOM_DOWNS_CODE|M_ANOM_CDIT|M_ANOM_CHROM_OTHER|M_ANOM_CHROM_LIT|M_ANOM_OTHER|M_ANOM_OTHER_LIT|CERTIFIERTITLEID|CERTIFIER_DATE_COMP|REGISTRAR_REGIS_DATE|B2_MOTHER_WIC_YESNO|B2_SOURCE_PAY_CODE|M_BREASTFEEDING|SSN_REQUESTED|HOS_NUMBER|M_MOTHER_MED_REC_NUM|B2_HOSP_PATERNITY_COMPLETE|B2_MOTHER_ETHNIC_YESNO|B2_MOTHER_MEXICAN|B2_MOTHER_PR|B2_MOTHER_CUBAN|B2_MOTHER_ETHNIC_OTHER|B2_MOTHER_ETHNIC|B2_MOTHER_RACE_WHITE|B2_MOTHER_RACE_BLACK|B2_MOTHER_RACE_AM_INDIAN|B2_MOTHER_RACE_AM_IND_LIT|B2_MOTHER_RACE_ASIAN_IND|B2_MOTHER_RACE_ASIAN_OTH|B2_MOTHER_RACE_ASIAN_LIT|B2_MOTHER_RACE_CHINESE|B2_MOTHER_RACE_FILIPINO|B2_MOTHER_RACE_JAPANESE|B2_MOTHER_RACE_KOREAN|B2_MOTHER_RACE_VIETNAMESE|B2_MOTHER_RACE_HAWAIIAN|B2_MOTHER_RACE_GUAM|B2_MOTHER_RACE_SAMOAN|B2_MOTHER_RACE_PAC_OTHER|B2_MOTHER_RACE_PAC_LIT|B2_MOTHER_RACE_OTHER|B2_MOTHER_RACE_OTHER_LIT|B2_MOTHER_RACE_UNKNOWN|B2_MOTHER_RACE_REFUSED|B2_MRACE1E|B2_MRACE2E|B2_MRACE3E|B2_MRACE4E|B2_MRACE5E|B2_MRACE6E|B2_MRACE7E|B2_MRACE8E|B2_MRACE16E|B2_MRACE18E|B2_MRACE20E|B2_MRACE22E|B2_NCHS_MO_ETHNIC_CD|B2_NCHS_MO_ETHNIC_LIT_CD|B2_MO_BRIDGED_RACE|B2_FATHER_ETHNIC_YESNO|B2_FATHER_MEXICAN|B2_FATHER_PR|B2_FATHER_CUBAN|B2_FATHER_ETHNIC_OTHER|B2_FATHER_ETHNIC|B2_FATHER_RACE_WHITE|B2_FATHER_RACE_BLACK|B2_FATHER_RACE_AM_INDIAN|B2_FATHER_RACE_AM_IND_LIT|B2_FATHER_RACE_ASIAN_IND|B2_FATHER_RACE_ASIAN_OTH|B2_FATHER_RACE_ASIAN_LIT|B2_FATHER_RACE_CHINESE|B2_FATHER_RACE_FILIPINO|B2_FATHER_RACE_JAPANESE|B2_FATHER_RACE_KOREAN|B2_FATHER_RACE_VIETNAMESE|B2_FATHER_RACE_HAWAIIAN|B2_FATHER_RACE_GUAM|B2_FATHER_RACE_SAMOAN|B2_FATHER_RACE_PAC|B2_FATHER_RACE_PAC_LIT|B2_FATHER_RACE_OTHER|B2_FATHER_RACE_OTHER_LIT|B2_FATHER_RACE_UNKNOWN|B2_FATHER_RACE_REFUSED|B2_FRACE1E|B2_FRACE2E|B2_FRACE3E|B2_FRACE4E|B2_FRACE5E|B2_FRACE6E|B2_FRACE7E|B2_FRACE8E|B2_FRACE16E|B2_FRACE18E|B2_FRACE20E|B2_FRACE22E|B2_NCHS_FA_ETHNIC_CD|B2_NCHS_FA_ETHNIC_LIT_CD|B2_FA_BRIDGED_RACE|EVENT_YEAR|ISACTIVE|MOTHER_BIRTH_STATE|MOTHER_BIRTH_COUNTRY_FIPS|MOTHER_RES_CITY_FIPS|MOTHER_RES_CNTY_FIPS|MOTHER_RES_STATE|MOTHER_RES_COUNTRY_FIPS|SSN_CHILD|DEATH_MATCHED|DEATH_STATE_FILE_NUMBER|DEATH_DATE|FBIR_STATE_FIPS_ALPHA_CD|FATHER_BIRTH_COUNTRY_FIPS|REG_TYPE_CODE";
}
{
	for (i=1;i<=NF;i++){
		gsub (/^ */,"",$i);
		gsub (/ *$/,"",$i);
	}
	print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$100,$101,$102,$103,$104,$105,$106,$107,$108,$109,$110,$111,$112,$113,$114,$115,$116,$117,$118,$119,$120,$121,$122,$123,$124,$125,$126,$127,$128,$129,$130,$131,$132,$133,$134,$135,$136,$137,$138,$139,$140,$141,$142,$143,$144,$145,$146,$147,$148,$149,$150,$151,$152,$153,$154,$155,$156,$157,$158,$159,$160,$161,$162,$163,$164,$165,$166,$167,$168,$169,$170,$171,$172,$173,$174,$175,$176,$177,$178,$179,$180,$181,$182,$183,$184,$185,$186,$187,$188,$189,$190,$191,$192,$193,$194,$195,$196,$197,$198,$199,$200,$201,$202,$203,$204,$205,$206,$207,$208,$209,$210,$211,$212,$213,$214,$215,$216,$217,$218,$219,$220,$221,$222,$223,$224,$225,$226,$227,$228,$229,$230,$231,$232,$233,$234,$235,$236,$237,$238,$239,$240,$241,$242,$243,$244,$245,$246,$247,$248,$249,$250,$251,$252,$253,$254,$255,$256,$257,$258,$259,$260,$261,$262,$263,$264,$265,$266,$267,$268,$269,$270,$271,$272,$273,$274,$275,$276,$277,$278,$279,$280,$281,$282,$283,$284,$285,$286,$287,$288,$289,$290,$291,$292,$293,$294,$295,$296,$297,$298,$299,$300,$301,$302,$303,$304,$305,$306,$307,$308,$309,$310,$311,$312,$313,$314,$315,$316,$317,$318,$319,$320,$321,$322,$323,$324,$325,$326,$327,$328,$329,$330,$331,$332,$333,$334,$335,$336,$337,$338,$339,$340,$341,$342,$343,$344,$345;
}
