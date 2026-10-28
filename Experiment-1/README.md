# Experiment 1: ER Diagram Design for an Indian E-Commerce Platform

## 🎯 Aim

Design an ER diagram for an Indian e-commerce platform with entities `Customer`, `Product`, `Order`, `OrderItem`, `Seller`, `Category`, `Payment`, `Delivery`, and `Address`. Specify primary keys, composite and multi-valued attributes, weak entities, specialization of `Product`, and participation constraints.

---

## 📋 Objectives

- Identify all **entities** and their **attributes** (simple, composite, multi-valued, derived).
- Define **primary keys** for each entity and identify the **weak entity** with its **partial key**.
- Establish **relationships** with appropriate **cardinality ratios** and **participation constraints**.
- Model **specialization/generalization** of the `Product` entity.

---

## 🏛️ Entities & Attributes

### 1. Customer (Strong Entity)
| Attribute | Type |
| :--- | :--- |
| `Customer_ID` | **Primary Key** |
| `Name` (`First_Name`, `Last_Name`) | Composite Attribute |
| `Phone_Numbers` | Multi-valued Attribute |
| `Email` | Simple Attribute |

### 2. Address (Strong Entity)
| Attribute | Type |
| :--- | :--- |
| `Address_ID` | **Primary Key** |
| `Customer_ID` | Foreign Key |
| `Street_Address` (`Flat_No`, `Building_Name`, `Street_Name`) | Composite Attribute |
| `City`, `State`, `Pincode` | Simple Attributes |

### 3. Seller (Strong Entity)
| Attribute | Type |
| :--- | :--- |
| `Seller_ID` | **Primary Key** |
| `Phone_Numbers` | Multi-valued Attribute |
| `Email` | Simple Attribute |

### 4. Category (Strong Entity)
| Attribute | Type |
| :--- | :--- |
| `Category_ID` | **Primary Key** |
| `Category_Name` | Simple Attribute |
| `HSN_Code` | Simple Attribute |
| `Parent_Category_ID` | Recursive (Self-referencing) |

### 5. Product (Superclass Entity)
| Attribute | Type |
| :--- | :--- |
| `Product_ID` | **Primary Key** |
| `Product_Name` | Simple Attribute |
| `Image_URLs` | Multi-valued Attribute |

### 6. OrderItem (Weak Entity)
| Attribute | Type |
| :--- | :--- |
| `Item_Number` | **Partial Key / Discriminator** |
| `(Order_ID, Item_Number)` | **Composite Primary Key** |
| `Quantity` | Simple Attribute |
| **Identifying Owner:** | `Order` |

### 7. Order (Strong Entity)
| Attribute | Type |
| :--- | :--- |
| `Order_ID` | **Primary Key** |
| `Order_item` | Simple Attribute |

### 8. Payment (Strong Entity)
| Attribute | Type |
| :--- | :--- |
| `Payment_ID` | **Primary Key** |
| `Amount` | Simple Attribute |

### 9. Delivery (Strong Entity)
| Attribute | Type |
| :--- | :--- |
| `Delivery_ID` | **Primary Key** |
| `Tracking_No` | Simple Attribute |
| `Delivery_Status` | Simple Attribute |

---

## 🔀 Specialization of Product

The `Product` entity is specialized into:

| Subclass | Inherited From | Additional Attributes |
| :--- | :--- | :--- |
| **Electronics** | All `Product` attributes | `Model_Number`, `Warranty_Period` |
| **Clothing** | All `Product` attributes | `Gender`, `Material`, `Size` |

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

## 📝 Report

Refer to [`DBMS1.docx`](./DBMS1.docx) for the complete ER diagram and detailed documentation.
