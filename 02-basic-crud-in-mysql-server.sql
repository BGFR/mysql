--Basic CRUD in MySQL Server
--Create, Retrieve, Update, Delete – Using SQL Queries
--01. Select Employee Information
SELECT id,`first_name`,`last_name`,`job_title` FROM employees;
--02. Select Employees with Filter
SELECT id, CONCAT(first_name,' ',`last_name`) AS full_name,`job_title`,`salary`
FROM employees
WHERE salary > 1000
--03. Update Salary and Select
UPDATE `employees` SET `salary`= `salary`+100 WHERE `job_title` LIKE 'Manager';
SELECT `salary` FROM `employees`;
--04. Top Paid Employee
CREATE VIEW `top_paid_employee` AS 
SELECT `id`, `first_name`, `last_name`, `job_title`, `department_id`, `salary` FROM `employees` WHERE id = 8;
SELECT * FROM `top_paid_employee`;
--05. Select Employees by Multiple Filters
SELECT `id`, `first_name`, `last_name`, `job_title`, `department_id`, `salary` FROM `employees` WHERE department_id = 4 AND salary >= 1000;
--06. Delete from Table
DELETE FROM `employees` WHERE `department_id` in (1,2); 
SELECT * FROM `employees` order by id;
