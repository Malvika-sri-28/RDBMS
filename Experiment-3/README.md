# Experiment 3: Selection, Projection, Aggregates, GROUP BY, HAVING & CASE

## 🎯 Aim

To create an Employee–Department–Project relational database, insert at least 30 employees across 5 departments and 8 projects, and demonstrate SQL queries using **Selection**, **Projection**, **Aggregate Functions**, **GROUP BY**, **HAVING**, **CASE** expressions, and **ORDER BY**.

---

## 📋 Objectives

- Design and populate a normalized `CompanyDB` schema with `Department`, `Project`, and `Employee` tables.
- Execute SQL queries demonstrating relational algebra operations (Selection, Projection).
- Use **aggregate functions** (`COUNT`, `AVG`, `MAX`, `MIN`, `SUM`) for data summarization.
- Apply **GROUP BY** and **HAVING** clauses for group-level filtering.
- Implement conditional logic using **CASE** expressions.
- Perform multi-table joins to combine related records.

---

## 🗄️ Database Schema: `CompanyDB`

```
Department (dept_id PK, dept_name)
     │
     ├──< Project (project_id PK, project_name, budget, dept_id FK)
     │
     └──< Employee (emp_id PK, emp_name, salary, hire_date, dept_id FK, project_id FK)
```

- **Departments (5):** IT, HR, Finance, Marketing, Operations
- **Projects (8):** Enterprise Cloud, Machine Learning Platform, Talent Acquisition System, Audit & Accounting Suite, Social Media Growth, Logistics Optimization, Customer iOS App, Corporate Wellness
- **Employees (30):** Distributed across all departments with salaries ranging from ₹48,000 to ₹84,000

---

## 💻 SQL Script

The complete SQL implementation with DDL, sample data, and queries is available in:
🔗 **[`Experiment_3.sql`](./Experiment_3.sql)**

---

## 📷 Outputs

Query execution result screenshots are available in:
🔗 **[`output/`](./output/)**

---

## 📊 Result

The Employee–Department–Project relational database (`CompanyDB`) was successfully created, populated with 5 departments, 8 projects, and 30 employees, and queried using Selection, Projection, Aggregates, GROUP BY, HAVING, CASE, ORDER BY, and Multi-table JOINs.
