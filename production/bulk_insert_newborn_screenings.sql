
--
-- I had to convert these malformed csv files into malformed psv files
-- to get bulk import to correctly import the contents.
-- awk -f /cygdrive/z/Renown\ Project/CHIRP/Personal\ folders/Jake/chirp/scripts/csv_prepare_for_bulk_insert.awk September\ 2015.csv > September\ 2015.csv.psv
--


DECLARE @bulk_cmd VARCHAR(1000);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\July 2015.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\August 2015.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\September 2015.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\October 2015.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\November 2015.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\December 2015.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\January 2016.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\February 2016.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\March 2016.csv.psv''
WITH (
  FIELDTERMINATOR = ''|'',
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);


