# Experiment 7: Database Normalization (UNF to 3NF/BCNF)

## 🎯 Aim

Identify functional dependencies in a denormalized `Sales` table and normalize it step-by-step from **Unnormalized Form (UNF)** to **Third Normal Form (3NF)** and **Boyce–Codd Normal Form (BCNF)**. Verify **lossless join** and **dependency preservation** using SQL queries.

---

## 📋 Objectives

- Create a **denormalized Sales table** with redundant data.
- Identify all **functional dependencies (FDs)**.
- Normalize step-by-step: **UNF → 1NF → 2NF → 3NF/BCNF**.
- Verify the decomposition is a **lossless join** (no spurious tuples).
- Verify all **functional dependencies are preserved** across the decomposed tables.

---

## 🗄️ Database: `NormalizationDB`

### Denormalized Table: `Sales_UNF`

| Column | Depends On |
| :--- | :--- |
| `order_id` | — (part of key) |
| `order_date` | `order_id` |
| `customer_id` | `order_id` |
| `customer_name` | `customer_id` |
| `customer_city` | `customer_id` |
| `city_state` | `customer_city` |
| `product_id` | — (part of key) |
| `product_name` | `product_id` |
| `category` | `product_id` |
| `unit_price` | `product_id` |
| `quantity` | `order_id, product_id` |
| `salesperson_id` | `order_id` |
| `salesperson_name` | `salesperson_id` |
| `commission_pct` | `salesperson_id` |

---

## 📐 Normalization Steps

### Step 1: UNF → 1NF
- Assign composite primary key `(order_id, product_id)`.
- All values are already atomic (no repeating groups).

### Step 2: 1NF → 2NF (Remove Partial Dependencies)

| New Table | Primary Key | Columns |
| :--- | :--- | :--- |
| `Orders_2NF` | `order_id` | `order_date`, `customer_*`, `salesperson_*` |
| `Products_2NF` | `product_id` | `product_name`, `category`, `unit_price` |
| `OrderDetails_2NF` | `(order_id, product_id)` | `quantity` |

### Step 3: 2NF → 3NF / BCNF (Remove Transitive Dependencies)

| New Table | Primary Key | Columns |
| :--- | :--- | :--- |
| `Customers_3NF` | `customer_id` | `customer_name`, `customer_city` |
| `Cities_3NF` | `customer_city` | `city_state` |
| `Salespersons_3NF` | `salesperson_id` | `salesperson_name`, `commission_pct` |
| `Orders_3NF` | `order_id` | `order_date`, `customer_id` (FK), `salesperson_id` (FK) |
| `Products_3NF` | `product_id` | `product_name`, `category`, `unit_price` |
| `OrderDetails_3NF` | `(order_id, product_id)` | `quantity` |

---

## ✅ Verification

### Lossless Join Test
Reconstructs the original data by joining all 3NF tables and compares:

```
Original row count  == Reconstructed row count  → ✅ PASS
Original EXCEPT Reconstructed → Empty           → ✅ PASS
Reconstructed EXCEPT Original → Empty           → ✅ PASS
```

### Dependency Preservation Test
Each FD is verified by checking for violations in the corresponding 3NF table:

| FD | Table Checked | Violations |
| :--- | :--- | :---: |
| `order_id → order_date, customer_id, salesperson_id` | `Orders_3NF` | 0 ✅ |
| `customer_id → customer_name, customer_city` | `Customers_3NF` | 0 ✅ |
| `customer_city → city_state` | `Cities_3NF` | 0 ✅ |
| `product_id → product_name, category, unit_price` | `Products_3NF` | 0 ✅ |
| `salesperson_id → salesperson_name, commission_pct` | `Salespersons_3NF` | 0 ✅ |
| `(order_id, product_id) → quantity` | `OrderDetails_3NF` | 0 ✅ |

---

## ▶️ How to Run

```bash
mysql -u root -p < Experiment_7.sql
```

---

## 📁 Files

| File | Description |
| :--- | :--- |
| [`Experiment_7.sql`](./Experiment_7.sql) | Full normalization script with verification queries |
| [`DBMS7.docx`](./DBMS7.docx) | Lab report with step-by-step analysis |
