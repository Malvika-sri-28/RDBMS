# Experiment 9: Execution Outputs & Query Execution Plans

This directory documents the execution outputs, data generation verification, and tabular `EXPLAIN` query execution plans for **Experiment 9: Database Indexing, B-Tree Indexes, Composite Indexes & Query Plan Analysis**.

---

### Output 1: Procedure Execution & Workload Verification
```sql
CALL PopulateBookings(5000);
SELECT COUNT(*) AS total_records FROM Railway_Bookings;
```
| total_records |
| :---: |
| `5000` |

---

### Output 2: Sample Generated Bookings
```sql
SELECT booking_id, pnr_no, train_no, train_name, passenger_name, travel_date, coach_class, fare, booking_status 
FROM Railway_Bookings LIMIT 3;
```
| booking_id | pnr_no | train_no | train_name | passenger_name | travel_date | coach_class | fare | booking_status |
| :---: | :---: | :---: | :--- | :--- | :---: | :---: | :---: | :--- |
| `1` | `4829104821` | `12015` | Express-12015 | Passenger_1 | `2026-07-15` | `3A` | `1450.00` | `CONFIRMED` |
| `2` | `7182938491` | `12004` | Express-12004 | Passenger_2 | `2026-06-22` | `SL` | `680.00` | `WAITLIST` |
| `3` | `9018273645` | `12030` | Express-12030 | Passenger_3 | `2026-08-01` | `2A` | `2100.00` | `RAC` |

---

### Output 3: PNR Query Plan BEFORE Index (Full Table Scan)
```sql
EXPLAIN SELECT * FROM Railway_Bookings WHERE pnr_no = '4829104821';
```
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Railway_Bookings` | `NULL` | `ALL` | `NULL` | `NULL` | `NULL` | `NULL` | **5000** | `10.00` | `Using where` |

---

### Output 4: PNR Query Plan AFTER Index (`idx_pnr`)
```sql
CREATE INDEX idx_pnr ON Railway_Bookings (pnr_no);
EXPLAIN SELECT * FROM Railway_Bookings WHERE pnr_no = '4829104821';
```
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Railway_Bookings` | `NULL` | `ref` | `idx_pnr` | **idx_pnr** | `50` | `const` | **1** | `100.00` | `NULL` |

---

### Output 5: Composite Multi-Column Query Plan BEFORE Index
```sql
EXPLAIN SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';
```
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Railway_Bookings` | `NULL` | `ALL` | `NULL` | `NULL` | `NULL` | `NULL` | **5000** | `0.67` | `Using where` |

---

### Output 6: Composite Multi-Column Query Plan AFTER Index (`idx_train_date_status`)
```sql
CREATE INDEX idx_train_date_status ON Railway_Bookings (train_no, travel_date, booking_status);
EXPLAIN SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';
```
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
| :---: | :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `1` | `SIMPLE` | `Railway_Bookings` | `NULL` | `ref` | `idx_train_date_status` | **idx_train_date_status** | `71` | `const,const,const` | **2** | `100.00` | `NULL` |
