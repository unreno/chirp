
-- Create group_counts table
IF OBJECT_ID('tempdb..#group_counts', 'U') IS NOT NULL
DROP TABLE #group_counts
CREATE TABLE #group_counts( field VARCHAR(255), value VARCHAR(255), group_count INT )

-- Group by every field (very excessive)
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




---- Blanks
--SELECT @SQL = (
--	SELECT 'INSERT INTO #group_counts (field,group_count) ' +
--		'SELECT ''' + name + ''' AS field, ' +
--		'COUNT(*) AS group_count ' +
--		'FROM vital.births WHERE ' + name + ' IS NULL OR CAST(' + name + ' AS VARCHAR) = '''';'
--	FROM sys.columns
--	WHERE object_id = OBJECT_ID('vital.births')
--	FOR XML PATH ('')
--);
--EXECUTE sp_executesql @SQL;
---- Blank and Not Blank
--SELECT @SQL = (
--	SELECT 'INSERT INTO #group_counts (field,value,group_count) ' +
--		'SELECT field, value, COUNT(*) as group_count FROM (' +
--			'SELECT ''' + name + ''' AS field, ' +
--			'CASE WHEN ''' + name + ''' IS NULL OR CAST(''' + name + ''' AS VARCHAR) = '''' ' +
--				'THEN ''Blank'' ELSE ''Not Blank'' END AS value' +
--			'FROM vital.births ' +
--		') GROUP BY value'
--	FROM sys.columns
--	WHERE object_id = OBJECT_ID('vital.births')
--	FOR XML PATH ('')
--);
--EXECUTE sp_executesql @SQL;

---- Coded and Not Coded
--SELECT @SQL = (
--	SELECT 'INSERT INTO #group_counts (field,value,group_count) ' +
--		'SELECT field, value, COUNT(*) as group_count FROM (' +
--			'SELECT ''' + name + ''' AS field, ' +
--			'CASE WHEN ''' + value + ''' IS IN ( ' +
--				'SELECT code FROM dbo.codes c JOIN dbo.dictionary d ON c.codeset = d.codeset ' +
--			') THEN ''Coded'' ELSE ''Not Coded'' END AS value' +
--			'FROM vital.births ' +
--		') GROUP BY value'
--	FROM sys.columns
--	WHERE object_id = OBJECT_ID('vital.births')
--	FOR XML PATH ('')
--);
--EXECUTE sp_executesql @SQL;





IF OBJECT_ID('tempdb..#dict_counts', 'U') IS NOT NULL
DROP TABLE #dict_counts
CREATE TABLE #dict_counts( field VARCHAR(255), label VARCHAR(255), description VARCHAR(MAX),
	codeset VARCHAR(255), code VARCHAR(255), value VARCHAR(255), group_count INT )


-- Insert all dictionary fields joined with every coded value and count
INSERT INTO #dict_counts
	SELECT d.field, d.label, d.description, d.codeset, c.code, c.value, g.group_count
	FROM dbo.dictionary d
	LEFT JOIN dbo.codes c
	ON d._table = c._table AND d.codeset = c.codeset
	LEFT JOIN #group_counts g
	ON g.field = d.field AND g.value = CAST(c.code AS VARCHAR(255))
	WHERE d._table = 'births'


--INSERT INTO #dict_counts
--SELECT d.field, d.label, d.description, d.codeset, 'Not Coded','Not Coded', g.group_count
--FROM dbo.dictionary d
--LEFT JOIN #group_counts g
--ON g.field = d.field AND g.value = 'Not Coded'
--WHERE d._table = 'births'



-- Set group_count to 0 for those values that weren't actually used (NULL).
UPDATE #dict_counts
	SET group_count = 0 
	WHERE group_count IS NULL and codeset IS NOT NULL


-- Set value for NULL counts?
UPDATE #dict_counts
	SET group_count = g.group_count
	FROM #dict_counts d
	INNER JOIN #group_counts g ON ( g.field = d.field AND g.value IS NULL )
	WHERE d.group_count IS NULL and d.codeset IS NULL

--SELECT * FROM #dict_counts ORDER BY field, code


-- Blank and Not Blank -- THIS COMMAND IS TOO LONG!
-- To do this, I think that I need to use a CURSOR and loop through each field.
--SELECT @SQL = (
--	SELECT 'INSERT INTO #dict_counts (field,label,description,codeset,code,value,group_count) ' +
--		'SELECT f,l,d,s,c,v,COUNT(*) as group_count FROM (' +
--			'SELECT ''' + name + ''' AS f, ' +
--				'd.label AS l, ' +
--				'd.description AS d, ' +
--				'd.codeset AS s, ' +
--				'''Presence'' AS c, ' +
--				'CASE WHEN ''' + name + ''' IS NULL OR CAST(''' + name + ''' AS VARCHAR) = '''' ' +
--					'THEN ''Blank'' ELSE ''Not Blank'' END AS v ' +
--			'FROM vital.births b LEFT JOIN dbo.dictionary d ON ''' + name + ''' = d.field ' +
--		') tmp GROUP BY f,l,d,s,c,v; '
--	FROM sys.columns
--	WHERE object_id = OBJECT_ID('vital.births')
--	FOR XML PATH ('')
--);
--EXECUTE sp_executesql @SQL;




---- Coded and Not Coded
---- Probably going to need to use a CURSOR here as well.
--SELECT @SQL = (
--	SELECT 'INSERT INTO #dict_counts (field,label,description,codeset,code,value,group_count) ' +
--		'SELECT field, label, description, codeset, code, value, COUNT(*) as group_count FROM ( ' +
--			'SELECT ''' + name + ''' AS b.field, ' +
--				'd.label AS label, ' +
--				'd.description AS description, ' +
--				'd.codeset AS codeset, ' +
--				'''Codeness'' AS code, ' +
--				'CASE WHEN ''' + value + ''' IS IN ( ' +
--					'SELECT code FROM dbo.codes c JOIN dbo.dictionary d ON c.codeset = d.codeset ' +
--				') THEN ''Coded'' ELSE ''Not Coded'' END AS value ' +
--			'FROM vital.births ' +
--		') GROUP BY value; '
--	FROM sys.columns
--	WHERE object_id = OBJECT_ID('vital.births')
--	FOR XML PATH ('')
--);
--EXECUTE sp_executesql @SQL;






-- Simple (field, label, description, description, codeset, [if codeset, valid codes and values]).
-- No groupings. No counts.


SELECT field, 
		ISNULL(label,'') AS label, 
		ISNULL(description,'') AS description, 
		ISNULL(codeset,'') AS codeset,
		code, value
--		ISNULL(CAST(code AS VARCHAR(255)),'Blank') AS code, 
--		ISNULL(value,'Blank') AS value,
		group_count
	FROM #dict_counts
	ORDER BY field, code		-- CAST(code AS INTEGER)




