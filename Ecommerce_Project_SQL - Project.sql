use sql_session;

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Email VARCHAR(100),
  Country VARCHAR(50)
);

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  Category VARCHAR(50),
  Price DECIMAL(10, 2)
);

CREATE TABLE Employees (
  EmployeeID INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Position VARCHAR(50),
  Department VARCHAR(50),
  JoinDate DATE
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  OrderDate DATE,
  TotalAmount DECIMAL(10, 2),
  EmployeeID INT,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE OrderDetails (
  OrderDetailID INT PRIMARY KEY,
  OrderID INT,
  ProductID INT,
  Quantity INT,
  Subtotal DECIMAL(10, 2),
  EmployeeID INT,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Country)
VALUES
  (101, 'John', 'Doe', 'john.doe@example.com', 'USA'),
  (102, 'Jane', 'Smith', 'jane.smith@example.com', 'Canada'),
  (103, 'Michael', 'Johnson', 'michael.johnson@example.com', 'USA'),
  (104, 'Emily', 'Williams', 'emily.williams@example.com', 'UK'),
  (105, 'Daniel', 'Brown', 'daniel.brown@example.com', 'Australia');

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
  (1, 'Laptop', 'Electronics', 1000),
  (2, 'Smartphone', 'Electronics', 800),
  (3, 'Chair', 'Furniture', 150),
  (4, 'Tablet', 'Electronics', 400),
  (5, 'Desk', 'Furniture', 250);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Department, JoinDate)
VALUES
  (1, 'David', 'Johnson', 'Manager', 'Sales', '2020-01-15'),
  (2, 'Emily', 'Williams', 'Analyst', 'Marketing', '2021-03-10'),
  (3, 'Daniel', 'Smith', 'Developer', 'IT', '2019-06-20'),
  (4, 'Sarah', 'Jones', 'Analyst', 'Marketing', '2022-02-01'),
  (5, 'James', 'Miller', 'Developer', 'IT', '2020-08-12');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, EmployeeID)
VALUES
  (1, 101, '2023-01-15', 1800, 2),
  (2, 102, '2023-02-10', 950, 3),
  (3, 101, '2023-03-20', 450, 1),
  (4, 103, '2023-04-05', 1200, 4),
  (5, 102, '2023-05-18', 900, 2),
  (6, 105, '2023-06-30', 700, 1),
  (7, 103, '2023-07-12', 850, 3),
  (8, 101, '2023-08-05', 1600, 2),
  (9, 102, '2023-08-15', 1100, 4),
  (10, 104, '2023-08-25', 1650, 1),
  (11, 105, '2023-09-08', 720, 2),
  (12, 101, '2023-09-20', 980, 3),
  (13, 103, '2023-10-02', 570, 4),
  (14, 104, '2023-10-15', 2000, 1),
  (15, 102, '2023-11-05', 850, 2),
  (16, 101, '2023-11-18', 1200, 3),
  (17, 103, '2023-12-10', 920, 4),
  (18, 104, '2023-12-22', 700, 1),
  (19, 102, '2024-01-05', 1100, 2),
  (20, 105, '2024-01-18', 1400, 3);


INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Subtotal, EmployeeID)
VALUES
  (1, 1, 1, 2, 2000, 2),
  (2, 1, 3, 1, 150, 3),
  (3, 2, 2, 1, 800, 1),
  (4, 3, 5, 3, 600, 4),
  (5, 4, 1, 1, 1000, 2),
  (6, 4, 4, 2, 1200, 1),
  (7, 5, 2, 1, 800, 3),
  (8, 6, 5, 1, 200, 2),
  (9, 6, 3, 2, 300, 4),
  (10, 7, 1, 3, 3000, 1),
  (11, 7, 2, 1, 800, 2),
  (12, 8, 4, 4, 2400, 3),
  (13, 8, 3, 2, 300, 4),
  (14, 9, 1, 1, 1000, 1),
  (15, 9, 5, 1, 200, 2),
  (16, 10, 2, 3, 2400, 3),
  (17, 11, 3, 1, 150, 4),
  (18, 11, 4, 1, 600, 1),
  (19, 12, 1, 2, 2000, 2),
  (20, 12, 5, 1, 200, 3);

-- -------------------- QUESTIONS --------------------
-- Q.1 List the total sales amount for each customer, including their first and last names.
SELECT c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSales
FROM customers c
INNER JOIN orders o
	ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

-- Q.2 Find the orders where the total amount is higher than the average total amount of all orders.
SELECT OrderID, OrderDate, TotalAmount
FROM orders
WHERE TotalAmount > (SELECT avg(TotalAmount) FROM orders)
;

-- Q.3 Calculate the total quantity and subtotal for each product in the OrderDetails table.
SELECT o.ProductID, p.ProductName, sum(o.Quantity), sum(o.Subtotal)
FROM orderdetails o
INNER JOIN products p 
	ON o.ProductID = p.ProductID
GROUP BY o.ProductID, p.ProductName;

-- Q.4 Create a report that shows whether an order's total amount is high, medium, or low based on the following ranges: 
-- high (>= 1500), medium (>= 1000), low (< 1000).
SELECT OrderID, TotalAmount,
CASE 
	WHEN TotalAmount >= 1500 THEN 'High'
    WHEN TotalAmount >= 1000 AND TotalAmount < 1500 THEN 'Medium'
    ELSE 'Low'
END AS Category
FROM orders;

-- Q.5 Rank the employees based on the total number of orders they have processed.
SELECT EmployeeID, COUNT(OrderID),
  DENSE_RANK() OVER (ORDER BY COUNT(OrderID) DESC) AS OrderDenseRank,
  RANK() OVER (ORDER BY COUNT(OrderID) DESC) AS OrderRank
FROM orders
GROUP BY EmployeeID;

-- Q.6 List the products that have been ordered more than the average quantity ordered across all products.
SELECT ProductName
FROM products
WHERE ProductID IN 
(
SELECT ProductID
FROM orderdetails
GROUP BY ProductID
HAVING SUM(Quantity) > (SELECT avg(Quantity) from orderdetails)
)
;

-- Q.7 Retrieve the customer details along with the employee first and last name who handled their order.
SELECT  c.FirstName AS CustomerFirstName, c.LastName AS CustomerLastName, 
e.FirstName AS EmployeeFirstName, e.LastName AS EmployeeLastName
FROM customers c
INNER JOIN orders o
	ON c.CustomerID = O.CustomerID
INNER JOIN employees e
	ON o.EmployeeID = e.EmployeeID
GROUP BY c.FirstName, c.LastName , 
e.FirstName , e.LastName 
;

select o.OrderID,c.*,o.EmployeeID,e.FirstName,e.LastName						
from Customers c, Orders o, Employees e						
where o.CustomerID  = c.CustomerID and o.EmployeeID = e.EmployeeID;

-- Q.8 List the total quantity sold and the average price per product category.
SELECT p.Category, SUM(o.Quantity), AVG(p.Price)
FROM products p
INNER JOIN orderdetails o
	ON p.ProductID = o.ProductID
GROUP BY p.Category;

-- Q.9 List the customers who have placed orders more than the average number of orders.
-- Avg no. of orders customers placed
-- Customers who have placed >= Avg. 

SELECT c.FirstName, c.LastName
FROM customers c
WHERE CustomerID IN (
SELECT CustomerID
FROM orders
GROUP BY CustomerID
HAVING Count(OrderId) >
(
SELECT AVG(OrdersCust)
FROM (
SELECT CustomerID, Count(OrderId) AS OrdersCust
FROM orders
GROUP BY CustomerID) a
))
;