
DECLARE @a VARCHAR(50) ='18551234 BARINGUNIT##1403';

PRINT 'Full string:  ' + @a
PRINT 'Length: ' + CAST(LEN(@a) AS VARCHAR)
--	CHARINDEX is 1 based

PRINT 'Index of first space: ' + CAST( ISNULL(NULLIF(CHARINDEX(' ',@a), 0), LEN(@a) + 1 ) AS VARCHAR)
PRINT 'Index of second space: ' +CAST( 
	ISNULL(NULLIF(CHARINDEX(' ',@a,
	ISNULL(NULLIF(CHARINDEX(' ',@a),0),-1)+1), 0), LEN(@a) + 1)
	AS VARCHAR)
PRINT 'Num chars between spaces: ' + CAST( 
	ISNULL(NULLIF(CHARINDEX(' ',@a,
	ISNULL(NULLIF(CHARINDEX(' ',@a),0),-1)+1), 0), LEN(@a)) 
	- ISNULL(NULLIF(CHARINDEX(' ',@a), 0), LEN(@a) ) - 1
AS VARCHAR)


PRINT	'Chars before first space :' + SUBSTRING(@a, 1,
		ISNULL(NULLIF(CHARINDEX(' ',@a)-1,-1),LEN(@a)) ) + ':'
PRINT 'Chars between spaces:' + SUBSTRING(@a,
	ISNULL(NULLIF(CHARINDEX(' ',@a), 0), LEN(@a) )+1,
	ISNULL(NULLIF(CHARINDEX(' ',@a,
	ISNULL(NULLIF(CHARINDEX(' ',@a),0),-1)+1), 0), LEN(@a) + 1) 
	- ISNULL(NULLIF(CHARINDEX(' ',@a), 0), LEN(@a) ) - 1
)+':'

PRINT 'Char after second space :' + 
	SUBSTRING(@a,
	ISNULL(NULLIF(CHARINDEX(' ',@a,
	ISNULL(NULLIF(CHARINDEX(' ',@a),0),-1)+1), 0) + 1, LEN(@a) + 1),
	
			LEN(@a) ) + ':'
--	deving for use in address parsing
