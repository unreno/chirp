
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

SELECT d.field, d.label, d.definition, d.codeset, c.code, c.value, g.group_count
FROM dbo.dictionary d
LEFT JOIN dbo.codes c
ON d._table = c._table AND d.codeset = c.codeset
LEFT JOIN #group_counts g
ON g.field = d.field AND g.value = CAST(c.code AS VARCHAR(255))
WHERE d._table = 'births'
ORDER BY d.field, CAST(c.code AS INT)


