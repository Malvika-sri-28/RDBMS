<div align="center">

# 🗄️ Relational Database Management System (RDBMS) Practicals

*This repository contains SQL scripts, relational schemas, ER diagrams, query implementations, and execution outputs for the **Relational Database Management System (RDBMS)** *

</div>

---

## 📚 Index of Experiments

| Exp No. | Experiment Title | Database Used | SQL Script | Outputs |
| :---: | :--- | :---: | :---: | :---: |
| **01** | [ER Diagram for Indian E-Commerce Platform](./Experiment-01/) | Conceptual Design | N/A (Diagram) | [`output/`](./Experiment-01/output/) |
| **02** | [Relational Schema & Referential Integrity Constraints](./Experiment-02/) | `IndianEcommerceDB` | [`Experiment_2.sql`](./Experiment-02/Experiment_2.sql) | [`output/`](./Experiment-02/output/) |
| **03** | [Selection, Projection, Aggregates, GROUP BY, HAVING & CASE](./Experiment-03/) | `CompanyDB` | [`Experiment_3.sql`](./Experiment-03/Experiment_3.sql) | [`output/`](./Experiment-03/output/) |
| **04** | [JOINs, Correlated Subqueries, Set Operations & EXPLAIN](./Experiment-04/) | `CompanyDB` | [`Experiment_4.sql`](./Experiment-04/Experiment_4.sql) | [`output/`](./Experiment-04/output/) |
| **05** | [SQL Views, View Updatability & Recursive CTEs](./Experiment-05/) | `CompanyDB` | [`Experiment_5.sql`](./Experiment-05/Experiment_5.sql) | [`output/`](./Experiment-05/output/) |
| **06** | [Stored Procedures, Transactions & Triggers](./Experiment-06/) | `CompanyDB` | [`Experiment_6.sql`](./Experiment-06/Experiment_6.sql) | [`output/`](./Experiment-06/output/) |
| **07** | [Database Normalization (UNF to 3NF/BCNF), Lossless Join & FD Preservation](./Experiment-07/) | `NormalizationDB` | [`Experiment_7.sql`](./Experiment-07/Experiment_7.sql) | [`output/`](./Experiment-07/output/) |
| **08** | [Transaction Processing, ACID Properties, Concurrency & Savepoints](./Experiment-08/) | `BankingDB` | [`Experiment_8.sql`](./Experiment-08/Experiment_8.sql) | [`output/`](./Experiment-08/output/) |
| **09** | [Database Indexing, B-Tree Indexes, Composite Indexes & Query Plan Analysis](./Experiment-09/) | `RailwayDB` | [`Experiment_9.sql`](./Experiment-09/Experiment_9.sql) | [`output/`](./Experiment-09/output/) |
| **10** | [Advanced SQL Query Optimization, Sargability, Anti-Joins & Join Tuning](./Experiment-10/) | `OptimizationDB` | [`Experiment_10.sql`](./Experiment-10/Experiment_10.sql) | [`output/`](./Experiment-10/output/) |

---

## 🏗️ Repository Structure

```text
RDBMS/
├── README.md                          # Main Repository Overview & Index
├── Experiment-01/
│   ├── README.md                      # ER Diagram Documentation
│   └── output/                        # Conceptual ER Diagram Screenshot
├── Experiment-02/
│   ├── README.md                      # Relational Schema & Constraints
│   ├── Experiment_2.sql               # IndianEcommerceDB DDL, DML & Integrity
│   └── output/                        # Constraint & Violation Screenshots (8)
├── Experiment-03/
│   ├── README.md                      # Selection, Projection, Aggregates & CASE
│   ├── Experiment_3.sql               # CompanyDB DDL, DML & Query Implementation
│   └── output/                        # Query Result Grid Screenshots (8)
├── Experiment-04/
│   ├── README.md                      # Advanced JOINs, Subqueries & EXPLAIN
│   ├── Experiment_4.sql               # Complex Joins, Subqueries & Plans
│   └── output/                        # Query Result Grid Screenshots (8)
├── Experiment-05/
│   ├── README.md                      # Views & Recursive CTEs
│   ├── Experiment_5.sql               # Views, Updatability & Hierarchical CTE
│   └── output/                        # View & CTE Execution Screenshots (3)
├── Experiment-06/
│   ├── README.md                      # Stored Procedures, Triggers & Transactions
│   ├── Experiment_6.sql               # Procedures, Salary Triggers & Audit Log
│   └── output/                        # Execution Screenshots (6)
├── Experiment-07/
│   ├── README.md                      # Normalization (UNF to BCNF)
│   ├── Experiment_7.sql               # Decomposition & Lossless Verification
│   └── output/                        # Execution & Verification Screenshots (8)
├── Experiment-08/
│   ├── README.md                      # Transaction Processing & ACID Properties
│   ├── Experiment_8.sql               # BankingDB Transactions, Rollback & Savepoints
│   └── output/                        # Balances & Audit Trail Logs
├── Experiment-09/
│   ├── README.md                      # Indexing & Query Execution Plan Analysis
│   ├── Experiment_9.sql               # RailwayDB Bulk Workload (5k) & EXPLAIN Plans
│   └── output/                        # Tabular EXPLAIN Analysis
└── Experiment-10/
    ├── README.md                      # Query Optimization & Sargability Tuning
    ├── Experiment_10.sql              # OptimizationDB 5 Bottleneck Solutions (14k rows)
    └── output/                        # Comparative Query Execution Plans
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
| :--- | :--- |
| **MySQL 8.0** | Relational Database Management System Engine |
| **MySQL Workbench** | Query execution, schema design, and result inspection |
| **Draw.io / Lucidchart** | Conceptual ER Diagram modeling |

---
*MALVIKA SRIVASTAVA | 25LBCS3382*
