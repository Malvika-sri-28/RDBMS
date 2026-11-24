-- =========================================================================
-- EXPERIMENT 10
-- AIM: To design an e-commerce database with customers and orders, populate
-- it with 14,000 records (2,000 customers and 12,000 orders) using a stored
-- procedure, and analyze 5 distinct SQL query performance bottlenecks using
-- EXPLAIN. Optimize each query through index design, query rewriting
-- (sargability, anti-joins, prefix matching), and covering indexes.
-- =========================================================================

-- =========================================================================
-- 1. DATABASE CREATION AND RELATIONAL SCHEMA SETUP
-- =========================================================================
CREATE DATABASE IF NOT EXISTS OptimizationDB;
USE OptimizationDB;

-- Drop tables in child-to-parent order to prevent foreign key errors
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_name   VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL,
    city            VARCHAR(50)  NOT NULL,
    signup_date     DATE         NOT NULL
);

CREATE TABLE Orders (
    order_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT NOT NULL,
    order_date      DATETIME NOT NULL,
    order_status    VARCHAR(20) NOT NULL,    -- 'COMPLETED', 'PENDING', 'CANCELLED'
    payment_method  VARCHAR(20) NOT NULL,    -- 'CREDIT_CARD', 'UPI', 'NET_BANKING', 'COD'
    total_amount    DECIMAL(10,2) NOT NULL,
    shipping_city   VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


-- =========================================================================
-- 2. STORED PROCEDURE FOR MASS E-COMMERCE WORKLOAD (14,000 RECORDS)
-- Inserts 2,000 customers and 12,000 orders with batch committing.
-- =========================================================================
DROP PROCEDURE IF EXISTS GenerateEcommerceData;

DELIMITER $$

CREATE PROCEDURE GenerateEcommerceData()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE rand_cust_id INT;
    DECLARE rand_status VARCHAR(20);
    DECLARE rand_payment VARCHAR(20);
    DECLARE rand_city VARCHAR(50);
    DECLARE rand_amount DECIMAL(10,2);
    DECLARE rand_dt DATETIME;
    
    SET autocommit = 0;
    
    -- Insert 2,000 Customers
    WHILE i <= 2000 DO
        INSERT INTO Customers (customer_name, email, city, signup_date)
        VALUES (
            CONCAT('Customer_', i),
            CONCAT('user', i, '@', ELT(FLOOR(1 + RAND() * 4), 'gmail.com', 'yahoo.com', 'outlook.com', 'company.in')),
            ELT(FLOOR(1 + RAND() * 5), 'Mumbai', 'Delhi', 'Bangalore', 'Pune', 'Hyderabad'),
            DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 700) DAY)
        );
        SET i = i + 1;
    END WHILE;
    COMMIT;
    
    -- Insert 12,000 Orders
    SET i = 1;
    WHILE i <= 12000 DO
        SET rand_cust_id = 1 + FLOOR(RAND() * 2000);
        SET rand_status  = ELT(FLOOR(1 + RAND() * 3), 'COMPLETED', 'PENDING', 'CANCELLED');
        SET rand_payment = ELT(FLOOR(1 + RAND() * 4), 'CREDIT_CARD', 'UPI', 'NET_BANKING', 'COD');
        SET rand_city    = ELT(FLOOR(1 + RAND() * 5), 'Mumbai', 'Delhi', 'Bangalore', 'Pune', 'Hyderabad');
        SET rand_amount  = ROUND(100.00 + (RAND() * 9900.00), 2);
        SET rand_dt      = DATE_ADD('2024-01-01 08:00:00', INTERVAL FLOOR(RAND() * 730 * 24 * 60) MINUTE);
        
        INSERT INTO Orders (customer_id, order_date, order_status, payment_method, total_amount, shipping_city)
        VALUES (rand_cust_id, rand_dt, rand_status, rand_payment, rand_amount, rand_city);
        
        SET i = i + 1;
    END WHILE;
    COMMIT;
    
    SET autocommit = 1;
END$$

DELIMITER ;

-- Execute generation procedure
CALL GenerateEcommerceData();


-- =========================================================================
-- 3. DATA VERIFICATION & BASELINE INSPECTION
-- =========================================================================
-- Verify row counts
SELECT 'Customers' AS entity, COUNT(*) AS count FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders;


-- =========================================================================
-- 4. OPTIMIZATION TECHNIQUE 1: SARGABILITY & FUNCTION-WRAPPER ELIMINATION
-- Problem: Wrapping order_date inside YEAR() function invalidates index seeks.
-- Solution: Rewrite as an open-ended range filter and add B-Tree index.
-- =========================================================================

-- A. Unoptimized Query (Non-Sargable Function on Indexed Column)
SELECT COUNT(*), SUM(total_amount) 
FROM Orders 
WHERE YEAR(order_date) = 2025;

-- Plan shows: type = ALL, rows = 12,000 (Full Table Scan)
EXPLAIN SELECT COUNT(*), SUM(total_amount) FROM Orders WHERE YEAR(order_date) = 2025;

-- B. Create B-Tree Index on order_date
CREATE INDEX idx_orders_order_date ON Orders(order_date);

