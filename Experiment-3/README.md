# Experiment 3: Selection, Projection, Aggregates, GROUP BY, HAVING & CASE

## 🎯 Aim

Create an Employee–Department–Project relational database, insert at least 30 employees across 5 departments and 8 projects, and demonstrate SQL queries using **Selection**, **Projection**, **Aggregate Functions**, **GROUP BY**, **HAVING**, **CASE** expressions, and **ORDER BY**.

---

## 📋 Objectives

- Design and populate a normalized `CompanyDB` schema with `Department`, `Project`, and `Employee` tables.
- Write queries demonstrating each SQL clause/operator individually.
- Use **aggregate functions** (`COUNT`, `AVG`, `MAX`, `MIN`, `SUM`) for statistical analysis.
- Apply **CASE** expressions for conditional classification.

---

## 🗄️ Database: `CompanyDB`

### Schema Diagram

```
Department (dept_id PK, dept_name)
     │
     ├──< Project (project_id PK, project_name, budget, dept_id FK)
     │
     └──< Employee (emp_id PK, emp_name, salary, hire_date, dept_id FK, project_id FK)
```

### Tables

#### `Department`
| Column | Type | Constraint |
| :--- | :--- | :--- |
| `dept_id` | INT | PRIMARY KEY |
| `dept_name` | VARCHAR(50) | NOT NULL |

#### `Project`
| Column | Type | Constraint |
| :--- | :--- | :--- |
| `project_id` | INT | PRIMARY KEY |
| `project_name` | VARCHAR(100) | NOT NULL |
| `budget` | DECIMAL(12,2) | — |
| `dept_id` | INT | FOREIGN KEY → `Department` |

#### `Employee`
| Column | Type | Constraint |
| :--- | :--- | :--- |
| `emp_id` | INT | PRIMARY KEY |
| `emp_name` | VARCHAR(50) | NOT NULL |
| `salary` | DECIMAL(10,2) | — |
| `hire_date` | DATE | — |
| `dept_id` | INT | FOREIGN KEY → `Department` |
| `project_id` | INT | FOREIGN KEY → `Project` |

---

## 📊 Data Summary

| Table | Records | Details |
| :---: | :---: | :--- |
| Department | 5 | IT, HR, Finance, Marketing, Operations |
| Project | 8 | Enterprise Cloud, ML Platform, Talent Acquisition, etc. |
| Employee | 30 | 6 per department, salaries ₹48,000 – ₹84,000 |

---

## 🔍 Queries Demonstrated

| # | Query Type | Description |
| :---: | :--- | :--- |
| 1 | **Selection** (`WHERE`) | Employees with salary > ₹70,000 |
| 2 | **Projection** (`SELECT`) | Employee names and salaries only |
| 3 | **Aggregate Functions** | `COUNT`, `AVG`, `MAX`, `MIN`, `SUM` on all employees |
| 4 | **GROUP BY** | Employee count & average salary per department |
| 5 | **HAVING** | Departments with average salary > ₹65,000 |
| 6 | **CASE Expression** | Classify salaries as High / Medium / Low |
| 7 | **ORDER BY** | Employees sorted by salary descending |
| 8 | **Multi-table JOIN** | Employee with department and project names |

---

## ▶️ How to Run

```bash
mysql -u root -p < Experiment_3.sql
```

---

## 📁 Files

| File | Description |
| :--- | :--- |
| [`Experiment_3.sql`](./Experiment_3.sql) | Complete DDL, DML, and query demonstrations |
| [`DBMS3.docx`](./DBMS3.docx) | Lab report with query outputs and screenshots |
