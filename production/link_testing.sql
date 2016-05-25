
#	Link Looking (Don't use LEFT JOIN as that will include all birth records)



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


SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b

--> 5670


SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s
  ON b.bth_date = s.birth_date

--> 4321

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
	SET @str = REPLACE(REPLACE(REPLACE(@str
		,'''','')
		,' ','')
		,'-','')
	RETURN @str
END
GO


SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
WHERE b.mom_snam <> s.mom_surname

--> 545

SELECT COUNT(DISTINCT b.cert_year_num)
FROM vital.births b
JOIN health_lab.newborn_screenings s 
	ON b.bth_date = s.birth_date 
	AND b.mom_dob = s.mom_birth_date
	AND CAST(b.mom_rzip AS VARCHAR) = s.zip_code
WHERE REPLACE(b.mom_snam,' ','') <> REPLACE(s.mom_surname,' ','')

--> 500


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





SELECT b.id, b.cert_year_num, s.id, 
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
WHERE ( bin.strip(b.name_sur) <> bin.strip(s.last_name)
	AND bin.strip(b.mom_snam) <> bin.strip(s.mom_surname)
	AND bin.strip(b.maiden_n) <> bin.strip(s.mom_surname) )



