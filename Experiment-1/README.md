# Experiment 1: ER Diagram Design for an Indian E-Commerce Platform

## 🎯 Aim

Design an ER diagram for an Indian e-commerce platform with entities `Customer`, `Product`, `Order`, `OrderItem`, `Seller`, `Category`, `Payment`, `Delivery`, and `Address`. Specify primary keys, composite and multi-valued attributes, weak entities, specialization of `Product`, and participation constraints.

---

## 📋 Objectives & System Requirements

- Identify all **entities** and their **attributes** (simple, composite, multi-valued, derived).
- Define **primary keys** for each entity and identify the **weak entity** with its **partial key**.
- Establish **relationships** with appropriate **cardinality ratios** and **participation constraints**.
- Model **specialization/generalization** of the `Product` entity.

---

## 🏛️ Entities & Attributes

### 1. Customer (Strong Entity)
- **Primary Key:** `Customer_ID`
- **Composite Attribute:** `Name` (`First_Name`, `Last_Name`)
- **Multi-valued Attribute:** `Phone_Numbers`
- **Simple Attributes:** `Email`

### 2. Address (Strong Entity)
- **Primary Key:** `Address_ID`
- **Foreign Key:** `Customer_ID`
- **Composite Attribute:** `Street_Address` (`Flat_No`, `Building_Name`, `Street_Name`)
- **Simple Attributes:** `City`, `State`, `Pincode`

### 3. Seller (Strong Entity)
- **Primary Key:** `Seller_ID`
- **Multi-valued Attribute:** `Phone_Numbers`
- **Simple Attributes:** `Email`

### 4. Category (Strong Entity)
- **Primary Key:** `Category_ID`
- **Simple Attributes:** `Category_Name`, `HSN_Code`
- **Recursive Attribute:** `Parent_Category_ID`

### 5. Product (Superclass Entity)
- **Primary Key:** `Product_ID`
- **Multi-valued Attribute:** `Image_URLs`
- **Simple Attributes:** `Product_Name`

### 6. OrderItem (Weak Entity)
- **Identifying Owner Entity:** `Order`
- **Partial Key / Discriminator:** `Item_Number`
- **Composite Primary Key:** `(Order_ID, Item_Number)`
- **Simple Attributes:** `Quantity`

### 7. Order (Strong Entity)
- **Primary Key:** `Order_ID`
- **Simple Attributes:** `Order_item`

### 8. Payment (Strong Entity)
- **Primary Key:** `Payment_ID`
- **Simple Attributes:** `Amount`

### 9. Delivery (Strong Entity)
- **Primary Key:** `Delivery_ID`
- **Simple Attributes:** `Tracking_No`, `Delivery_Status`

---

## 🔀 Specialization of Product

The `Product` entity is specialized into:

- **Electronics:** Inherits all `Product` attributes (`Product_ID`, `Name`, `Image`); adds `Model_Number`, `Warranty_Period`.
- **Clothing:** Inherits all `Product` attributes; adds `Gender`, `Material`, `Size`.

> **Specialization Type:** Disjoint, Partial

---

## 🔗 Key Relationships

| Relationship | Entities | Cardinality | Participation |
| :--- | :--- | :---: | :--- |
| Places | Customer → Order | 1:N | Total (Customer), Partial (Order) |
| Contains | Order → OrderItem | 1:N | Total (both) |
| Sells | Seller → Product | 1:N | Total (Seller), Partial (Product) |
| Belongs_To | Product → Category | N:1 | Total (Product), Partial (Category) |
| Has_Payment | Order → Payment | 1:1 | Total (both) |
| Has_Delivery | Order → Delivery | 1:1 | Total (both) |
| Has_Address | Customer → Address | 1:N | Total (Customer), Partial (Address) |

---

## 📷 Outputs

The conceptual ER Diagram is available in:
🔗 **[`output/`](./output/)**
