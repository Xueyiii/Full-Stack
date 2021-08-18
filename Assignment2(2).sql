--14.	List all Products that has been sold at least once in last 25 years.
SELECT p.ProductName
FROM Products p JOIN [Order Details] od
ON p.ProductID = od.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID
WHERE DATEDIFF(year, o.OrderDate, getdate()) < 25

--15.	List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 ShipPostalCode AS ZipCode
FROM Orders
GROUP BY ShipPostalCode
HAVING ShipPostalCode IS NOT NULL
ORDER BY ShipPostalCode

--16.	List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 ShipPostalCode AS ZipCode
FROM Orders
WHERE DATEDIFF(year, Orders.OrderDate, getdate()) < 25
GROUP BY ShipPostalCode
HAVING ShipPostalCode IS NOT NULL
ORDER BY ShipPostalCode

--17.	 List all city names and number of customers in that city.     
SELECT City, COUNT(ContactName) AS Number
FROM Customers
GROUP BY City

--18.	List city names which have more than 2 customers, and number of customers in that city 
SELECT City, COUNT(ContactName) AS Number
FROM Customers
GROUP BY City
HAVING COUNT(ContactName) > 2

--19.	List the names of customers who placed orders after 1/1/98 with order date.
SELECT ContactName
FROM Customers c JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate BETWEEN '1998/01/01' AND GETDATE()

--20.	List the names of all customers with most recent order dates 
SELECT c.ContactName, o.Orderdate AS OrderDate
FROM Customers c jOIN Orders o on c.CustomerID = o.CustomerID 
GROUP BY c.ContactName, o.OrderDate

--21.	Display the names of all customers  along with the  count of products they bought 
SELECT c.ContactName, SUM(od.Quantity) AS Number
FROM Customers c jOIN Orders o on c.CustomerID = o.CustomerID 
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName

--22.	Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID
FROM Customers c jOIN Orders o on c.CustomerID = o.CustomerID 
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE od.Quantity > 100

--23.	List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT u.CompanyName AS SupplierCompanyName, s.CompanyName AS ShippingCompanyName
FROM Shippers s CROSS JOIN Suppliers u

--24.	Display the products order each day. Show Order date and Product Name.
SELECT DISTINCT p.ProductName, o.OrderDate
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID

--25.	Displays pairs of employees who have the same job title.
SELECT e.LastName, e.FirstName, e.Title
FROM Employees e JOIN Employees m ON e.Title = m.Title

--26.	Display all the Managers who have more than 2 employees reporting to them.
SELECT DISTINCT e.LastName, e.FirstName, e.Title
FROM Employees e JOIN Employees m ON e.EmployeeID = m.ReportsTo

--27.	Display the customers and suppliers by city. The results should have the following columns
SELECT City, CompanyName AS Name, ContactName, 'Customer' AS Tpye
FROM Customers
UNION
SELECT City, CompanyName AS Name, ContactName, 'Supplier' AS Type
FROM Suppliers

-- 28. Have two tables T1 and T2. Please write a query to inner join these two tables and write down the result of this query.
-- SELECT * FROM T1 INNER JOIN T2 ON F1.T1 = F2.T2
--Result will be 2,3

-- 29. Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
-- SELECT * FROM T1 LEFT JOIN T2 ON F1.T1 = F2.T2
--Reslut will be 1,2,3,4
