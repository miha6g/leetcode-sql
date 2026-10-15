-- ============================================
-- LeetCode SQL 50 — Раздел 1: Select
-- ============================================

-- --------------------------------------------
-- 1757. Recyclable and Low Fat Products (Easy)
-- https://leetcode.com/problems/recyclable-and-low-fat-products/
-- --------------------------------------------

Select product_id
From Products 
where low_fats = 'Y'
and recyclable = 'Y'

-- --------------------------------------------
-- 584. Find Customer Referee (Easy)
-- https://leetcode.com/problems/find-customer-referee
-- --------------------------------------------

select name
from Customer
where referee_id != 2
or referee_id is null

-- --------------------------------------------
-- 595. Big Countries (Easy)
-- https://leetcode.com/problems/big-countries/
-- --------------------------------------------

select name, population, area    
from world
where area >= 3000000
or population >= 25000000


-- --------------------------------------------
-- 1148. Article Views I (Easy)
-- https://leetcode.com/problems/article-views-i/
-- --------------------------------------------

select DISTINCT viewer_id as id
from Views
where author_id = viewer_id 
ORDER BY viewer_id asc

-- --------------------------------------------
-- 1683. Invalid Tweets (Easy)
-- https://leetcode.com/problems/invalid-tweets/
-- --------------------------------------------

select tweet_id
from Tweets
where LENGTH(content) > 15