<div align="center">

# 🗄️ Relational Database Management System (RDBMS) Practicals

[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/Malvika-sri-28/RDBMS/pulls)

*This repository contains SQL scripts, relational schemas, ER diagrams, query implementations, and execution outputs for the **Relational Database Management System (RDBMS)** coursework.*

</div>

---

## 📚 Index of Experiments

| Exp No. | Experiment Title | Database Used | SQL Script | Outputs |
| :---: | :--- | :---: | :---: | :---: |
| **01** | [ER Diagram for Indian E-Commerce Platform](./Experiment-1/) | Conceptual Design | N/A (Diagram) | [`output/`](./Experiment-1/output/) |
| **02** | [Relational Schema & Referential Integrity Constraints](./Experiment-2/) | `IndianEcommerceDB` | [`Experiment_2.sql`](./Experiment-2/Experiment_2.sql) | [`output/`](./Experiment-2/output/) |
| **03** | [Selection, Projection, Aggregates, GROUP BY, HAVING & CASE](./Experiment-3/) | `CompanyDB` | [`Experiment_3.sql`](./Experiment-3/Experiment_3.sql) | [`output/`](./Experiment-3/output/) |
| **04** | [JOINs, Correlated Subqueries, Set Operations & EXPLAIN](./Experiment-4/) | `CompanyDB` | [`Experiment_4.sql`](./Experiment-4/Experiment_4.sql) | [`output/`](./Experiment-4/output/) |
| **05** | [SQL Views, View Updatability & Recursive CTEs](./Experiment-5/) | `CompanyDB` | [`Experiment_5.sql`](./Experiment-5/Experiment_5.sql) | [`output/`](./Experiment-5/output/) |
| **06** | [Stored Procedures, Transactions & Triggers](./Experiment-6/) | `CompanyDB` | [`Experiment_6.sql`](./Experiment-6/Experiment_6.sql) | [`output/`](./Experiment-6/output/) |
| **07** | [Database Normalization (UNF to 3NF/BCNF), Lossless Join & FD Preservation](./Experiment-7/) | `NormalizationDB` | [`Experiment_7.sql`](./Experiment-7/Experiment_7.sql) | [`output/`](./Experiment-7/output/) |

---

## 🏗️ Repository Structure

```text
RDBMS/
├── README.md                          # Main Repository Overview & Index
├── Experiment-1/
│   ├── README.md                      # ER Diagram Documentation
│   └── output/                        # Conceptual ER Diagram Screenshot
├── Experiment-2/
│   ├── README.md                      # Relational Schema & Constraints
│   ├── Experiment_2.sql               # IndianEcommerceDB DDL, DML & Integrity
│   └── output/                        # Constraint & Violation Screenshots (8)
├── Experiment-3/
│   ├── README.md                      # Selection, Projection, Aggregates & CASE
│   ├── Experiment_3.sql               # CompanyDB DDL, DML & Query Implementation
│   └── output/                        # Query Result Grid Screenshots (8)
├── Experiment-4/
│   ├── README.md                      # Advanced JOINs, Subqueries & EXPLAIN
│   ├── Experiment_4.sql               # Complex Joins, Subqueries & Plans
│   └── output/                        # Query Result Grid Screenshots (8)
├── Experiment-5/
│   ├── README.md                      # Views & Recursive CTEs
│   ├── Experiment_5.sql               # Views, Updatability & Hierarchical CTE
│   └── output/                        # View & CTE Execution Screenshots (3)
├── Experiment-6/
│   ├── README.md                      # Stored Procedures, Triggers & Transactions
│   ├── Experiment_6.sql               # Procedures, Salary Triggers & Audit Log
│   └── output/                        # Execution Screenshots (6)
└── Experiment-7/
    ├── README.md                      # Normalization (UNF to BCNF)
    ├── Experiment_7.sql               # Decomposition & Lossless Verification
    └── output/                        # Execution & Verification Screenshots (8)
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
| :--- | :--- |
| **MySQL 8.0** | Relational Database Management System Engine |
| **MySQL Workbench** | Query execution, schema design, and result inspection |
| **Draw.io / Lucidchart** | Conceptual ER Diagram modeling |

---

## 📄 License

This repository is maintained for academic and educational purposes under the MIT License.
