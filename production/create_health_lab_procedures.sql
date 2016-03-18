USE chirp
GO

IF OBJECT_ID ( 'dbo.create_newborn_screening_for_each_birth_record', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.create_newborn_screening_for_each_birth_record;
GO
CREATE PROCEDURE dbo.create_newborn_screening_for_each_birth_record
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO health_lab.newborn_screening
		( name_first, name_last, date_of_birth, sex )
		SELECT name_first, name_last, date_of_birth, sex
		FROM vital_records.birth

END
GO

