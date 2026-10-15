-- ============================================
-- LeetCode SQL 50 — Раздел 2: Basic Joins
-- ============================================

-- --------------------------------------------
-- 1378. Replace Employee ID With The Unique Identifier (Easy)
-- https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/
-- --------------------------------------------

select unique_id, name
from EmployeeUNI e right join Employees em on e.id = em.id

-- --------------------------------------------
-- 1068. Product Sales Analysis I (Easy)
-- https://leetcode.com/problems/product-sales-analysis-i/
-- --------------------------------------------

select product_name, year, price
from Product p right join Sales s on p.product_id = s.product_id


-- --------------------------------------------
-- 1581. Customer Who Visited but Did Not Make Any Transactions (Easy)
-- https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/
-- --------------------------------------------

select t2.customer_id, count(*) as count_no_trans
from
(select t1.customer_id
from
(select v.visit_id, customer_id, v.transaction_id
from Transactions v FULL JOIN Visits t on v.visit_id=t.visit_id) t1
where t1.transaction_id is null) t2
group by t2.customer_id

-- --------------------------------------------
-- 197. Rising Temperature (Easy)
-- https://leetcode.com/problems/rising-temperature/
-- --------------------------------------------

SELECT w1.id
FROM Weather w1
JOIN Weather w2
  ON w1.recordDate - w2.recordDate = 1
WHERE w1.temperature > w2.temperature;


-- --------------------------------------------
-- 1661. Average Time of Process per Machine (Easy)
-- https://leetcode.com/problems/average-time-of-process-per-machine/
-- --------------------------------------------

select lasttable.machine_id, round(avg(lasttable.diff)::numeric ,3) as processing_time 
from
(Select starttable.machine_id, starttable.process_id, starttable.start, endtable.end, (endtable.end - starttable.start) as diff
from 
    (select machine_id, process_id , activity_type, "timestamp" as start
        from Activity 
        where activity_type = 'start') starttable 
    join 
     (select machine_id, process_id , activity_type, "timestamp" as end
        from Activity 
        where activity_type = 'end') endtable
    ON starttable.machine_id = endtable.machine_id
        AND starttable.process_id = endtable.process_id) lasttable
group by lasttable.machine_id


-- --------------------------------------------
-- 577. Employee Bonus (Easy)
-- https://leetcode.com/problems/employee-bonus/
-- --------------------------------------------

select name, bonus
from employee e left join bonus b on e.empId = b.empId
where bonus < 1000 or bonus is null

-- --------------------------------------------
-- 1280. Students and Examinations (Easy)
-- https://leetcode.com/problems/students-and-examinations/
-- --------------------------------------------

SELECT
  s.student_id,
  s.student_name,
  sub.subject_name,
  COUNT(e.student_id) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
  ON s.student_id = e.student_id
 AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

-- --------------------------------------------
-- 570. Managers with at Least 5 Direct Reports (Medium)
-- https://leetcode.com/problems/managers-with-at-least-5-direct-reports/
-- --------------------------------------------

SELECT
  s.student_id,
  s.student_name,
  sub.subject_name,
  COUNT(e.student_id) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
  ON s.student_id = e.student_id
 AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

-- --------------------------------------------
-- 1934. Confirmation Rate (Medium)
-- https://leetcode.com/problems/confirmation-rate/
-- --------------------------------------------

SELECT
  s.student_id,
  s.student_name,
  sub.subject_name,
  COUNT(e.student_id) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
  ON s.student_id = e.student_id
 AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;