# Experiment 7: Database Normalization (UNF to 3NF/BCNF)

## 🎯 Aim

To identify functional dependencies in a denormalized Sales table and normalize it step-by-step from Unnormalized Form (UNF) to Third Normal Form (3NF) and Boyce–Codd Normal Form (BCNF). Verify lossless join and dependency preservation using SQL queries.

---

## 📋 Objectives

- Create a denormalized Sales table that contains repeating groups and redundant data.
- Identify all functional dependencies present in the data.
- Convert the table from UNF to 1NF by eliminating repeating groups and establishing a composite primary key.
- Convert from 1NF to 2NF by removing partial dependencies.
- Convert from 2NF to 3NF by removing transitive dependencies.
- Convert from 3NF to BCNF by ensuring every determinant is a candidate key.
- Verify lossless join by reconstructing the original data using natural joins.
- Verify dependency preservation by checking all original FDs against the decomposed tables.

---

## 🗄️ Database: `NormalizationDB`

### Functional Dependencies Identified
- **FD1:** `order_id → order_date, customer_id, salesperson_id`
- **FD2:** `customer_id → customer_name, customer_city`
- **FD3:** `customer_city → city_state`
- **FD4:** `product_id → product_name, category, unit_price`
- **FD5:** `salesperson_id → salesperson_name, commission_pct`
- **FD6:** `order_id, product_id → quantity`
- **Candidate Key:** `{order_id, product_id}` (composite key uniquely identifying each row)

### Anomalies in UNF / 1NF:
- **Insertion anomaly:** Cannot add a new product without an order.
- **Update anomaly:** Changing customer city requires updating multiple rows.
- **Deletion anomaly:** Deleting the last order of a customer loses customer data.

---

## 📐 Normalization Progression

| Normal Form | Action Taken | Resulting Tables |
| :--- | :--- | :--- |
| **UNF → 1NF** | Ensure atomic attributes and assign composite primary key `(order_id, product_id)` | `Sales_1NF` |
| **1NF → 2NF** | Remove partial dependencies (attributes depending on only part of the key) | `Orders_2NF`, `Products_2NF`, `OrderDetails_2NF` |
| **2NF → 3NF** | Remove transitive dependencies (non-key attribute depending on non-key attribute) | `Customers_3NF`, `Cities_3NF`, `Salespersons_3NF`, `Orders_3NF`, `Products_3NF`, `OrderDetails_3NF` |
| **3NF → BCNF** | Ensure every determinant is a candidate key | Confirmed in BCNF (no further decomposition required) |

---

## 💻 SQL Script

The complete SQL implementation with table decomposition, lossless join verification, and dependency preservation tests is available in:
🔗 **[`Experiment_7.sql`](./Experiment_7.sql)**

---

## 📷 Outputs

Normalization execution, lossless join, and dependency preservation output screenshots are available in:
🔗 **[`output/`](./output/)**

---

## 📊 Result & Conclusion

### Result
1. A denormalized `Sales_UNF` table was created with 14 columns containing redundant data across orders, customers, products, and salespersons.
2. Six functional dependencies were identified with `{order_id, product_id}` as the candidate key.
3. 1NF was achieved by assigning a composite primary key (data was already atomic).
4. 2NF was achieved by removing partial dependencies — separating `Orders_2NF`, `Products_2NF`, and `OrderDetails_2NF`.
5. 3NF was achieved by removing transitive dependencies — extracting `Customers_3NF`, `Cities_3NF`, and `Salespersons_3NF` from the Orders table.
6. BCNF was confirmed — every determinant in every table is a candidate key; no further decomposition was required.
7. Lossless join was verified — joining all normalized tables reproduced exactly 10 original rows with zero missing or spurious tuples.
8. Dependency preservation was verified — all 6 original FDs are enforceable within individual tables without cross-table joins.

### Conclusion
Normalization systematically eliminates data redundancy and update anomalies by decomposing a relation based on its functional dependencies. The step-by-step progression from UNF through 1NF, 2NF, 3NF, and BCNF ensures that each table stores only closely related facts, reducing insertion, update, and deletion anomalies. The lossless join property guarantees that no information is lost during decomposition, while dependency preservation ensures that all original business rules (functional dependencies) can be enforced locally within individual tables without requiring expensive multi-table joins. Together, these properties confirm that the normalized schema is both correct and practical for real-world database design.
