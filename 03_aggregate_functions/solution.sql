-- ============================================
-- LeetCode SQL 50 — Раздел 3: Basic Aggregate Functions
-- ============================================

-- --------------------------------------------
-- 620. Not Boring Movies (Easy)
-- https://leetcode.com/problems/not-boring-movies/
-- --------------------------------------------

select id, movie, description, rating
from cinema
where description != 'boring' and  id % 2 <> 0
order by rating  desc


-- --------------------------------------------
-- 1251. Average Selling Price (Easy)
-- https://leetcode.com/problems/average-selling-price/
-- --------------------------------------------

SELECT
  p.product_id,
  COALESCE(
    ROUND(SUM(p.price * us.units)::numeric / NULLIF(SUM(us.units), 0), 2),
    0
  ) AS average_price
FROM Prices p
LEFT JOIN UnitsSold us
  ON p.product_id = us.product_id
 AND us.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;

-- --------------------------------------------
-- 1075. Project Employees I (Easy)
-- https://leetcode.com/problems/project-employees-i/
-- --------------------------------------------

select p.project_id, round(sum(experience_years)::numeric/count(*),2) as average_years 
from Project p left join Employee e on p.employee_id = e.employee_id
group by p.project_id


-- --------------------------------------------
-- 1633. Percentage of Users Attended a Contest (Easy)
-- https://leetcode.com/problems/percentage-of-users-attended-a-contest/
-- --------------------------------------------

select contest_id, round(count(*)::numeric/(select count(*) from users) * 100, 2) as percentage
from register 
group by contest_id
order by percentage desc, contest_id asc

-- --------------------------------------------
-- 1211. Queries Quality and Percentage (Easy)
-- https://leetcode.com/problems/queries-quality-and-percentage/
-- --------------------------------------------

with first as (select query_name, ROUND(AVG(rating::numeric / position), 2) as quality, count(*) as allbeast
from
(select query_name, position, rating,rating::numeric / position 
from Queries ) t1
group by query_name),

second as (select query_name, count(*) as badbeast
from Queries
where rating < 3
group by query_name)

select f.query_name, f.quality, coalesce(round(s.badbeast::numeric/f.allbeast * 100, 2), 0) as poor_query_percentage  
from first f left join second s on f.query_name = s.query_name

-- --------------------------------------------
-- 1193. Monthly Transactions I (Medium)
-- https://leetcode.com/problems/monthly-transactions-i/
-- --------------------------------------------

SELECT
  TO_CHAR(trans_date, 'YYYY-MM') AS month,
  country,
  COUNT(*) AS trans_count,
  COUNT(*) FILTER (WHERE state = 'approved') AS approved_count,
  SUM(amount) AS trans_total_amount,
  COALESCE(SUM(amount) FILTER (WHERE state = 'approved'), 0) AS approved_total_amount
FROM Transactions
GROUP BY TO_CHAR(trans_date, 'YYYY-MM'), country;

-- --------------------------------------------
-- 1174. Immediate Food Delivery II (Medium)
-- https://leetcode.com/problems/immediate-food-delivery-ii/
-- --------------------------------------------

select delivery_id , customer_id ,  order_date , customer_pref_delivery_date , RANK() OVER (PARTITION BY customer_id  ORDER BY order_date)
from Delivery 

-- --------------------------------------------
-- 550. Game Play Analysis IV (Medium)
-- https://leetcode.com/problems/game-play-analysis-iv/
-- --------------------------------------------

with test as 
(
    select * 
    from
    (
        select *, ROW_NUMBER() over (partition by player_id order by event_date ) as rn
            from Activity 
    )
    where rn = 1 or rn = 2
)

select round((select count(*)
from test t1 join test t2 on t1.player_id = t2.player_id and t2.event_date - t1.event_date = 1)::numeric/(select count(distinct player_id) from Activity), 2) as fraction 