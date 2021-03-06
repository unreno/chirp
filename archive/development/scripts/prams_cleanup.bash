#!/usr/bin/env bash

while [ $# -ne 0 ] ; do
	echo $1
	root=${1%.*}
	new_name=$root.jake.csv

# awk -F, 'NF!=90{print}' PRAMS_SPECIMENS_201*.csv | sed -re 's/,([^,]+, [^,]+),/,"\1",/g' | awk 'BEGIN{FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)"}NF!=90{print}' | sed -re 's/,([^,]+,(RN|RNC|MA|CMA|MW|LPN)),/,"\1",/g' |  awk 'BEGIN{FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)"}NF!=90{print}' > PRAMS_SPECIMENS_NOT_90.csv

#Male	C B	25	7226435	Single

#	Can only use references from \1 to \9. NO \10, \11, etc.
#	perl seems to be able to do this

#	sed -e 's/Unkown/Unknown/g' -re 's/,((False|True),([^,]*),(False|True),([^,]*),(Male|Female|Unknown),(.*),([^,]*),([^,]*),(Single|Multiple|Unknown),([^,]*),(False|True),/,\1,\2,\3,\4,\5,"\6",\7,\8,\9,\10,\11,/' $1 > $new_name

	sed -e 's/Unkown/Unknown/g' $1 | perl -pe 's/,(False|True),([^,]*),(False|True),([^,]*),([^,]*),(False|True),([^,]*),(False|True),([^,]*),(Male|Female|Unknown),(.*),([^,]*),([^,]*),(Single|Multiple|Unknown),([^,]*),(False|True|),/,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,"$11",$12,$13,$14,$15,$16,/'  > $new_name



#	sed -e 's/Unkown/Unknown/g' $1 | awk '
#		BEGIN { 
#			TorF["True"]=TorF["False"]=0
#			Sex["Male"]=Sex["Female"]=Sex["Unknown"]=0
#			Type["Single"]=Type["Multiple"]=Type["Unknown"]=0
#		}
#	' > $new_name
#	( ( $1 in TorF ) && ( $3 in TorF ) &&  ....

	shift
done

# SpecimenID,AccessionNumber,KitNumber,OrigKitNumber,TimeReceived,Unsat1,Unsat2,ParentRefused,Adopted,Deceased,DeceasedDate,ConsentGiven,BabyLast,BabyFirst,BirthDate,BirthDateNotGiven,BirthTime,BirthTimeNotGiven,BirthWeight,CollectionDate,CollectionDateNotGiven,CollectionTime,CollectionTimeNotGiven,CurrentWeight,BabySex,CollectedBy,CollectionAge,MedicalRecord,BirthType,BirthOrder,RaceWhite,RaceAfrAmer,RaceAmerInd,RaceAsian,RaceOther,RaceHispanic,BreastFeedOnly,MilkFeedOnly,SoyFeedOnly,BreastMilkFeed,BreastSoyFeed,TPN,NotFed,GestationAge,Meconiumileus,NICU,Antibiotic,BloodTransfusion,TrasfusionDate,BirthHospitalFacility,BirthHospitalFirstName,BirthHospitalLastName,BirthHospitalCode,BirthHospitalNotGiven,CollectionFacilityFacility,CollectionFacilityFirstName,CollectionFacilityLastName,CollectionFacilityCode,CollectionFacilityNotGiven,ReportToFacility,ReportToFirstName,ReportToLastName,ReportToCode,ReportToNotGiven,ReportToAddress,ReportToCity,ReportToState,ReportToZip,MotherLastName,MotherFirstName,MotherDOB,MotherMaidenName,MotherAddress,MotherCity,MotherState,MotherZip,Phone,EmergencyPhone,FatherName,FatherPhone,TestName,TestResultNumber,TestResultPlainValue,TestResultTextValue,MeasuredTime,AcceptedTime,TestPhase,TestStatus,ResultName,ResultLevel

#	1/A SpecimenID VARCHAR(10),              Integer
#	AccessionNumber VARCHAR(15),         AlphaNumeric
#	KitNumber VARCHAR(15),               AlphaNumeric
#	OrigKitNumber VARCHAR(10),           Alphanumeric
#	TimeReceived DATETIME,               Date & time
#	Unsat1 VARCHAR(10),                  blank, text
#	Unsat2 VARCHAR(10),                  blank, text
#	ParentRefused VARCHAR(10),           blank
#	Adopted VARCHAR(10),                 blank
#	Deceased VARCHAR(10),                blank, TRUE, FALSE
#	DeceasedDate DATE,                   blank, date time
#	ConsentGiven VARCHAR(10),            unknown, yes, no
#	BabyLast VARCHAR(20),                text									------ potential problem as suffixes included sometimes separated by comma
#	BabyFirst VARCHAR(10),               text
#	BirthDate DATE,                      date
#	BirthDateNotGiven VARCHAR(10),       False
#	BirthTime VARCHAR(10),               time
#	BirthTimeNotGiven VARCHAR(10),       false
#	BirthWeight VARCHAR(10),             text weight
#	CollectionDate DATE,                 date time
#	CollectionDateNotGiven VARCHAR(10),  false, true
#	CollectionTime VARCHAR(10),          time
#	CollectionTimeNotGiven VARCHAR(10),  false, true
#	CurrentWeight VARCHAR(10),           text weight
#	BabySex VARCHAR(10),                 male, female, unknown
#	26/Z CollectedBy VARCHAR(20),             text ------------------- THIS IS A PROBLEM FIELD, FIXED?
#	CollectionAge VARCHAR(10),           text
#	MedicalRecord VARCHAR(10),           alphanumeric
#	29/AC 	BirthType VARCHAR(10),               single, multiple, unknown
#	BirthOrder VARCHAR(10),              blank
#	RaceWhite VARCHAR(10),               true, false, blank
#	RaceAfrAmer VARCHAR(10),             true, false, blank
#	RaceAmerInd VARCHAR(10),             true, false, blank
#	RaceAsian VARCHAR(10),               true, false, blank
#	RaceOther VARCHAR(10),               true, false, blank
#	RaceHispanic VARCHAR(10),            yes, no, unknown
#	BreastFeedOnly VARCHAR(10),          true, false, blank
#	MilkFeedOnly VARCHAR(10),            true, false, blank
#	SoyFeedOnly VARCHAR(10),             true, false, blank
#	BreastMilkFeed VARCHAR(10),          true, false, blank
#	BreastSoyFeed VARCHAR(10),           true, false, blank
#	TPN VARCHAR(10),                     true, false, blank
#	NotFed VARCHAR(10),                  true, false, blank
#	GestationAge VARCHAR(10),            integer
#	Meconiumileus VARCHAR(10),           yes, no, unknown
#	NICU VARCHAR(10),                    yes, no, unknown
#	Antibiotic VARCHAR(10),              yes, no, unknown
#	BloodTransfusion VARCHAR(10),        yes, no, unknown
#	TrasfusionDate VARCHAR(10),           date
#	BirthHospitalFacility VARCHAR(50),      text
#	BirthHospitalFirstName VARCHAR(40),      text
#	52/AZ BirthHospitalLastName VARCHAR(10),      text
#	BirthHospitalCode VARCHAR(10),           alphanumeric
#	54/BB BirthHospitalNotGiven VARCHAR(10),         true, false
#	55 CollectionFacilityFacility VARCHAR(50),      text						---- possible problem
#	56 CollectionFacilityFirstName VARCHAR(40),      text						---- possible problem
#	57 CollectionFacilityLastName VARCHAR(10),      text						---- possible problem
#	58 CollectionFacilityCode VARCHAR(10),      alphanumeric
#	59/BG CollectionFacilityNotGiven VARCHAR(10),     true, false
#	60 ReportToFacility VARCHAR(40),               text						---- possible problem
#	61/BI ReportToFirstName VARCHAR(30),               text						---- possible problem
#	ReportToLastName VARCHAR(20),               text						---- possible problem
#	ReportToCode VARCHAR(20),                   alphanumeric
#	64/BL ReportToNotGiven VARCHAR(10),               true, false
#	ReportToAddress VARCHAR(40),               text
#	ReportToCity VARCHAR(40),               text
#	67/BO ReportToState VARCHAR(10),               text
#	ReportToZip VARCHAR(10),               text
#	MotherLastName VARCHAR(20),               text
#	MotherFirstName VARCHAR(20),               text
#	71/BS MotherDOB DATE,                           date
#	72 MotherMaidenName VARCHAR(10),             text
#	73/BU MotherAddress VARCHAR(30),             text
#	74 MotherCity VARCHAR(30),             text
#	75/BW MotherState VARCHAR(5),             text
#	76 MotherZip VARCHAR(10),             text
#	77 Phone VARCHAR(10),             text
#	78/BZ EmergencyPhone VARCHAR(10),             text
#	79 FatherName VARCHAR(30),             text		--- likely a problem as father's name is last,first, no quotes
#	80/CB FatherPhone VARCHAR(10),             text
#	TestName VARCHAR(10),                     blank
#	TestResultNumber VARCHAR(10),                     blank
#	TestResultPlainValue VARCHAR(10),                     blank
#	TestResultTextValue VARCHAR(10),                     blank
#	MeasuredTime VARCHAR(10),                     blank
#	AcceptedTime VARCHAR(10),                     blank
#	TestPhase VARCHAR(10),                     blank
#	TestStatus VARCHAR(10),                     blank
#	ResultName VARCHAR(10),                     blank
#	90/CL ResultLevel VARCHAR(10),                     blank

exit



#	still 157 out of 88379
#sed -e 's/Unkown/Unknown/g' PRAMS_SPECIMENS_201*csv | perl -pe 's/,(False|True),([^,]*),(False|True),([^,]*),([^,]*),(False|True),([^,]*),(False|True),([^,]*),(Male|Female|Unknown),(.*?),([^,]*),([^,]*),(Single|Multiple|Unknown),([^,]*),(False|True|),(False|True|),(False|True|),(False|True|),/,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,"$11",$12,$13,$14,$15,$16,$17,$18,$19,/' | perl -pe 's/,(Yes|No|Unknown),(Yes|No|Unknown),(Yes|No|Unknown),(Yes|No|Unknown),([^,]*),(.*?),([^,]*),([^,]*),([^,]*),(False|True),(.*?),([^,]*),([^,]*),([^,]*),(False|True),(.*?),([^,]*),([^,]*),([^,]*),(False|True),([^,]*),([^,]*),(NV|NEVADA|AZ|UT),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),(NV|NEVADA),/,$1,$2,$3,$4,$5,"$6",$7,$8,$9,$10,"$11",$12,$13,$14,$15,"$16",$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,/' | perl -pe 's/,(NV|NEVADA),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),(NV|NEVADA|CA|NY|FRANCE),([0-9]*),([0-9]*),([0-9]*),([A-z \\\.\-\(\)]+),([A-z \\\.\-\(\)]+),/,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,"$13,$14",/' | awk 'BEGIN{FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)"}(NF!=90){print}'  > PRAMS_SPECIMENS_NOT_90.csv
#	still 142 out of 88379
#sed -e 's/Unkown/Unknown/g' PRAMS_SPECIMENS_201*csv | perl -pe 's/,(False|True),([^,]*),(False|True),([^,]*),([^,]*),(False|True),([^,]*),(False|True),([^,]*),(Male|Female|Unknown),(.*?),([^,]*),([^,]*),(Single|Multiple|Unknown),([^,]*),(False|True|),(False|True|),(False|True|),(False|True|),/,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,"$11",$12,$13,$14,$15,$16,$17,$18,$19,/' | perl -pe 's/,(Yes|No|Unknown),(Yes|No|Unknown),(Yes|No|Unknown),(Yes|No|Unknown),([^,]*),(.*?),([^,]*),([^,]*),([^,]*),(False|True),(.*?),([^,]*),([^,]*),([^,]*),(False|True),(.*?),([^,]*),([^,]*),([^,]*),(False|True),([^,]*),([^,]*),(NV|NEVADA|AZ|UT),/,$1,$2,$3,$4,$5,"$6",$7,$8,$9,$10,"$11",$12,$13,$14,$15,"$16",$17,$18,$19,$20,$21,$22,$23,/' | perl -pe 's/,(NV|NEVADA),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),(.*?),([^,]*),(NV|NEVADA|CA|NY|FRANCE),([0-9]*),([0-9]*),([0-9]*),([A-z \\\.\-\(\)]+),([A-z \\\.\-\(\)]+),/,$1,$2,$3,$4,$5,$6,"$7",$8,$9,$10,$11,$12,"$13,$14",/' | awk 'BEGIN{FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)"}(NF!=90){print}'  > PRAMS_SPECIMENS_NOT_90.csv



#	still 83 out of 88379 (< 0.1%!)
sed -e 's/Unkown/Unknown/g' PRAMS_SPECIMENS_201*csv | perl -pe 's/,(False|True),([^,]*),(False|True),([^,]*),([^,]*),(False|True),([^,]*),(False|True),([^,]*),(Male|Female|Unknown),(.*?),([^,]*),([^,]*),(Single|Multiple|Unknown),([^,]*),(False|True|),(False|True|),(False|True|),(False|True|),/,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,"$11",$12,$13,$14,$15,$16,$17,$18,$19,/' | perl -pe 's/,(Yes|No|Unknown),(Yes|No|Unknown),(Yes|No|Unknown),(Yes|No|Unknown),([^,]*),(.*?),([^,]*),([^,]*),([^,]*),(False|True),(.*?),([^,]*),([^,]*),([^,]*),(False|True),(.*?),([^,]*),([^,]*),([^,]*),(False|True),([^,]*),([^,]*),(NV|NEVADA|AZ|CA|UT),/,$1,$2,$3,$4,$5,"$6",$7,$8,$9,$10,"$11",$12,$13,$14,$15,"$16",$17,$18,$19,$20,$21,$22,$23,/' | perl -pe 's/,(NV|NEVADA|AZ|CA|UT),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),(NV|NEVADA|CA|NY|AZ|UT),([0-9]*),([0-9]*),([0-9]*),([A-z \*\#\/\.\-\(\)'\'']+),([A-z \*\#\/\.\-\(\)'\'']+),/,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,"$13,$14",/' | perl -pe 's/,(NV|NEVADA|AZ|CA|UT),([0-9\-\\]+),([^,]*),([^,]*),([^,]*),([^,]*),(.*?),([^,]*),(NV|NEVADA|CA|NY|AZ|UT),([0-9\-\\]+),/,$1,$2,$3,$4,$5,$6,"$7",$8,$9,$10,/' | awk 'BEGIN{FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)"}(NF!=90){print}'  > PRAMS_SPECIMENS_NOT_90.csv

#
#wc -l PRAMS_SPECIMENS_2*
#    5372 PRAMS_SPECIMENS_2016_1.csv
#    6043 PRAMS_SPECIMENS_2016_10.csv
#    5773 PRAMS_SPECIMENS_2016_11.csv
#    5749 PRAMS_SPECIMENS_2016_12.csv
#    5534 PRAMS_SPECIMENS_2016_2.csv
#    6022 PRAMS_SPECIMENS_2016_3.csv
#    5432 PRAMS_SPECIMENS_2016_4.csv
#    5814 PRAMS_SPECIMENS_2016_5.csv
#    6154 PRAMS_SPECIMENS_2016_6.csv
#    5833 PRAMS_SPECIMENS_2016_7.csv
#    6780 PRAMS_SPECIMENS_2016_8.csv
#    6457 PRAMS_SPECIMENS_2016_9.csv
#    6240 PRAMS_SPECIMENS_2017_1.csv
#    5318 PRAMS_SPECIMENS_2017_2.csv
#    5858 PRAMS_SPECIMENS_2017_3.csv
#   88379 total
#	88379 total records
#
#	ls PRAMS_SPECIMENS_201* | wc -l
#	15
#	minus 15 header lines ( 88364 )
#
#	awk -F, '{print NF}' PRAMS_SPECIMENS_2* | sort | uniq -c
#  70977 90
#  16204 91
#   1145 92
#     28 93
#     23 94
#      2 96
#
#	Corrected and grouped
#  70962 90
#  17402 90+	( 19.7% are corrupted )
#
