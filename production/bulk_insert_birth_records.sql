
--FROM ''C:\Users\gwendt\Desktop\Data\NSBR\Washoe_2015.csv.psv''
--  FIELDTERMINATOR = ''|'',

DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT vital.bulk_insert_births
FROM ''C:\Users\gwendt\Desktop\Data\NSBR\Washoe_2015.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

--FROM ''C:\Users\gwendt\Desktop\Data\NSBR\Washoe_2016a.csv.psv''
--  FIELDTERMINATOR = ''|'',

SET @bulk_cmd = 'BULK INSERT vital.bulk_insert_births
FROM ''C:\Users\gwendt\Desktop\Data\NSBR\Washoe_2016a.csv.tsv''
WITH (
  ROWTERMINATOR = '''+CHAR(10)+''',
  FIRSTROW = 2,
  TABLOCK
)';
EXEC(@bulk_cmd);

