/*
1. View is a virtual table contents are defined by a query. A view consists of a set of named columns and rows of data. 
Benefits: to simplify data manipulation. Views enable to create a backward compatible interface for a table when its chema changes.
To customize data: views let different users to see data in different ways.

2. Data cannot be modified through Views.

3. Stored procedure: it groups one or more Transact_SQL statements into a logical unit, stored as an object in a SQL Server database.
Beneffit: Increase database security; faster execution; reduce network traffic for large queries.

4. View doesn't accept parameters, can be used as a building block in large query; can only contain one single Select query; can't perform modification to any table.
SP: Accept paramentters; cannot be used as a building block in large query; can contain several statement like if, else,etc.;can perform modification to one or several table.

5. Function: must return a value; not allow to use DML statement; not allow use try-catch bolck;not allow transaction; not allow using temporary table vairables.
SP:may not return values; allow use DML statement; can use try catch bolck; can use transaction within SP; can use both table variables as well as temporary table in it.

6. Stored procedure can return mutiple result sets.

7. Procedures can't be called from SELECT/WHERE/HAVING and so on. 
Execute/Exec statement can be used to call Stored Procedure.

8. Trigger: a type of stored procedure that get executed when a s[ecific event happens.
Type: DML triggers; DDL triggers; Logon triggers

9. Enforce integrity beyond simple referential integrity; implement business rules;
maintian audit record of changes; accomplish cascading updates and deletes.

10. triggers: it can execute automatically based on the events; it can't take input as parameter; we can't use transaction inside triger; it can return value.
SP: It can be invoked explivitly by the user; it can take input as a parameter; we can use transation like Begin Tran, commit, rollbackinside stored procedure.

*/

