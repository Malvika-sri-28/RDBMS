# Experiment 5: SQL Views, View Updatability & Recursive CTEs

## 🎯 Aim

Create SQL views for **department salary summary** and **employee hierarchy**, test the **updatability of views**, and implement a **recursive CTE** to display reporting chains.

---

## 📋 Objectives

- Add a `manager_id` self-referencing column to model an **employee hierarchy**.
- Create a **grouped/aggregate view** (`department_salary_summary`) and a **joined view** (`employee_hierarchy`).
- Test which views are **updatable** and which are **read-only** in MySQL.
- Write a **Recursive Common Table Expression (CTE)** to trace full reporting paths.

---

## 🗄️ Database: `CompanyDB` (continued from Experiments 3–4)

> ⚠️ Run `Experiment_3.sql` first. This script adds `manager_id` to `Employee`.

### Schema Modification

```sql
ALTER TABLE Employee ADD COLUMN manager_id INT;
ALTER TABLE Employee ADD FOREIGN KEY (manager_id) REFERENCES Employee(emp_id);
```

### Manager Hierarchy (per department)

```
Department Head (manager_id = NULL)
├── Direct Report 1
│   ├── Subordinate A
│   └── Subordinate B
└── Direct Report 2
    └── Subordinate C
```

---

## 🔍 Components Demonstrated

### 1. `department_salary_summary` View
Aggregates employee statistics by department:

| Column | Description |
| :--- | :--- |
| `dept_id` | Department ID |
| `dept_name` | Department Name |
| `employee_count` | Number of employees |
| `average_salary` | Average salary in department |
| `minimum_salary` | Lowest salary |
| `maximum_salary` | Highest salary |
| `total_salary` | Sum of all salaries |

### 2. `employee_hierarchy` View
Joins Employee with Department and self-joins for manager names:

| Column | Description |
| :--- | :--- |
| `emp_id`, `emp_name` | Employee details |
| `dept_id`, `dept_name` | Department details |
| `manager_id`, `manager_name` | Reporting manager |
| `salary` | Employee salary |

### 3. View Updatability Tests

| View | Update Attempted | Result |
| :--- | :--- | :---: |
| `employee_hierarchy` | `SET salary = salary + 1000` for `emp_id = 6` | ✅ Success |
| `department_salary_summary` | `SET average_salary = average_salary + 1000` | ❌ Error (aggregate view) |

> **Rule:** MySQL allows updates on views that map directly to a single base table without aggregation. Views with `GROUP BY`, `HAVING`, or aggregate functions are **read-only**.

### 4. Recursive CTE — Reporting Chain

Traces the full reporting path from department heads down to leaf employees:

```
Rahul → Priya → Amit → Anjali
Rahul → Priya → Vikram
Rahul → Sneha
...
```

---

## ▶️ How to Run

```bash
mysql -u root -p CompanyDB < Experiment_5.sql
```

---

## 📁 Files

| File | Description |
| :--- | :--- |
| [`Experiment_5.sql`](./Experiment_5.sql) | Views, updatability tests, and recursive CTE |
| [`DBMS5.docx`](./DBMS5.docx) | Lab report with outputs and analysis |
