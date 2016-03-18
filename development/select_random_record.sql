


SELECT TOP 1 * FROM table ORDER BY NEWID()





Assuming there is an id or id-like field
Get max. Get min. Select random id in between.
Not an even probablity distribution of selection.

SELECT TOP 1 * FROM table WHERE Id >= @yourrandomid




IF OBJECT_ID ( 'dbo.newidd_view', 'V' ) IS NOT NULL
  DROP VIEW dbo.newid_view;
GO
CREATE VIEW dbo.newid_view AS SELECT NEWID() AS number
GO

In a function
SELECT TOP 1 * FROM table ORDER BY (select number from dbo.newid_view)
