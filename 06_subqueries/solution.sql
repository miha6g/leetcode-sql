-- ============================================
-- LeetCode SQL 50 — Раздел 6: Subqueries
-- ============================================

-- --------------------------------------------
-- 1978. Employees Whose Manager Left the Company (Easy)
-- https://leetcode.com/problems/employees-whose-manager-left-the-company/
-- --------------------------------------------

with leaves as (
select manager_id
from employees
where manager_id not in (select distinct employee_id from employees)
)

select employee_id 
from Employees 
where manager_id in (select * from leaves) and salary < 30000
order by employee_id

-- --------------------------------------------
-- 626. Exchange Seats (Medium)
-- https://leetcode.com/problems/exchange-seats/
-- --------------------------------------------

with leaves as (
select manager_id
from employees
where manager_id not in (select distinct employee_id from employees)
)

select employee_id 
from Employees 
where manager_id in (select * from leaves) and salary < 30000
order by employee_id

-- --------------------------------------------
-- 1341. Movie Rating (Medium)
-- https://leetcode.com/problems/movie-rating/
-- --------------------------------------------

with greatest_user as(
select u.name as results
from
users u join
(
select user_id, count(*) as count_rating
from MovieRating 
group by user_id
) t1 on u.user_id = t1.user_id
order by t1.count_rating desc, u.name
limit 1),

greatest_film as (
select m.title as results
from
Movies m join
(select movie_id, avg(rating) as avg_rating
from MovieRating
where  EXTRACT(year from created_at) = 2020 and  EXTRACT(month from created_at) = 02
group by movie_id) t2 
on m.movie_id=t2.movie_id
order by t2.avg_rating desc, title
limit 1)

select * from greatest_user
union all
select * from greatest_film

-- --------------------------------------------
-- 1321. Restaurant Growth (Medium)
-- https://leetcode.com/problems/restaurant-growth/
-- --------------------------------------------

select visited_on, sum(amount) over (order by visited_on range between interval '6 days' preceding and current row) as amount, round(avg(amount) over (order by visited_on range between interval '6 days' preceding and current row),2) as average_amount
from(
select visited_on, sum(amount) as amount
from Customer 
group by visited_on) t1
OFFSET 6

-- --------------------------------------------
-- 602. Friend Requests II: Who Has the Most Friends (Medium)
-- https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/
-- --------------------------------------------

with request as (select requester_id as id, count(*) as count_request
from RequestAccepted 
group by requester_id),

accept as (select accepter_id as id  , count(*) as count_accepted
from RequestAccepted 
group by accepter_id)


select id, num
from
(select Coalesce(a.id, r.id) as id, Coalesce(count_request,0) + coalesce(count_accepted,0)  as num
from request r full OUTER  join  accept a on r.id = a.id)
where num = (select max(num) from (select Coalesce(a.id, r.id) as id, Coalesce(count_request,0) + coalesce(count_accepted,0)  as num
from request r full OUTER  join  accept a on r.id = a.id))

-- --------------------------------------------
-- 585. Investments in 2016 (Medium)
-- https://leetcode.com/problems/investments-in-2016/
-- --------------------------------------------

WITH unique_geo AS (
  SELECT lat, lon
  FROM Insurance
  GROUP BY lat, lon
  HAVING COUNT(*) = 1
),
repeated_tiv AS (
  SELECT tiv_2015
  FROM Insurance
  GROUP BY tiv_2015
  HAVING COUNT(*) > 1
)
SELECT
  ROUND(SUM(tiv_2016)::numeric, 2) AS tiv_2016
FROM Insurance i
WHERE EXISTS (
  SELECT 1
  FROM unique_geo g
  WHERE g.lat = i.lat
    AND g.lon = i.lon
)
AND i.tiv_2015 IN (SELECT tiv_2015 FROM repeated_tiv);

-- --------------------------------------------
-- 185. Department Top Three Salaries (Hard)
-- https://leetcode.com/problems/department-top-three-salaries/
-- --------------------------------------------

select d.name as Department, t1.name as Employee, t1.salary
from
(select name, salary, departmentId, dense_rank() over(partition by departmentId order by salary desc) as rank
from Employee) t1 left join Department d on t1.departmentId = d.id 
where rank <= 3
order by d.name, t1.salary desc
