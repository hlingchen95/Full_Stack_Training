-- 1.List all cities that have both Employees and Customers.

SELECT DISTINCT c.City 
FROM Customers c JOIN Employees e ON c.City = e.City

SELECT DISTINCT city
FROM Customers 
WHERE city IN (SELECT city From Employees)

-- 2.List all cities that have Customers but no Employee.

-- a.Use sub-query
SELECT DISTINCT city
FROM Customers 
WHERE city NOT IN (SELECT city FROM Employees)


-- b.Do not use sub-query
SELECT DISTINCT c.City 
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.City IS NULL

-- 3.List all products and their total order quantities throughout all orders.

SELECT p.ProductName, SUM(od.Quantity)
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName

-- 4.List all Customer Cities and total products ordered by that city.

SELECT DISTINCT c.City, SUM(od.Quantity)
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID 
GROUP BY c.City

-- 5.List all Customer Cities that have at least two customers.

--a.Use union
SELECT c.City, COUNT(c.CustomerID) CustomerCount
FROM Customers c 
GROUP BY c.City
HAVING COUNT(c.CustomerID) > 2
UNION
SELECT c.City, COUNT(c.CustomerID) CustomerCount
FROM Customers c 
GROUP BY c.City
HAVING COUNT(c.CustomerID) = 2
--b.Use sub-query and no union
SELECT DISTINCT c.City
FROM Customers c 
WHERE c.City IN (SELECT u.City FROM Customers u GROUP BY u.City HAVING COUNT(u.City) >= 2)


--6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(od.ProductID) AS ProductCount
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(od.ProductID) >= 2

-- 7.List all Customers who have ordered products, but have the �ship city� on the order different from their own customer cities.
SELECT DISTINCT c.ContactName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.City != o.ShipCity


-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 p.ProductName, AVG(od.UnitPrice)
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID 
GROUP BY p.ProductName


WITH cte_ordersc
as(
SELECT oc.ShipCity,oc.ProductID, oc.average,DENSE_RANK() over (partition by
oc.ProductID order by oc.number) rnk FROM (
SELECT TOP(5) od.ProductID,o.ShipCity, SUM(Quantity) number,AVG(od.UnitPrice)
average FROM dbo.Orders o left join dbo.[Order Details] od on o.OrderID=od.OrderID
GROUP BY o.ShipCity, od.ProductID
ORDER BY number DESC
) oc
)
select * from cte_ordersc where rnk=1

-- 9.List all cities that have never ordered something but we have employees there.

-- a.Use sub-query
SELECT e.City FROM Employees e
WHERE e.City NOT IN (
SELECT c.City FROM Orders o JOIN Customers c ON c.CustomerID = o.CustomerID)

-- b.Do not use sub-query
SELECT DISTINCT e.City 
FROM Employees e LEFT JOIN Customers c ON e.City = c.City
WHERE c.City is null


-- 10.List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

SELECT * 
FROM (SELECT Top 1 e.City, COUNT(o.OrderID) countOrder 
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.City) T1 
JOIN (SELECT Top 1 c.City, COUNT(r.Quantity) countQuantity 
FROM [Order Details] r JOIN Orders d ON r.OrderID = d.OrderID JOIN Customers c ON c.CustomerID = d.CustomerID 
GROUP BY c.City) T2 ON T1.City = T2.City;

--11. How do you remove the duplicates record of a table?
--Find duplicate rows using GROUP BY clause or ROW_NUMBER() function.
--Use DELETE statement to remove the duplicate rows.
















