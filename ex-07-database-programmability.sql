--Database Programmability
--User-defined Functions, Procedures, Triggers and Transactions

-- 1.	Employees with Salary Above 35000 ( за judge се взима всичко между // и //)
DROP PROCEDURE IF EXISTS usp_get_employees_salary_above_35000;
DELIMITER //
CREATE PROCEDURE usp_get_employees_salary_above_35000
(above_salary DECIMAL
(19,4))
BEGIN
	SELECT `first_name
	`, `last_name` FROM `employees` 
WHERE  `salary` >= above_salary
ORDER BY first_name, last_name, employee_id ASC;
END
//
DELIMITER ;
CALL `usp_get_employees_salary_above_35000`
('35000');

-- 2.	Employees with Salary Above Number 
DROP PROCEDURE IF EXISTS usp_get_employees_salary_above
DELIMITER //
CREATE PROCEDURE usp_get_employees_salary_above
(min_salary DECIMAL
(19,4))
BEGIN
	SELECT `first_name
	`, `last_name` FROM `employees` 
WHERE  `salary` >= min_salary
ORDER BY first_name, last_name, employee_id ASC;
END
//
DELIMITER ;
CALL `usp_get_employees_salary_above`
('1000');

-- 3.	Town Names Starting With

DROP PROCEDURE IF EXISTS usp_get_towns_starting_with;
DELIMITER //
CREATE PROCEDURE usp_get_towns_starting_with
(get_string VARCHAR
(50))
BEGIN
	SELECT name AS 'town_name'
	FROM `towns
	` WHERE `name` LIKE CONCAT
	(get_string, '%') 
ORDER BY town_name;
END //
DELIMITER ;
CALL `usp_get_towns_starting_with`
('b');

-- 4.	Employees from Town

DROP PROCEDURE IF EXISTS usp_get_employees_from_town;
DELIMITER //
CREATE PROCEDURE usp_get_employees_from_town
(employees_from_town VARCHAR
(30))
BEGIN
	SELECT e.`first_name`, e.`last_name
	` FROM `employees` AS e
JOIN addresses as a
ON e.address_id = a.address_id
JOIN towns as t
ON a.town_id = t.town_id
WHERE t.name = employees_from_town;
END
//
DELIMITER ;
CALL `usp_get_employees_from_town`
('Sofia');


-- 5.	Salary Level Function

DROP FUNCTION IF EXISTS ufn_get_salary_level;
DELIMITER //
CREATE FUNCTION ufn_get_salary_level (e_salary DECIMAL)
RETURNS VARCHAR
(10)
DETERMINISTIC
BEGIN
	RETURN (CASE
	    WHEN e_salary < 30000 THEN 'LOW'
    	WHEN e_salary BETWEEN 30000 AND 50000 THEN 'AVERAGE'
    	WHEN e_salary > 50000 THEN 'High'
    END
           );
END
//
DELIMITER ;
SELECT ufn_get_salary_level(30000);

-- 6.	Employees by Salary Level

DROP PROCEDURE IF EXISTS usp_get_employees_by_salary_level;
DELIMITER //
CREATE PROCEDURE usp_get_employees_by_salary_level (s_salary VARCHAR
(10))
BEGIN
	SELECT `first_name
	`, `last_name` 
FROM `employees` 
WHERE ufn_get_salary_level
	(salary) = s_salary
ORDER BY `first_name`DESC, `last_name` DESC;
END //
DELIMITER ;
CALL `usp_get_employees_by_salary_level`
('HIGH');

-- 7.	Define Function
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar
(50))
RETURNS BIT
RETURN word
REGEXP
(concat
('^[', set_of_letters, ']+$'));

CREATE FUNCTION ufn_is_word_comprised (set_of_letters VARCHAR(50), word VARCHAR
(50))  
RETURNS BIT
BEGIN
	RETURN word
	REGEXP CONCAT
	('^[', set_of_letters, ']+$');
END;
SELECT ufn_get_salary_level(30000);
ufn_is_word_comprised

-- PART II – Queries for Bank Database

-- 8.	Find Full Name

CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT concat(a.first_name, ' ', a.last_name) AS 'full_name'
	FROM account_holders AS a
	ORDER BY full_name, a.id;
END

DROP PROCEDURE IF EXISTS usp_get_holders_full_name;
DELIMITER //
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN
	SELECT CONCAT(`first_name
	`,' ',`last_name`) AS full_name
FROM `account_holders`
ORDER BY full_name, id;
END
//
DELIMITER ;
CALL `usp_get_holders_full_name`
();

-- 9.	People with Balance Higher Than

DROP PROCEDURE IF EXISTS usp_get_holders_with_balance_higher_than;
DELIMITER //
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (num_as_par INT)
BEGIN
	SELECT acc.first_name, acc.last_name
	FROM `accounts
	` AS a
