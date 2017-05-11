
-- if just one grouping, something like the following works
-- (COUNT(*) * 100. / SUM(COUNT(*)) OVER()) AS [percent]


USE AdventureWorks2012;
GO
SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER(PARTITION BY SalesOrderID) AS Total
    ,CAST(1. * OrderQty / SUM(OrderQty) OVER(PARTITION BY SalesOrderID) 
        *100 AS DECIMAL(5,2))AS "Percent by ProductID"
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID IN(43659,43664);
GO


-- if multiple groupings, include them in the PARTITION BY clause
-- COUNT(*) * 100. / SUM(COUNT(*)) OVER(PARTITION BY o1.value, o2.value) AS [percent]
