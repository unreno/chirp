
--	Link Looking (Don't use LEFT JOIN as that will include all birth records)

-- FYI NO SEX/GENDER in newborn screening data
-- FYI NO COUNTY in newborn screening data


SELECT COUNT(1) FROM health_lab.newborn_screenings
--> 159818

SELECT COUNT(DISTINCT kit_number) FROM health_lab.newborn_screenings
--> 53239

SELECT COUNT(DISTINCT accession_number) FROM health_lab.newborn_screenings
--> 53317

SELECT COUNT(1) FROM (
	SELECT DISTINCT accession_number, kit_number FROM health_lab.newborn_screenings
) x
--> 53317

-- Not sure what's so special about 3. Perhaps 3 spots per kit?
SELECT kit_number, COUNT(DISTINCT accession_number) FROM health_lab.newborn_screenings
GROUP BY kit_number HAVING COUNT(DISTINCT accession_number) > 1
--> 78 kits have 2 accession numbers


-- Washoe County Zip Codes

SELECT COUNT(*) FROM health_lab.newborn_screenings
WHERE zip_code IN ( '89402', '89405', '89412', '89424', '89431', '89432', '89433', '89434', '89435', '89436', '89439', '89441', '89442', '89450', '89451', '89452', '89501', '89502', '89503', '89504', '89505', '89506', '89507', '89508', '89509', '89510', '89511', '89512', '89513', '89515', '89519', '89520', '89521', '89523', '89533', '89555', '89557', '89570', '89595', '89599', '89704' )
--> 22724


SELECT COUNT(DISTINCT kit_number) FROM health_lab.newborn_screenings
WHERE zip_code IN ( '89402', '89405', '89412', '89424', '89431', '89432', '89433', '89434', '89435', '89436', '89439', '89441', '89442', '89450', '89451', '89452', '89501', '89502', '89503', '89504', '89505', '89506', '89507', '89508', '89509', '89510', '89511', '89512', '89513', '89515', '89519', '89520', '89521', '89523', '89533', '89555', '89557', '89570', '89595', '89599', '89704' )
--> 7570



SELECT MIN(birth_date) FROM health_lab.newborn_screenings
WHERE zip_code IN ( '89402', '89405', '89412', '89424', '89431', '89432', '89433', '89434', '89435', '89436', '89439', '89441', '89442', '89450', '89451', '89452', '89501', '89502', '89503', '89504', '89505', '89506', '89507', '89508', '89509', '89510', '89511', '89512', '89513', '89515', '89519', '89520', '89521', '89523', '89533', '89555', '89557', '89570', '89595', '89599', '89704' )
--> 1983-05-09

-- Note 126 with birth dates from 1983-05-09 - 2011-12-12
-- Note First birth date in range is 2015-04-09 - 2016-03-29

SELECT COUNT(DISTINCT kit_number) FROM health_lab.newborn_screenings
WHERE zip_code IN ( '89402', '89405', '89412', '89424', '89431', '89432', '89433', '89434', '89435', '89436', '89439', '89441', '89442', '89450', '89451', '89452', '89501', '89502', '89503', '89504', '89505', '89506', '89507', '89508', '89509', '89510', '89511', '89512', '89513', '89515', '89519', '89520', '89521', '89523', '89533', '89555', '89557', '89570', '89595', '89599', '89704' )
AND YEAR(birth_date) = 2015
--> 5428

SELECT COUNT(DISTINCT kit_number) FROM health_lab.newborn_screenings
WHERE zip_code IN ( '89402', '89405', '89412', '89424', '89431', '89432', '89433', '89434', '89435', '89436', '89439', '89441', '89442', '89450', '89451', '89452', '89501', '89502', '89503', '89504', '89505', '89506', '89507', '89508', '89509', '89510', '89511', '89512', '89513', '89515', '89519', '89520', '89521', '89523', '89533', '89555', '89557', '89570', '89595', '89599', '89704' )
AND birth_date between '2015-04-10' AND '2015-12-31'
--> 5428

SELECT COUNT(1) FROM vital.births
WHERE bth_date between '2015-04-10' AND '2015-12-31'
--> 4015


SELECT 
	b.name_sur, s.last_name, 
	b.mom_snam, s.mom_surname, 
	b.mom_fnam, s.mom_first_name, 
	b.maiden_n, s.mom_maiden_name, 
	b.mom_dob, s.mom_birth_date
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code


-- All birth records
SELECT COUNT(1) FROM vital.births
--> 5670

-- Matches dob.
SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s
  ON b.bth_date = s.birth_date
--> 4321

-- Matched dob, mom's dob and a zip
SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
--> 2803



IF OBJECT_ID ( 'bin.strip', 'FN' ) IS NOT NULL 
  DROP FUNCTION bin.strip;
GO
CREATE FUNCTION bin.strip( @str VARCHAR(255) )
	RETURNS VARCHAR(255)
BEGIN
	SET @str = REPLACE(@str,'''','')
	SET @str = REPLACE(@str, ' ','')
	SET @str = REPLACE(@str, '-','')
--	SET @str = REPLACE(@str,'RR','R')
--	SET @str = REPLACE(@str,'LL','L')
	RETURN @str
END
GO


-- Quick check of the misses

-- Matched dob, mom's dob and a zip, but mom's surname not exact
SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
WHERE b.mom_snam <> s.mom_surname
--> 545

-- Matched dob, mom's dob and a zip, but mom's surname not exact
SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
WHERE REPLACE(b.mom_snam,' ','') <> REPLACE(s.mom_surname,' ','')
--> 500

-- Matched dob, mom's dob and a zip, but mom's surname not exact
SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
WHERE bin.strip(b.mom_snam) <> bin.strip(s.mom_surname)
--> 356


-- Searching for matches now


SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND bin.strip(b.mom_snam) = bin.strip(s.mom_surname)

--> 2463

SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( bin.strip(b.mom_snam) = bin.strip(s.mom_surname)
		OR bin.strip(b.maiden_n) = bin.strip(s.mom_surname) )

--> 2504

SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( bin.strip(b.name_sur) = bin.strip(s.last_name)
		OR bin.strip(b.mom_snam) = bin.strip(s.mom_surname)
		OR bin.strip(b.maiden_n) = bin.strip(s.mom_surname) )

--> 2605

SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( DIFFERENCE(bin.strip(b.name_sur),bin.strip(s.last_name)) = 4
		OR DIFFERENCE(bin.strip(b.mom_snam),bin.strip(s.mom_surname)) = 4
		OR DIFFERENCE(bin.strip(b.maiden_n),bin.strip(s.mom_surname)) = 4
)
--> 2766 (2803 would be perfect!)

SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( DIFFERENCE(b.name_sur,s.last_name) = 4
		OR DIFFERENCE(b.mom_snam,s.mom_surname) = 4
		OR DIFFERENCE(b.maiden_n,s.mom_surname) = 4
)

--> 2735 ( the stripping helps a bit, so put it back )

SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( DIFFERENCE(bin.strip(b.name_sur),bin.strip(s.last_name)) = 4
		OR DIFFERENCE(bin.strip(b.mom_snam),bin.strip(s.mom_surname)) = 4
		OR DIFFERENCE(bin.strip(b.maiden_n),bin.strip(s.mom_surname)) = 4
    OR DIFFERENCE(bin.strip(b.maiden_n+b.mom_snam),bin.strip(s.mom_surname)) = 4
)

--> Still 2766 ? I expected that the merging of maiden and surname would help


SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( DIFFERENCE(bin.strip(b.name_sur),bin.strip(s.last_name)) = 4
		OR DIFFERENCE(bin.strip(b.mom_snam),bin.strip(s.mom_surname)) = 4
		OR DIFFERENCE(bin.strip(b.maiden_n),bin.strip(s.mom_surname)) = 4
    OR DIFFERENCE(b.maiden_n+b.mom_snam,s.mom_surname) = 4
)

--> Still 2776! Stripping out the hyphen hurts, apparently.

SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( DIFFERENCE(bin.strip(b.name_sur),bin.strip(s.last_name)) = 4
		OR DIFFERENCE(bin.strip(b.mom_snam),bin.strip(s.mom_surname)) = 4
		OR DIFFERENCE(bin.strip(b.maiden_n),bin.strip(s.mom_surname)) = 4
    OR DIFFERENCE(b.maiden_n+b.mom_snam,s.mom_surname) = 4 
		OR bin.strip(b.name_sur) = bin.strip(s.last_name)
		OR bin.strip(b.maiden_n) = bin.strip(s.last_name)
		OR bin.strip(b.mom_snam) = bin.strip(s.mom_surname)
		OR bin.strip(b.maiden_n) = bin.strip(s.mom_surname) 
		OR bin.strip(b.name_sur) = bin.strip(s.last_name + s.mom_surname)
		OR bin.strip(b.maiden_n+b.name_sur) = bin.strip(s.last_name)
		OR bin.strip(b.maiden_n+b.name_sur) = bin.strip(s.mom_surname)
		OR bin.strip(b.maiden_n+b.mom_snam) = bin.strip(s.last_name)
		OR bin.strip(b.maiden_n+b.mom_snam) = bin.strip(s.mom_surname)
	)

--> 2777 



-- Checking screening duplication. I was expecting triple 2605. Not even double? And not the same.
-- This counting is misleading due to the joining.

SELECT COUNT(DISTINCT s.accession_number)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( bin.strip(b.name_sur) = bin.strip(s.last_name)
		OR bin.strip(b.mom_snam) = bin.strip(s.mom_surname)
		OR bin.strip(b.maiden_n) = bin.strip(s.mom_surname) )

--> 4645

SELECT COUNT(DISTINCT s.kit_number)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
	AND ( bin.strip(b.name_sur) = bin.strip(s.last_name)
		OR bin.strip(b.mom_snam) = bin.strip(s.mom_surname)
		OR bin.strip(b.maiden_n) = bin.strip(s.mom_surname) )

--> 4639





--	b.bth_date AS birth_dob
--	s.birth_date AS screen_dob
--	b.mom_dob AS birth_mom_dob,
--	s.mom_birth_date AS screen_mom_dob,
-- Look for misses so can match
SELECT 
	b.mom_fnam AS birth_mom_first,
	b.name_sur AS birth_last,
	b.mom_snam AS birth_mom_last,
	b.maiden_n AS birth_mom_maiden,
	NULL AS divider,
	s.last_name AS screen_last,
	s.mom_surname AS screen_mom_last,
	s.mom_maiden_name AS screen_mom_maiden,
	s.mom_first_name AS screen_mom_first
FROM vital.births b
JOIN health_lab.newborn_screenings s
	ON b.bth_date = s.birth_date
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
WHERE ( bin.strip(b.name_sur) <> bin.strip(s.last_name)
	AND bin.strip(b.maiden_n) <> bin.strip(s.last_name)
	AND bin.strip(b.mom_snam) <> bin.strip(s.mom_surname)
	AND bin.strip(b.maiden_n) <> bin.strip(s.mom_surname) 
	AND bin.strip(b.name_sur) <> bin.strip(s.last_name + s.mom_surname)
	AND bin.strip(b.maiden_n+b.name_sur) <> bin.strip(s.last_name)
	AND bin.strip(b.maiden_n+b.name_sur) <> bin.strip(s.mom_surname)
	AND bin.strip(b.maiden_n+b.mom_snam) <> bin.strip(s.last_name)
	AND bin.strip(b.maiden_n+b.mom_snam) <> bin.strip(s.mom_surname)
	AND DIFFERENCE(bin.strip(b.mom_snam), bin.strip(s.mom_surname)) <> 4
  AND DIFFERENCE(bin.strip(b.name_sur),bin.strip(s.last_name)) <> 4
  AND DIFFERENCE(bin.strip(b.maiden_n),bin.strip(s.mom_surname)) <> 4
  AND DIFFERENCE(b.maiden_n+b.mom_snam,s.mom_surname) <> 4
)


SELECT 
	b.mom_fnam AS birth_mom_first,
	b.name_sur AS birth_last,
	b.maiden_n AS birth_mom_maiden,
	b.mom_snam AS birth_mom_last,
	NULL AS divider,
	s.mom_surname AS screen_mom_last,
	s.last_name AS screen_last,
	s.mom_maiden_name AS screen_mom_maiden,
	s.mom_first_name AS screen_mom_first
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
WHERE DIFFERENCE(bin.strip(b.mom_snam), bin.strip(s.mom_surname)) = 4

-- FYI Some kit_numbers are associated with multiple accession_numbers
-- For example ...

SELECT * FROM health_lab.newborn_screenings 
WHERE kit_number = 'NV1421039631'



--> Sadly, these are being doubly matched. For example 

SELECT 
b.cert_year_num, s.id, s.kit_number, s.accession_number,
  b.mom_fnam AS birth_mom_first,
  b.name_sur AS birth_last,
  b.maiden_n AS birth_mom_maiden,
  b.mom_snam AS birth_mom_last,
  NULL AS divider,
  s.mom_surname AS screen_mom_last,
  s.last_name AS screen_last,
  s.mom_maiden_name AS screen_mom_maiden,
  s.mom_first_name AS screen_mom_first
FROM vital.births b
JOIN health_lab.newborn_screenings s
  ON b.bth_date = s.birth_date
  AND b.mom_dob = s.mom_birth_date
  AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
  AND ( DIFFERENCE(bin.strip(b.name_sur),bin.strip(s.last_name)) = 4
    OR DIFFERENCE(bin.strip(b.mom_snam),bin.strip(s.mom_surname)) = 4
    OR DIFFERENCE(bin.strip(b.maiden_n),bin.strip(s.mom_surname)) = 4
    OR DIFFERENCE(b.maiden_n+b.mom_snam,s.mom_surname) = 4
    OR bin.strip(b.name_sur) = bin.strip(s.last_name)
    OR bin.strip(b.maiden_n) = bin.strip(s.last_name)
    OR bin.strip(b.mom_snam) = bin.strip(s.mom_surname)
    OR bin.strip(b.maiden_n) = bin.strip(s.mom_surname)
    OR bin.strip(b.name_sur) = bin.strip(s.last_name + s.mom_surname)
    OR bin.strip(b.maiden_n+b.name_sur) = bin.strip(s.last_name)
    OR bin.strip(b.maiden_n+b.name_sur) = bin.strip(s.mom_surname)
    OR bin.strip(b.maiden_n+b.mom_snam) = bin.strip(s.last_name)
    OR bin.strip(b.maiden_n+b.mom_snam) = bin.strip(s.mom_surname)
  )
WHERE b.mom_fnam = 'Rodica'
order by b.cert_year_num

-- Twins.
SELECT * FROM vital.births
WHERE cert_year_num IN ('2015-17668','2015-17669')

SELECT * FROM health_lab.newborn_screenings
WHERE mom_first_name = 'RODICA'

-- Observation suggests that the screening patient id is the 
-- birth record's inf_hospnum / ########
-- It is unclear what the second half is. Not mom's hospnum, any ssn, date


