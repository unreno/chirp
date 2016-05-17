


-- Put this into a development snippet
-- Be sure to define VARCHAR lengths. I think just VARCHAR implies length of 1 (actually it's 30)
-- Does it matter?

DECLARE @x DATE = '12/31/2015'
PRINT CAST(@x AS VARCHAR)
DECLARE @y INT = 123456789
PRINT CAST(@y AS VARCHAR)
DECLARE @z VARCHAR(1000) = '12345678901234567890123456789012345678901234567890'
PRINT CAST(@z AS VARCHAR)
-- => 2015-12-31
-- => 123456789
-- => 123456789012345678901234567890

-- Ah.  VARCHAR has a default length of 30.





