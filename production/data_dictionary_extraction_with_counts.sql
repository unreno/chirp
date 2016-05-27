
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
EXEC( @SQL )


IF OBJECT_ID('tempdb..#dict_counts', 'U') IS NOT NULL
DROP TABLE #dict_counts
CREATE TABLE #dict_counts( field VARCHAR(255), label VARCHAR(255), description VARCHAR(MAX),
	codeset VARCHAR(255), code VARCHAR(255), value VARCHAR(255), group_count INT )


-- Insert all dictionary fields joined with every coded value and count
INSERT INTO #dict_counts
	SELECT d.field, d.label, d.description, d.codeset, c.code, c.value, g.group_count
	FROM dbo.dictionary d
	JOIN dbo.codes c
--	Using a LEFT JOIN will include NULLs for those without a codeset
--	LEFT JOIN dbo.codes c
	ON d._table = c._table AND d.codeset = c.codeset
	LEFT JOIN #group_counts g
	ON g.field = d.field AND g.value = CAST(c.code AS VARCHAR(255))
	WHERE d._table = 'births'


-- Insert all dictionary fields joined with every NOT coded value and count
INSERT INTO #dict_counts
	SELECT g.field, d.label, d.description, d.codeset, g.value AS code,
		bin.decode('vital','births',g.field,g.value) AS value,g.group_count
	FROM #group_counts g
	LEFT JOIN dbo.dictionary d
		ON d.field = g.field
	WHERE d._table = 'births'
		AND d.codeset IS NOT NULL
		AND g.value = bin.decode('vital','births',g.field,g.value)



-- Add the Blank / Not Blank counts for non-coded fields
INSERT INTO #dict_counts
	SELECT field,label,description,codeset,code,value,SUM(group_count) 
	FROM ( SELECT g.field, d.label, d.description, d.codeset, NULL AS code, 
		CASE WHEN CAST(g.value AS VARCHAR(255)) = '' THEN 'Blank'
			WHEN g.value IS NULL THEN 'Blank'
			ELSE 'Not Blank'
		END AS value, g.group_count
		FROM #group_counts g
		LEFT JOIN dbo.dictionary d
			ON d.field = g.field
		WHERE d._table = 'births'
			AND d.codeset IS NULL
	) xyz GROUP BY field,label,description,codeset,code,value


-- Set group_count to 0 for those values that weren't actually used (NULL).
UPDATE #dict_counts
	SET group_count = 0 
	WHERE group_count IS NULL and codeset IS NOT NULL


-- Set value for NULL counts?
-- Only needed if used LEFT JOIN above
--UPDATE #dict_counts
--	SET group_count = g.group_count
--	FROM #dict_counts d
--	INNER JOIN #group_counts g ON ( g.field = d.field AND g.value IS NULL )
--	WHERE d.group_count IS NULL and d.codeset IS NULL


SELECT field, 
		ISNULL(label,'') AS label, 
		ISNULL(description,'') AS description, 
		ISNULL(codeset,'') AS codeset,
		code, value,
		group_count AS count
	FROM #dict_counts
	WHERE group_count > 0
	ORDER BY field, CAST(code AS INTEGER)

