# Experiment 9: Database Indexing, B-Tree Indexes, Composite Indexes & Query Plan Analysis

## 🎯 Aim

To design a large-scale railway reservation database schema, generate a synthetic workload of 5,000 booking records using a stored procedure with batch committing, and evaluate query performance before and after creating Single-Column and Multi-Column B-Tree indexes using `EXPLAIN` execution plans.

---

## 📋 Objectives

- Design and implement the `RailwayDB` schema with a `Railway_Bookings` table.
- Develop and execute a stored procedure `PopulateBookings(total_rows)` using fast batch ingestion (`autocommit = 0`) to insert 5,000 realistic train booking records.
- Use `EXPLAIN` to inspect query execution plans and interpret key metrics: access `type`, `possible_keys`, `key`, `key_len`, `rows`, and `Extra`.
- Create a **single-column B-Tree index** on `pnr_no` (`idx_pnr`) and analyze the transition from a full table scan (`ALL`) to an index seek (`ref`).
- Analyze multi-attribute query patterns involving `train_no`, `travel_date`, and `booking_status`.
- Create a **composite (multi-column) B-Tree index** (`idx_train_date_status`) following the Leftmost Prefix Rule and equality-first ordering.
- Contrast query cost, examined row counts, and disk I/O reduction achieved through indexing.

---

## 🗄️ Database Schema: `RailwayDB`

### `Railway_Bookings` Table
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `booking_id` | INT | `AUTO_INCREMENT PRIMARY KEY` | Unique booking ID |
| `pnr_no` | VARCHAR(12) | `NOT NULL` | 10-digit Passenger Name Record number |
| `train_no` | INT | `NOT NULL` | 5-digit train number (12000 - 12049) |
| `train_name` | VARCHAR(100) | `NOT NULL` | Express train name |
| `passenger_name` | VARCHAR(100) | `NOT NULL` | Name of passenger |
| `age` | INT | — | Passenger age (18 - 77) |
| `gender` | CHAR(1) | — | M / F |
| `travel_date` | DATE | `NOT NULL` | Date of journey |
| `source_station` | VARCHAR(50) | `NOT NULL` | Origin station (e.g. New Delhi, Mumbai CST) |
| `dest_station` | VARCHAR(50) | `NOT NULL` | Destination station (e.g. Bangalore, Pune) |
| `coach_class` | VARCHAR(10) | `NOT NULL` | '1A', '2A', '3A', 'SL', 'CC' |
| `fare` | DECIMAL(8,2) | `NOT NULL` | Ticket fare (₹500.00 - ₹3000.00) |
| `booking_status` | VARCHAR(15) | `NOT NULL` | 'CONFIRMED', 'RAC', 'WAITLIST' |
| `booking_time` | TIMESTAMP | `DEFAULT CURRENT_TIMESTAMP` | Transaction timestamp |

---

## 🔍 Indexing & Query Plan Comparison

### 1. Single-Column Index: `pnr_no`
```sql
SELECT * FROM Railway_Bookings WHERE pnr_no = '4829104821';
```

| Metric | Before Index | After Index (`idx_pnr`) | Optimization Impact |
| :--- | :---: | :---: | :--- |
| **Access Type (`type`)** | `ALL` | `ref` | Scans index tree instead of entire table blocks |
| **Possible Keys** | `NULL` | `idx_pnr` | Index recognized by MySQL query optimizer |
| **Key Used (`key`)** | `NULL` | `idx_pnr` | B-Tree index chosen for execution |
| **Key Length (`key_len`)** | `NULL` | 50 bytes | VARCHAR(12) utf8mb4 |
| **Estimated Rows (`rows`)** | **5,000** | **1** | **99.98% reduction in rows inspected** |
| **Extra** | `Using where` | — | Direct pointer seek via index |

---

### 2. Multi-Column Composite Index: `(train_no, travel_date, booking_status)`
```sql
SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';
```

| Metric | Before Index | After Index (`idx_train_date_status`) | Optimization Impact |
| :--- | :---: | :---: | :--- |
| **Access Type (`type`)** | `ALL` | `ref` | Transitions from exhaustive table scan to composite index seek |
| **Key Used (`key`)** | `NULL` | `idx_train_date_status` | Multi-column B-Tree index |
| **Key Length (`key_len`)** | `NULL` | 71 bytes | INT (4) + DATE (3) + VARCHAR(15) utf8mb4 (64) |
| **Estimated Rows (`rows`)** | **5,000** | **1 – 4** | **Over 99.9% reduction in rows inspected** |
| **Extra** | `Using where` | — | Eliminates intermediate filtering; satisfies all three predicates directly |

---

## 💻 SQL Script

The complete SQL implementation with DDL schema, bulk insertion stored procedure, index creation, and `EXPLAIN` query plans is available in:
🔗 **[`Experiment_9.sql`](./Experiment_9.sql)**

---

## 📷 Outputs

Detailed execution outputs, record counts, and tabular `EXPLAIN` execution plan outputs are documented in:
🔗 **[`output/`](./output/)**

---

## 📊 Result & Conclusion

### Result
1. The `RailwayDB` database and `Railway_Bookings` table were created with columns representing realistic passenger booking data.
2. The `PopulateBookings` stored procedure successfully generated and batch-committed 5,000 synthetic records in under 2 seconds using `SET autocommit = 0`.
3. Baseline query analysis with `EXPLAIN` confirmed that searching unindexed columns forced full table scans (`type = ALL`) examining all 5,000 rows.
4. Adding single-column B-Tree index `idx_pnr` reduced examined rows from 5,000 down to 1 (`type = ref`).
5. Adding multi-column composite index `idx_train_date_status` enabled simultaneous filtering across `train_no`, `travel_date`, and `booking_status`, reducing rows examined from 5,000 to only matching rows without post-scan filtering.

### Conclusion
Database indexes are critical structures that transform $O(N)$ sequential table scans into $O(\log N)$ logarithmic tree lookups. Single-column indexes are ideal for unique or highly selective lookup attributes (such as PNR or order numbers). Composite indexes further accelerate queries with multiple filter predicates when columns are ordered by equality columns first. However, index design must be balanced against insert/update write overhead and storage costs.
