

IF OBJECT_ID('testcopy', 'U') IS NOT NULL
	DROP TABLE testcopy;
CREATE TABLE testcopy( code varchar(255),extra text );
GO

INSERT INTO testcopy (code)
	SELECT DISTINCT 'ICD10:'+icd10_code_id
	FROM lmrp.icd10_code_lookup;
    
INSERT INTO testcopy (code)
	SELECT DISTINCT 'HCPC:'+hcpc_code_id
	FROM lmrp.hcpc_code_lookup;
    
SELECT COUNT(*) FROM testcopy;
SELECT * FROM testcopy;

