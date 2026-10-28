# Experiment 2: Relational Schema & Referential Integrity Constraints

## 🎯 Aim

Convert the ER diagram (Experiment 1) into a relational schema. Write complete MySQL `CREATE TABLE` statements with primary keys, foreign keys, `NOT NULL`, `UNIQUE`, `ON DELETE CASCADE` and `SET NULL` constraints. Insert sample data and demonstrate referential integrity violations.

---

## 📋 Objectives

- Map each entity from the ER diagram to a **relational table** with appropriate data types.
- Define **primary keys**, **foreign keys**, and column-level constraints (`NOT NULL`, `UNIQUE`, `DEFAULT`).
- Specify **referential actions** (`ON DELETE CASCADE`, `ON DELETE SET NULL`).
- Insert realistic **Indian e-commerce sample data**.
- Demonstrate what happens when **constraint violations** occur.

---

## 🗄️ Database: `IndianEcommerceDB`

### Schema Overview

| Table | Primary Key | Foreign Key(s) | Referential Action |
| :--- | :--- | :--- | :--- |
| `Category` | `category_id` | — | — |
| `Seller` | `seller_id` | — | — |
| `Product` | `product_id` | `seller_id`, `category_id` | `CASCADE`, `SET NULL` |
| `Customer` | `customer_id` | — | — |
| `Orders` | `order_id` | `customer_id` | `CASCADE` |
| `Order_Item` | `item_id` | `order_id`, `product_id` | `CASCADE`, `SET NULL` |
| `Payment` | `payment_id` | `order_id` (UNIQUE) | `CASCADE` |
| `Review` | `review_id` | `product_id`, `customer_id` | `CASCADE`, `CASCADE` |

---

## 📊 Sample Data Summary

| Table | Rows Inserted |
| :---: | :---: |
| Category | 6 |
| Seller | 5 |
| Product | 15 |
| Customer | 10 |
| Orders | 12 |
| Order_Item | 15 |
| Payment | 12 |
| Review | 10 |

---

## ⚠️ Constraint Violation Demonstrations

| # | Violation Type | What Was Tested | Expected Result |
| :---: | :--- | :--- | :--- |
| 1 | **FOREIGN KEY** | Insert order with non-existent `customer_id = 99` | ❌ Error |
| 2 | **UNIQUE** | Duplicate `email` in `Customer` table | ❌ Error |
| 3 | **NOT NULL** | Insert `Seller` with `gst_number = NULL` | ❌ Error |
| 4 | **ON DELETE CASCADE** | Delete `Seller` → Products of that seller removed | ✅ Cascade |
| 5 | **ON DELETE SET NULL** | Delete `Category` → Product's `category_id` set to `NULL` | ✅ Set NULL |
| 6 | **UNIQUE (Payment)** | Duplicate `order_id` in `Payment` table | ❌ Error |

---

## ▶️ How to Run

```bash
mysql -u root -p < Experiment_2.sql
```

---

## 📁 Files

| File | Description |
| :--- | :--- |
| [`Experiment_2.sql`](./Experiment_2.sql) | Complete SQL script with DDL, DML, and violation demos |
| [`DBMS2.docx`](./DBMS2.docx) | Detailed lab report with screenshots |
