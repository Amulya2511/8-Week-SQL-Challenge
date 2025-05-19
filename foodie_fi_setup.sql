
-- Create Database
DROP DATABASE IF EXISTS foodie_fi;
CREATE DATABASE foodie_fi;
USE foodie_fi;

-- Create Plans Table
DROP TABLE IF EXISTS plans;
CREATE TABLE plans (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    price DECIMAL(5,2)
);

INSERT INTO plans (plan_id, plan_name, price) VALUES
(0, 'Trial', 0.00),
(1, 'Basic Monthly', 9.90),
(2, 'Pro Monthly', 19.90),
(3, 'Pro Annual', 199.00),
(4, 'Churn', NULL);

-- Create Subscriptions Table
DROP TABLE IF EXISTS subscriptions;
CREATE TABLE subscriptions (
    customer_id INT,
    plan_id INT,
    start_date DATE
);

INSERT INTO subscriptions (customer_id, plan_id, start_date) VALUES
(1, 0, '2020-08-01'),
(1, 1, '2020-08-08'),
(2, 0, '2020-09-20'),
(2, 3, '2020-09-27'),
(3, 0, '2020-01-13'),
(3, 1, '2020-01-20'),
(4, 0, '2020-05-19'),
(4, 1, '2020-06-26'),
(5, 0, '2020-06-11'),
(5, 4, '2020-06-17'),
(6, 0, '2020-05-23'),
(6, 1, '2020-06-29'),
(7, 0, '2020-05-19'),
(8, 0, '2020-08-11'),
(9, 0, '2020-09-24'),
(9, 3, '2020-09-29'),
(10, 0, '2020-10-03');

-- Q1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions;

-- Q2. What is the monthly distribution of trial plan start_date values for our dataset? 
SELECT MONTH(start_date) AS month_number,
       MONTHNAME(start_date) AS month_name,
       COUNT(*) AS trial_starts
FROM subscriptions
WHERE plan_id = 0
GROUP BY MONTH(start_date), MONTHNAME(start_date)
ORDER BY month_number;

-- Q3. What plan start_date values occur after the year 2020 for our dataset? Show the customer_id, start_date, plan_id and plan_name.
SELECT s.customer_id, s.start_date, s.plan_id, p.plan_name
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE s.start_date > '2020-12-31'
ORDER BY s.customer_id;

-- Q4. What is the customer count and percentage of customers who have churned?
SELECT 
  COUNT(DISTINCT CASE WHEN plan_id = 4 THEN customer_id END) AS churned_customers,
  ROUND(
    COUNT(DISTINCT CASE WHEN plan_id = 4 THEN customer_id END) / 
    COUNT(DISTINCT customer_id) * 100, 2
  ) AS churn_rate_percent
FROM subscriptions;

-- Q5. How many customers have churned straight after their initial free trial?
SELECT COUNT(*) AS churned_after_trial
FROM (
  SELECT customer_id
  FROM subscriptions
  WHERE customer_id IN (
    SELECT customer_id
    FROM subscriptions
    GROUP BY customer_id
    HAVING COUNT(*) = 2
  )
  GROUP BY customer_id
  HAVING MIN(plan_id) = 0 AND MAX(plan_id) = 4
) sub;

-- Q6. What is the number and percentage of customer plans after the free trial?
SELECT p.plan_name,
       COUNT(s.customer_id) AS customer_count,
       ROUND(COUNT(s.customer_id) / (
         SELECT COUNT(DISTINCT customer_id)
         FROM subscriptions
       ) * 100, 2) AS percentage
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE s.plan_id != 0
  AND (s.customer_id, s.start_date) IN (
    SELECT customer_id, MIN(start_date)
    FROM subscriptions
    WHERE plan_id != 0
    GROUP BY customer_id
  )
GROUP BY p.plan_name;

-- Q7. What is the customer count and percentage breakdown of all 5 plan_ids at 2020-12-31?
SELECT p.plan_name,
       COUNT(s.customer_id) AS customer_count,
       ROUND(COUNT(s.customer_id) / (
         SELECT COUNT(DISTINCT customer_id)
         FROM subscriptions
       ) * 100, 2) AS percentage
FROM (
  SELECT customer_id, plan_id
  FROM subscriptions
  WHERE start_date <= '2020-12-31'
  AND (customer_id, start_date) IN (
    SELECT customer_id, MAX(start_date)
    FROM subscriptions
    WHERE start_date <= '2020-12-31'
    GROUP BY customer_id
  )
) s
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY p.plan_name;

-- Q8. How many customers have upgraded to an annual plan in 2020?
SELECT COUNT(DISTINCT customer_id) AS upgraded_to_annual
FROM subscriptions
WHERE plan_id = 3 AND start_date <= '2020-12-31';

-- Q9. How many days on average does it take for a customer to upgrade to an annual plan from the day they joined Foodie-Fi?
SELECT ROUND(AVG(DATEDIFF(annual.start_date, trial.start_date)), 2) AS avg_days_to_annual
FROM (
  SELECT customer_id, start_date
  FROM subscriptions
  WHERE plan_id = 0
) trial
JOIN (
  SELECT customer_id, start_date
  FROM subscriptions
  WHERE plan_id = 3
) annual
ON trial.customer_id = annual.customer_id;

-- Q10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)?
SELECT 
  CONCAT(FLOOR(DATEDIFF(a.start_date, t.start_date)/30)*30 + 1, '-', 
         FLOOR(DATEDIFF(a.start_date, t.start_date)/30)*30 + 30) AS days_group,
  COUNT(*) AS customer_count
FROM (
  SELECT customer_id, start_date
  FROM subscriptions
  WHERE plan_id = 0
) t
JOIN (
  SELECT customer_id, start_date
  FROM subscriptions
  WHERE plan_id = 3
) a ON t.customer_id = a.customer_id
GROUP BY days_group
ORDER BY MIN(DATEDIFF(a.start_date, t.start_date));
