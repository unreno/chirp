/*

Codes are to be unique, so the second INSERT fails and triggers a rollback because XACT_ABORT is ON.
This could also be handled by wrapping everything in some TRY/CATCH code and manually calling ROLLBACK in the CATCH block.

SET XACT_ABORT (Transact-SQL)
Specifies whether SQL Server automatically rolls back the current transaction when a Transact-SQL statement raises a run-time error.

*/
DELETE FROM concepts WHERE code LIKE 'TEST%'
SELECT COUNT(*) FROM concepts;

BEGIN TRANSACTION
	SET XACT_ABORT ON
	INSERT INTO [dbo].[concepts] VALUES (
		'TEST:1',
		'/TEST/1',
		'Just testing');
	INSERT INTO [dbo].[concepts] VALUES (
		'TEST:1',
		'/TEST/1',
		'Just testing');
;
GO
SELECT COUNT(*) FROM concepts;





BEGIN TRANSACTION [Tran1]
	BEGIN TRY
		INSERT INTO [dbo].[concepts] VALUES (
			'TEST:1',
			'/TEST/1',
			'Just testing');
		INSERT INTO [dbo].[concepts] VALUES (
			'TEST:1',
			'/TEST/1',
			'Just testing');
		COMMIT TRANSACTION [Tran1]
	END TRY
	BEGIN CATCH
  	ROLLBACK TRANSACTION [Tran1]
	END CATCH  
GO