-- C. Optimized Query (Sargable Range Filter)
-- Plan shows: type = range, key = idx_orders_order_date
SELECT COUNT(*), SUM(total_amount) 
FROM Orders 
WHERE order_date >= '2025-01-01 00:00:00' 
  AND order_date < '2026-01-01 00:00:00';

EXPLAIN SELECT COUNT(*), SUM(total_amount) 
FROM Orders 
WHERE order_date >= '2025-01-01 00:00:00' 
  AND order_date < '2026-01-01 00:00:00';


-- =========================================================================
-- 5. OPTIMIZATION TECHNIQUE 2: LEADING WILDCARD VS PREFIX PATTERN MATCHING
-- Problem: LIKE '%...' leading wildcard cannot use B-Tree index navigation.
-- Solution: Rewrite query to use prefix matching or exact domain matching.
-- =========================================================================

-- A. Unoptimized Query (Leading Wildcard)
SELECT customer_id, customer_name, email 
FROM Customers 
WHERE email LIKE '%@gmail.com';

-- Plan shows: type = ALL, rows = 2,000
EXPLAIN SELECT customer_id, customer_name, email FROM Customers WHERE email LIKE '%@gmail.com';

-- B. Create Index on email
CREATE INDEX idx_customers_email ON Customers(email);

-- C. Optimized Query (Prefix Search)
-- Plan shows: type = range, key = idx_customers_email, rows reduced to matching range
SELECT customer_id, customer_name, email 
FROM Customers 
WHERE email LIKE 'user100%';

EXPLAIN SELECT customer_id, customer_name, email 
FROM Customers 
WHERE email LIKE 'user100%';


-- =========================================================================
-- 6. OPTIMIZATION TECHNIQUE 3: ANTI-JOIN OPTIMIZATION (NOT IN VS LEFT ANTI-JOIN)
-- Problem: NOT IN with subquery forces materialization and handles NULLs poorly.
-- Solution: Rewrite as LEFT JOIN ... WHERE right_side IS NULL with covering index.
-- =========================================================================

-- A. Unoptimized Query (NOT IN Subquery)
SELECT customer_id, customer_name 
FROM Customers 
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM Orders 
    WHERE order_status = 'COMPLETED'
);

-- Plan shows: Dependent Subquery / Subplan evaluation
EXPLAIN SELECT customer_id, customer_name 
FROM Customers 
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM Orders 
    WHERE order_status = 'COMPLETED'
);

-- B. Create Composite Index on Orders (customer_id, order_status)
CREATE INDEX idx_orders_cust_status ON Orders(customer_id, order_status);

-- C. Optimized Query (Left Anti-Join)
-- Plan shows: type = ref / eq_ref, Using where; Not exists (Optimized Anti-Join)
SELECT c.customer_id, c.customer_name 
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id 
      AND o.order_status = 'COMPLETED'
WHERE o.order_id IS NULL;

EXPLAIN SELECT c.customer_id, c.customer_name 
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id 
      AND o.order_status = 'COMPLETED'
WHERE o.order_id IS NULL;


-- =========================================================================
-- 7. OPTIMIZATION TECHNIQUE 4: FILESORT ELIMINATION ON ORDER BY ... LIMIT
-- Problem: Filtering on one column and sorting on another forces 'Using filesort'.
-- Solution: Composite index matching filter equality + order direction.
-- =========================================================================

-- A. Unoptimized Query (Filter + Sort causing Filesort)
SELECT order_id, customer_id, total_amount, order_date 
FROM Orders 
WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC 
LIMIT 10;

-- Plan shows: Using where; Using filesort across all matching rows
EXPLAIN SELECT order_id, customer_id, total_amount, order_date 
FROM Orders 
WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC 
LIMIT 10;

-- B. Create Composite Index with Descending Sort Direction
CREATE INDEX idx_status_amount ON Orders(order_status, total_amount DESC);

-- C. Optimized Query (Pre-Sorted Index Scan)
-- Plan shows: type = ref, key = idx_status_amount, filesort completely ELIMINATED!
SELECT order_id, customer_id, total_amount, order_date 
FROM Orders 
WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC 
LIMIT 10;

EXPLAIN SELECT order_id, customer_id, total_amount, order_date 
FROM Orders 
WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC 
LIMIT 10;


-- =========================================================================
-- 8. OPTIMIZATION TECHNIQUE 5: COVERING INDEXES FOR MULTI-TABLE JOIN & GROUP BY
-- Problem: Join + Filter + GROUP BY forces temporary table and file sort.
-- Solution: Covering indexes on both sides of the join.
-- =========================================================================

-- A. Unoptimized Query (Join with Group By and Sorting)
SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city 
ORDER BY revenue DESC;

-- Plan shows: Using temporary; Using filesort
EXPLAIN SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city 
ORDER BY revenue DESC;

-- B. Create Covering Indexes for Join & Aggregate Columns
CREATE INDEX idx_customers_id_city ON Customers(customer_id, city);
CREATE INDEX idx_orders_covering ON Orders(customer_id, order_status, total_amount);

-- C. Optimized Query Plan With Covering Indexes
-- Plan shows: Index-driven join, Using index covering on both relations
SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city 
ORDER BY revenue DESC;

EXPLAIN SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city 
ORDER BY revenue DESC;
