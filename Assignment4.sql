-- 1.Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.

CREATE VIEW view_product_order_Chen AS
SELECT p.ProductName, SUM(od.Quantity) QuantityCount
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY  p.ProductName

SELECT * FROM view_product_order_Chen

-- 2.Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.

--Create sp using return
CREATE PROC sp_product_order_quantity_Chen1 
@id int
AS
BEGIN
DECLARE @quantity AS int
SELECT @quantity = od.Quantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE p.ProductID = @id
RETURN @quantity
END
--Test sp
BEGIN
DECLARE @result int
EXEC @result = sp_product_order_quantity_Chen1 1
PRINT @result
END

--Create sp using out, it still worked
CREATE PROC sp_product_order_quantity_Chen 
@id int,
@quantity int out
AS
BEGIN
SELECT @quantity = od.Quantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE p.ProductID = @id
END
--Test sp
BEGIN 
DECLARE @quantity int
EXEC sp_product_order_quantity_Chen 1, @quantity output
PRINT @quantity
END

-- 3. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and 
--    top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.

-- Create sp table 
CREATE PROC sp_product_order_city_Chen 
@Name varchar(20)
AS
BEGIN
SELECT TOP 5 o.ShipCity, SUM(od.Quantity) AS TotalQuantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON od.OrderID = o.OrderID 
WHERE p.ProductName = @Name
GROUP BY o.ShipCity
ORDER BY TotalQuantity DESC
END
--Test
BEGIN
EXEC sp_product_order_city_Chen [Alice Mutton]
END


--  4. Create 2 new tables “people_your_last_name” “city_your_last_name”. 
--     City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
--     People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
--     Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. 
--     Create a view “Packers_your_name” lists all people from Green Bay. 
--     If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.

-- Create table people
CREATE TABLE people_Chen(
	id int primary key,
	Name varchar (20) not null,
	City int foreign key references city_Chen(id) on delete set NULL
)
DROP TABLE people_Chen
--Create table city
CREATE TABLE city_Chen(
	id int primary key,
	city varchar (20)
)

--Insert values into city table
INSERT INTO city_Chen VALUES (1, 'Seattle')
INSERT INTO city_Chen VALUES (2, 'Green Bay')

SELECT * FROM city_Chen

--Insert values into people table
INSERT INTO people_Chen VALUES (1, 'Aaron Rodgers', 2)
INSERT INTO people_Chen VALUES (2, 'Russell Wilson', 1)
INSERT INTO people_Chen VALUES (3, 'Jody Nelson', 2)

SELECT * FROM people_Chen

--Create view
CREATE VIEW Packers_Chen AS
SELECT p.Name
FROM people_Chen p Join city_Chen c ON p.City = c.id
WHERE c.city = 'Green Bay'
-- Test view
SELECT * FROM Packers_Chen
--DROP tables and views
DROP TABLE people_Chen
DROP TABLE city_Chen
DROP VIEW Packers_Chen


--  5.Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. 
--    (Make a screen shot) drop the table. Employee table should not be affected.


CREATE PROC sp_birthday_employees_Chen AS
BEGIN
SELECT e.EmployeeID
FROM Employees e
WHERE MONTH(e.BirthDate) = 2
END

EXEC sp_birthday_employees_Chen


SELECT e.BirthDate
From Employees e

CREATE TABLE birthday_employees_Chen(id int)
DROP TABLE birthday_employees_Chen

 -- 6. How do you make sure two tables have the same data?

 You can compare the two similar tables or data sets using MINUS operator. It returns all rows in table 1 that do not exist or changed in the other table.


