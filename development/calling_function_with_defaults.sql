

USE chirp

IF OBJECT_ID ( 'random_date_in', 'FN' ) IS NOT NULL
	DROP FUNCTION random_date_in;
GO
CREATE FUNCTION random_date_in(
	@from_date DATE = '2010-01-01', 
	@to_date   DATE = '2015-12-31' )
RETURNS DATE
BEGIN
	DECLARE @rand DECIMAL(18,18)
	SELECT @rand = number FROM rand_view
	RETURN DATEADD(day, 
		@rand*(1+DATEDIFF(DAY, @from_date, @to_date)), 
		@from_date)
END
GO
--NEED to pass 2 params. (default,default) uses the defaults. Duh!

--Create a different function that takes no params
--and have it call the other function with params
IF OBJECT_ID ( 'random_date', 'FN' ) IS NOT NULL
	DROP FUNCTION random_date;
GO
CREATE FUNCTION random_date()
RETURNS DATE
BEGIN
	RETURN dbo.random_date_in(default,default);
END
GO




--This works, but NEED to specify the from and to dates 
--(or (default,default)) for every call.  Lame.  Don't like that.
--
--However, if you need the inline ability...
--It does alleviate the need to declare a variable, set it then use it.
--With functions, you just call the function.

--A workaround is to create a simple function that takes no params 
--and calls the more complex function with the 'default' keyword.

--Ex
--PRINT dbo.random_date()
--PRINT dbo.random_date_in(default,default)


