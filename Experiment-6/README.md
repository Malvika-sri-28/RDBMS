# Experiment 6: Stored Procedures, Transactions & Triggers

## 🎯 Aim

To create a stored procedure `transfer_employee(emp_id, new_dept_id)` with validation and error handling, implement triggers for salary validation and audit logging, and test important edge cases.

---

## 📋 Objectives

- Create a stored procedure for transferring an employee between departments.
- Validate employee and department identifiers before performing a transfer.
- Use transaction control (`START TRANSACTION`, `COMMIT`, `ROLLBACK`) and error handling inside a stored procedure.
- Validate salary values using a trigger `BEFORE INSERT` or `UPDATE` (enforcing ₹30,000 to ₹1,50,000 range).
- Maintain an audit log whenever an employee salary is changed.
- Test successful and invalid transfer and salary-update edge cases.

---

## 🗄️ Database Schema: `CompanyDB`

### 1. `Employee_Salary_Audit` Table
| Column | Type | Description |
| :--- | :--- | :--- |
| `audit_id` | INT (AUTO_INCREMENT) | Primary Key |
| `emp_id` | INT | Employee ID |
| `old_salary` | DECIMAL(10,2) | Previous salary |
| `new_salary` | DECIMAL(10,2) | Updated salary |
| `changed_at` | TIMESTAMP | Timestamp of change (`DEFAULT CURRENT_TIMESTAMP`) |
| `action` | VARCHAR(30) | Audit action type (`SALARY UPDATE`) |

### 2. Triggers
| Trigger Name | Event | Description |
| :--- | :--- | :--- |
| `validate_employee_salary_insert` | `BEFORE INSERT ON Employee` | Enforces salary between 30,000 and 150,000 |
| `validate_employee_salary_update` | `BEFORE UPDATE ON Employee` | Enforces salary between 30,000 and 150,000 |
| `audit_salary_update` | `AFTER UPDATE ON Employee` | Automatically logs old and new salary to audit table |

### 3. Stored Procedure: `transfer_employee(p_emp_id, p_new_dept_id)`
Transfers an employee with validation checks:
- Verifies employee existence (raises SQLSTATE `'45000'` if not found)
- Verifies department existence (raises SQLSTATE `'45000'` if not found)
- Prevents redundant transfer if already in target department
- Manages transaction safety with `EXIT HANDLER FOR SQLEXCEPTION` and `ROLLBACK`

---

## 💻 SQL Script

The complete SQL implementation with table DDL, triggers, stored procedure, and test queries is available in:
🔗 **[`Experiment_6.sql`](./Experiment_6.sql)**

---

## 📷 Outputs

Procedure execution, error handling, and audit log screenshots are available in:
🔗 **[`output/`](./output/)**

---

## 📊 Result & Conclusion

### Result
1. The `Employee_Salary_Audit` table was created to preserve salary history.
2. `BEFORE INSERT` and `BEFORE UPDATE` triggers successfully enforced salary limits (30,000 to 1,50,000).
3. The `AFTER UPDATE` trigger automatically logged old and new salary values into the audit table.
4. The `transfer_employee` stored procedure successfully transferred an employee with transaction management and raised exceptions for invalid edge cases.

### Conclusion
Stored procedures provide a centralized and secure way to execute complex business logic and manage transactions with `COMMIT` and `ROLLBACK`. Database triggers enforce business rules and automate audit logging at the database level, ensuring data integrity regardless of external application interfaces.
