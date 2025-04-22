-- Fresh Segments Case Study: Complete SQL Script

-- 1. Database and Table Setup
DROP DATABASE IF EXISTS fresh_segments;
CREATE DATABASE fresh_segments;
USE fresh_segments;

CREATE TABLE campaign_identifier (
    campaign_id INT PRIMARY KEY,
    start_date DATE,
    end_date DATE
);

CREATE TABLE customer_details (
    customer_id INT PRIMARY KEY,
    region VARCHAR(50),
    age INT
);

CREATE TABLE product_information (
    product_id INT PRIMARY KEY,
    category VARCHAR(50)
);

CREATE TABLE sales (
    prod_id INT,
    cust_id INT,
    txn_date DATE,
    qty INT,
    price DECIMAL(10,2)
);

-- 2. Data Insertion
INSERT INTO campaign_identifier VALUES
(1, '2020-01-01', '2020-01-14'),
(2, '2020-01-15', '2020-01-28'),
(3, '2020-01-29', '2020-02-11'),
(4, '2020-02-12', '2020-02-25'),
(5, '2020-02-26', '2020-03-10');

INSERT INTO customer_details VALUES
(1, 'USA', 32), (2, 'USA', 45), (3, 'USA', 21),
(4, 'India', 36), (5, 'India', 58), (6, 'India', 27),
(7, 'Germany', 31), (8, 'Germany', 26), (9, 'Germany', 22), (10, 'Germany', 35);

INSERT INTO product_information VALUES
(1, 'Shoes'), (2, 'Apparel'), (3, 'Accessories'),
(4, 'Shoes'), (5, 'Accessories');

INSERT INTO sales VALUES
(1, 1, '2020-01-02', 2, 100.00),
(2, 2, '2020-01-05', 1, 200.00),
(3, 3, '2020-01-16', 1, 150.00),
(1, 4, '2020-01-20', 2, 100.00),
(2, 5, '2020-01-30', 3, 200.00),
(3, 6, '2020-02-05', 1, 150.00),
(1, 7, '2020-02-20', 2, 100.00),
(4, 8, '2020-02-28', 1, 250.00),
(5, 9, '2020-03-02', 1, 300.00),
(2, 10, '2020-03-05', 1, 200.00);

-- 3. Challenge Questions and Solutions

-- Q1. Unique customers per campaign
SELECT c.campaign_id, COUNT(DISTINCT s.cust_id) AS unique_customers
FROM campaign_identifier c
JOIN sales s ON s.txn_date BETWEEN c.start_date AND c.end_date
GROUP BY c.campaign_id;

-- Q2. Total revenue per product category during campaigns
SELECT c.campaign_id, pi.category, ROUND(SUM(s.qty * s.price), 2) AS total_revenue
FROM campaign_identifier c
JOIN sales s ON s.txn_date BETWEEN c.start_date AND c.end_date
JOIN product_information pi ON s.prod_id = pi.product_id
GROUP BY c.campaign_id, pi.category;

-- Q3. Average customer age per campaign
SELECT c.campaign_id, ROUND(AVG(cd.age), 1) AS avg_age
FROM campaign_identifier c
JOIN sales s ON s.txn_date BETWEEN c.start_date AND c.end_date
JOIN customer_details cd ON s.cust_id = cd.customer_id
GROUP BY c.campaign_id;

-- Q4. Region with highest overall spend
SELECT cd.region, ROUND(SUM(s.qty * s.price), 2) AS total_spend
FROM sales s
JOIN customer_details cd ON s.cust_id = cd.customer_id
GROUP BY cd.region
ORDER BY total_spend DESC
LIMIT 1;

-- Q5. Total quantity and revenue per product category
SELECT pi.category, SUM(s.qty) AS total_quantity, ROUND(SUM(s.qty * s.price), 2) AS total_revenue
FROM sales s
JOIN product_information pi ON s.prod_id = pi.product_id
GROUP BY pi.category;

-- Q6. Most popular product per campaign
SELECT campaign_id, prod_id, total_qty
FROM (
    SELECT c.campaign_id, s.prod_id, SUM(s.qty) AS total_qty,
           RANK() OVER (PARTITION BY c.campaign_id ORDER BY SUM(s.qty) DESC) AS rnk
    FROM campaign_identifier c
    JOIN sales s ON s.txn_date BETWEEN c.start_date AND c.end_date
    GROUP BY c.campaign_id, s.prod_id
) AS ranked
WHERE rnk = 1;

-- Q7. Total revenue per customer
SELECT s.cust_id, ROUND(SUM(s.qty * s.price), 2) AS total_spent
FROM sales s
GROUP BY s.cust_id
ORDER BY total_spent DESC;

-- Q8. Number of products sold per region
SELECT cd.region, COUNT(*) AS total_orders, SUM(s.qty) AS total_quantity
FROM sales s
JOIN customer_details cd ON s.cust_id = cd.customer_id
GROUP BY cd.region;

-- Q9. Average order value per campaign
SELECT c.campaign_id, ROUND(AVG(s.qty * s.price), 2) AS avg_order_value
FROM campaign_identifier c
JOIN sales s ON s.txn_date BETWEEN c.start_date AND c.end_date
GROUP BY c.campaign_id;

-- Q10. Age group that spent the most
SELECT 
    CASE 
        WHEN cd.age BETWEEN 20 AND 29 THEN '20s'
        WHEN cd.age BETWEEN 30 AND 39 THEN '30s'
        WHEN cd.age BETWEEN 40 AND 49 THEN '40s'
        WHEN cd.age BETWEEN 50 AND 59 THEN '50s'
    END AS age_group,
    ROUND(SUM(s.qty * s.price), 2) AS total_spent
FROM sales s
JOIN customer_details cd ON s.cust_id = cd.customer_id
GROUP BY age_group
ORDER BY total_spent DESC;
