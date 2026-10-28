-- =========================================================================
-- EXPERIMENT 7
-- AIM: To identify functional dependencies in a denormalized Sales table and
-- normalize it step-by-step from Unnormalized Form (UNF) to Third Normal
-- Form (3NF) and Boyce–Codd Normal Form (BCNF). Verify lossless join and
-- dependency preservation using SQL queries.
-- =========================================================================

DROP DATABASE IF EXISTS NormalizationDB;
CREATE DATABASE IF NOT EXISTS NormalizationDB;
USE NormalizationDB;

-- 1. CREATE THE DENORMALIZED SALES TABLE (UNF)
CREATE TABLE IF NOT EXISTS Sales_UNF (
    order_id         INT,
    order_date       DATE,
    customer_id      INT,
    customer_name    VARCHAR(100),
    customer_city    VARCHAR(100),
    city_state       VARCHAR(100),
    product_id       INT,
    product_name     VARCHAR(100),
    category         VARCHAR(50),
    unit_price       DECIMAL(10,2),
    quantity         INT,
    salesperson_id   INT,
    salesperson_name VARCHAR(100),
    commission_pct   DECIMAL(4,2)
);

-- Insert Sample Data
INSERT INTO Sales_UNF VALUES
(1001, '2026-01-15', 201, 'Riya Sharma',    'Pune',      'Maharashtra', 501, 'Laptop',       'Electronics', 55000.00, 2, 301, 'Arjun Mehta',   5.00),
(1001, '2026-01-15', 201, 'Riya Sharma',    'Pune',      'Maharashtra', 502, 'Mouse',        'Accessories', 800.00,   3, 301, 'Arjun Mehta',   5.00),
(1002, '2026-02-10', 202, 'Vikram Patel',   'Ahmedabad', 'Gujarat',     501, 'Laptop',       'Electronics', 55000.00, 1, 302, 'Sneha Iyer',    4.50),
(1003, '2026-02-20', 201, 'Riya Sharma',    'Pune',      'Maharashtra', 503, 'Keyboard',     'Accessories', 1500.00,  5, 301, 'Arjun Mehta',   5.00),
(1004, '2026-03-05', 203, 'Neha Kulkarni',  'Nagpur',    'Maharashtra', 504, 'Monitor',      'Electronics', 18000.00, 2, 303, 'Karan Desai',   6.00),
(1005, '2026-03-18', 204, 'Amit Joshi',     'Surat',     'Gujarat',     502, 'Mouse',        'Accessories', 800.00,   10,302, 'Sneha Iyer',    4.50),
(1006, '2026-04-01', 202, 'Vikram Patel',   'Ahmedabad', 'Gujarat',     505, 'Headphones',   'Accessories', 2500.00,  4, 302, 'Sneha Iyer',    4.50),
(1007, '2026-04-12', 205, 'Priya Nair',     'Kochi',     'Kerala',      501, 'Laptop',       'Electronics', 55000.00, 1, 304, 'Deepak Menon',  5.50),
(1008, '2026-05-08', 203, 'Neha Kulkarni',  'Nagpur',    'Maharashtra', 503, 'Keyboard',     'Accessories', 1500.00,  3, 303, 'Karan Desai',   6.00),
(1009, '2026-05-25', 206, 'Rahul Verma',    'Jaipur',    'Rajasthan',   504, 'Monitor',      'Electronics', 18000.00, 1, 305, 'Pooja Singh',   4.00);

SELECT * FROM Sales_UNF;

-- 2. CONVERT TO 1NF (Assign Composite Primary Key)
CREATE TABLE IF NOT EXISTS Sales_1NF (
    order_id         INT,
    order_date       DATE,
    customer_id      INT,
    customer_name    VARCHAR(100),
    customer_city    VARCHAR(100),
    city_state       VARCHAR(100),
    product_id       INT,
    product_name     VARCHAR(100),
    category         VARCHAR(50),
    unit_price       DECIMAL(10,2),
    quantity         INT,
    salesperson_id   INT,
    salesperson_name VARCHAR(100),
    commission_pct   DECIMAL(4,2),
    PRIMARY KEY (order_id, product_id)
);

INSERT INTO Sales_1NF SELECT * FROM Sales_UNF;

-- 3. CONVERT FROM 1NF TO 2NF (Remove Partial Dependencies)
CREATE TABLE IF NOT EXISTS Orders_2NF (
    order_id         INT PRIMARY KEY,
    order_date       DATE,
    customer_id      INT,
    customer_name    VARCHAR(100),
    customer_city    VARCHAR(100),
    city_state       VARCHAR(100),
    salesperson_id   INT,
    salesperson_name VARCHAR(100),
    commission_pct   DECIMAL(4,2)
);

INSERT INTO Orders_2NF
SELECT DISTINCT order_id, order_date, customer_id, customer_name,
       customer_city, city_state, salesperson_id, salesperson_name, commission_pct
FROM Sales_1NF;

CREATE TABLE IF NOT EXISTS Products_2NF (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50),
    unit_price   DECIMAL(10,2)
);

INSERT INTO Products_2NF
SELECT DISTINCT product_id, product_name, category, unit_price
FROM Sales_1NF;

