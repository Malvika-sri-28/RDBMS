# Experiment 10: Execution Outputs & Query Execution Plans

This directory documents the query execution outputs, comparative execution plans, and optimization metrics for **Experiment 10: Advanced SQL Query Optimization, Sargability, Anti-Joins, Index-Driven Sorting & Join Tuning**.

---

### Output 1: Workload Generation Verification
```sql
CALL GenerateEcommerceData();
SELECT 'Customers' AS entity, COUNT(*) AS count FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders;
```
| entity | count |
| :--- | :---: |
| `Customers` | `2000` |
| `Orders` | `12000` |

---

### Output 2: Technique 1 — Sargability (`YEAR(order_date) = 2025` vs Range Scan)

#### A. Non-Sargable Function Query Plan (BEFORE)
```sql
EXPLAIN SELECT COUNT(*), SUM(total_amount) FROM Orders WHERE YEAR(order_date) = 2025;
```
| id | select_type | table | type | possible_keys | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Orders` | `ALL` | `NULL` | `NULL` | **12000** | `Using where` |

#### B. Sargable Range Scan Query Plan (AFTER)
```sql
CREATE INDEX idx_orders_order_date ON Orders(order_date);
EXPLAIN SELECT COUNT(*), SUM(total_amount) FROM Orders 
WHERE order_date >= '2025-01-01 00:00:00' AND order_date < '2026-01-01 00:00:00';
```
| id | select_type | table | type | possible_keys | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Orders` | **range** | `idx_orders_order_date` | **idx_orders_order_date** | **~5980** | `Using index condition` |

---

### Output 3: Technique 2 — Leading Wildcard vs Prefix Search

#### A. Leading Wildcard Query Plan (`%@gmail.com`)
```sql
EXPLAIN SELECT customer_id, customer_name, email FROM Customers WHERE email LIKE '%@gmail.com';
```
| id | select_type | table | type | possible_keys | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Customers` | `ALL` | `NULL` | `NULL` | **2000** | `Using where` |

#### B. Prefix Pattern Query Plan (`user100%`)
```sql
CREATE INDEX idx_customers_email ON Customers(email);
EXPLAIN SELECT customer_id, customer_name, email FROM Customers WHERE email LIKE 'user100%';
```
| id | select_type | table | type | possible_keys | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Customers` | **range** | `idx_customers_email` | **idx_customers_email** | **~11** | `Using index condition` |

---

### Output 4: Technique 3 — Anti-Join Optimization (`NOT IN` vs `LEFT JOIN ... IS NULL`)

#### A. `NOT IN` Subquery Query Plan
```sql
EXPLAIN SELECT customer_id, customer_name FROM Customers 
WHERE customer_id NOT IN (SELECT customer_id FROM Orders WHERE order_status = 'COMPLETED');
```
| id | select_type | table | type | possible_keys | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `1` | `PRIMARY` | `Customers` | `ALL` | `NULL` | `NULL` | **2000** | `Using where` |
| `2` | `SUBQUERY` | `Orders` | `ALL` | `NULL` | `NULL` | **12000** | `Using where` |

#### B. Left Anti-Join Query Plan with Composite Index (`idx_orders_cust_status`)
```sql
CREATE INDEX idx_orders_cust_status ON Orders(customer_id, order_status);
EXPLAIN SELECT c.customer_id, c.customer_name 
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id AND o.order_status = 'COMPLETED'
WHERE o.order_id IS NULL;
```
| id | select_type | table | type | possible_keys | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `c` | `ALL` | `PRIMARY` | `NULL` | **2000** | `NULL` |
| `1` | `SIMPLE` | `o` | **ref** | `idx_orders_cust_status` | **idx_orders_cust_status** | **~6** | **Using where; Not exists** |

---

### Output 5: Technique 4 — Filesort Elimination on `ORDER BY ... LIMIT`

#### A. Filesort Query Plan (BEFORE)
```sql
EXPLAIN SELECT order_id, customer_id, total_amount, order_date 
FROM Orders WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC LIMIT 10;
```
| id | select_type | table | type | possible_keys | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Orders` | `ALL` | `NULL` | `NULL` | **12000** | **Using where; Using filesort** |

#### B. Pre-Sorted Composite Index Seek (AFTER)
```sql
CREATE INDEX idx_status_amount ON Orders(order_status, total_amount DESC);
EXPLAIN SELECT order_id, customer_id, total_amount, order_date 
FROM Orders WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC LIMIT 10;
```
| id | select_type | table | type | possible_keys | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Orders` | **ref** | `idx_status_amount` | **idx_status_amount** | **~3990** | **NULL (No filesort; stopped after 10 rows!)** |

---

### Output 6: Technique 5 — Covering Indexes for Multi-Table Aggregation

#### A. Unindexed Join & Group By Plan
```sql
EXPLAIN SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city ORDER BY revenue DESC;
```
| id | select_type | table | type | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `o` | `ALL` | `NULL` | **12000** | **Using temporary; Using filesort** |
| `1` | `SIMPLE` | `c` | `eq_ref` | `PRIMARY` | **1** | `NULL` |

#### B. Covering Indexes Plan
```sql
CREATE INDEX idx_customers_id_city ON Customers(customer_id, city);
CREATE INDEX idx_orders_covering ON Orders(customer_id, order_status, total_amount);
EXPLAIN SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city ORDER BY revenue DESC;
```
| id | select_type | table | type | key | rows | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `o` | **ref** | **idx_orders_covering** | **~3990** | **Using where; Using index** |
| `1` | `SIMPLE` | `c` | **ref** | **idx_customers_id_city** | **1** | **Using index** |

