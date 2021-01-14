--Data Definition and Data Types (1) 
--Simple Database Operations Using Queries
--1 Create Tables
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL
    );
    
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL
    );
CREATE TABLE productS (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    category_id INT NOT NULL
    );

-- 2. Insert Data in Tables
INSERT INTO employees (id, first_name, last_name) VALUES
(NULL,'A','B'),
(NULL,'C','D'),
(NULL,'E','F');
-- 3. Alter Tables
ALTER TABLE `employees` ADD `middle_name` VARCHAR(30) NOT NULL;
-- 4. Adding Constraints
ALTER TABLE `products` ADD CONSTRAINT `foreign_key_id` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`);
