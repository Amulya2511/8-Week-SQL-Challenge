-- 📊 8 Week SQL Challenge - Case Study #7: Balanced Tree
-- ✅ MySQL-Compatible Version

DROP DATABASE IF EXISTS balanced_tree;
CREATE DATABASE balanced_tree;
USE balanced_tree;

-- Product hierarchy
CREATE TABLE product_hierarchy (
    id INT PRIMARY KEY,
    level_name VARCHAR(20),
    parent_id INT
);

-- Product prices
CREATE TABLE product_prices (
    id INT PRIMARY KEY,
    product_id INT,
    price DECIMAL(5,2)
);

-- Product details
CREATE TABLE product_details (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    segment_id INT,
    style_id INT
);

-- Insert product_hierarchy
INSERT INTO product_hierarchy VALUES
(1, 'Category', NULL),
(2, 'Segment', 1),
(3, 'Style', 2);

-- Insert product_prices
INSERT INTO product_prices VALUES
(1, 1, 13.00),
(2, 2, 32.00),
(3, 3, 10.00),
(4, 4, 15.00),
(5, 5, 8.00),
(6, 6, 25.00),
(7, 7, 5.00),
(8, 8, 12.00);

-- Insert product_details
INSERT INTO product_details VALUES
(1, 'Forest Green T-Shirt', 1, 2, 3),
(2, 'Ocean Blue T-Shirt', 1, 2, 3),
(3, 'Fire Red T-Shirt', 1, 2, 3),
(4, 'Sky Blue Sweatshirt', 1, 2, 4),
(5, 'Maroon Hoodie', 1, 3, 5),
(6, 'Black Track Pants', 1, 3, 5),
(7, 'Navy Blue Shorts', 1, 4, 6),
(8, 'White Cotton Shirt', 1, 4, 6);

-- ✅ Q1: Total number of products
SELECT COUNT(*) AS total_products FROM product_details;

-- ✅ Q2: Average price
SELECT ROUND(AVG(price), 2) AS avg_price FROM product_prices;

-- ✅ Q3: Products with category, segment, style
SELECT 
  pd.product_id,
  pd.product_name,
  ph1.level_name AS category_level,
  ph2.level_name AS segment_level,
  ph3.level_name AS style_level
FROM product_details pd
JOIN product_hierarchy ph1 ON pd.category_id = ph
JOIN product_hierarchy ph2 ON pd.segment_id = ph2.id
JOIN product_hierarchy ph3 ON pd.style_id = ph3.id;

-- ✅ Q4: Most expensive product
SELECT product_id, price
FROM product_prices
ORDER BY price DESC
LIMIT 1;

-- ✅ Q5: Category with highest average price
SELECT 
  pd.category_id,
  ROUND(AVG(pp.price), 2) AS avg_price
FROM product_details pd
JOIN product_prices pp ON pd.product_id = pp.product_id
GROUP BY pd.category_id
ORDER BY avg_price DESC
LIMIT 1;

-- ✅ Q6: Count products per segment
SELECT segment_id, COUNT(*) AS product_count
FROM product_details
GROUP BY segment_id;

-- ✅ Q7: Total price value
SELECT SUM(price) AS total_value FROM product_prices;

-- ✅ Q8: Products under ₹15
SELECT pd.product_id, pd.product_name, pp.price
FROM product_details pd
JOIN product_prices pp ON pd.product_id = pp.product_id
WHERE price < 15;

-- ✅ Q9: Style with most products
SELECT style_id, COUNT(*) AS count
FROM product_details
GROUP BY style_id
ORDER BY count DESC
LIMIT 1;

-- ✅ Q10: Products sorted by price
SELECT pd.product_name, pp.price
FROM product_details pd
JOIN product_prices pp ON pd.product_id = pp.product_id
ORDER BY price DESC;
