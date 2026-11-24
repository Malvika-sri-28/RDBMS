-- =========================================================================
-- EXPERIMENT 9
-- AIM: To design a large-scale railway reservation database schema, generate
-- a synthetic workload of 5,000 booking records using a stored procedure with
-- batch committing, and evaluate query performance before and after creating
-- Single-Column and Multi-Column B-Tree indexes using EXPLAIN execution plans.
-- =========================================================================

-- =========================================================================
-- 1. DATABASE CREATION AND RELATIONAL SCHEMA SETUP
-- =========================================================================
CREATE DATABASE IF NOT EXISTS RailwayDB;
USE RailwayDB;

-- Drop table if it already exists to allow a fresh start
DROP TABLE IF EXISTS Railway_Bookings;

CREATE TABLE Railway_Bookings (
    booking_id       INT AUTO_INCREMENT PRIMARY KEY,
    pnr_no           VARCHAR(12) NOT NULL,
    train_no         INT NOT NULL,
    train_name       VARCHAR(100) NOT NULL,
    passenger_name   VARCHAR(100) NOT NULL,
    age              INT,
    gender           CHAR(1),
    travel_date      DATE NOT NULL,
    source_station   VARCHAR(50) NOT NULL,
    dest_station     VARCHAR(50) NOT NULL,
    coach_class      VARCHAR(10) NOT NULL,     -- '1A', '2A', '3A', 'SL', 'CC'
    fare             DECIMAL(8,2) NOT NULL,
    booking_status   VARCHAR(15) NOT NULL,     -- 'CONFIRMED', 'RAC', 'WAITLIST'
    booking_time     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================================
-- 2. STORED PROCEDURE FOR SYNTHETIC WORKLOAD GENERATION (5,000 ROWS)
-- Uses batch insertion with autocommit disabled for maximum ingestion speed.
-- =========================================================================
DROP PROCEDURE IF EXISTS PopulateBookings;

DELIMITER $$

CREATE PROCEDURE PopulateBookings(IN total_rows INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE rand_pnr VARCHAR(12);
    DECLARE rand_train INT;
    DECLARE rand_class VARCHAR(10);
    DECLARE rand_status VARCHAR(15);
    DECLARE rand_date DATE;
    
    -- Turn off autocommit for fast batch insertion
    SET autocommit = 0;
    
    WHILE i <= total_rows DO
        SET rand_pnr    = LPAD(FLOOR(1000000000 + (RAND() * 9000000000)), 10, '0');
        SET rand_train  = 12000 + FLOOR(RAND() * 50); -- Train numbers 12000 - 12049
        SET rand_class  = ELT(FLOOR(1 + (RAND() * 5)), '1A', '2A', '3A', 'SL', 'CC');
        SET rand_status = ELT(FLOOR(1 + (RAND() * 3)), 'CONFIRMED', 'RAC', 'WAITLIST');
        SET rand_date   = DATE_ADD('2026-06-01', INTERVAL FLOOR(RAND() * 90) DAY);
        
        INSERT INTO Railway_Bookings (
            pnr_no, train_no, train_name, passenger_name, age, gender,
            travel_date, source_station, dest_station, coach_class, fare, booking_status
        ) VALUES (
            rand_pnr,
            rand_train,
            CONCAT('Express-', rand_train),
            CONCAT('Passenger_', i),
            18 + FLOOR(RAND() * 60),
            IF(RAND() > 0.5, 'M', 'F'),
            rand_date,
            ELT(FLOOR(1 + (RAND() * 4)), 'New Delhi', 'Mumbai CST', 'Howrah', 'Chennai Central'),
            ELT(FLOOR(1 + (RAND() * 4)), 'Bangalore City', 'Ahmedabad', 'Pune', 'Secunderabad'),
            rand_class,
            ROUND(500.00 + (RAND() * 2500.00), 2),
            rand_status
        );
        
        SET i = i + 1;
    END WHILE;
    
    -- Commit all inserted rows at once
    COMMIT;
    SET autocommit = 1;
END$$

DELIMITER ;

-- Execute procedure to insert 5,000 synthetic records
CALL PopulateBookings(5000);


-- =========================================================================
-- 3. DATA VERIFICATION & BASELINE INSPECTION
-- =========================================================================
-- Verify total row count
SELECT COUNT(*) AS total_records FROM Railway_Bookings;

-- View sample rows
SELECT * FROM Railway_Bookings LIMIT 5;


-- =========================================================================
-- 4. SINGLE-COLUMN B-TREE INDEX OPTIMIZATION (PNR LOOKUP)
-- =========================================================================
-- Select a sample PNR from the table for testing
SELECT pnr_no FROM Railway_Bookings LIMIT 1; 

-- A. Baseline Query Plan WITHOUT Index:
-- Result: type = ALL (Full Table Scan), rows = 5000
EXPLAIN SELECT * FROM Railway_Bookings WHERE pnr_no = '4829104821';

-- B. Create Single-Column B-Tree Index on pnr_no
CREATE INDEX idx_pnr ON Railway_Bookings (pnr_no);

-- C. Optimized Query Plan WITH Index:
-- Result: type = ref (Index Seek), rows = 1, key = idx_pnr
EXPLAIN SELECT * FROM Railway_Bookings WHERE pnr_no = '4829104821';


-- =========================================================================
-- 5. COMPOSITE (MULTI-COLUMN) INDEX OPTIMIZATION (SCHEDULE & STATUS LOOKUP)
-- Scenario: Find confirmed passengers for a specific train and travel date.
-- Filters on: train_no, travel_date, and booking_status.
-- =========================================================================
-- Sample multi-column equality query
SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';

-- A. Baseline Query Plan WITHOUT Composite Index:
-- Result: type = ALL (Full Table Scan), rows = 5000
EXPLAIN SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';

-- B. Create Multi-Column Composite Index
-- Ordered by equality columns matching query predicates
CREATE INDEX idx_train_date_status 
ON Railway_Bookings (train_no, travel_date, booking_status);

-- C. Optimized Query Plan WITH Composite Index:
-- Result: type = ref, key = idx_train_date_status, rows drastically reduced to exact matches
EXPLAIN SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';


-- =========================================================================
-- 6. INDEX METADATA & SYSTEM CATALOG VERIFICATION
-- =========================================================================
-- Inspect created indexes on the Railway_Bookings table
SHOW INDEX FROM Railway_Bookings;
