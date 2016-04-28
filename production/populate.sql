
BEGIN TRY
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT dev.names
	FROM ''C:\Users\gwendt\Desktop\1000_most_common_female_name_in_US.csv''
	WITH (
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = '''+CHAR(10)+''',
		TABLOCK
	)';
	EXEC(@bulk_cmd);
END TRY BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

BEGIN TRY
	SET @bulk_cmd = 'BULK INSERT dev.names
	FROM ''C:\Users\gwendt\Desktop\1000_most_common_male_name_in_US.csv''
	WITH (
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = '''+CHAR(10)+''',
		TABLOCK
	)';
	EXEC(@bulk_cmd);
END TRY BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

BEGIN TRY
	SET @bulk_cmd = 'BULK INSERT dev.names
	FROM ''C:\Users\gwendt\Desktop\1000_most_common_last_name_in_US.csv''
	WITH (
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = '''+CHAR(10)+''',
		TABLOCK
	)';
	EXEC(@bulk_cmd);
END TRY BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH



--BULK INSERT requires a format file? for column selection
--Using a view works just as well.
IF OBJECT_ID ( 'dbo.cc', 'V' ) IS NOT NULL
	DROP VIEW dbo.cc;
GO
CREATE VIEW dbo.cc AS SELECT code, path, description FROM dbo.concepts;
GO


-- ll *concept_codes.csv
-- -rwx------ 1 jakewendt  2105675 Mar 17 12:59 hcpc_concept_codes.csv
-- -rwx------ 1 jakewendt  7869583 Mar 17 12:59 icd10dx_concept_codes.csv
-- -rwx------ 1 jakewendt  1023195 Apr 28 13:04 icd10pcs_concept_codes.csv
-- -rwx------ 1 jakewendt  1223532 Mar 17 12:59 icd9dx_concept_codes.csv
-- -rwx------ 1 jakewendt   267271 Mar 17 12:59 icd9sg_concept_codes.csv
-- -rwx------ 1 jakewendt 16960137 Mar 17 12:59 ndc_concept_codes.csv
-- cat *concept_codes.csv > ../all_concept_codes.csv

--UNIX line feeds don\'t work well in MS so need dynamic sql 
--However, ALL the double quotes in the description are preserved
--This would require a series of UPDATEs, STUFFs and/or REPLACEs.
--Still faster that dealing with SSIS.
BEGIN TRY
	--A GO call apparently undeclare variables, so redeclare here
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT cc
	FROM ''C:\Users\gwendt\Desktop\all_concept_codes.csv''
	WITH (
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = '''+CHAR(10)+''',
		TABLOCK
	)';
	EXEC(@bulk_cmd);
END TRY BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH
IF OBJECT_ID ( 'dbo.cc', 'V' ) IS NOT NULL
	DROP VIEW dbo.cc;	-- only needed this for the import.
GO

--
-- FIXED
--
--The ICD10PCS codes weren't trimmed far enough so will end
--up with a leading double quote. Removing it here.
--UPDATE dbo.concepts
--	SET path = STUFF(path, 1,1,'')
--	WHERE path LIKE '"%';


-- some of these records are actually wrapped in a quotes
-- ->"blah blah blah ""something quoted"" blah blah"<-
-- so replace the wrappers together

UPDATE dbo.concepts
	SET description = SUBSTRING ( description, 2, LEN(description)-2 )
	WHERE description LIKE '"%"';

-- and the double double quotes LAST
-- ->blah blah blah ""something quoted"" blah blah<-
UPDATE dbo.concepts
	SET description = REPLACE(description, '""', '"')
	WHERE description LIKE '%""%';

