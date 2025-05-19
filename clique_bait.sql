-- 📊 8 Week SQL Challenge - Case Study #6: Clique Bait
-- ✅ MySQL-Compatible Version

-- Step 1: Create and use the database
DROP DATABASE IF EXISTS clique_bait;
CREATE DATABASE clique_bait;
USE clique_bait;

-- Step 2: Create users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE
);

-- Step 3: Create articles table
CREATE TABLE articles (
    article_id INT PRIMARY KEY,
    author_id INT,
    title VARCHAR(200),
    publish_date DATE
);

-- Step 4: Create page_views table
CREATE TABLE page_views (
    view_id INT PRIMARY KEY,
    user_id INT,
    article_id INT,
    view_date DATE
);

-- Step 5: Insert sample users
INSERT INTO users VALUES
(1, 'Alice Johnson', 'alice@example.com', '2021-01-01'),
(2, 'Bob Smith', 'bob@example.com', '2021-01-05'),
(3, 'Charlie Lee', 'charlie@example.com', '2021-01-10');

-- Step 6: Insert sample articles
INSERT INTO articles VALUES
(101, 1, 'Top 10 Python Tips', '2021-01-15'),
(102, 2, 'Data Science in 2024', '2021-01-20'),
(103, 3, 'Web Dev Tricks', '2021-01-25');

-- Step 7: Insert sample page views
INSERT INTO page_views VALUES
(1001, 1, 101, '2021-01-16'),
(1002, 2, 101, '2021-01-17'),
(1003, 3, 102, '2021-01-21'),
(1004, 1, 102, '2021-01-22'),
(1005, 1, 103, '2021-01-26');

-- ✅ Q1: How many users viewed each article?
SELECT article_id, COUNT(DISTINCT user_id) AS viewer_count
FROM page_views
GROUP BY article_id;

-- ✅ Q2: Which article has the most views?
SELECT a.article_id, a.title, COUNT(pv.view_id) AS total_views
FROM articles a
JOIN page_views pv ON a.article_id = pv.article_id
GROUP BY a.article_id
ORDER BY total_views DESC
LIMIT 1;

-- ✅ Q3: How many articles did each user view?
SELECT user_id, COUNT(DISTINCT article_id) AS articles_viewed
FROM page_views
GROUP BY user_id;

-- ✅ Q4: Which user viewed the most articles?
SELECT user_id, COUNT(DISTINCT article_id) AS total_articles
FROM page_views
GROUP BY user_id
ORDER BY total_articles DESC
LIMIT 1;

-- ✅ Q5: Which article was viewed by all users?
SELECT article_id
FROM page_views
GROUP BY article_id
HAVING COUNT(DISTINCT user_id) = (SELECT COUNT(*) FROM users);

-- ✅ Q6: Which user has viewed all articles?
SELECT user_id
FROM page_views
GROUP BY user_id
HAVING COUNT(DISTINCT article_id) = (SELECT COUNT(*) FROM articles);

-- ✅ Q7: What is the average number of views per article?
SELECT ROUND(COUNT(*) / (SELECT COUNT(*) FROM articles), 2) AS avg_views_per_article
FROM page_views;

-- ✅ Q8: What is the total number of views per author?
SELECT a.author_id, COUNT(pv.view_id) AS total_views
FROM articles a
JOIN page_views pv ON a.article_id = pv.article_id
GROUP BY a.author_id;

-- ✅ Q9: Find the day with the highest views.
SELECT view_date, COUNT(*) AS total_views
FROM page_views
GROUP BY view_date
ORDER BY total_views DESC
LIMIT 1;

-- ✅ Q10: Find users who viewed their own articles.
SELECT u.user_id, u.name, a.title
FROM users u
JOIN articles a ON u.user_id = a.author_id
JOIN page_views pv ON a.article_id = pv.article_id AND u.user_id = pv.user_id;