JOIN account_holders AS acc
ON acc.id = a.account_holder_id
GROUP BY a.account_holder_id
HAVING
	(SUM
	(a.balance)) > num_as_par
ORDER BY acc.id ASC;
END //
DELIMITER ;
CALL `usp_get_holders_with_balance_higher_than`
(7000);


-- 10.	Future Value Function

DROP FUNCTION IF EXISTS ufn_calculate_future_value;
DELIMITER //
CREATE FUNCTION ufn_calculate_future_value (in_sum DECIMAL(13,4), interest DOUBLE, num_years INT)  
RETURNS DECIMAL
(13,4)
BEGIN
	RETURN in_sum * POW((1+interest), num_years);
END
//
DELIMITER ;
SELECT ufn_calculate_future_value(1000,0.5,5);

-- 11.	Calculating Interest

DROP PROCEDURE IF EXISTS usp_calculate_future_value_for_account;
DELIMITER //
CREATE PROCEDURE usp_calculate_future_value_for_account (id INT, interest DOUBLE
(19,4))
BEGIN
	SELECT a.id, acc.first_name, acc.last_name, a.balance,
		ufn_calculate_future_value (a.balance,interest,5) AS balance_in_5_years
	FROM `accounts
	` AS a
JOIN account_holders as acc
ON a.account_holder_id  = acc.id
WHERE a.id = id;
END //
DELIMITER ;
CALL `usp_calculate_future_value_for_account`
(1,0.1);


CREATE FUNCTION ufn_calculate_future_value (sum DECIMAL (19,4), yearly_interest_rate double, number_of_years int )
RETURNS DECIMAL
(19,4)
DETERMINISTIC
BEGIN
	RETURN sum * pow( 1 + yearly_interest_rate, number_of_years);
END;
CREATE PROCEDURE usp_calculate_future_value_for_account (id INT, interest DOUBLE
(19,4) )
BEGIN
	SELECT a.id, ah.first_name, ah. last_name, a.balance,
		ufn_calculate_future_value (a.balance, interest, 5 ) as balance_in_5_years
	FROM accounts as a
		JOIN account_holders as ah
		ON ah.id = a.account_holder_id
	WHERE a.id = id;
END;

-- 12.	Deposit Money

DROP PROCEDURE IF EXISTS usp_deposit_money;
DELIMITER //
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL
(19.4))
BEGIN
START TRANSACTION;
IF((SELECT count(*)
FROM `accounts` WHERE `id` = account_id) = 0) OR
( money_amount <=0 )
THEN
ROLLBACK;
ELSE
UPDATE accounts SET balance = balance+money_amount 
WHERE id = account_id;
END
IF;
END//
DELIMITER ;
CALL `usp_deposit_money`
(1,10);


-- 13.	Withdraw Money

DROP PROCEDURE IF EXISTS usp_withdraw_money;
DELIMITER //
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL
(19.4))
BEGIN
START TRANSACTION;
IF((SELECT count(*)
FROM `accounts` WHERE `id` = account_id) = 0) OR
( money_amount <=0 )
OR
((SELECT balance
FROM `accounts
` WHERE `id` = account_id) <= money_amount)
THEN
ROLLBACK;
ELSE
UPDATE accounts SET balance = balance-money_amount 
WHERE id = account_id;
END
IF;
END//
DELIMITER ;
CALL `usp_withdraw_money`
(1,10);

-- 14.	Money Transfer

DROP PROCEDURE IF EXISTS usp_transfer_money;
DELIMITER //
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL
(19.4))
BEGIN
START TRANSACTION;
IF((SELECT count(*)
FROM `accounts` WHERE `id` = from_account_id) = 0) OR
((SELECT count(*)
FROM `accounts
` WHERE `id` = to_account_id) = 0) OR
(amount <=0) OR
((SELECT balance
FROM `accounts
` WHERE `id` = from_account_id) < amount)
THEN
ROLLBACK;
ELSE
UPDATE accounts SET balance = balance+amount 
WHERE accounts.id = to_account_id;
UPDATE accounts SET balance = balance-amount 
WHERE accounts.id = from_account_id;
END
IF;
END//
DELIMITER ;
CALL `usp_transfer_money`
(1,2,10);

-- 15.	Log Accounts Trigger

DROP TRIGGER IF EXISTS tr_update_account;
DELIMITER //
CREATE TRIGGER tr_update_account
AFTER
UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO logs
		(account_id, old_sum, new_sum)
	VALUES(OLD_id, old_balance, new_balance);
END
// 
DELIMITER ;
-- 16.	Emails Trigger
DROP PROCEDURE IF EXISTS
;
DELIMITER //
CREATE PROCEDURE 
()
BEGIN

	END
//
DELIMITER ;
CALL ``
();
