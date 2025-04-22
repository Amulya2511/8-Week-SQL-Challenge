
-- Create and Use Database
DROP DATABASE IF EXISTS data_mart;
CREATE DATABASE data_mart;
USE data_mart;

-- Create Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    join_date DATE
);

-- Create Sales Table
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    prod_id VARCHAR(5),
    qty INT,
    price INT,
    discount INT,
    member_id VARCHAR(10),
    txn_date DATE
);

-- Create Products Table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    prod_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

-- Insert Sample Members
INSERT INTO members VALUES
('C001', '2020-01-15'),
('C002', '2020-02-10'),
('C003', '2020-03-05');

-- Insert Sample Products
INSERT INTO products VALUES
('P001', 'Premium Chocolate', 'Snacks'),
('P002', 'Organic Chips', 'Snacks'),
('P003', 'Protein Bar', 'Health');

-- Insert Sample Sales
INSERT INTO sales VALUES
('P001', 2, 10, 0, 'C001', '2020-01-20'),
('P002', 1, 15, 2, 'C002', '2020-02-15'),
('P003', 3, 12, 3, 'C003', '2020-03-10'),
('P001', 1, 10, 0, 'C001', '2020-02-20'),
('P002', 2, 15, 1, 'C002', '2020-03-15');

-- Q1: What is the total amount each customer spent?
SELECT member_id, SUM((price - discount) * qty) AS total_spent
FROM sales
GROUP BY member_id;

-- Q2: How many days has each customer visited the store?
SELECT member_id, COUNT(DISTINCT txn_date) AS visit_days
FROM sales
GROUP BY member_id;

-- Q3: What was the first product purchased by each customer?
SELECT s.member_id, MIN(s.txn_date) AS first_purchase_date, s.prod_id, p.product_name
FROM sales s
JOIN products p ON s.prod_id = p.prod_id
GROUP BY s.member_id;

-- Q4: What is the most purchased product overall?
SELECT s.prod_id, p.product_name, SUM(qty) AS total_qty
FROM sales s
JOIN products p ON s.prod_id = p.prod_id
GROUP BY s.prod_id
ORDER BY total_qty DESC
LIMIT 1;

-- Q5: Which product generated the most revenue?
SELECT s.prod_id, p.product_name, SUM((price - discount) * qty) AS revenue
FROM sales s
JOIN products p ON s.prod_id = p.prod_id
GROUP BY s.prod_id
ORDER BY revenue DESC
LIMIT 1;

-- Q6: What is the average discount given per product?
SELECT s.prod_id, p.product_name, ROUND(AVG(discount), 2) AS avg_discount
FROM sales s
JOIN products p ON s.prod_id = p.prod_id
GROUP BY s.prod_id;

-- Q7: List customers who have made more than 1 purchase
SELECT member_id, COUNT(*) AS purchase_count
FROM sales
GROUP BY member_id
HAVING purchase_count > 1;

-- Q8: What is the average spend per transaction for each customer?
SELECT member_id, ROUND(AVG((price - discount) * qty), 2) AS avg_spend
FROM sales
GROUP BY member_id;

-- Q9: For each category, what is the total sales and revenue?
SELECT p.category, 
       SUM(s.qty) AS total_units,
       SUM((price - discount) * qty) AS total_revenue
FROM sales s
JOIN products p ON s.prod_id = p.prod_id
GROUP BY p.category;

-- Q10: Which month had the highest total sales?
SELECT MONTH(txn_date) AS month, SUM(qty) AS total_units_sold
FROM sales
GROUP BY MONTH(txn_date)
ORDER BY total_units_sold DESC
LIMIT 1;
