
-- Create Database
DROP DATABASE IF EXISTS data_bank;
CREATE DATABASE data_bank;
USE data_bank;

-- Create Customers Table
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    address VARCHAR(200),
    postcode VARCHAR(10),
    date_of_birth DATE,
    job_title VARCHAR(100),
    job_industry_category VARCHAR(100),
    wealth_segment VARCHAR(50),
    deceased_indicator VARCHAR(5),
    owns_car VARCHAR(5),
    tenure INT
);

-- Create Regions Table
DROP TABLE IF EXISTS regions;
CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(100)
);

-- Create Transactions Table
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    product_id INT,
    amount DECIMAL(10,2)
);

-- Create Products Table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2)
);

-- Insert Sample Customers
INSERT INTO customers VALUES
(1, 'Sally Smith', 'Female', '123 Queen St', '2000', '1980-01-01', 'Engineer', 'Technology', 'Affluent Customer', 'N', 'Yes', 10),
(2, 'John Doe', 'Male', '456 King St', '3000', '1975-05-15', 'Manager', 'Financial Services', 'Mass Customer', 'N', 'No', 5),
(3, 'Alice Brown', 'Female', '789 Prince St', '4000', '1990-07-22', 'Designer', 'Retail', 'High Net Worth', 'N', 'Yes', 7);

-- Insert Sample Regions
INSERT INTO regions VALUES
(1, 'New South Wales'),
(2, 'Victoria');

-- Insert Sample Products
INSERT INTO products VALUES
(101, 'Phone X', 'Technology', 'BrandA', 999.99, 500.00),
(102, 'Tablet Z', 'Technology', 'BrandB', 799.99, 400.00),
(103, 'Laptop Pro', 'Technology', 'BrandC', 1299.99, 700.00);

-- Insert Sample Transactions
INSERT INTO transactions VALUES
(10001, 1, '2021-01-15', 101, 999.99),
(10002, 2, '2021-02-10', 102, 799.99),
(10003, 3, '2021-03-12', 103, 1299.99),
(10004, 1, '2021-04-18', 103, 1299.99),
(10005, 2, '2021-05-05', 101, 999.99);

-- Q1. What is the total amount each customer spent at the Data Bank?
SELECT customer_id, ROUND(SUM(amount), 2) AS total_spent
FROM transactions
GROUP BY customer_id;

-- Q2. How many days has each customer visited the Data Bank?
SELECT customer_id, COUNT(DISTINCT transaction_date) AS visit_days
FROM transactions
GROUP BY customer_id;

-- Q3. What was the first product purchased by each customer?
SELECT t.customer_id, MIN(t.transaction_date) AS first_purchase_date,
       t.product_id, p.product_name
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY t.customer_id;

-- Q4. What is the most purchased item on the Data Bank?
SELECT t.product_id, p.product_name, COUNT(*) AS purchase_count
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY t.product_id
ORDER BY purchase_count DESC
LIMIT 1;

-- Q5. Which customer spent the most money at the Data Bank?
SELECT customer_id, ROUND(SUM(amount), 2) AS total_spent
FROM transactions
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- Q6. What is the average transaction amount for each customer?
SELECT customer_id, ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM transactions
GROUP BY customer_id;

-- Q7. What are the top 3 highest revenue-generating products?
SELECT p.product_id, p.product_name, ROUND(SUM(t.amount), 2) AS total_revenue
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 3;

-- Q8. What is the total number of transactions for each customer?
SELECT customer_id, COUNT(*) AS transaction_count
FROM transactions
GROUP BY customer_id;

-- Q9. What is the average age of customers by wealth segment?
SELECT wealth_segment, ROUND(AVG(YEAR(CURDATE()) - YEAR(date_of_birth))) AS avg_age
FROM customers
GROUP BY wealth_segment;

-- Q10. What are the top 3 most common job industries among Data Bank customers?
SELECT job_industry_category, COUNT(*) AS total_customers
FROM customers
GROUP BY job_industry_category
ORDER BY total_customers DESC
LIMIT 3;
