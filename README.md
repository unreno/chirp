# CHIRP

## Preparations and TSQL Code for creating a database and warehouse


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

all_lmrp includes ...

```
 -rw-r--r-- 1 jakewendt  25676215 Feb  1 14:10 hcpc_code_lookup.csv
 -rw-r--r-- 1 jakewendt  16776749 Feb  1 14:10 icd10_code_lookup.csv
```

