
--
-- I had to convert these malformed csv files into malformed tsv files
-- to get bulk import to correctly import the contents.
-- awk -f /cygdrive/z/Renown\ Project/CHIRP/Personal\ folders/Jake/chirp/scripts/csv_prepare_for_bulk_insert.awk September\ 2015.csv > September\ 2015.csv.tsv
--

DECLARE @bulk_cmd VARCHAR(1000);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\July 2015.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\July 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\August 2015.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\August 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\September 2015.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\September 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\October 2015.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\October 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\November 2015.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\November 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\December 2015.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\December 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\January 2016.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\January 2016.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\February 2016.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\February 2016.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NBS\March 2016.csv.psv''
--  FIELDTERMINATOR = ''|'',
SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\March 2016.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);


