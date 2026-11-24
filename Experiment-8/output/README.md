# Experiment 8: Execution Outputs & Audit Logs

This directory documents the query outputs and audit log results for **Experiment 8: Transaction Processing, ACID Properties, Concurrency & Savepoints**.

---

### Output 1: Baseline Accounts State
```sql
SELECT * FROM Accounts;
```
| account_no | holder_name | account_type | balance |
| :---: | :--- | :--- | :---: |
| `101` | Riya Sharma | Savings | `50000.00` |
| `102` | Vikram Patel | Savings | `30000.00` |
| `103` | Sneha Iyer | Current | `75000.00` |

---

### Output 2: Balances After Transaction 1 (Successful Transfer of ₹10,000)
```sql
COMMIT;
SELECT * FROM Accounts;
```
| account_no | holder_name | account_type | balance |
| :---: | :--- | :--- | :---: |
| `101` | Riya Sharma | Savings | `40000.00` |
| `102` | Vikram Patel | Savings | `40000.00` |
| `103` | Sneha Iyer | Current | `75000.00` |

---

### Output 3: Balances After Transaction 2 (Attempted Overdraw & ROLLBACK)
```sql
ROLLBACK;
SELECT * FROM Accounts WHERE account_no IN (101, 102, 103);
```
| account_no | holder_name | account_type | balance |
| :---: | :--- | :--- | :---: |
| `101` | Riya Sharma | Savings | `40000.00` |
| `102` | Vikram Patel | Savings | `40000.00` |
| `103` | Sneha Iyer | Current | `75000.00` |

*Explanation:* An attempt to debit ₹60,000 when only ₹40,000 was available was safely rolled back. No balance changes occurred.

---

### Output 4: Final Account Balances After Transaction 3 (Savepoint & Partial Rollback)
```sql
SELECT * FROM Accounts;
```
| account_no | holder_name | account_type | balance |
| :---: | :--- | :--- | :---: |
| `101` | Riya Sharma | Savings | `35000.00` |
| `102` | Vikram Patel | Savings | `45000.00` |
| `103` | Sneha Iyer | Current | `75000.00` |

*Explanation:* Transfer 1 (101 -> 102 for ₹5,000) was committed. Transfer 2 (101 -> 999 for ₹10,000) was rolled back to savepoint `sp_transfer1` because Account 999 was non-existent.

---

### Output 5: Final Audit Trail Log (`Transaction_Logs`)
```sql
SELECT * FROM Transaction_Logs;
```
| log_id | from_acc | to_acc | amount | status | log_time |
| :---: | :---: | :---: | :---: | :---: | :---: |
| `1` | 101 | 102 | `10000.00` | `SUCCESS` | `2026-11-24 10:15:32` |
| `2` | 101 | 102 | `5000.00` | `SUCCESS` | `2026-11-24 10:16:18` |
| `3` | 101 | 999 | `10000.00` | `FAILED_INVALID_ACC` | `2026-11-24 10:16:19` |
