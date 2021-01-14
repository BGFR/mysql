--Database Programmability
--User-defined Functions, Procedures, Triggers and Transactions

-- 2.	Employees Promotion
DROP PROCEDURE IF EXISTS `usp_raise_salaries`
DELIMITER //
CREATE PROCEDURE `usp_raise_salaries` (
IN department_name VARCHAR(50)
)
BEGIN
	UPDATE employees JOIN departments USING(department_id)
    SET salary = salary * 1.05
	WHERE d.`name` = department_name;
END//
DELIMITER ;
CALL `usp_raise_salaries` ('Sales');

-- 2.	Employees Promotion v2

DROP PROCEDURE IF EXISTS `usp_raise_salaries`;
DELIMITER //
CREATE PROCEDURE `usp_raise_salaries` (
IN department_name VARCHAR(50),
IN percentage DOUBLE)
BEGIN
	UPDATE employees JOIN departments d USING(department_id)
    SET salary = salary * (1 + percentage/100)
	WHERE d.`name` = department_name;
END//
DELIMITER ;
CALL `usp_raise_salaries` ('Sales', 10);

-- offLab
SELECT `employee_id`, `first_name`, `last_name` 
FROM `employees` JOIN departments d USING (department_id)
WHERE d.name = 'Sales'

-- 3. Employees Promotion by ID
CREATE PROCEDURE usp_raise_salaries(department_name var
char(50))
BEGIN
UPDATE employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
SET salary = salary * 1.05
WHERE d.name = department_name;
END


DROP PROCEDURE IF EXISTS `usp_raise_salary_by_id`;
DELIMITER //
CREATE PROCEDURE usp_raise_salary_by_id(emp_id INT)
BEGIN
START TRANSACTION;
IF((SELECT count(employee_id) FROM employees WHERE employee_id like emp_id)<>1) 
THEN ROLLBACK;
ELSE
UPDATE employees AS e SET salary = salary + salary*0.05
WHERE e.employee_id = emp_id;
END IF;
END//
DELIMITER ;

CALL usp_raise_salary_by_id(268)

-- 4. Triggered
DROP TRIGGER IF EXISTS `tr_deleted_employees`;
DELIMITER //
CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
INSERT INTO deleted_employees (first_name,last_name
,middle_name,job_title,department_id,salary)
VALUES(OLD.first_name,OLD.last_name,OLD.middle_name,OLD
.job_title,OLD.department_id,OLD.salary);
END //
DELIMITER ;
