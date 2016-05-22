
IF OBJECT_ID('tempdb..#group_counts', 'U') IS NOT NULL
DROP TABLE #group_counts
CREATE TABLE #group_counts( field VARCHAR(255), value VARCHAR(255), group_count INT )

DECLARE @SQL NVARCHAR(MAX) = '';
SELECT @SQL = (
	SELECT 'INSERT INTO #group_counts (field,value,group_count) ' +
		'SELECT ''' + name + ''' AS field, ' +
		name + ' AS value, ' +
		'COUNT(*) AS group_count ' +
		'FROM vital.births GROUP BY ' + name + ';'
	FROM sys.columns
	WHERE object_id = OBJECT_ID('vital.births')
	FOR XML PATH ('')
);
EXECUTE sp_executesql @SQL;


---- This may/will include non-coded fields
--SELECT @SQL = (
--	SELECT 'INSERT INTO #group_counts (field,value,group_count) ' +
--		'SELECT ''' + name + ''' AS field, ' +
--		'''Not Coded'' AS value, ' +
--		'COUNT(*) AS group_count ' +
--		'FROM vital.births WHERE ' + name + ' IS NOT IN ( ' +
--			'SELECT code FROM bin.codes(''vital'',''births'',''' + name + ''')' +
--		' );'
---- add and no codeset for field?
--	FROM sys.columns
--	WHERE object_id = OBJECT_ID('vital.births')
--	FOR XML PATH ('')
--);
--EXECUTE sp_executesql @SQL;




-- Blanks
SELECT @SQL = (
	SELECT 'INSERT INTO #group_counts (field,group_count) ' +
		'SELECT ''' + name + ''' AS field, ' +
		'COUNT(*) AS group_count ' +
		'FROM vital.births WHERE ' + name + ' IS NULL OR CAST(' + name + ' AS VARCHAR) = '''';'
	FROM sys.columns
	WHERE object_id = OBJECT_ID('vital.births')
	FOR XML PATH ('')
);
EXECUTE sp_executesql @SQL;

IF OBJECT_ID('tempdb..#dict_counts', 'U') IS NOT NULL
DROP TABLE #dict_counts
CREATE TABLE #dict_counts( field VARCHAR(255), label VARCHAR(255),definition VARCHAR(255),
	codeset VARCHAR(255), code VARCHAR(255), value VARCHAR(255), group_count INT )
--	codeset VARCHAR(255), code INT, value VARCHAR(255), group_count INT )

INSERT INTO #dict_counts
SELECT d.field, d.label, d.definition, d.codeset, c.code, c.value, g.group_count
FROM dbo.dictionary d
LEFT JOIN dbo.codes c
ON d._table = c._table AND d.codeset = c.codeset
LEFT JOIN #group_counts g
ON g.field = d.field AND g.value = CAST(c.code AS VARCHAR(255))
WHERE d._table = 'births'
-- is ordering really necesary?
--ORDER BY d.field, CAST(c.code AS INT)




--INSERT INTO #dict_counts
--SELECT d.field, d.label, d.definition, d.codeset, 'Not Coded','Not Coded', g.group_count
--FROM dbo.dictionary d
--LEFT JOIN #group_counts g
--ON g.field = d.field AND g.value = 'Not Coded'
--WHERE d._table = 'births'




UPDATE #dict_counts
SET group_count = 0 
WHERE group_count IS NULL and codeset IS NOT NULL

UPDATE #dict_counts
SET group_count = g.group_count
FROM #dict_counts d
INNER JOIN #group_counts g ON ( g.field = d.field AND g.value IS NULL )
WHERE d.group_count IS NULL and d.codeset IS NULL

--SELECT * FROM #dict_counts ORDER BY field, code

SELECT field, 
	ISNULL(label,'') AS label, 
	ISNULL(definition,'') AS definition, 
	ISNULL(codeset,'') AS codeset,
	ISNULL(CAST(code AS VARCHAR(255)),'Blank') AS code, 
	ISNULL(value,'Blank') AS value,
	group_count FROM #dict_counts
ORDER BY field, CAST(code AS INTEGER)

