# Experiment 4: JOINs, Correlated Subqueries, Set Operations & EXPLAIN

## 🎯 Aim

Using the `CompanyDB` Employee schema (from Experiment 3), write and execute SQL queries with **INNER JOIN**, **LEFT JOIN**, **Self-Join**, **3-Way Join**, **Correlated Subqueries**, **EXISTS**, and simulated **INTERSECT / EXCEPT**. Compare execution plans of selected queries using **EXPLAIN**.

---

## 📋 Objectives

- Understand and apply different types of **JOINs** (INNER, LEFT, SELF, 3-Way).
- Write **correlated subqueries** that reference the outer query.
- Use **EXISTS** to check for the existence of related rows.
- Simulate **INTERSECT** and **EXCEPT** set operations using subqueries.
- Use **EXPLAIN** to analyze and compare query execution plans.

---

## 🗄️ Database: `CompanyDB` (continued from Experiment 3)

> ⚠️ Run `Experiment_3.sql` first to create the schema and insert data.

---

## 🔍 Queries Demonstrated

| # | Query Type | Description |
| :---: | :--- | :--- |
| 1 | **INNER JOIN** | Employee IDs, names, salaries with department names |
| 2 | **LEFT JOIN** | All departments with any matching employees |
| 3 | **SELF JOIN** | Pairs of employees in the same department (first 10) |
| 4 | **3-WAY JOIN** | Employee → Department → Project details |
| 5 | **Correlated Subquery** | Employees earning above their department's average |
| 6 | **EXISTS** | Departments with at least one employee earning > ₹80,000 |
| 7 | **Simulated INTERSECT** | IT employees AND earning > ₹70,000 |
| 8 | **Simulated EXCEPT** | Employees earning > ₹70,000 EXCEPT those in IT |
| 9 | **EXPLAIN** | Execution plan comparison for JOIN vs Subquery vs EXISTS |

---

## 📊 EXPLAIN Comparison

The script runs `EXPLAIN` on three queries to compare how MySQL optimizes:

| Query | Key Observation |
| :--- | :--- |
| INNER JOIN with WHERE | Simple table scan, filter applied after join |
| Correlated Subquery | Dependent subquery re-evaluated per outer row |
| EXISTS | Semi-join optimization, stops at first match |

---

## ▶️ How to Run

```bash
# Ensure CompanyDB exists (run Experiment 3 first)
mysql -u root -p CompanyDB < Experiment_4.sql
```

---

## 📁 Files

| File | Description |
| :--- | :--- |
| [`Experiment_4.sql`](./Experiment_4.sql) | All JOIN, subquery, set operation, and EXPLAIN queries |
| [`DBMS4.docx`](./DBMS4.docx) | Lab report with query results and EXPLAIN analysis |
