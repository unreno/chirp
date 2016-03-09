/*



--REPLACE will replace ALL matches so be as specific as possible.
--REPLACE ( string_expression , string_pattern , string_replacement )
--STUFF in conjunction with CharIndex and Len is more powerful.
--STUFF ( character_expression , start , length , replaceWith_expression )

UPDATE dbo.concepts
SET code = REPLACE(code, 'vital_records:', '')


DECLARE @find varchar(8000)
SELECT @find='Replace this'
UPDATE myTable
SET myCol=Stuff(myCol, CharIndex(@find, myCol), Len(@find), 'Replacement text')

print STUFF( 'abcdefcdgh', CharIndex('cd','abcdefcdgh'), Len('cd'), 'NewStuff')
-> abNewStuffefcdgh




DECLARE @code VARCHAR(255)
SET @code = 'vital_records:birth:action_flag_comments'
PRINT CharIndex(':',@code)
PRINT CharIndex(':',@code,CharIndex(':',@code)+1)
PRINT STUFF(@code, 1, CharIndex(':',@code,CharIndex(':',@code)+1)-1, 'BC')
...
14
20
BC:action_flag_comments


UPDATE dbo.concepts
SET code = STUFF(code, 1, CharIndex(':',code,CharIndex(':',code)+1)-1, 'BC')
WHERE code LIKE 'vital_records:birth%'
--Sadly, this will violate some code uniqueness

UPDATE dbo.concepts
SET code = STUFF(code, 1, CharIndex(':',code), '')
WHERE code LIKE 'vital_records:%'


*/