--Queries:
--1. 
BEGIN TRAN
SELECT * FROM Region with (HOLDLOCK)
SELECT * FROM Territories with (HOLDLOCK)
SELECT * FROM EmployeeTerritories with (HOLDLOCK)
INSERT INTO Region(RegionDescription) VALUES('Middle Earth')
INSERT INTO EmployeeTerritories( VALUES('Gondor',5)
INSERT INTO Employees VALUES('Middle Earth')



--2. 
UPDATE Territories
SET TerritoryDescription = 'Arnor'
WHERE TerritoryDescription = 'Gondor'
IF @@ERROR<>0
ROLLBACK
ELSE BEGIN

--3. 
DELETE FROM EmployeeTerritories 
WHERE TerritoryID = (SELECT TerritoryID FROM Territories WHERE TerritoryDescription = 'Arnor')
DELETE FROM Territories
WHERE TerritoryDescription = 'Arnor'
DELETE FROM Region
WHERE RegionDescription = 'Middel Earth'
IF @@ERROR <>0
ROLLBACK
ELSE BEGIN
COMMIT

--4. 
CREATE VIEW view_product_order_yang 
AS
SELECT p.ProductName, SUM(od.Quantity) AS Order_qyt
FROM Products p
JOIN [Order Details] od
ON p.ProductID = od.ProductID
GROUP BY p.ProductName

--5.
CREATE PROCEDURE sp_product_order_quantity_yang
@ProductId int
@Order_qyt int OUT
AS
SELECT @Order_qyt = SUM(od.Quantity)
FROM Products p
JOIN [Order Details] od
ON p.ProductID = od.ProductID
WHERE P.ProductID = @ProductID
GROUP BY p.ProductName

--6.
ALTER PROCEDURE sp_product_order_city_yang
@ProductName nvarchar(40)
AS
SELECT TOP 5 s.City
FROM Products p
JOIN [Order Details] od
ON p.ProductID = od.ProductID
INNER JOIN Suppliers s
ON s.SupplierID = p.SupplierID
WHERE p.ProductName = @ProductName
GROUP BY s.City, p.ProductName
ORDER BY SUM(od.Quantity) DESC
END

--7. 
BEGIN TRAN
select * from Region
select * from Territories
select * from Employees
select * from EmployeeTerritories
GO
CREATE PROCEDURE sp_move_employees_yang
(@TerritoryDescription nvarchar(50),
@EmployeeId int)
AS
IF EXISTS (
SELECT *
FROM Employees e
JOIN EmployeeTerritories et
ON e.EmployeeID = et.EmployeeID
INNER JOIN Territories t
ON et.TerritoryID = t.TerritoryID
WHERE t.TerritoryDescription = @TerritoryDescription) 
BEGIN 
DECLARE @TerritotyID INT
SELECT @TerritotyID = MAX(TerritoryID) FROM Territories
BEGIN TRAN
	INSERT INTO Territories VALUES (@TerritotyID+1, 'Stevens Point', 3)
	UPDATE Employees SET TerritoryID = @TerritotyID+1
	WHERE EmployeeID = @EmployeeId
IF @@ERROR <> 0
BEGIN
ROLLBACK
END
ELSE
COMMIT
END
END

--8. 
CREATE TRIGGER tr_move_employeees_yang
ON EmployeeTerritories
FOR INSERT
AS
DECLARE @EmpNum INT
SELECT @EmpNum = COUNT(*)
FROM EmployeeTerritories et
WHERE et.TerritoryID IN
(SELECT TerritoryID FROM Territories
WHERE TerritoryDescription = 'Stevens Point')
GROUP BY et.EmployeeID
IF (@EmpNum > 100)
BEGIN
UPDATE EmployeeTerritories
SET TerritoryID = (SELECT TerritoryID FROM Territories WHERE TerritoryDescription = 'Troy')
WHERE EmployeeID IN(
SELECT EmployeeID FROM EmployeeTerritories et JOIN Territories t ON t.TerritoryID  = et.TerritoryID
WHERE t.TerritoryDescription = 'Stevens Point')
END

DROP TRIGGER tr_move_employeees_yang
Commit

--9.
CREATE TABLE people_yang
(Id int, Name nvarchar(50), City int)
CREATE TABLE city_yang
(Id int, City nvarchar(50))

BEGIN TRAN
INSERT INTO people_yang VALUES (1, 'Aaron Rodgers', 2)
INSERT INTO people_yang VALUES (2, 'Russell Wilson', 1)
INSERT INTO people_yang VALUES (3, 'Jody Nelson', 2)

INSERT INTO city_yang VALUES (1,'Seattle')
INSERT INTO city_yang VALUES (2,'Green Bay')

IF EXISTS (SELECT Id FROM people_yang WHERE City = (
SELECT City FROM city_yang WHERE City = 'Seattle'))
BEGIN
INSERT INTO city_yang VALUES (3,'Seattle')
UPDATE people_yang
SET City = 'Madison'
WHERE Id IN (SELECT Id FROM people_yang WHERE City = (
SELECT City FROM city_yang WHERE City = 'Seattle'))
END
DELETE FROM city_yang WHERE City = 'Seattle'

CREATE VIEW Packers_yang
AS
SELECT Name FROM people_yang WHERE City = (
SELECT City FROM city_yang WHERE City = 'Green Bay')

SELECT * FROM Packers_yang
COMMIT
DROP TABLE people_yang
DROP TABLE city_yang
DROP VIEW Packers_yang

--10. 
CREATE PROC sp_birthday_employee_yang
AS
BEGIN 
SELECT * INTO #EmployeeTemp
FROM Employees WHERE DATEPART(MM,BirthDate) = 02
SELECT * FROM #EmployeeTemp
END

--11. 
CREATE PROC sp_yang_1
AS
BEGIN 
SELECT City FROM CUSTOMERS
GROUP BY City
HAVING COUNT(*)>2
INTERSECT
SELECT City FROM Customers c JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY od.ProductID, c.CustomerID, c.City
HAVING COUNT(*) BETWEEN 0 AND 1
END
GO

CREATE PROC sp_yang_2
AS
BEGIN
SELECT City FROM CUSTOMERS
WHERE CITY IN (
SELECT City FROM Customers C JOIN Orders O ON O.CustomerID=C.CustomerID 
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY OD.ProductID,C.CustomerID,City
HAVING COUNT(*) BETWEEN 0 AND 1)
GROUP BY City
HAVING COUNT(*)>2
END
GO

--12. Using EXCEPT

/*
14. 
SELECT FirstName + ' ' + LastName FROM table WHERE MiddleName IS NULL
UNION
SELECT FirstName+ ' ' + LastName + ' ' + MiddleName FROM table WHERE MiddleName IS NOT NULL

15. 
SELECT TOP 1 Marks
FROM table
WHERE Sex = 'F'
ORDER BY Marks DESC

16. 
SELECT * FROM table 
ORDER BY Marks, Sex