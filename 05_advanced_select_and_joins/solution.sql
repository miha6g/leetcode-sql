-- ============================================
-- LeetCode SQL 50 — Раздел 5: Advanced Select and Joins
-- ============================================

-- --------------------------------------------
-- 1731. The Number of Employees Which Report to Each Employee (Easy)
-- https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/
-- --------------------------------------------

with first as (select distinct e1.employee_id, e1.name
from Employees e1 join Employees e2 on e1.employee_id = e2.reports_to),

second as (select reports_to, count(*) as reports_count , avg(age) as average_age 
from Employees 
group by reports_to)

select f.employee_id, f.name, s.reports_count, round(s.average_age, 0)  as average_age
from first f join second s on f.employee_id = s.reports_to 
order by f.employee_id 

-- --------------------------------------------
-- 1789. Primary Department for Each Employee (Easy)
-- https://leetcode.com/problems/primary-department-for-each-employee/
-- --------------------------------------------

with employee_first as (
    select employee_id , min(department_id )  as department_id 
    from employee
    group by employee_id 
    having count(*) = 1
),

epmployee_second as (
    select employee_id, department_id
    from employee
    where primary_flag = 'Y'
)

SELECT * FROM employee_first
UNION
SELECT * FROM epmployee_second

-- --------------------------------------------
-- 610. Triangle Judgement (Easy)
-- https://leetcode.com/problems/triangle-judgement/
-- --------------------------------------------

select x,y,z, case 
when x+y<=z then 'No'
when x+z<=y then 'No'
when y+z<=x then 'No'
else 'Yes' end as triangle 
from triangle

-- --------------------------------------------
-- 180. Consecutive Numbers (Medium)
-- https://leetcode.com/problems/consecutive-numbers/
-- --------------------------------------------

SELECT DISTINCT num AS ConsecutiveNums
FROM (
  SELECT
    id,
    num,
    LAG(num) OVER (ORDER BY id) AS lag1,
    LAG(num, 2) OVER (ORDER BY id) AS lag2
  FROM Logs
) t
WHERE num = lag1 AND num = lag2;

-- --------------------------------------------
-- 1164. Product Price at a Given Date (Medium)
-- https://leetcode.com/problems/product-price-at-a-given-date/
-- --------------------------------------------

with first as (select product_id , new_price as price
from
(
select product_id, new_price, ROW_NUMBER() OVER(PARTITION BY product_id order by change_date desc) as rn
from products 
where change_date <= date '2019-08-16'
)
where rn = 1),

second as (select product_id, 10 as price
from products
where change_date > date '2019-08-16' and product_id not in (select distinct product_id from Products where change_date <= date '2019-08-16'))

select * from first
union
select * from second

-- --------------------------------------------
-- 1204. Last Person to Fit in the Bus (Medium)
-- https://leetcode.com/problems/last-person-to-fit-in-the-bus/
-- --------------------------------------------

select person_name 
from
(
select turn, person_name,  sum(weight) over(order by turn ) as Total_Weight
from queue 
)
where Total_Weight <= 1000
order by turn desc 
limit 1

-- --------------------------------------------
-- 1907. Count Salary Categories (Medium)
-- https://leetcode.com/problems/count-salary-categories/
-- --------------------------------------------


with tbl as (select t1.category, count(*) as accounts_count
from
(select account_id , income , 
case 
when income < 20000 then 'Low Salary'
when income > 50000 then 'High Salary'
else 'Average Salary'
end as category       
from Accounts) t1
group by t1.category),

categories AS (SELECT * FROM (VALUES
  ('Low Salary'),
  ('Average Salary'),
  ('High Salary')
) AS categories(category)
)

SELECT
  c.category,
  COUNT(a.account_id) AS accounts_count
FROM categories c
LEFT JOIN (
  SELECT
    account_id,
    CASE
      WHEN income < 20000 THEN 'Low Salary'
      WHEN income > 50000 THEN 'High Salary'
      ELSE 'Average Salary'
    END AS category
  FROM Accounts
) a ON c.category = a.category
GROUP BY c.category;


