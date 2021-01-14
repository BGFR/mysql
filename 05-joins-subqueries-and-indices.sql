--Joins, Subqueries and Indices
--Data Retrieval and Performance

-- 1. Managers

SELECT e.employee_id, CONCAT(e.first_name,' ',e.last_name) AS full_name, 
d.`department_id`, d.`name` AS 'department_name' 
FROM `departments` AS d 
JOIN employees AS e
ON d.manager_id = e.employee_id
ORDER BY e.employee_id LIMIT 5;

-- 2. Towns Addresses

SELECT t.town_id, t.name AS 'town_name', a.address_text FROM `addresses` AS a
JOIN towns AS t
ON t.town_id = a.town_id
WHERE name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY town_id,address_id

SELECT a.town_id, name AS 'town_name', address_text FROM `addresses` AS a, `towns` AS t
WHERE t.town_id = a.town_id  AND name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY town_id,address_id;

-- 3. Employees Without Managers

SELECT `employee_id`, `first_name`, `last_name`, d.`department_id`, `salary` FROM `employees` e JOIN departments d ON e.department_id = d.department_id
WHERE e.manager_id is NULL;


-- EXTRA
SELECT e.`employee_id`, e.`first_name`, e.`last_name`, d.`name` AS 'department_name', a.`address_text`, t.`name` AS 'name_of_town' 
FROM `departments` AS d 
LEFT JOIN `employees` AS e ON d.department_id = e.department_id
JOIN `addresses` AS a ON a.address_id = e.address_id
JOIN `towns` AS t ON t.town_id = a.town_id


SELECT e.`employee_id`, e.`first_name`, e.`last_name`, d.`name` AS 'department_name', a.`address_text`, t.`name` AS 'name_of_town' 
FROM `departments` AS d, `employees` AS e, `addresses` AS a, `towns` AS t
WHERE d.department_id = e.department_id AND a.address_id = e.address_id AND t.town_id = a.town_id;
