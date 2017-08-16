#!/usr/bin/env perl

use strict;
use warnings;

while (<>) {

	s/Unkown/Unknown/g;	#	mispelled many times

	s/"//g;	#	Only ever used incorrectly as ,BABY BOY "A", which is invalid csv

	s/,([^,]+), ([^,]+),/,"$1, $2",/g;	#	merge if field starts with a space ,something, else, => ,"something, else",

	s/,(False|True),
		([^,]*),(False|True),
		([^,]*),([^,]*),(False|True),
		([^,]*),(False|True),([^,]*),
		(Male|Female|Unknown),
		(.*?),												#	26 Z CollectedBy VARCHAR(20) can contain commas
		([^,]*),([^,]*),
		(Single|Multiple|Unknown),		#	29 AC BirthType VARCHAR(10)
		([^,]*),(False|True|),(False|True|),(False|True|),(False|True|),
	/,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,"$11",$12,$13,$14,$15,$16,$17,$18,$19,/x;

	s/,(Yes|No|Unknown),(Yes|No|Unknown),(Yes|No|Unknown),(Yes|No|Unknown),([^,]*),
		(.*?),												# 50 AX BirthHospitalFacility VARCHAR(50) can contain commas
		([^,]*),([^,]*),([^,]*),(False|True),
		(.*?),												# 55 BC CollectionFacilityFacility can contain commas
		([^,]*),([^,]*),([^,]*),(False|True),
		(.*?),												# 60 BH ReportToFacility can contain commas
		([^,]*),([^,]*),([^,]*),(False|True),([^,]*),([^,]*),
		(NV|NEVADA|AZ|CA|UT),
	/,$1,$2,$3,$4,$5,"$6",$7,$8,$9,$10,"$11",$12,$13,$14,$15,"$16",$17,$18,$19,$20,$21,$22,$23,/x;

	s/,(NV|NEVADA|AZ|CA|UT),						#	67 BO ReportToState VARCHAR(10)
		([0-9\-\\]+),([^,]*),([^,]*),([^,]*),([^,]*),
																			#	68 ReportToZip VARCHAR(10)
																			#	69 MotherLastName VARCHAR(20)
																			#	70 MotherFirstName VARCHAR(20)
																			#	71 BS MotherDOB DATE
																			#	72 MotherMaidenName VARCHAR(10)
		(.*?),														#	73 BU MotherAddress VARCHAR(30)	can contain commas
		([^,]*),													#	74 MotherCity VARCHAR(30)
		(NV|NEVADA|CA|NY|AZ|UT),					#	75 BW MotherState VARCHAR(5) 5? likely never actually NEVADA
		([0-9\-\\]+),
	/,$1,$2,$3,$4,$5,$6,"$7",$8,$9,$10,/x;

	s/,(NV|NEVADA|AZ|CA|UT),						# 67 BO ReportToState VARCHAR(10)
		([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),
		(NV|NEVADA|CA|NY|AZ|UT),					# 75 BW MotherState VARCHAR(5)
		([0-9\\]*),													#	76 MotherZip VARCHAR(10)
		([0-9]*),													#	77 Phone VARCHAR(10)
		([0-9]*),													#	78 BZ EmergencyPhone VARCHAR(10)
		([A-z \*\#\/\.\-\(\)\']+),([A-z \*\#\/\.\-\(\)\']+),
																			#	79 FatherName VARCHAR(30) can contain commas
	/,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,"$13,$14",/x;

} continue {
	print;
}

__END__

./prams_cleanup.pl PRAMS_SPECIMENS_20??_*.csv | awk 'BEGIN{FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)"}(NF!=90){print}'  > PRAMS_SPECIMENS_NOT_90.csv

#	some field actually contain double quotes, but the field isn't double quoted (eg. ,BOY "A",)
#	actually just removing all double quotes so stick with the above
awk 'BEGIN{FPAT = "(\"([^\"]|\"\")*\")|([^,]*)"}(NF!=90){print}'  > PRAMS_SPECIMENS_NOT_90.csv

