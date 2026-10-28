# Experiment 6: Stored Procedures, Transactions & Triggers

## 🎯 Aim

Create a stored procedure `transfer_employee(emp_id, new_dept_id)` with validation and error handling, implement **triggers** for salary validation and audit logging, and test important edge cases.

---

## 📋 Objectives

- Create an **audit table** to log salary changes.
- Implement **BEFORE INSERT** and **BEFORE UPDATE** triggers for salary range validation.
- Implement an **AFTER UPDATE** trigger for automatic audit logging.
- Write a **stored procedure** with `START TRANSACTION`, `COMMIT`, `ROLLBACK`, and custom error signals.
- Test all **edge cases** (invalid employee, invalid department, same department, salary boundaries).

---

## 🗄️ Database: `CompanyDB` (continued from Experiments 3–5)

> ⚠️ Run `Experiment_3.sql` and `Experiment_5.sql` first.

---

## 🔍 Components Demonstrated

### 1. `Employee_Salary_Audit` Table

| Column | Type | Description |
| :--- | :--- | :--- |
| `audit_id` | INT (AUTO_INCREMENT) | Primary Key |
| `emp_id` | INT | Employee whose salary changed |
| `old_salary` | DECIMAL(10,2) | Previous salary |
| `new_salary` | DECIMAL(10,2) | Updated salary |
| `changed_at` | TIMESTAMP | When the change occurred |
| `action` | VARCHAR(30) | Type of action (e.g., `SALARY UPDATE`) |

### 2. Triggers

| Trigger | Event | Purpose |
| :--- | :--- | :--- |
| `validate_employee_salary_insert` | BEFORE INSERT | Reject salary outside ₹30,000 – ₹1,50,000 |
| `validate_employee_salary_update` | BEFORE UPDATE | Reject salary outside ₹30,000 – ₹1,50,000 |
| `audit_salary_update` | AFTER UPDATE | Log old & new salary to `Employee_Salary_Audit` |

### 3. Stored Procedure: `transfer_employee(p_emp_id, p_new_dept_id)`

**Logic Flow:**
```
START TRANSACTION
  → Validate employee exists
  → Validate department exists
  → Check employee is not already in target department
  → UPDATE Employee SET dept_id = p_new_dept_id
COMMIT (or ROLLBACK on error)
```

---

## 🧪 Test Cases

| # | Test | Input | Expected Result |
| :---: | :--- | :--- | :---: |
| 1 | ✅ Successful Transfer | `transfer_employee(6, 4)` | Anjali → Marketing |
| 2 | ❌ Invalid Employee | `transfer_employee(99, 4)` | Error: Employee does not exist |
| 3 | ❌ Invalid Department | `transfer_employee(6, 99)` | Error: Department does not exist |
| 4 | ❌ Same Department | `transfer_employee(6, 4)` | Error: Already in this department |
| 5 | ❌ Salary Too Low | `SET salary = 20000` | Error: Salary must be between 30000 and 150000 |
| 6 | ✅ Valid Salary Update | `SET salary = 85000` | Success + Audit log entry |

---

## ▶️ How to Run

```bash
mysql -u root -p CompanyDB < Experiment_6.sql
```

---

## 📁 Files

| File | Description |
| :--- | :--- |
| [`Experiment_6.sql`](./Experiment_6.sql) | Triggers, stored procedure, and test cases |
| [`DBMS6.docx`](./DBMS6.docx) | Lab report with test outputs and analysis |
