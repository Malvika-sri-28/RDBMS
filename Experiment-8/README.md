# Experiment 8: Transaction Processing, ACID Properties, Concurrency & Savepoints

## 🎯 Aim

To design a banking relational schema with account balances and transaction audit logging, and implement transaction control commands (`START TRANSACTION`, `COMMIT`, `ROLLBACK`, `SAVEPOINT`) to demonstrate Atomicity, Consistency, Isolation, and Durability (ACID), handling successful transfers, constraint violations, and partial rollbacks using savepoints.

---

## 📋 Objectives

- Design and implement the `BankingDB` schema with an `Accounts` table and an audit `Transaction_Logs` table.
- Enforce domain integrity using the `CHECK (balance >= 0)` constraint.
- Execute an atomic multi-step fund transfer using `START TRANSACTION` and `COMMIT`.
- Demonstrate transaction rollback using `ROLLBACK` when an operation attempts to exceed available funds.
- Implement nested transaction control using `SAVEPOINT` and `ROLLBACK TO SAVEPOINT` to recover from partial batch failures without aborting the entire transaction.
- Analyze and explain how relational database transaction managers maintain the **ACID** properties.
- Verify account consistency and review audit trail logs across all execution phases.

---

## 🗄️ Database Schema: `BankingDB`

### 1. `Accounts` Table
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `account_no` | INT | `PRIMARY KEY` | Unique customer account number |
| `holder_name` | VARCHAR(100) | `NOT NULL` | Account holder name |
| `account_type` | VARCHAR(20) | `NOT NULL` | Savings, Current, etc. |
| `balance` | DECIMAL(12,2) | `NOT NULL, CHECK (balance >= 0)` | Current account balance |

### 2. `Transaction_Logs` Table
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `log_id` | INT | `AUTO_INCREMENT PRIMARY KEY` | Audit entry identifier |
| `from_acc` | INT | — | Source account number |
| `to_acc` | INT | — | Destination account number |
| `amount` | DECIMAL(12,2) | — | Transferred amount |
| `status` | VARCHAR(20) | — | Outcome (`SUCCESS`, `FAILED_INVALID_ACC`) |
| `log_time` | TIMESTAMP | `DEFAULT CURRENT_TIMESTAMP` | System timestamp of log entry |

---

## 🛡️ ACID Properties in Action

| Property | Implementation in this Experiment |
| :--- | :--- |
| **Atomicity (All-or-Nothing)** | A fund transfer comprises both a debit from the sender and a credit to the receiver. If either fails, `ROLLBACK` undoes all partial updates so money cannot be destroyed or created. |
| **Consistency (Integrity)** | The `CHECK (balance >= 0)` constraint guarantees that an account balance can never drop below zero. Database state moves only from one valid state to another. |
| **Isolation (Concurrency)** | Concurrent transactions running simultaneously cannot see uncommitted intermediate states (preventing dirty reads, non-repeatable reads, and phantom reads). |
| **Durability (Permanence)** | Once `COMMIT` executes, all state changes and log records are permanently written to persistent storage and survive unexpected system crashes. |

---

## 📐 Transaction Execution Scenarios

### Scenario 1: Successful Atomic Transfer (`COMMIT`)
```text
[START TRANSACTION]
       │
       ▼
Debit ₹10,000 from Acc 101 (Balance: ₹50,000 -> ₹40,000)
       │
       ▼
Credit ₹10,000 to Acc 102 (Balance: ₹30,000 -> ₹40,000)
       │
       ▼
Insert Audit Log ('SUCCESS')
       │
       ▼
   [COMMIT] ===> Changes written permanently to disk
```

### Scenario 2: Insufficient Funds & Rollback (`ROLLBACK`)
```text
[START TRANSACTION]
       │
       ▼
Attempt Debit ₹60,000 from Acc 101 (Available: ₹40,000)
       │
       ▼
Violation: CHECK (balance >= 0) / Insufficient Balance
       │
       ▼
  [ROLLBACK] ===> Entire transaction undone; Acc 101 remains ₹40,000
```

### Scenario 3: Batch Transfer with Savepoint (`SAVEPOINT` & Partial Rollback)
```text
[START TRANSACTION]
       │
       ▼
Transfer 1: Acc 101 -> Acc 102 (₹5,000) [Valid]
       │
       ▼
[SAVEPOINT sp_transfer1]
       │
       ▼
Transfer 2: Acc 101 -> Acc 999 (₹10,000) [Invalid: Acc 999 does not exist]
       │
       ▼
[ROLLBACK TO SAVEPOINT sp_transfer1] ===> Transfer 2 discarded; Transfer 1 preserved!
       │
       ▼
Insert Audit Log (101 -> 999, 'FAILED_INVALID_ACC')
       │
       ▼
   [COMMIT] ===> Transfer 1 & Failure Audit Log permanently committed!
```

---

## 💻 SQL Script

The complete SQL implementation with schema creation, seed records, transaction statements, and audit verification is available in:
🔗 **[`Experiment_8.sql`](./Experiment_8.sql)**

---

## 📷 Outputs

Detailed execution outputs, tabular result sets, and transaction log audit trail screenshots and logs are documented in:
🔗 **[`output/`](./output/)**

---

## 📊 Result & Conclusion

### Result
1. The `BankingDB` database was created with `Accounts` (featuring `CHECK (balance >= 0)`) and `Transaction_Logs` audit tables.
2. Initial accounts were seeded for Riya Sharma (₹50,000), Vikram Patel (₹30,000), and Sneha Iyer (₹75,000).
3. **Transaction 1** successfully debited ₹10,000 from Account 101, credited Account 102, and logged `'SUCCESS'` using `COMMIT`.
4. **Transaction 2** demonstrated safe failure recovery: an illegal debit of ₹60,000 was intercepted and reverted using `ROLLBACK`, leaving Account 101's balance intact.
5. **Transaction 3** utilized `SAVEPOINT sp_transfer1` to isolate an invalid transfer to non-existent Account 999, allowing the application to roll back only the invalid operation while committing the valid transfer and audit log.

### Conclusion
Transaction control is fundamental to maintaining relational database integrity. SQL transaction boundaries (`START TRANSACTION`, `COMMIT`, `ROLLBACK`) ensure that complex multi-step operations execute atomically without corrupting data during runtime anomalies. Furthermore, savepoints provide granular control over complex batch operations, allowing applications to recover from partial errors gracefully without sacrificing previously completed valid work.
