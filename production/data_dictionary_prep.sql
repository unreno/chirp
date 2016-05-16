

IF OBJECT_ID('tempdb..#exclude', 'U') IS NOT NULL 
	DROP TABLE #exclude;
CREATE TABLE #exclude ( name VARCHAR(255) )
INSERT INTO #exclude VALUES ('cert_num'),('fa_dob'),('mom_dob'),('bth_date'),('bth_time'),
	('cer_date'),('grams'),('id'),('lbs'),('oz'),('maiden_n'),
	('mom_fnam'),('mom_mnam'),('mom_snam'),(
	'wt_gain'),('term_dte'),('reg_date'),('prv_livebthdte'),(
	'pre_end'),('pre_begin'),('mom_apt'),('lm_date'),('dat_concep'),(
	'ssn_date'),('name_sur'),('name_sux'),('name_fir'),('name_mid'),(
	'ssn_child'),('inf_hospnum'),('mom_hospnum'),(
	'fa_mname'),('fa_ssn'),('mom_ssn'),('fa_sname'),('fa_xname'),(
	'fa_fname'),( 'cert_year_num'),('mom_address'),(
	'cert_yr'),( 'mom_age'),( 'ssn_date'),(
	'birth_yr'),( 'birth_mo'),( 'birth_da'),(
	'lm_yr'),( 'lm_mo'),( 'lm_da'),(
	'pre_begyr'),( 'pre_begmo'),( 'pre_begda'),(
	'pre_endyr'),( 'pre_endmo'),( 'pre_endda'),(
	'cer_yr'),( 'cer_mo'),( 'cer_da'),(
	'reg_yr'),( 'reg_mo'),( 'reg_da'),(
	'imported_to_dw'),( 'imported_at' )


IF OBJECT_ID('tempdb..#Groups', 'U') IS NOT NULL 
DROP TABLE #Groups
CREATE TABLE #Groups( field VARCHAR(255), value VARCHAR(255), 
	decoded_value VARCHAR(255), group_count INT )

DECLARE @SQL NVARCHAR(MAX) = '';
SELECT @SQL = (
	SELECT 'INSERT INTO #Groups (field,value,decoded_value,group_count) ' +
		'SELECT ''' + name + ''' AS field, ' +
		'CAST(' + name + ' AS VARCHAR(255)) AS value, ' +
		'bin.decode(''vital'',''births'',''' + name + ''',' + name + ') AS decoded_value, ' +
		'COUNT(*) AS group_count ' +
		'FROM vital.births GROUP BY ' + name + ' ORDER BY ' + name + ';'
	FROM sys.columns
	WHERE object_id = OBJECT_ID('vital.births')
	AND name NOT IN ( SELECT name FROM #exclude )
	FOR XML PATH ('')
);
EXECUTE sp_executesql @SQL;


SELECT @SQL = (
	SELECT 'INSERT INTO #Groups (field,value,decoded_value,group_count) ' +
		'SELECT ''' + name + ''' AS field, ' +
		'''Blank'' AS value, ' +
		'''Blank'' AS decoded_value, ' +
		'COUNT(*) AS group_count ' +
		'FROM vital.births WHERE ' + name + ' IS NULL OR ' + name + ' = '''';'
	FROM sys.columns
	WHERE object_id = OBJECT_ID('vital.births')
	AND name IN ( SELECT name FROM #exclude )
	FOR XML PATH ('')
);
EXECUTE sp_executesql @SQL;


SELECT @SQL = (
	SELECT 'INSERT INTO #Groups (field,value,decoded_value,group_count) ' +
		'SELECT ''' + name + ''' AS field, ' +
		'''Not Blank'' AS value, ' +
		'''Not Blank'' AS decoded_value, ' +
		'COUNT(*) AS group_count ' +
		'FROM vital.births WHERE ' + name + ' <> '''';'
	FROM sys.columns
	WHERE object_id = OBJECT_ID('vital.births')
	AND name IN ( SELECT name FROM #exclude )
	FOR XML PATH ('')
);
SET @SQL = REPLACE( @SQL,'&lt;','<')
SET @SQL = REPLACE( @SQL,'&gt;','>')
EXECUTE sp_executesql @SQL;





SELECT * FROM #Groups
ORDER BY field, value, group_count
	
