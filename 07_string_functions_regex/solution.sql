-- ============================================
-- LeetCode SQL 50 — Раздел 7: Advanced String Functions / Regex / Clause
-- ============================================

-- --------------------------------------------
-- 1667. Fix Names in a Table (Easy)
-- https://leetcode.com/problems/fix-names-in-a-table/
-- --------------------------------------------

SELECT user_id, Concat(
(UPPER(SUBSTRING(name, 1, 1))),
(LOWER(SUBSTRING(name, 2, LENGTH(name)- 1)))
) as name
from Users 
order by user_id

-- --------------------------------------------
-- 1527. Patients With a Condition (Easy)
-- https://leetcode.com/problems/patients-with-a-condition/
-- --------------------------------------------

select patient_id, patient_name , conditions   
from Patients 
WHERE conditions ~ '(^|\s)DIAB1'

-- --------------------------------------------
-- 196. Delete Duplicate Emails (Easy)
-- https://leetcode.com/problems/delete-duplicate-emails/
-- --------------------------------------------

delete from Person 
where id in
(select id
from
(select id, rank() over (partition by email order by id) as number
from Person )
where number > 1)


-- --------------------------------------------
-- 176. Second Highest Salary (Medium)
-- https://leetcode.com/problems/second-highest-salary/
-- --------------------------------------------

SELECT (
  SELECT DISTINCT salary
  FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM Employee
  ) t
  WHERE salary_rank = 2
) AS SecondHighestSalary;

-- --------------------------------------------
-- 1484. Group Sold Products By The Date (Easy)
-- https://leetcode.com/problems/group-sold-products-by-the-date/
-- --------------------------------------------

select t1.sell_date, t2.num_sold, t1.products
From
(SELECT
  sell_date,
  STRING_AGG(distinct product, ',' ORDER BY product) AS products  
FROM Activities 
GROUP BY sell_date  
order by sell_date)t1
join
(SELECT
  sell_date,
  count(distinct product)   as num_sold
FROM Activities 
GROUP BY sell_date) t2 
on 
t1.sell_date  = t2.sell_date  

-- --------------------------------------------
-- 1327. List the Products Ordered in a Period (Easy)
-- https://leetcode.com/problems/list-the-products-ordered-in-a-period/
-- --------------------------------------------

select p.product_name, t1.unit
from
(
    select product_id, sum(unit) as unit
    from Orders 
    where order_date >= date '2020-02-01' and order_date < date '2020-03-01'
    group by product_id      
    having sum(unit) >= 100
) t1
join
    products p
on
    t1.product_id = p.product_id

-- --------------------------------------------
-- 1517. Find Users With Valid E-Mails (Easy)
-- https://leetcode.com/problems/find-users-with-valid-e-mails/
-- --------------------------------------------

select user_id, name, mail
from Users
where mail ~ '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$'