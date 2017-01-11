


--	On the private machine ...


--	bcp "DECLARE @colnames VARCHAR(max);SELECT @colnames = COALESCE(@colnames + ',', '') + column_name from chirp.INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='observations'; select @colnames;" queryout HeadersOnly.csv -c -T
--
--	#	This misses the very first "
--	#	And adds a " at the very end.
--
--	#	Will need to devise a scripted way to fix this.
--
--	bcp "SELECT * FROM chirp.dbo.observations" queryout DataOnly.csv -c -T -t"\",\"" -r"\"\n\""
--	awk 'BEGIN { FPAT = "(\"([^\"]|\"\")*\")|([^,\"]*)" }{print NF}' DataOnly.csv | sort | uniq -c
--	#	should ALL be 14
--	cat HeadersOnly.csv DataOnly.csv > Observations.csv



--	copy in Observations.csv


--	On the new public machine ....


USE master;
DROP DATABASE chirp;

CREATE DATABASE chirp;
GO
USE chirp;
GO

CREATE TABLE dbo.observations (
	id INT IDENTITY(1,1),
	CONSTRAINT observation_id PRIMARY KEY CLUSTERED (id ASC),
	chirp_id        INT NOT NULL,
	provider_id     INT NOT NULL,
	concept         VARCHAR(255) NOT NULL,
	started_at      DATETIME NOT NULL,
	ended_at        DATETIME,
	value           VARCHAR(255),
	units           VARCHAR(20),
	raw             VARCHAR(255),   --      is "raw" a keyword? sorta so may not be able to use it.
	downloaded_at   DATETIME,
	source_schema   VARCHAR(50) NOT NULL,
	source_table    VARCHAR(50) NOT NULL,
	source_id       INT NOT NULL,
	imported_at     DATETIME
--		CONSTRAINT dbo_observations_imported_at_default 
--		DEFAULT CURRENT_TIMESTAMP NOT NULL,
);
GO

DECLARE @bulk_cmd VARCHAR(MAX) = 'BULK INSERT observations
FROM ''C:\Users\Administrator\Downloads\Observations-20161219.csv.tsv\Observations-20161219.csv.tsv''
WITH
(
	ROWTERMINATOR = ''' + CHAR(10) + ''',
	FIRSTROW = 2,
	TABLOCK
)';
EXEC(@bulk_cmd);
