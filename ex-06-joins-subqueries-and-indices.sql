--Joins, Subqueries and Indices
--Data Retrieval and Performance

-- 1.	Employee Address
SELECT e.`employee_id`, e.`job_title`, e.`address_id`, a.`address_text` FROM `employees` AS e
JOIN addresses AS a
ON e.address_id = a.`address_id`
GROUP BY e.`address_id` LIMIT 5;

-- 2.	Addresses with Towns
SELECT e.`first_name`, e.`last_name`, t.name as 'town', a.address_text FROM `employees` as e
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id = t.town_id
ORDER BY e.`first_name`, e.`last_name` LIMIT 5;

-- 3.	Sales Employee

SELECT e.`employee_id`, e.`first_name`, e.`last_name`, d.`name` AS 'department_name' FROM `employees`  AS e
JOIN departments AS d
ON d.`department_id` = e.`department_id`
WHERE d.name IN ('Sales')
ORDER BY e.employee_id DESC;

-- 4.	Employee Departments

SELECT e.`employee_id`, e.`first_name`, e.`salary`, d.`name` AS 'department_name' FROM `employees`  AS e
JOIN departments AS d
ON d.department_id = e.`department_id`
WHERE e.salary > 15000
ORDER BY d.department_id DESC LIMIT 5

-- 5.	Employees Without Project

SELECT e.`employee_id`, e.`first_name`
FROM `employees`  AS e
LEFT JOIN employees_projects AS ep
ON e.employee_id = ep.`employee_id`
WHERE ep.project_id IS NULL 
ORDER BY e.employee_id DESC LIMIT 3;

SELECT e.`employee_id`, e.`first_name`
FROM `employees`  AS e
WHERE e.`employee_id` NOT IN 
(
SELECT employee_id FROM employees_projects
)
ORDER BY e.employee_id DESC LIMIT 3;


-- 6.	Employees Hired After

SELECT  e.`first_name`, e.`last_name`,  e.`hire_date`,  d.`name` AS 'dept_name'
FROM `employees` AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE e.`hire_date` > '1999-01-01' AND d.`name` IN ('Sales', 'Finance')
ORDER BY e.`hire_date` ASC

-- 7.	Employees with Project
SELECT e.`employee_id`, e.`first_name`,  p.`name` AS 'project_name'
FROM `employees` AS e
JOIN employees_projects AS ep
ON e.`employee_id` = ep.`employee_id`
JOIN projects as p
ON p.project_id = ep.project_id
WHERE p.start_date > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name, p.`name` LIMIT 5


SELECT e.employee_id, first_name, p.`name` as `project_name`
FROM employees as e
JOIN employees_projects as ep ON e.employee_id = ep.employee_id
JOIN projects as p ON ep.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL
ORDER BY first_name, p.`name`
LIMIT 5;
-- 8.	Employee 24

SELECT e.`employee_id`, e.`first_name`,  
IF (DATE(p.`start_date`) >= '2005-01-01', NULL, p.`name`)
AS 'project_name'
FROM `employees` AS e

JOIN employees_projects AS ep
ON e.`employee_id` = ep.`employee_id`

JOIN projects as p
ON p.project_id = ep.project_id

WHERE e.`employee_id` = 24 
ORDER BY p.`name` ASC


SELECT e.employee_id,e.first_name,
IF(YEAR(p.`start_date`) < 2005,p.`name`, NULL) AS `project_name`
FROM employees AS e
JOIN employees_projects AS ep
ON e.employee_id = ep.employee_id
JOIN projects AS p
ON ep.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY `project_name`;

-- 9.	Employee Manager

