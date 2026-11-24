-- =========================================================================
-- EXPERIMENT 8
-- AIM: To design a banking relational schema with account balances and
-- transaction audit logging, and implement transaction control commands
-- (START TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT) to demonstrate ACID
-- properties, handling successful transfers, constraint violations, and
-- partial rollbacks using savepoints.
-- =========================================================================

-- 1. DATABASE CREATION & RELATIONAL SCHEMA SETUP
CREATE DATABASE IF NOT EXISTS BankingDB;
USE BankingDB;

-- Drop tables if they already exist to allow clean replay
DROP TABLE IF EXISTS Transaction_Logs;
DROP TABLE IF EXISTS Accounts;

-- Accounts table storing customer balances with non-negative constraint
CREATE TABLE IF NOT EXISTS Accounts (
    account_no   INT PRIMARY KEY,
    holder_name  VARCHAR(100) NOT NULL,
    account_type VARCHAR(20)  NOT NULL,
    balance      DECIMAL(12, 2) NOT NULL CHECK (balance >= 0)
);

-- Transaction log table for audit trails
CREATE TABLE IF NOT EXISTS Transaction_Logs (
    log_id       INT AUTO_INCREMENT PRIMARY KEY,
    from_acc     INT,
    to_acc       INT,
    amount       DECIMAL(12, 2),
    status       VARCHAR(20),
    log_time     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. SEED INITIAL CUSTOMER ACCOUNTS
INSERT INTO Accounts (account_no, holder_name, account_type, balance) VALUES
(101, 'Riya Sharma',   'Savings',  50000.00),
(102, 'Vikram Patel',  'Savings',  30000.00),
(103, 'Sneha Iyer',    'Current',  75000.00);

-- Verify baseline state
SELECT * FROM Accounts;


-- =========================================================================
-- 3. TRANSACTION 1: SUCCESSFUL ATOMIC FUND TRANSFER (COMMIT)
-- Scenario: Transfer ₹10,000 from Riya (101) to Vikram (102).
-- Demonstrates Atomicity and Consistency: both debit and credit must succeed.
-- =========================================================================
START TRANSACTION;

-- Step 1: Debit from Account 101
UPDATE Accounts 
SET balance = balance - 10000.00 
WHERE account_no = 101;

-- Step 2: Credit to Account 102
UPDATE Accounts 
SET balance = balance + 10000.00 
WHERE account_no = 102;

-- Step 3: Record transaction in audit log
INSERT INTO Transaction_Logs (from_acc, to_acc, amount, status) 
VALUES (101, 102, 10000.00, 'SUCCESS');

-- Commit all changes permanently to disk
COMMIT;

-- Verify updated balances after successful commit
SELECT * FROM Accounts;
SELECT * FROM Transaction_Logs;


-- =========================================================================
-- 4. TRANSACTION 2: INSUFFICIENT BALANCE & TRANSACTION ROLLBACK (ROLLBACK)
-- Scenario: Attempt to debit ₹60,000 from Account 101 (current balance ₹40,000).
-- The operation violates the CHECK (balance >= 0) constraint or business rules.
-- Demonstrates Atomicity: Entire transaction is rolled back, leaving state intact.
-- =========================================================================
START TRANSACTION;

-- Step 1: Attempt to debit an amount higher than current balance
-- (In strict SQL mode, this triggers a CHECK constraint violation)
UPDATE Accounts 
SET balance = balance - 60000.00 
WHERE account_no = 101;

-- If an error occurs or application detects invalid balance:
ROLLBACK;

-- Verify that Account 101 balance remains unchanged (₹40,000.00)
SELECT * FROM Accounts WHERE account_no IN (101, 102, 103);


-- =========================================================================
-- 5. TRANSACTION 3: BATCH TRANSFERS WITH PARTIAL ROLLBACK (SAVEPOINT)
-- Scenario:
--   - Valid Transfer 1: 101 -> 102 (₹5,000) [Should be retained]
--   - Invalid Transfer 2: 101 -> 999 (₹10,000) [Target doesn't exist, roll back only this step]
-- Demonstrates Savepoint: Rollback to savepoint preserves earlier valid work.
-- =========================================================================
START TRANSACTION;

-- Valid Transfer 1: 101 -> 102 (₹5,000)
UPDATE Accounts 
SET balance = balance - 5000.00 
WHERE account_no = 101;

UPDATE Accounts 
SET balance = balance + 5000.00 
WHERE account_no = 102;

INSERT INTO Transaction_Logs (from_acc, to_acc, amount, status) 
VALUES (101, 102, 5000.00, 'SUCCESS');

-- Set Savepoint after Transfer 1
SAVEPOINT sp_transfer1;

-- Invalid Transfer 2: Target account 999 does not exist
UPDATE Accounts 
SET balance = balance - 10000.00 
WHERE account_no = 101;

UPDATE Accounts 
SET balance = balance + 10000.00 
WHERE account_no = 999; -- Affects 0 rows because account 999 does not exist

-- Application detects that target account does not exist; rolls back Transfer 2 only
ROLLBACK TO SAVEPOINT sp_transfer1;

-- Log the partial failure in audit log
INSERT INTO Transaction_Logs (from_acc, to_acc, amount, status) 
VALUES (101, 999, 10000.00, 'FAILED_INVALID_ACC');

-- Commit remaining valid operations
COMMIT;


-- =========================================================================
-- 6. FINAL VERIFICATION & AUDIT TRAIL INSPECTION
-- =========================================================================
-- View final account balances
SELECT * FROM Accounts;

-- View complete transaction audit log
SELECT * FROM Transaction_Logs;
