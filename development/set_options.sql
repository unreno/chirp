/*


https://www.mssqltips.com/sqlservertip/1415/determining-set-options-for-a-current-session-in-sql-server/


1 	DISABLE_DEF_CNST_CHK 	Controls interim or deferred constraint checking.
2 	IMPLICIT_TRANSACTIONS 	For dblib network library connections, controls whether a transaction is started implicitly when a statement is executed. The IMPLICIT_TRANSACTIONS setting has no effect on ODBC or OLEDB connections.
4 	CURSOR_CLOSE_ON_COMMIT 	Controls behavior of cursors after a commit operation has been performed.
8 	ANSI_WARNINGS 	Controls truncation and NULL in aggregate warnings.
16 	ANSI_PADDING 	Controls padding of fixed-length variables.
32 	ANSI_NULLS 	Controls NULL handling when using equality operators.
64 	ARITHABORT 	Terminates a query when an overflow or divide-by-zero error occurs during query execution.
128 	ARITHIGNORE 	Returns NULL when an overflow or divide-by-zero error occurs during a query.
256 	QUOTED_IDENTIFIER 	Differentiates between single and double quotation marks when evaluating an expression.
512 	NOCOUNT 	Turns off the message returned at the end of each statement that states how many rows were affected.
1024 	ANSI_NULL_DFLT_ON 	Alters the session's behavior to use ANSI compatibility for nullability. New columns defined without explicit nullability are defined to allow nulls.
2048 	ANSI_NULL_DFLT_OFF 	Alters the session's behavior not to use ANSI compatibility for nullability. New columns defined without explicit nullability do not allow nulls.
4096 	CONCAT_NULL_YIELDS_NULL 	Returns NULL when concatenating a NULL value with a string.
8192 	NUMERIC_ROUNDABORT 	Generates an error when a loss of precision occurs in an expression.
16384 	XACT_ABORT 	Rolls back a transaction if a Transact-SQL statement raises a run-time error.


You can also do a before and after check.
If the number changes after setting, then it has changed.
21880
5496
The number changed, so the setting changed. It was ON.
*/

SELECT @@options
SET XACT_ABORT OFF
SELECT @@options




DECLARE @options INT

SELECT @options = @@OPTIONS

PRINT @options
IF ( (1 & @options) = 1 ) PRINT 'DISABLE_DEF_CNST_CHK'
IF ( (2 & @options) = 2 ) PRINT 'IMPLICIT_TRANSACTIONS'
IF ( (4 & @options) = 4 ) PRINT 'CURSOR_CLOSE_ON_COMMIT'
IF ( (8 & @options) = 8 ) PRINT 'ANSI_WARNINGS'
IF ( (16 & @options) = 16 ) PRINT 'ANSI_PADDING'
IF ( (32 & @options) = 32 ) PRINT 'ANSI_NULLS'
IF ( (64 & @options) = 64 ) PRINT 'ARITHABORT'
IF ( (128 & @options) = 128 ) PRINT 'ARITHIGNORE'
IF ( (256 & @options) = 256 ) PRINT 'QUOTED_IDENTIFIER'
IF ( (512 & @options) = 512 ) PRINT 'NOCOUNT'
IF ( (1024 & @options) = 1024 ) PRINT 'ANSI_NULL_DFLT_ON'
IF ( (2048 & @options) = 2048 ) PRINT 'ANSI_NULL_DFLT_OFF'
IF ( (4096 & @options) = 4096 ) PRINT 'CONCAT_NULL_YIELDS_NULL'
IF ( (8192 & @options) = 8192 ) PRINT 'NUMERIC_ROUNDABORT'
IF ( (16384 & @options) = 16384 ) PRINT 'XACT_ABORT' 

/*


5496
ANSI_WARNINGS
ANSI_PADDING
ANSI_NULLS
ARITHABORT
QUOTED_IDENTIFIER
ANSI_NULL_DFLT_ON
CONCAT_NULL_YIELDS_NULL


*/
