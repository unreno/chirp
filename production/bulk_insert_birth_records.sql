
DECLARE @bulk_cmd VARCHAR(1000);

SET @bulk_cmd = 'BULK INSERT vital.bulk_insert_births
FROM ''C:\Users\gwendt\Desktop\Data\NSBR\Washoe_2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
ALTER TABLE vital.births
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'Washoe_2015.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE vital.births
	DROP CONSTRAINT temp_source_filename;

SET @bulk_cmd = 'BULK INSERT vital.bulk_insert_births
FROM ''C:\Users\gwendt\Desktop\Data\NSBR\Washoe_2016a.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
ALTER TABLE vital.births
	ADD CONSTRAINT temp_source_filename
	DEFAULT 'Washoe_2016a.csv.tsv' FOR source_filename;
EXEC(@bulk_cmd);
ALTER TABLE vital.births
	DROP CONSTRAINT temp_source_filename;