CREATE TABLE IF NOT EXISTS OrderDetails_2NF (
    order_id   INT,
    product_id INT,
    quantity   INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id)   REFERENCES Orders_2NF(order_id),
    FOREIGN KEY (product_id) REFERENCES Products_2NF(product_id)
);

INSERT INTO OrderDetails_2NF
SELECT order_id, product_id, quantity
FROM Sales_1NF;

-- 4. CONVERT FROM 2NF TO 3NF / BCNF (Remove Transitive Dependencies)
CREATE TABLE IF NOT EXISTS Customers_3NF (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_city VARCHAR(100)
);

INSERT INTO Customers_3NF
SELECT DISTINCT customer_id, customer_name, customer_city
FROM Orders_2NF;

CREATE TABLE IF NOT EXISTS Cities_3NF (
    customer_city VARCHAR(100) PRIMARY KEY,
    city_state    VARCHAR(100)
);

INSERT INTO Cities_3NF
SELECT DISTINCT customer_city, city_state
FROM Orders_2NF;

CREATE TABLE IF NOT EXISTS Salespersons_3NF (
    salesperson_id   INT PRIMARY KEY,
    salesperson_name VARCHAR(100),
    commission_pct   DECIMAL(4,2)
);

INSERT INTO Salespersons_3NF
SELECT DISTINCT salesperson_id, salesperson_name, commission_pct
FROM Orders_2NF;

CREATE TABLE IF NOT EXISTS Orders_3NF (
    order_id       INT PRIMARY KEY,
    order_date     DATE,
    customer_id    INT,
    salesperson_id INT,
    FOREIGN KEY (customer_id)    REFERENCES Customers_3NF(customer_id),
    FOREIGN KEY (salesperson_id) REFERENCES Salespersons_3NF(salesperson_id)
);

INSERT INTO Orders_3NF
SELECT DISTINCT order_id, order_date, customer_id, salesperson_id
FROM Orders_2NF;

CREATE TABLE IF NOT EXISTS Products_3NF AS SELECT * FROM Products_2NF;
ALTER TABLE Products_3NF ADD PRIMARY KEY (product_id);

CREATE TABLE IF NOT EXISTS OrderDetails_3NF AS SELECT * FROM OrderDetails_2NF;
ALTER TABLE OrderDetails_3NF ADD PRIMARY KEY (order_id, product_id);

-- 5. VERIFY LOSSLESS JOIN
CREATE TABLE IF NOT EXISTS Sales_Reconstructed AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.customer_city,
    ct.city_state,
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    od.quantity,
    s.salesperson_id,
    s.salesperson_name,
    s.commission_pct
FROM OrderDetails_3NF od
JOIN Orders_3NF o       ON od.order_id       = o.order_id
JOIN Customers_3NF c    ON o.customer_id     = c.customer_id
JOIN Cities_3NF ct      ON c.customer_city   = ct.customer_city
JOIN Products_3NF p     ON od.product_id     = p.product_id
JOIN Salespersons_3NF s ON o.salesperson_id  = s.salesperson_id;

-- Compare row counts
SELECT 'Original' AS source, COUNT(*) AS row_count FROM Sales_1NF
UNION ALL
SELECT 'Reconstructed', COUNT(*) FROM Sales_Reconstructed;

-- Check for missing or spurious tuples
(SELECT * FROM Sales_1NF)
EXCEPT
(SELECT * FROM Sales_Reconstructed);

(SELECT * FROM Sales_Reconstructed)
EXCEPT
(SELECT * FROM Sales_1NF);

-- 6. VERIFY DEPENDENCY PRESERVATION
-- FD1: order_id -> order_date, customer_id, salesperson_id
SELECT order_id
FROM Orders_3NF
GROUP BY order_id
HAVING COUNT(DISTINCT order_date) > 1
    OR COUNT(DISTINCT customer_id) > 1
    OR COUNT(DISTINCT salesperson_id) > 1;
    
-- FD2: customer_id -> customer_name, customer_city
SELECT customer_id
FROM Customers_3NF
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_name) > 1
    OR COUNT(DISTINCT customer_city) > 1;
    
-- FD3: customer_city -> city_state
SELECT customer_city
FROM Cities_3NF
GROUP BY customer_city
HAVING COUNT(DISTINCT city_state) > 1;

-- FD4: product_id -> product_name, category, unit_price
SELECT product_id
FROM Products_3NF
GROUP BY product_id
HAVING COUNT(DISTINCT product_name) > 1
    OR COUNT(DISTINCT category) > 1
    OR COUNT(DISTINCT unit_price) > 1;
    
-- FD5: salesperson_id -> salesperson_name, commission_pct
SELECT salesperson_id
FROM Salespersons_3NF
GROUP BY salesperson_id
HAVING COUNT(DISTINCT salesperson_name) > 1
    OR COUNT(DISTINCT commission_pct) > 1;    
    
-- FD6: order_id, product_id -> quantity
SELECT order_id, product_id
FROM OrderDetails_3NF
GROUP BY order_id, product_id
HAVING COUNT(DISTINCT quantity) > 1;
