
--There is no error checking here so the query string 
--needs to be perfect to work.
-------------------------------1---a-------------b----------c
DECLARE @query VARCHAR(250) = 'http://example.com/over/there?name=ferret&color=brown&size=7&'
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

WHILE(LEN(@params)>0)BEGIN
	DECLARE @eql INT = CharIndex('=',@params)
	DECLARE @amp INT = CharIndex('&',@params)
	DECLARE @k VARCHAR(250) = SUBSTRING(@params,1,@eql-1)
	DECLARE @v VARCHAR(250) = SUBSTRING(@params,@eql+1,@amp-@eql-1)
	--PRINT @params
	PRINT @k + ' = ' + @v
	SET @params = SUBSTRING(@params,CharIndex('&',@params)+1, LEN(@params))
END

