
-- Create Database
DROP DATABASE IF EXISTS pizza_runner;
CREATE DATABASE pizza_runner;
USE pizza_runner;

-- Table: runner_orders
DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
    order_id INT,
    runner_id INT,
    pickup_time DATETIME,
    distance VARCHAR(10),
    duration VARCHAR(20),
    cancellation VARCHAR(100)
);

INSERT INTO runner_orders (order_id, runner_id, pickup_time, distance, duration, cancellation) VALUES
(1, 1, '2020-01-01 18:15:34', '20km', '32 minutes', NULL),
(2, 1, '2020-01-01 19:10:54', '20km', '27 minutes', NULL),
(3, 1, '2020-01-02 00:12:37', '13.4km', '20 mins', NULL),
(4, 2, '2020-01-04 13:53:03', '23.4km', '40 mins', NULL),
(5, 3, NULL, NULL, NULL, 'Restaurant Cancellation'),
(6, 3, '2020-01-08 21:10:57', '10km', '15 minutes', NULL),
(7, 2, '2020-01-08 21:30:45', '25km', '25mins', NULL),
(8, 2, '2020-01-09 00:15:53', '23.4km', '51 mins', NULL),
(9, 1, NULL, NULL, NULL, 'Customer Cancellation'),
(10, 2, '2020-01-11 18:50:20', '10km', '10minutes', NULL);

-- Table: customer_orders
DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
    order_id INT,
    customer_id INT,
    pizza_id INT,
    exclusions VARCHAR(10),
    extras VARCHAR(10),
    order_time DATETIME
);

INSERT INTO customer_orders (order_id, customer_id, pizza_id, exclusions, extras, order_time) VALUES
(1, 101, 1, '', '', '2020-01-01 18:05:02'),
(2, 101, 1, '', '', '2020-01-01 19:00:52'),
(3, 102, 1, '', '', '2020-01-02 23:51:23'),
(4, 103, 1, '4', '', '2020-01-04 13:23:46'),
(5, 104, 1, '4', '1', '2020-01-08 21:00:29'),
(6, 101, 2, '', '1', '2020-01-08 21:03:13'),
(7, 105, 2, '', '', '2020-01-08 21:20:29'),
(8, 102, 1, '', '1', '2020-01-09 23:54:33'),
(9, 103, 1, '4', '1', '2020-01-10 11:22:59'),
(10, 104, 1, '', '', '2020-01-11 18:34:49');

-- Table: pizza_names
DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
    pizza_id INT,
    pizza_name VARCHAR(50)
);

INSERT INTO pizza_names (pizza_id, pizza_name) VALUES
(1, 'Meatlovers'),
(2, 'Vegetarian');

-- Table: pizza_recipes
DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
    pizza_id INT,
    toppings VARCHAR(100)
);

INSERT INTO pizza_recipes (pizza_id, toppings) VALUES
(1, '1, 2, 3, 4, 5, 6, 8, 10'),
(2, '4, 6, 7, 9, 11, 12');

-- Table: pizza_toppings
DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
    topping_id INT,
    topping_name VARCHAR(50)
);

INSERT INTO pizza_toppings (topping_id, topping_name) VALUES
(1, 'Bacon'),
(2, 'BBQ Sauce'),
(3, 'Beef'),
(4, 'Cheese'),
(5, 'Chicken'),
(6, 'Mushrooms'),
(7, 'Onions'),
(8, 'Pepperoni'),
(9, 'Peppers'),
(10, 'Salami'),
(11, 'Tomatoes'),
(12, 'Tomato Sauce');

-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS total_pizzas_ordered FROM customer_orders;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL AND pickup_time IS NOT NULL
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT co.pizza_id, pn.pizza_name, COUNT(*) AS pizzas_delivered
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
WHERE ro.cancellation IS NULL AND ro.pickup_time IS NOT NULL
GROUP BY co.pizza_id, pn.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, pn.pizza_name, COUNT(*) AS total
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY customer_id, pn.pizza_name
ORDER BY customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT co.order_id, COUNT(*) AS pizza_count
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL AND ro.pickup_time IS NOT NULL
GROUP BY co.order_id
ORDER BY pizza_count DESC
LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change (exclusion or extra)?
SELECT customer_id, COUNT(*) AS changed_orders
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL 
  AND ro.pickup_time IS NOT NULL 
  AND (exclusions <> '' OR extras <> '')
GROUP BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) AS pizzas_with_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL 
  AND ro.pickup_time IS NOT NULL 
  AND exclusions <> '' 
  AND extras <> '';

-- 9. What was the total volume of pizzas ordered for each runner?
SELECT runner_id, COUNT(co.pizza_id) AS total_pizzas
FROM runner_orders ro
JOIN customer_orders co ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL AND ro.pickup_time IS NOT NULL
GROUP BY runner_id;

-- 10. What was the average distance travelled for each customer?
SELECT co.customer_id, ROUND(AVG(CAST(REPLACE(ro.distance, 'km', '') AS DECIMAL(5,2))), 2) AS avg_distance_km
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL AND ro.pickup_time IS NOT NULL
GROUP BY co.customer_id;

