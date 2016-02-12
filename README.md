# CHIRP

## Preparations and TSQL Code for creating a database and warehouse

### i2b2

I have been reviewing the i2b2 CRC Design Document.
It seems to be a good reference, but contains many items
which I would prefer not too use.  As such, it will stay just that.
A reference.

Ultimately, this database will contain a great deal of raw
data acquired from a number of sources.
This raw data will be selected and placed into a star or snowflake
schema data warehouse.

As all/most data warehouses are centered around a fact table,
so shall this one.  This central fact will be an "observation"
much like the i2b2.


From this point on, I am just brainstorming / rambling.



Observation (fact)
* Of What/Whom? (patient dimension [NO IDENTIFIABLE INFO])
* Who made this observation? (provider dimension [doctor,nurse,???])
* Where was this observation made? (visit dimension [WalGreens,Renown Hospital,ER,???])
* When was this observation made? (time dimension / visit dimension?)
* What observation was made? (concept dimension)
* How was this observation made? (not sure what I mean here)
* value of observation (several fields actually)


Observation "concepts" are things that change.
I suppose in practice, every attribute on a birth certificate
and any other type of observation
needs to be accurately recordable in this system.
What don't we record?
* height
* weight
* race
* income
* vaccination
* surgery
* cholesterol level
* pulse
* blood pressure
* just visited doctor to say hello?
* broken arm
* ICD10 codes
* incarcerated?
* changed address?  (perhaps just zip code)
* changed phone number?  (unlikely)
* sex (it can change)


i2b2 has sex, religion, and vital status part of the patient dimension
and language and race as part of the visit dimension.
I'm not sure that I agree with that.


1 visit, 1 patient, 1 (or more?) provider(s), MANY observations and concepts



ICD-10
Diagnosic (CM)
ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Publications/ICD10CM/2014/ICD10CM-FY2014_OrderFiles.zip
ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Publications/ICD10CM/2016/ICD10CM_FY2016_code_descriptions.zip
( code file exactly the same from 2016 and 2014.  Still HCPCS ICD10 file better. )

Procedural (PCS) This is huge and not as explicitly defined.
https://www.cms.gov/Medicare/Coding/ICD10/Downloads/2016-PCS-Code-Tables.zip



ICD-9 (both diagnostic and procedural)
https://www.cms.gov/Medicare/Coding/ICD9ProviderDiagnosticCodes/Downloads/cmsv31-master-descriptions.zip
https://www.cms.gov/Medicare/Coding/ICD9ProviderDiagnosticCodes/Downloads/ICD-9-CM-v32-master-descriptions.zip
( codes exactly the same here from v31 to v32 )


CPT / HCPCS
https://downloads.cms.gov/medicare-coverage-database/downloads/exports/all_lmrp.zip


LOINC (this is even huger!) LOINC_2.54.zip
http://loinc.org/downloads/files/loinc-and-relma-complete-download/loinc-and-relma-complete-download-file/download



Local Coverage Determination [LCD] or Local Coverage Documents
Medicare Coverage Database [MCD] 
Local Medical Review Policies [LMRPs],
https://downloads.cms.gov/medicare-coverage-database/downloads/exports/all_lmrp.zip
All CPT codes are HCPCS codes, but not all HCPCS codes are CPT codes.
all_lmrp includes 
-rw-r--r-- 1 jakewendt  25676215 Feb  1 14:10 hcpc_code_lookup.csv
-rw-r--r-- 1 jakewendt  16776749 Feb  1 14:10 icd10_code_lookup.csv






Meddling locally with postgres ...

sudo mkdir -p /opt/local/var/db/postgresql95/defaultdb
sudo chown postgres:postgres /opt/local/var/db/postgresql95/defaultdb
sudo chown postgres:postgres /opt/local/var/db/postgresql95
sudo su postgres -c '/opt/local/lib/postgresql95/bin/initdb -D /opt/local/var/db/postgresql95/defaultdb' 
sudo su postgres -c '/opt/local/lib/postgresql95/bin/pg_ctl -D /opt/local/var/db/postgresql95/defaultdb -l /opt/local/var/db/postgresql95/logfile start'

sudo port select postgresql postgresql95

sudo su postgres -c 'createdb jakewendt; createuser --superuser jakewendt;'

psql


psql < crc_create_datamart_postgresql.sql






