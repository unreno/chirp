
--There is no error checking here so the query string 
--needs to be perfect to work.
-------------------------------1---a-------------b----------c
DECLARE @query VARCHAR(250) = 'http://example.com/over/there?name=ferret&color=brown&size=7&truncated'
PRINT @query

DECLARE @a INT = CharIndex('://',@query)
PRINT @a
DECLARE @protocol VARCHAR(250) = SUBSTRING(@query,1,@a-1)
PRINT @protocol

DECLARE @b INT = CharIndex('/',@query, @a+3)
PRINT @b
DECLARE @server VARCHAR(250) = SUBSTRING(@query, @a+3, @b-@a-3)
PRINT @server

DECLARE @c INT = CharIndex('?',@query, @b)
PRINT @c
DECLARE @path VARCHAR(250) = SUBSTRING(@query, @b, @c-@b)
PRINT @path

DECLARE @params VARCHAR(250) = SUBSTRING(@query, @c+1, LEN(@query)-@c)
PRINT @params

DECLARE @kvpairs TABLE ( k VARCHAR(250), v VARCHAR(250) )
WHILE(LEN(@params)>0)BEGIN
	DECLARE @eql INT = CharIndex('=',@params)
	IF @eql = 0 SET @eql = LEN(@params)+1
	DECLARE @k VARCHAR(250) = SUBSTRING(@params,1,@eql-1)

	INSERT INTO @kvpairs (k)VALUES(@k)

	DECLARE @amp INT = CharIndex('&',@params,@eql)
	IF @amp = 0 BREAK
	DECLARE @v VARCHAR(250) = SUBSTRING(@params,@eql+1,@amp-@eql-1)
	--PRINT @params
	UPDATE @kvpairs SET v = @v WHERE k = @k
	SET @params = SUBSTRING(@params, @amp+1, LEN(@params))
END

SELECT * FROM @kvpairs