SELECT e.`employee_id`, e.`first_name`, e.`manager_id`, e2.first_name AS 'manager_name'
FROM employees AS e
JOIN employees AS e2
ON e.manager_id = e2.employee_id
WHERE e.manager_id IN (3,7)
ORDER BY e.`first_name` ASC
-- 10.	Employee Summary
SELECT e.`employee_id`, CONCAT (e.`first_name`,' ',e.`last_name`) AS 'employee_name',
CONCAT (e2.`first_name`,' ',e2.`last_name`) AS 'manager_name', d.`name` AS 'department_name'
FROM `employees` AS e
JOIN employees AS e2
ON e.manager_id = e2.employee_id
JOIN departments AS d
ON e.department_id = d.department_id
ORDER BY e.employee_id LIMIT 5;
-- 11.	Min Average Salary

SELECT AVG(salary) AS 'min_average_salary' 
FROM `employees`
GROUP BY department_id  
ORDER BY `min_average_salary` ASC LIMIT 1;

-- 12.	Highest Peaks in Bulgaria

SELECT c.`country_code`, m.`mountain_range`, p.`peak_name`, p.`elevation` 
FROM `countries` AS c
JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
JOIN mountains AS m
ON mc.mountain_id = m.id
JOIN peaks AS p
ON m.id = p.mountain_id
WHERE c.`country_code` LIKE 'BG' AND p.elevation > 2835
ORDER BY p.elevation DESC

-- 13.	Count Mountain Ranges

SELECT c.`country_code`, COUNT(*) AS 'mountain_range'
FROM `countries` AS c
JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
JOIN mountains AS m
ON mc.mountain_id = m.id
GROUP BY c.`country_code`
HAVING c.`country_code` IN ('BG', 'RU', 'US')
ORDER BY mountain_range DESC

-- 14.	Countries with Rivers

SELECT  c.`country_name`, r.river_name 
FROM `countries` AS c
LEFT JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
LEFT JOIN rivers AS r
ON cr.river_id = r.id
WHERE c.continent_code LIKE 'AF'
ORDER BY c.country_name ASC LIMIT 5;

-- 15.	*Continents and Currencies

SELECT  `continent_code`, `currency_code`, COUNT(*) AS currency_usage
FROM `countries`
GROUP BY continent_code, currency_code
HAVING `currency_usage` > 1
ORDER BY continent_code, currency_code

select c.continent_code, c. currency_code, count(*) as 'currency_usage'
from countries as c
GROUP BY c.continent_code , c.currency_code
having `currency_usage` > 1 
AND `currency_usage` = (SELECT 
        COUNT(*) AS cn
    FROM
        `countries` AS c2
    WHERE
        c2.continent_code = c.continent_code
    GROUP BY c2.currency_code
    ORDER BY cn DESC
    LIMIT 1)
order by c.continent_code, c.currency_code
;


SELECT d1.continent_code, d1.currency_code, d1.currency_usage FROM 
    (SELECT `c`.`continent_code`, `c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
    GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d1
LEFT JOIN 
    (SELECT `c`.`continent_code`,`c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
     GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d2
ON d1.continent_code = d2.continent_code AND d2.currency_usage > d1.currency_usage
 
WHERE d2.currency_usage IS NULL
ORDER BY d1.continent_code, d1.currency_code;

-- 16.  Countries Without Any Mountains

SELECT COUNT(c.country_code) AS 'country_count'
FROM `countries` AS c
LEFT JOIN mountains_countries AS m
ON c.country_code = m.country_code  
WHERE m.mountain_id IS NULL;

SELECT COUNT(country_code) AS country_count 
FROM `countries` WHERE country_code NOT IN (
SELECT `country_code` FROM `mountains_countries` WHERE 1)


-- 17.  Highest Peak and Longest River by Country
SELECT c.`country_name`, MAX(p.`elevation`) AS 'highest_peak_elevation' , MAX(r.`length`) AS 'longest_river_length'
FROM `countries` AS c
JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
JOIN mountains AS mo
ON mc.mountain_id = mo.id
JOIN peaks AS p
ON mo.id = p.mountain_id
JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
JOIN rivers AS r
ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY p.`elevation` DESC, r.`length` DESC, c.country_name LIMIT 5
