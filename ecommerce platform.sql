create database e_commerce_platform;
use e_commerce_platform;
-- Create the tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    address TEXT
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert sample data

-- Customers
INSERT INTO Customers (customer_id, name, email, address) VALUES
(1, 'John Doe', 'johndoe@example.com', '123 Main St'),
(2, 'Jane Smith', 'janesmith@example.com', '456 Oak St'),
(3, 'Emily Davis', 'emilydavis@example.com', '789 Pine St');

-- Products
INSERT INTO Products (product_id, name, category, price) VALUES
(1, 'Laptop', 'Electronics', 899.99),
(2, 'Smartphone', 'Electronics', 599.99),
(3, 'Coffee Maker', 'Appliances', 49.99),
(4, 'Headphones', 'Electronics', 199.99);

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2025-02-01', 949.99),
(2, 2, '2025-02-15', 599.99),
(3, 3, '2025-02-20', 249.98);

-- OrderItems
INSERT INTO OrderItems (order_item_id, order_id, product_id, quantity) VALUES
(1, 1, 1, 1),
(2, 1, 4, 1),
(3, 2, 2, 1),
(4, 3, 3, 1),
(5, 3, 4, 1);

-- Questions and Answers

-- Question 1: What is the total amount spent by customer John Doe?
SELECT SUM(o.total_amount) AS Total_Spent_By_John_Doe
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE c.name = 'John Doe';



-- Question 2: How many products did customer Jane Smith order?
SELECT SUM(oi.quantity) AS Total_Products_Ordered_By_Jane_Smith
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE c.name = 'Jane Smith';



-- Question 3: What are the names of all products in the 'Electronics' category?
SELECT name FROM Products WHERE category = 'Electronics';



-- Question 4: Which product has the highest price?
SELECT name, price FROM Products ORDER BY price DESC LIMIT 1;



-- Question 5: How many orders did customer Emily Davis place?
SELECT COUNT(*) AS Total_Orders_By_Emily_Davis
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE c.name = 'Emily Davis';



-- Question 6: What is the total amount of the last order placed by customer John Doe?
SELECT o.total_amount FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE c.name = 'John Doe'
ORDER BY o.order_date DESC LIMIT 1;



-- Question 7: How many different categories of products exist in the database?
SELECT COUNT(DISTINCT category) AS Total_Categories FROM Products;



-- Question 8: What is the total quantity of 'Headphones' sold?
SELECT SUM(oi.quantity) AS Total_Headphones_Sold
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
WHERE p.name = 'Headphones';



-- Question 9: How many unique customers have made an order?
SELECT COUNT(DISTINCT o.customer_id) AS Total_Customers_Ordered
FROM Orders o;



-- Question 10: What is the total revenue generated from the 'Electronics' category?
SELECT SUM(o.total_amount) AS Total_Revenue_From_Electronics
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE p.category = 'Electronics';


