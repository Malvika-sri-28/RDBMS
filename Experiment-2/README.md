# Experiment 2: Relational Schema & Referential Integrity Constraints

## 🎯 Aim

Convert the ER diagram into a relational schema. Write complete MySQL `CREATE TABLE` statements with primary keys, foreign keys, `NOT NULL`, `UNIQUE`, `ON DELETE CASCADE` and `SET NULL` constraints. Insert sample data and demonstrate referential integrity violations.

---

## 📋 Objectives

- Map each entity from the ER diagram to a **relational table** with appropriate data types.
- Define **primary keys**, **foreign keys**, and column-level constraints (`NOT NULL`, `UNIQUE`, `DEFAULT`).
- Specify **referential actions** (`ON DELETE CASCADE`, `ON DELETE SET NULL`).
- Insert realistic **Indian e-commerce sample data**.
- Demonstrate and verify what happens when **constraint violations** occur.

---

## 🗄️ Database Schema: `IndianEcommerceDB`

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

## 💻 SQL Script

The complete SQL implementation with table creation, data insertion, and integrity checks is available in:
🔗 **[`Experiment_2.sql`](./Experiment_2.sql)**

---

## 📷 Outputs

Constraint verification and violation output screenshots are available in:
🔗 **[`output/`](./output/)**

---

## 📊 Result

The Indian E-Commerce Platform relational database (`IndianEcommerceDB`) was successfully designed, implemented, and tested with **6 Categories**, **5 Sellers**, **15 Products**, **10 Customers**, **12 Orders**, **15 Order Items**, **12 Payments**, and **10 Reviews**. All primary key, foreign key, NOT NULL, UNIQUE, ON DELETE CASCADE, and ON DELETE SET NULL constraints were verified.
