



IF OBJECT_ID('tempdb..#all_fields', 'U') IS NOT NULL 
	DROP TABLE #all_fields
CREATE TABLE #all_fields( 
	name VARCHAR(255), type VARCHAR(255), max_length INT )
INSERT INTO #all_fields( name, type, max_length )
	SELECT c.name AS name, t.name AS type, c.max_length 
	FROM sys.columns c
	JOIN sys.types t ON t.system_type_id = c.system_type_id
	WHERE [object_id] = OBJECT_ID('vital.births');

IF OBJECT_ID('tempdb..#dvc', 'U') IS NOT NULL DROP TABLE #dvc;
CREATE TABLE #dvc ( name VARCHAR(255), count INT )
INSERT INTO #dvc 
EXEC bin.distinct_value_counts 'vital', 'births', default 

IF OBJECT_ID('tempdb..#includable', 'U') IS NOT NULL 
	DROP TABLE #includable;
CREATE TABLE #includable ( name VARCHAR(255) )
INSERT INTO #includable (name) 
SELECT trait AS name FROM dbo.decoders;
INSERT INTO #includable (name) 
SELECT DISTINCT trait AS name FROM dbo.codes;
INSERT INTO #includable (name) 
SELECT name FROM #dvc WHERE count < 50;

IF OBJECT_ID('tempdb..#Groups', 'U') IS NOT NULL 
DROP TABLE #Groups
CREATE TABLE #Groups( 
name VARCHAR(255), value VARCHAR(255), group_count INT )



DECLARE @SQL NVARCHAR(MAX) = '';
SELECT @SQL = (
	SELECT 'INSERT INTO #Groups (name,value,group_count) ' +
		'SELECT ''' + name + ''' AS name, ' +
		'CAST(' + name + ' AS VARCHAR) AS value, ' +
		'COUNT(*) AS group_count ' +
		'FROM vital.births GROUP BY ' + name + ' ORDER BY ' + name + ';'
	FROM   sys.columns
	WHERE  object_id = OBJECT_ID('vital.births')
	AND name NOT IN ( 
		SELECT name FROM #all_fields WHERE name NOT IN (
			SELECT name FROM #includable ) )
	AND name NOT IN ( 'cert_yr', 'mom_age', 'ssn_date',
		'birth_yr', 'birth_mo', 'birth_da', 
		'lm_yr', 'lm_mo', 'lm_da', 
		'pre_begyr', 'pre_begmo', 'pre_begda', 
		'pre_endyr', 'pre_endmo', 'pre_endda', 
		'cer_yr', 'cer_mo', 'cer_da',
		'reg_yr', 'reg_mo', 'reg_da', 
		'imported_to_dw', 'imported_at')
	-- concatenate result strings with FOR XML PATH
	FOR XML PATH ('')
);
EXECUTE sp_executesql @SQL;


SELECT name, value, bin.decode('vital','births',name,value) AS decoded, group_count FROM #Groups
WHERE value = bin.decode('vital','births',name,value)


SELECT DISTINCT name FROM #Groups
WHERE value = bin.decode('vital','births',name,value)

