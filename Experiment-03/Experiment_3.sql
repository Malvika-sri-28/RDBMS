-- =========================================================================
-- EXPERIMENT 3
-- AIM: To create an Employee–Department–Project relational database, insert
-- at least 30 employees across 5 departments and 8 projects, and demonstrate
-- SQL queries using Selection, Projection, Aggregate Functions, GROUP BY,
-- HAVING, CASE expressions, and ORDER BY.
-- =========================================================================

DROP DATABASE IF EXISTS CompanyDB;
CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- Create Department Table
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

-- Create Project Table
CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(12, 2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- Create Employee Table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2),
    hire_date DATE,
    dept_id INT,
    project_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

-- Insert Departments
INSERT INTO Department (dept_id, dept_name) VALUES 
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Operations');

-- Insert Projects 
INSERT INTO Project (project_id, project_name, budget, dept_id) VALUES
(101, 'Enterprise Cloud', 160000.00, 1),
(102, 'Machine Learning Platform', 210000.00, 1),
(103, 'Talent Acquisition System', 85000.00, 2),
(104, 'Audit & Accounting Suite', 125000.00, 3),
(105, 'Social Media Growth', 95000.00, 4),
(106, 'Logistics Optimization', 185000.00, 5),
(107, 'Customer iOS App', 145000.00, 1),
(108, 'Corporate Wellness', 65000.00, 2);

-- Insert 30 Employees 
INSERT INTO Employee (emp_id, emp_name, salary, hire_date, dept_id, project_id) VALUES
(1, 'Rahul', 66000.00, '2022-02-15', 1, 101),
(2, 'Priya', 74000.00, '2021-04-10', 1, 102),
(3, 'Amit', 59000.00, '2023-07-05', 1, 107),
(4, 'Sneha', 82000.00, '2020-09-18', 1, 101),
(5, 'Vikram', 70000.00, '2022-10-12', 1, 102),
(6, 'Anjali', 63000.00, '2024-01-25', 1, 107),
(7, 'Kunal', 53000.00, '2022-05-14', 2, 103),
(8, 'Pooja', 49000.00, '2023-02-18', 2, 108),
(9, 'Rakesh', 62000.00, '2021-08-22', 2, 103),
(10, 'Neha', 56000.00, '2022-11-04', 2, 108),
(11, 'Deepak', 48000.00, '2024-04-19', 2, 103),
(12, 'Sunita', 60000.00, '2020-11-15', 2, 108),
(13, 'Sanjay', 77000.00, '2021-03-21', 3, 104),
(14, 'Kavita', 69000.00, '2022-06-11', 3, 104),
(15, 'Rajesh', 84000.00, '2019-11-14', 3, 104),
(16, 'Anita', 61000.00, '2023-09-08', 3, 104),
(17, 'Manoj', 72000.00, '2021-12-05', 3, 104),
(18, 'Swati', 57000.00, '2024-02-14', 3, 104),
(19, 'Gaurav', 55000.00, '2022-03-30', 4, 105),
(20, 'Divya', 64000.00, '2021-07-25', 4, 105),
(21, 'Harsh', 58000.00, '2023-05-16', 4, 105),
(22, 'Simran', 67000.00, '2020-10-10', 4, 105),
(23, 'Tarun', 52000.00, '2024-03-01', 4, 105),
(24, 'Shalini', 71000.00, '2022-12-08', 4, 105),
(25, 'Alok', 61000.00, '2021-02-19', 5, 106),
(26, 'Megha', 75000.00, '2020-05-28', 5, 106),
(27, 'Varun', 68000.00, '2022-08-20', 5, 106),
(28, 'Tanvi', 58000.00, '2023-06-15', 5, 106),
(29, 'Mohit', 78000.00, '2019-09-12', 5, 106),
(30, 'Kriti', 65000.00, '2024-02-28', 5, 106);

-- 1. SELECTION
SELECT *
FROM Employee
WHERE salary > 70000;

-- 2. PROJECTION
SELECT emp_name, salary
FROM Employee;

-- 3. AGGREGATE FUNCTIONS
SELECT
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary,
    SUM(salary) AS total_salary
FROM Employee;

-- 4. GROUP BY
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- 5. HAVING
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 65000;

-- 6. CASE EXPRESSION
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 75000 THEN 'High Salary'
        WHEN salary >= 60000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee;

-- 7. ORDER BY
SELECT emp_name, salary
FROM Employee
ORDER BY salary DESC;

-- 8. JOIN (Employee, Department, and Project)
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name,
    e.salary
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_id
JOIN Project p ON e.project_id = p.project_id
ORDER BY d.dept_name, e.emp_name;
