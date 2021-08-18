--Question:
--1. What is a result set?
--Result set is the output of a quary. It could result in a one row, one column output or a 100+ column, million+ row output. 

--2. What is the difference between Union and Union All?
-- Union only keeps unique records, but Union All keeps all records including duplicates.

--3. What are the other Set Operators SQL Server has?
--MINUS, INTERSECT, EXCEPT

--4. What is the difference between Union and Join?
--Union combines the records into new rows, while Join combines the records into new columns.
--By using Union, the data type must be the same in all SELECT statement. By using Join, there is no need to be the same data type. 
--Union: the order and number of the columns must be the same in all tables; Join: the order and number of the columns not need to be the same in all tables.

--5. What is the difference between INNER JOIN and FULL JOIN?
--INNER JOIN: return the matching values in both table
--FULL JOIN: returns all rows from both table, including non-matching rows from both table.

--6. What is difference between left join and outer join?
--LEFT JOIN:returns all records from left table, machted from right table.
--OUTER JOIN is futher subdivided into three types: LEFT OUTRT JOIN, RIGHT OUTER JOIN, and FULL OUTER JOIN.

--7. What is cross join?
--CROSS JOIN is used to generate a paired combination of each row of the firstt table with the each row of the second table.

--8. What is the difference between WHERE clause and HAVING clause?
--WHERE goes before aggregation, HAVING after the aggregation

--9. Can there be multiple group by columns?
--Yes, the results will first be grouped by column1, the by column2.

--Queries:
--1. How many products can you find in the Production.Product table?
SELECT COUNT(ProductNumber)
FROM Production.Product

--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
--The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductNumber)
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(ProductNumber) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

--4. How many products that do not have a product subcategory. 
SELECT COUNT(ProductNumber)
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

--5.	Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity)
FROM Production.ProductInventory

--6. Write a query to list the sum of products in the Production.ProductInventory table and 
--LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100


--7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and
--LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID, Shelf
HAVING SUM(Quantity) < 100

--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT AVG(Quantity)
FROM Production.ProductInventory
WHERE LocationID = 10

--9. Write query to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP By ROLLUP(Shelf, ProductID)

--10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP By ROLLUP(Shelf, ProductID)
HAVING Shelf != 'N/A'

--11.	List the members (rows) and average list price in the Production.Product table. This should be grouped  
--independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color,Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
GROUP BY ROLLUP(Color, Class)
HAVING Color IS NOT NULL AND Class IS NOT NULL

--12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables.
--Join them and produce a result set similar to the following. 
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode

--13.	Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries 
--filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany','Canada')
