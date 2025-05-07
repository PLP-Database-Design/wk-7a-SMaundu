--Qs 1.
-- Create a new table to hold the 1NF structure
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Insert data into the 1NF table by splitting the Products column
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, SUBSTRING_INDEX(Products, ',', n)
FROM ProductDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 -- Add more numbers if you anticipate more than 3 products per order
) AS numbers
WHERE SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1) <> '';

-- Display the transformed table
SELECT * FROM ProductDetail_1NF;

--Qs 2
-- Create a new table for Customers to remove the partial dependency
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(255)
);

-- Insert unique customer names into the Customers table
INSERT INTO Customers (CustomerName)
SELECT DISTINCT CustomerName
FROM OrderDetails;

-- Create a new table for Order Items without the CustomerName
CREATE TABLE OrderItems_2NF (
    OrderID INT,
    CustomerID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert data into the OrderItems_2NF table, linking to the Customers table
INSERT INTO OrderItems_2NF (OrderID, CustomerID, Product, Quantity)
SELECT od.OrderID, c.CustomerID, od.Product, od.Quantity
FROM OrderDetails od
JOIN Customers c ON od.CustomerName = c.CustomerName;

-- Display the transformed tables
SELECT * FROM Customers;
SELECT * FROM OrderItems_2NF;
