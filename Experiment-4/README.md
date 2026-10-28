# Experiment 4: JOINs, Correlated Subqueries, Set Operations & EXPLAIN

## 🎯 Aim

Using the Employee schema, write and execute SQL queries with **INNER JOIN**, **LEFT JOIN**, **Self-Join**, **3-Way Join**, **Correlated Subqueries**, **EXISTS**, and simulated **INTERSECT** and **EXCEPT**. Compare the execution plans of selected queries using **EXPLAIN**.

---

## 📋 Objectives

- Understand how different types of JOIN operations combine rows from related tables.
- Perform a **self-join** on the `Employee` table to compare pairs within the same department.
- Use **correlated subqueries** and **EXISTS** for row-by-row and existence-based filtering.
- Simulate **INTERSECT** and **EXCEPT** set operations using nested `IN` and `NOT IN` subqueries.
- Inspect and compare query execution plans using the **EXPLAIN** utility.

---

## 🗄️ Database Schema: `CompanyDB`

| Table | Important Columns | Relationships |
| :--- | :--- | :--- |
| `Employee` | `emp_id`, `emp_name`, `salary`, `hire_date`, `dept_id`, `project_id` | `dept_id` → Department, `project_id` → Project |
| `Department` | `dept_id`, `dept_name` | Primary Key: `dept_id` |
| `Project` | `project_id`, `project_name`, `budget`, `dept_id` | Primary Key: `project_id`, `dept_id` → Department |

---

## 💻 SQL Script

The complete SQL implementation with all queries and EXPLAIN statements is available in:
🔗 **[`Experiment_4.sql`](./Experiment_4.sql)**

---

## 📷 Outputs

Query execution result screenshots are available in:
🔗 **[`output/`](./output/)**

---

## 🔍 EXPLAIN — Execution Plan Comparison

The `EXPLAIN` statement displays how the MySQL query optimizer executes queries:

| Query | Main Operation | Plan Aspect to Compare | Expected Observation |
| :--- | :--- | :--- | :--- |
| **INNER JOIN** | Employee ↔ Department | Join access on `dept_id` | Optimizer scans base tables and joins via hash join or primary key index. |
| **Correlated Subquery** | Outer Employee + per-row department AVG | Subquery execution & rows examined | Evaluates the subquery repeatedly for each outer candidate row (`DEPENDENT SUBQUERY`). |
| **EXISTS** | Department + existence test on Employee | Early-exit filtering | Halts evaluation as soon as the first matching employee row is found per department. |

---

## 📊 Result & Conclusion

- Different SQL constructs achieve related data retrieval objectives through distinct optimizer access paths.
- While joins merge relational structures and set subqueries isolate target intersections, correlated subqueries and `EXISTS` evaluate row-level dependencies.
- The `EXPLAIN` utility confirms how query structure influences join buffers, index utilization, and execution cost.
