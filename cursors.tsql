
-- Simple CURSOR loop with a single FETCH

DECLARE abc CURSOR FOR SELECT * FROM renowns;

OPEN abc;
WHILE(1=1)BEGIN
   FETCH abc;
   IF(@@FETCH_STATUS <> 0)
     BREAK
   print 'hello'
END
CLOSE abc;
DEALLOCATE abc;
GO

