

--	So, apparently one cannot do 

SELECT COUNT( DISTINCT col1, col2, col3, ... ) FROM MyTable

--	One must find an alternative, like ...

SELECT COUNT( DISTINCT col1 + col2 + col3 ) FROM MyTable

--	However, if they are not all strings, will likely have to CAST 

SELECT COUNT( DISTINCT CAST(col1 AS VARCHAR(255)) + CAST(col2 AS VARCHAR(255)) + CAST(col3 AS VARCHAR(255)) ) FROM MyTable


--	If any could by NULL, would complicate things

--	CAST(col1 AS VARCHAR(255)) would change to something like

--	CAST(ISNULL(col1,'') AS VARCHAR(255))

