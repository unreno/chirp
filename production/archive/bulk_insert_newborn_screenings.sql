
--
-- I had to convert these malformed csv files into malformed tsv files
-- to get bulk import to correctly import the contents.
-- awk -f /cygdrive/z/Renown\ Project/CHIRP/Personal\ folders/Jake/chirp/scripts/csv_prepare_for_bulk_insert.awk September\ 2015.csv > September\ 2015.csv.tsv
--

DECLARE @bulk_cmd VARCHAR(1000);

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\July 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'July 2015.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\August 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'August 2015.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\September 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'September 2015.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\October 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'October 2015.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\November 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'November 2015.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
FROM ''C:\Users\gwendt\Desktop\Data\NBS\December 2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'December 2015.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\January 2016.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'January 2016.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\February 2016.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'February 2016.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--

SET @bulk_cmd = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
FROM ''C:\Users\gwendt\Desktop\Data\NBS\March 2016.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';

DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0)

ALTER TABLE health_lab.newborn_screenings_buffer
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'March 2016.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE health_lab.newborn_screenings_buffer
	DROP CONSTRAINT temp_source_filename;

--



-- Change this to only insert DISTINCT records? Why have multiples of the same?
-- This would stop the triplification of warehouse import and probably speed things up.
-- How to select the source_record_number while still being DISTINCT?
-- Will need to use another subselect and RANK() OVER(PARTITION BY ORDER BY id desc )

-- Want to Select smallest record number, but all other columns DISTINCT
-- Sadly, can't do DISTINCT(* - source_record_number) so will need to list all columns in DISTINCT()
-- Given that I haven't seen the REAL data yet, this may be moot as it will likely 
-- make these records very NON-DISTINCT so I'll need to import them all anyway.


INSERT INTO health_lab.newborn_screenings SELECT * FROM health_lab.newborn_screenings_buffer
DELETE FROM health_lab.newborn_screenings_buffer


