# Experiment 10: Advanced SQL Query Optimization, Sargability, Anti-Joins, Index-Driven Sorting & Join Tuning

## 🎯 Aim

To design an e-commerce database with customers and orders, populate it with 14,000 records (2,000 customers and 12,000 orders) using a stored procedure, and analyze 5 distinct SQL query performance bottlenecks using `EXPLAIN`. Optimize each query through index design, query rewriting (sargability, anti-joins, prefix matching), and covering indexes.

---

## 📋 Objectives

- Design and implement the `OptimizationDB` schema with normalized `Customers` and `Orders` tables.
- Generate realistic high-volume test data (2,000 customers and 12,000 orders) using the `GenerateEcommerceData` stored procedure.
- Analyze query execution plans using `EXPLAIN` to detect common database anti-patterns:
  - Non-sargable function calls on indexed columns.
  - Non-indexable leading wildcards in `LIKE` filters.
  - Suboptimal subquery evaluation in `NOT IN` predicates.
  - Disk-heavy `Using filesort` on `ORDER BY ... LIMIT` operations.
  - High-cost `Using temporary; Using filesort` during multi-table `GROUP BY` aggregations.
- Implement corresponding query rewrites and composite/covering indexes to optimize access paths and eliminate temporary structures.
- Evaluate the computational and I/O savings across each optimization strategy.

---

## 🗄️ Database Schema: `OptimizationDB`

### 1. `Customers` Table (2,000 rows)
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `customer_id` | INT | `AUTO_INCREMENT PRIMARY KEY` | Unique customer ID |
| `customer_name` | VARCHAR(100) | `NOT NULL` | Full customer name |
| `email` | VARCHAR(100) | `NOT NULL` | Customer email address |
| `city` | VARCHAR(50) | `NOT NULL` | Customer city |
| `signup_date` | DATE | `NOT NULL` | Registration date |

### 2. `Orders` Table (12,000 rows)
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `order_id` | INT | `AUTO_INCREMENT PRIMARY KEY` | Unique order ID |
| `customer_id` | INT | `FOREIGN KEY -> Customers(customer_id)` | Placed by customer |
| `order_date` | DATETIME | `NOT NULL` | Order timestamp |
| `order_status` | VARCHAR(20) | `NOT NULL` | 'COMPLETED', 'PENDING', 'CANCELLED' |
| `payment_method` | VARCHAR(20) | `NOT NULL` | 'CREDIT_CARD', 'UPI', 'NET_BANKING', 'COD' |
| `total_amount` | DECIMAL(10,2) | `NOT NULL` | Billed order amount (₹100 - ₹10,000) |
| `shipping_city` | VARCHAR(50) | `NOT NULL` | Destination city |

---

## 🚀 Optimization Matrix: 5 Classic Query Bottlenecks

| # | Technique | Bottleneck / Anti-Pattern | Optimized Strategy | Key / Index Used | Plan Improvement |
| :---: | :--- | :--- | :--- | :--- | :--- |
| **1** | **Sargability** | `WHERE YEAR(order_date) = 2025` wraps column in function, disabling index seek | Rewrite as range: `order_date >= '2025-01-01' AND order_date < '2026-01-01'` | `idx_orders_order_date (order_date)` | `ALL` (12,000 rows) ➔ `range` (exact year rows) |
| **2** | **Wildcard Matching** | `WHERE email LIKE '%@gmail.com'` forces full scan due to unanchored prefix | Use anchored prefix `LIKE 'user100%'` or exact domain column | `idx_customers_email (email)` | `ALL` (2,000 rows) ➔ `range` seek |
| **3** | **Anti-Join Tuning** | `WHERE customer_id NOT IN (SELECT ...)` subquery materialization & NULL issues | Rewrite as `LEFT JOIN Orders ... WHERE o.order_id IS NULL` | `idx_orders_cust_status (customer_id, order_status)` | Subquery ➔ Direct Index Anti-Join (`Not exists`) |
| **4** | **Filesort Elimination** | `ORDER BY total_amount DESC LIMIT 10` forces memory/disk filesort | Create composite index matching filter + sort: `(order_status, total_amount DESC)` | `idx_status_amount (order_status, total_amount DESC)` | Eliminates `Using filesort`; index is read pre-sorted, stopping after 10 rows |
| **5** | **Covering Join** | `JOIN ... GROUP BY c.city ORDER BY revenue DESC` causes temp table & filesort | Add covering indexes to satisfy join, filter, group, and aggregate without base table reads | `idx_customers_id_city` & `idx_orders_covering` | Eliminates base table row fetches (`Using index`) |

---

## 💻 SQL Script

The complete SQL implementation with DDL schema, bulk data generation procedure, 5 optimization scenarios, and comparative `EXPLAIN` query plans is available in:
🔗 **[`Experiment_10.sql`](./Experiment_10.sql)**

---

## 📷 Outputs

Detailed execution plans, comparative metric tables, and query execution outputs are documented in:
🔗 **[`output/`](./output/)**

---

## 📊 Result & Conclusion

### Result
1. The `OptimizationDB` schema was created and seeded with 2,000 customers and 12,000 orders using `GenerateEcommerceData()`.
2. **Sargability:** Removing `YEAR()` from the `WHERE` clause converted a 12,000-row table scan into a targeted B-Tree range scan on `idx_orders_order_date`.
3. **Prefix Indexing:** Replacing a leading wildcard search with a prefix filter allowed MySQL to utilize the B-Tree index structure.
4. **Anti-Join:** Rewriting `NOT IN` subquery to a `LEFT JOIN ... WHERE NULL` with composite index `idx_orders_cust_status` eliminated subquery overhead and leveraged MySQL's `Not exists` anti-join optimization.
5. **Sort Optimization:** Adding `idx_status_amount` completely eliminated the `Using filesort` step for `ORDER BY ... LIMIT` queries by traversing pre-sorted index leaf nodes.
6. **Covering Join:** Creating covering indexes on both tables satisfied the join and aggregation entirely in RAM without accessing primary table data pages.

### Conclusion
Writing efficient SQL queries requires understanding both relational algebra and physical storage engine mechanisms. Indexes alone do not guarantee performance if queries are written non-sargably or if sorting requires full filesorts. By pairing composite index design with query refactoring (range predicates, anti-joins, covering attributes), database systems can handle orders of magnitude higher throughput with minimal CPU and I/O overhead.

