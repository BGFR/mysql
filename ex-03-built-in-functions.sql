--Exercises Built-in Functions (3)
--Functions and Wildcards in MySQL Server

--ex-1.Find Names of All Employees by First Name
SELECT `first_name`, `last_name` FROM `employees` WHERE `first_name` LIKE 'Sa%' ORDER BY employee_id;
--ex-2.Find Names of All Employees by Last Name
SELECT `first_name`, `last_name` FROM `employees` WHERE `last_name` LIKE '%ei%' ORDER BY employee_id;
--ex-3.Find First Names of All Employees
SELECT `first_name` FROM `employees` WHERE department_id in(3,10) AND YEAR (`hire_date`) BETWEEN 1995 AND 2005 ORDER BY employee_id;
--ex-4.Find All Employees Except Engineers
SELECT  `first_name`, `last_name` FROM `employees` WHERE `job_title` NOT LIKE '%engineer%' ORDER BY employee_id;
--ex-5.Find Towns with Name Length
SELECT `name` FROM `towns` WHERE  CHAR_LENGTH(`name`) >= 5 AND CHAR_LENGTH(`name`) <= 6 ORDER BY `name`;
--ex-6.Find Towns Starting With
ELECT `town_id`, `name` FROM `towns` WHERE LEFT (`name`,1) in ('M','K','B','E') ORDER BY name;
--ex-7.Find Towns Not Starting With
SELECT `town_id`, `name` FROM `towns` WHERE LEFT (`name`,1) NOT in ('R','B','D') ORDER BY name;
--ex-8.Create View Employees Hired After 2000 Year
CREATE VIEW v_employees_hired_after_2000 AS
SELECT `first_name`, `last_name` FROM `employees` WHERE YEAR (`hire_date`) > 2000
--ex-9.Length of Last Name
SELECT `first_name`, `last_name` FROM `employees` WHERE char_length(`last_name`) = 5;
--ex-10.Countries Holding 'A' 3 or More Times
SELECT `country_name`, `iso_code` FROM countries WHERE `country_name` LIKE '%A%A%A%' ORDER BY `iso_code`;
--ex-11. Mix of Peak and River Names
SELECT p.`peak_name`, r.`river_name`,
LOWER(CONCAT(peak_name, SUBSTRING(river_name,2))) AS 'mix'
FROM peaks AS p, rivers AS r
WHERE RIGHT(peak_name,1) = LEFT(river_name,1)
ORDER BY `mix`;
--ex-12.Games from 2011 and 2012 Year
SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') FROM games WHERE YEAR (`start`) in (2011,2012) order by `start`LIMIT 50;
--ex-13. User Email Providers
SELECT `user_name`, 
SUBSTRING(`email`, LOCATE('@', `email`) + 1) AS 'Email Provider'FROM `users`
ORDER by `Email Provider` ASC, `user_name`;
--ex-14. Get Users with IP Address Like Pattern
SELECT `user_name`, `ip_address` FROM `users` 
WHERE ip_address LIKE ('___.1%.%.___')
ORDER BY `user_name` ASC;
--ex-15. Show All Games with Duration and Part of the Day
SELECT `name` AS 'game' , 
(CASE
 WHEN HOUR (`start`) BETWEEN 0 AND 11 THEN 'Morning'
 WHEN HOUR (`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
 WHEN HOUR (`start`) BETWEEN 18 AND 24 THEN 'Evening'
 END
 ) AS 'Part of the Day',
 (CASE
  WHEN `duration` BETWEEN 0 AND 3 THEN 'Extra Short'
  WHEN `duration` BETWEEN 3 AND 6 THEN 'Short'
  WHEN `duration` BETWEEN 6 AND 10 THEN 'Long'
  ELSE 'Extra Long'
  END
 )
 AS 'Duration'
FROM `games`
--ex-16. Orders Table
SELECT `product_name`, `order_date`, 
ADDDATE(`order_date`, INTERVAL 3 DAY) AS pay_due,
ADDDATE(`order_date`, INTERVAL 1 MONTH) AS deliver_due
FROM `orders`
