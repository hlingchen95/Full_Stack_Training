-- 1. How many products can you find in the Production.Product table?

SELECT COUNT(*)
FROM Production.Product 

-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
--    The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.

SELECT COUNT(*)
FROM Production.Product p 
WHERE p.ProductSubcategoryID IS NOT NULL

-- 3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
--    ProductSubcategoryID CountedProducts

SELECT p.ProductSubcategoryID, COUNT(p.ProductSubcategoryID) AS CountedProducts
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP By p.ProductSubcategoryID

-- 4. How many products that do not have a product subcategory.
SELECT COUNT(p.ProductSubcategoryID)
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NULL

-- 5.Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT p.ProductID, SUM(p.Quantity) AS ProductSum
FROM Production.ProductInventory p
GROUP BY p.ProductID

-- 6.Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT p.ProductID, SUM(p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE p.LocationID = 40 
GROUP BY p.ProductID
HAVING SUM(p.Quantity) < 100

-- 7.Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT p.Shelf, p.ProductID, SUM(p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE p.LocationID = 40 
GROUP BY p.Shelf, p.ProductID
HAVING SUM(p.Quantity) < 100

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT p.ProductID, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
WHERE p.LocationID = 10
GROUP BY p.ProductID

-- 9.Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory

SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
GROUP BY p.ProductID, p.Shelf

-- 10.Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory

SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
WHERE p.Shelf != 'N/A'
GROUP BY p.ProductID, p.Shelf

-- 11.  List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.

SELECT p.class, p.Color, COUNT(*) AS TheCount, AVG(p.ListPrice) AS AvgPrice
FROM Production.Product p
WHERE p.Class IS NOT NULL ANd p.Color IS NOT NULL
GROUP BY p.Class, p.Color

-- 12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
SELECT c.Name As Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode

-- 13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

SELECT c.Name As Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN('Germany','Canada')

--14.  List all Products that has been sold at least once in last 25 years.

SELECT DISTINCT p.ProductName
FROM Products p JOIN [Order Details] o ON p.ProductID = o.ProductID JOIN Orders r ON r.OrderID = o.OrderID

-- 15.  List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 ShipPostalCode, COUNT(ShipPostalCode) AS countSold 
FROM Orders
GROUP BY ShipPostalCode
ORDER By COUNT(ShipPostalCode) desc

-- 16.  List top 5 locations (Zip Code) where the products sold most in last 25 years.

SELECT TOP 5 ShipPostalCode, COUNT(ShipPostalCode) AS countSold 
FROM Orders
WHERE OrderDate BETWEEN '1995-10-21' and '2020-10-21'
GROUP BY ShipPostalCode
ORDER By COUNT(ShipPostalCode) desc

-- 17.   List all city names and number of customers in that city.   
SELECT City, COUNT(ContactName) AS CustomerInCity
FROM Customers
GROUP BY City

-- 18.  List city names which have more than 2 customers, and number of customers in that city

SELECT City, COUNT(ContactName) AS CustomerInCity
FROM Customers
GROUP BY City
HAVING COUNT(ContactName) > 2

-- 19.  List the names of customers who placed orders after 1/1/98 with order date.

SELECT DISTINCT c.ContactName 
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE OrderDate > '1/1/98'

--20.  List the names of all customers with most recent order dates

SELECT CustomerID, OrderDate 
FROM (select distinct CustomerID, OrderDate ,dense_rank() over (partition by CustomerID order
by orderDate desc) rnk from Orders) dt
WHERE dt.rnk = 1

-- 21.  Display the names of all customers  along with the  count of products they bought

SELECT c.ContactName, COUNT(c.ContactName)
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.ContactName
ORDER BY count(c.ContactName) desc

-- 22.  Display the customer ids who bought more than 100 Products with count of products.

SELECT c.ContactName, sum(r.Quantity) AS productCount
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID JOIN [Order Details] r ON r.OrderID = o.OrderID
GROUP BY c.ContactName
HAVING sum(r.Quantity) > 100
ORDER BY sum(r.Quantity) desc


-- 23.  List all of the possible ways that suppliers can ship their products. Display the results as below

SELECT u.CompanyName, s.CompanyName 
FROM Shippers s CROSS JOIN Suppliers u

-- 24.  Display the products order each day. Show Order date and Product Name.

SELECT DISTINCT r.OrderDate, p.ProductName
FROM Products p JOIN [Order Details] o ON p.ProductID = o.ProductID JOIN Orders r ON r.OrderID = o.OrderID


-- 25.  Displays pairs of employees who have the same job title.

SELECT e.EmployeeID
FROM Employees e JOIN Employees m ON e.Title = m.Title


-- 26.  Display all the Managers who have more than 2 employees reporting to them.
SELECT e.EmployeeID, e.LastName, e.FirstName, e.Title 
FROM Employees e JOIN Employees m ON e.EmployeeID = m.ReportsTo
WHERE e.Title LIKE '%manager%'
GROUP BY e.EmployeeID, e.LastName, e.FirstName, e.Title
HAVING COUNT(m.ReportsTo) > 2

-- 27.  Display the customers and suppliers by city. The results should have the following columns

SELECT city, ContactName, 'Customer' AS Type FROM Customers 
UNION
SELECT city, ContactName, 'Supplier' AS Type FROM Suppliers




