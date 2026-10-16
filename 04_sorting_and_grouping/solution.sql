-- ============================================
-- LeetCode SQL 50 — Раздел 4: Sorting and Grouping
-- ============================================

-- --------------------------------------------
-- 2356. Number of Unique Subjects Taught by Each Teacher (Easy)
-- https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/
-- --------------------------------------------

select teacher_id, count(distinct subject_id ) as  cnt
from teacher
group by teacher_id 


-- --------------------------------------------
-- 1141. User Activity for the Past 30 Days I (Easy)
-- https://leetcode.com/problems/user-activity-for-the-past-30-days-i/
-- --------------------------------------------

select activity_date  as day, count(distinct user_id) as active_users
from activity
where activity_date between DATE '2019-07-27' - INTERVAL '29 days' AND date '2019-07-27'
group by activity_date 

-- --------------------------------------------
-- 1070. Product Sales Analysis III (Medium)
-- https://leetcode.com/problems/product-sales-analysis-iii/
-- --------------------------------------------

with  first_year as (select product_id, min(year) as first_year 
from sales
group by product_id)

select s.product_id , fy.first_year as first_year , s.quantity as quantity, s.price as price
from Sales s join first_year fy on s.product_id = fy.product_id and s.year = fy.first_year 


-- --------------------------------------------
-- 596. Classes With at Least 5 Students (Easy)
-- https://leetcode.com/problems/classes-with-at-least-5-students/
-- --------------------------------------------

select class
from courses
group by class
having count(*) >= 5

-- --------------------------------------------
-- 1729. Find Followers Count (Easy)
-- https://leetcode.com/problems/find-followers-count/
-- --------------------------------------------

select user_id, count(*) as followers_count
from Followers
group by user_id
order by user_id

-- --------------------------------------------
-- 619. Biggest Single Number (Easy)
-- https://leetcode.com/problems/biggest-single-number/
-- --------------------------------------------

select max(num) as num
from(
    select num
    from MyNumbers
    group by num
    having count(*) = 1
)

-- --------------------------------------------
-- 1045. Customers Who Bought All Products (Medium)
-- https://leetcode.com/problems/customers-who-bought-all-products/
-- --------------------------------------------

select customer_id 
from Customer 
group by customer_id 
having count(distinct product_key ) = (select count(*) from Product)
order by customer_id
