--Data Definition and Data Types (1) 
--Simple Database Operations Using Queries
--ex-01. Create Tables
CREATE TABLE `minions` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR (30) NOT NULL,
    `age` INT
);

CREATE TABLE `towns`(
`town_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30)
);
--ex-02. Alter Minions Table
ALTER TABLE `minions`
ADD COLUMN `town_id` INT NOT NULL;
ALTER TABLE `minions`
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (`town_id`) REFERENCES `towns` (`id`)
--ex-03. Insert Records in Both Tables
INSERT INTO `towns` (id, name) VALUES (1,'Sofia');
INSERT INTO `towns` (id, name) VALUES (2,'Plovdiv');
INSERT INTO `towns` (id, name) VALUES (3,'Varna');

INSERT INTO `minions` (id,name,age,town_id) VALUES (1,'Kevin',22,1);
INSERT INTO `minions` (id,name,age,town_id) VALUES (2,'Bob',15,3);
INSERT INTO `minions` (id,name,age,town_id) VALUES (3,'Stewart',NULL,2);
--ex-04. Truncate Table Minions
TRUNCATE `minions`;
--ex-5. Drop All Tables
DROP TABLE minions;
DROP TABLE towns;
--ex-06. Create Table People
CREATE TABLE people (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
`name` VARCHAR(200) NOT NULL,
picture BLOB, 
height DOUBLE(3,2),
weight DOUBLE(5,2),
gender CHAR(1) NOT NULL,
birthdate DATE NOT NULL,
biography TEXT
);

INSERT INTO people (id,`name`, picture, height, weight, gender, birthdate, biography)
VALUES (1, 'Aleksander', NULL, 0.85, 13, 'm', '2018-11-09', 'Sashko'),
(2, 'Aleksander', NULL, 0.85, 13, 'm', '2018-11-09', 'Sashko'),
(3, 'Aleksander', NULL, 0.85, 13, 'm', '2018-11-09', 'Sashko'),
(4, 'Aleksander', NULL, 0.85, 13, 'm', '2018-11-09', 'Sashko'),
(5, 'Aleksander', NULL, 0.85, 13, 'm', '2018-11-09', 'Sashko');

--ex-7. Create Table Users
CREATE TABLE `users` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username  VARCHAR(30) NULL,
    password VARCHAR(26)NULL,
    profile_picture BLOB,
    last_login_time TIMESTAMP,
    is_deleted BOOLEAN
);

INSERT INTO users (id, username, password, profile_picture, last_login_time, is_deleted) VALUES
(1,'one','qqq','1234','2018-11-09','0'),
(2,'two','qqq','1234','2018-11-09','0'),
(3,'three','qqq','1234','2018-11-09','0'),
(4,'four','qqq','1234','2018-11-09','0'),
(5,'five','qqq','1234','2018-11-09','0');
--ex-08. Change Primary Key
ALTER TABLE users MODIFY id INT NOT NULL;
ALTER TABLE users DROP PRIMARY KEY;
ALTER TABLE users ADD UNIQUE pk_users (`id`, `username`);
--ex-9. Set Default Value of a Field
ALTER TABLE `users` CHANGE `last_login_time` `last_login_time` TIMESTAMP on update CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
--ex-10. Set Unique Field
ALTER TABLE users DROP PRIMARY KEY, ADD PRIMARY KEY (`id`);
ALTER TABLE users ADD UNIQUE(`username`);
--ex-11. Movies Database
CREATE TABLE directors (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    director_name VARCHAR(100) NOT NULL,
    notes TEXT DEFAULT NULL
);
INSERT INTO `directors` (id, director_name, notes) VALUES
(1,'one','blabla'),
(2,'two','blabla'),
(3,'three','blabla'),
(4,'four','blabla'),
(5,'five','blabla');

CREATE TABLE `genres` (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    genres_name VARCHAR(100) NOT NULL,
    notes TEXT DEFAULT NULL
);
INSERT INTO `genres` (id, genres_name, notes) VALUES
(1,'one','blabla'),
(2,'two','blabla'),
(3,'three','blabla'),
(4,'four','blabla'),
(5,'five','blabla');

CREATE TABLE `categories` (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    notes TEXT DEFAULT NULL
);
INSERT INTO `categories` (id, category_name, notes) VALUES
(1,'one','blabla'),
(2,'two','blabla'),
(3,'three','blabla'),
(4,'four','blabla'),
(5,'five','blabla');

CREATE TABLE `movies` (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    director_id INT NOT NULL,
    copyright_year YEAR NOT NULL,
    length TIME NOT NULL,
    genre_id INT NOT NULL,
    category_id INT NOT NULL,
    rating INT NOT NULL,
    notes TEXT DEFAULT NULL
);
INSERT INTO `movies` (id, title, director_id, copyright_year, length, genre_id, category_id, rating, notes) VALUES
(1,'one','1','2000','00:00:10','1','1','1','blabla'),
(2,'two','2','2000','00:00:20','2','2','2','blabla'),
(3,'three','3','2000','00:00:30','3','3','3','blabla'),
(4,'four','4','2000','00:00:40','4','4','4','blabla'),
(5,'five','5','2000','00:00:50','5','5','5','blabla');
--ex-12. Car Rental Database
create table categories (
id int not null primary key auto_increment,
category varchar(30) not null,
daily_rate smallint,
weekly_rate smallint,
monthly_rate smallint,
weekend_rate smallint);
 
create table cars (
id int not null primary key auto_increment,
plate_number varchar(15) not null,
make varchar(20),
model varchar(20),
car_year year,
category_id int not null,
doors smallint,
picture BLOB,
car_condition varchar(15),
available tinyint);
 
create table employees (
id int not null primary key auto_increment,
first_name varchar(40) not null,
last_name varchar(40) not null,
title varchar(30),
notes text);
 
create table customers (
id int not null primary key auto_increment,
driver_licence_number int not null,
full_name varchar(80) not null,
address varchar(100),
city varchar(30),
zip_code int,
notes text);
 
create table rental_orders (
id int not null primary key auto_increment,
employee_id int not null,
customer_id int not null,
car_id int not null,
car_condition varchar(20),
tank_level int,
kilometrage_start int,
kilometrage_end int,
total_kilometrage int,
start_date date,
end_date date,
total_days int,
rate_applied varchar(15),
tax_rate int,
order_status tinyint,
notes text);
 
insert into categories (id, category, daily_rate, weekly_rate, monthly_rate, weekend_rate) values
(1, 'топ 3', null, null, null, null),
(2, 'топ 5', null, null, null, null),
(3, 'топ 10', null, null, null, null);
 
insert into cars (id, plate_number, make, model, car_year, category_id, doors, picture, car_condition, available) values
(1, '123456', null, null, null, 3, null, null, null, null),
(2, '654321', null, null, null, 2, null, null, null, null),
(3, '987654', null, null, null, 2, null, null, null, null);
 
insert into employees (id, first_name, last_name, title, notes) values
(1, 'Ivan', 'Ivanov', null, null),
(2, 'Jordan', 'Yordanov', null, null),
(3, 'Petran', 'Petrunov', null, null);
 
insert into customers (id, driver_licence_number, full_name, address, city, zip_code, notes) values
(1, '641234567', 'Ivan Ivanov Petrunov', null, null, null, null),
(2, '642345678', 'Georgi Petrunov Ivanov', null, null, null, null),
(3, '643456789', 'Petran Georgiev Petrunov', null, null, null, null);
 
insert into rental_orders (id, employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes) values
(1, 3, 1, 2, null, null, null, null, null, null, null, null, null, null, null, null),
(2, 2, 3, 2, null, null, null, null, null, null, null, null, null, null, null, null),
(3, 2, 3, 1, null, null, null, null, null, null, null, null, null, null, null, null);
--ex-14. Basic Insert
INSERT INTO `towns`
VALUES 
(1, 'Sofia'), 
(2, 'Plovdiv'), 
(3, 'Varna'), 
(4, 'Burgas');
 
INSERT INTO `departments`
VALUES
(1, 'Engineering'), 
(2, 'Sales'), 
(3, 'Marketing'), 
(4, 'Software Development'), 
(5, 'Quality Assurance'); 
 
INSERT INTO `employees` (`id`, `first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`)
VALUES
(1, 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
(2, 'Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
(3, 'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
(4, 'Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
(5, 'Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);
--ex-15. Basic Select All Fields
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;
--ex-16. Basic Select All Fields and Order Them
SELECT * FROM towns ORDER BY `name` ASC;
SELECT * FROM departments ORDER BY `name` ASC;
SELECT * FROM employees ORDER BY `salary` ASC;
--ex-17. Basic Select Some Fields
SELECT name FROM towns ORDER BY `name` ASC;
SELECT name FROM departments ORDER BY `name` ASC;
SELECT first_name, last_name, job_title, salary FROM employees ORDER BY `salary` DESC;
--ex-18. Increase Employees Salary
UPDATE `employees` SET `salary`= `salary` * 1.1;
SELECT `salary` FROM `employees;
--ex-19. Decrease Tax Rate
UPDATE `payments` SET `tax_rate` = `tax_rate` * 0.97;
