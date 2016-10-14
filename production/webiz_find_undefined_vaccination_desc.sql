
SELECT DISTINCT vaccination_desc, c.code, c.value, c.units 
FROM webiz.immunizations i
LEFT JOIN dbo.dictionary d
	ON  d._schema = 'webiz'
	AND d._table = 'immunizations'
	AND d.field = 'vaccination_desc'
 LEFT JOIN dbo.codes c
	ON  c._schema = 'webiz'
	AND c._table = 'immunizations'
	AND d.codeset = c.codeset
	AND CAST(c.code AS VARCHAR(255)) = vaccination_desc
WHERE units IS NULL 





DELETE FROM dbo.codes WHERE _schema = 'webiz'

DECLARE @bulk_cmd VARCHAR(1000)

ALTER TABLE dbo.codes ADD CONSTRAINT temp_schema_default DEFAULT 'webiz' FOR _schema;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_table_default DEFAULT 'immunizations' FOR _table;
ALTER TABLE dbo.codes ADD CONSTRAINT temp_codeset_default DEFAULT 'vaccination_desc' FOR codeset;
SET @bulk_cmd = 'BULK INSERT dbo.bulk_insert_codes_with_units
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\webiz\immunizations\vaccination_desc.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
ALTER TABLE dbo.codes DROP CONSTRAINT temp_schema_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_table_default;
ALTER TABLE dbo.codes DROP CONSTRAINT temp_codeset_default;



