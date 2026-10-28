-- =========================================================================
-- EXPERIMENT 2
-- AIM: Convert the ER diagram into a relational schema. Write complete MySQL
-- CREATE TABLE statements with primary keys, foreign keys, NOT NULL, UNIQUE,
-- ON DELETE CASCADE and SET NULL constraints. Insert sample data and
-- demonstrate referential integrity violations.
-- =========================================================================

DROP DATABASE IF EXISTS IndianEcommerceDB;
CREATE DATABASE IndianEcommerceDB;
USE IndianEcommerceDB;

-- 1. Create Category Table
CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Create Seller Table
CREATE TABLE Seller (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    city VARCHAR(50),
    state VARCHAR(50),
    gst_number VARCHAR(20) NOT NULL UNIQUE
);

-- 3. Create Product Table
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_qty INT DEFAULT 0,
    seller_id INT,
    category_id INT,
    FOREIGN KEY (seller_id) REFERENCES Seller(seller_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE SET NULL
);

-- 4. Create Customer Table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    city VARCHAR(50),
    state VARCHAR(50),
    registration_date DATE
);

-- 5. Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12, 2),
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);

-- 6. Create Order_Item Table
CREATE TABLE Order_Item (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE SET NULL
);

-- 7. Create Payment Table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    order_id INT UNIQUE,
    payment_date DATE,
    payment_method VARCHAR(30) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- 8. Create Review Table
CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    rating INT NOT NULL,
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);

-- =========================================================================
-- INSERT SAMPLE DATA
-- =========================================================================

-- Insert Categories
INSERT INTO Category (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home & Kitchen'),
(4, 'Books'),
(5, 'Beauty & Health'),
(6, 'Sports & Fitness');

-- Insert Sellers
INSERT INTO Seller (seller_id, seller_name, email, phone, city, state, gst_number) VALUES
(1, 'TechBazaar India', 'tech@bazaar.in', '9876543210', 'Bengaluru', 'Karnataka', '29ABCDE1234F1Z5'),
(2, 'FashionMitra', 'contact@fashionmitra.in', '9123456780', 'Mumbai', 'Maharashtra', '27FGHIJ5678K2Y6'),
(3, 'HomeSaathi', 'info@homesaathi.in', '9988776655', 'Delhi', 'Delhi', '07KLMNO9012L3X7'),
(4, 'Kitaab Ghar', 'order@kitaabghar.in', '9112233445', 'Jaipur', 'Rajasthan', '08PQRST3456M4W8'),
(5, 'AyurvedaKart', 'care@ayurvedakart.in', '9001122334', 'Lucknow', 'Uttar Pradesh', '09UVWXY7890N5V9');

-- Insert Products
INSERT INTO Product (product_id, product_name, price, stock_qty, seller_id, category_id) VALUES
(101, 'boAt Rockerz 450 Headphones', 1499.00, 120, 1, 1),
(102, 'Realme Narzo 70 Pro 5G', 17999.00, 45, 1, 1),
(103, 'Noise ColorFit Pro 5 Smartwatch', 3499.00, 80, 1, 1),
(104, 'Allen Solly Formal Shirt', 1299.00, 200, 2, 2),
(105, 'Libas Anarkali Kurti Set', 1899.00, 150, 2, 2),
(106, 'Prestige Induction Cooktop', 2599.00, 60, 3, 3),
(107, 'Milton Thermosteel Flask 1L', 799.00, 300, 3, 3),
(108, 'Pigeon Stainless Steel Pressure Cooker 5L', 1899.00, 90, 3, 3),
(109, 'Wings of Fire by APJ Abdul Kalam', 299.00, 500, 4, 4),
(110, 'The Monk Who Sold His Ferrari', 249.00, 350, 4, 4),
(111, 'Himalaya Neem Face Wash 200ml', 199.00, 400, 5, 5),
(112, 'Mamaearth Vitamin C Serum', 549.00, 250, 5, 5),
(113, 'Nivia Storm Football Size 5', 699.00, 100, 1, 6),
(114, 'Boldfit Yoga Mat 6mm', 499.00, 180, 3, 6),
(115, 'Puma Running Shoes', 3299.00, 75, 2, 6);

-- Insert Customers
INSERT INTO Customer (customer_id, name, email, phone, city, state, registration_date) VALUES
(1, 'Aarav Sharma', 'aarav.sharma@gmail.com', '9871001001', 'Delhi', 'Delhi', '2023-01-10'),
(2, 'Ishita Patel', 'ishita.patel@yahoo.com', '9871001002', 'Ahmedabad', 'Gujarat', '2023-03-22'),
(3, 'Rohan Gupta', 'rohan.gupta@gmail.com', '9871001003', 'Lucknow', 'Uttar Pradesh', '2022-11-05'),
(4, 'Meera Nair', 'meera.nair@outlook.com', '9871001004', 'Kochi', 'Kerala', '2023-06-18'),
(5, 'Arjun Reddy', 'arjun.reddy@gmail.com', '9871001005', 'Hyderabad', 'Telangana', '2022-08-14'),
(6, 'Diya Iyer', 'diya.iyer@gmail.com', '9871001006', 'Chennai', 'Tamil Nadu', '2024-01-30'),
(7, 'Kabir Singh', 'kabir.singh@yahoo.com', '9871001007', 'Chandigarh', 'Punjab', '2023-09-12'),
(8, 'Ananya Das', 'ananya.das@gmail.com', '9871001008', 'Kolkata', 'West Bengal', '2023-04-07'),
(9, 'Vivaan Joshi', 'vivaan.joshi@outlook.com', '9871001009', 'Pune', 'Maharashtra', '2022-12-25'),
(10, 'Saanvi Mishra', 'saanvi.mishra@gmail.com', '9871001010', 'Bhopal', 'Madhya Pradesh', '2024-05-16');

-- Insert Orders
INSERT INTO Orders (order_id, customer_id, order_date, total_amount, order_status) VALUES
(1001, 1, '2024-06-10', 19498.00, 'Delivered'),
(1002, 2, '2024-06-15', 1899.00, 'Delivered'),
(1003, 3, '2024-07-01', 548.00, 'Shipped'),
(1004, 4, '2024-07-10', 3499.00, 'Delivered'),
(1005, 5, '2024-07-18', 4498.00, 'Processing'),
(1006, 6, '2024-08-02', 799.00, 'Delivered'),
(1007, 7, '2024-08-15', 2998.00, 'Shipped'),
(1008, 8, '2024-08-20', 1899.00, 'Delivered'),
(1009, 9, '2024-09-05', 17999.00, 'Delivered'),
(1010, 10, '2024-09-12', 699.00, 'Cancelled'),
(1011, 1, '2024-09-20', 249.00, 'Delivered'),
(1012, 3, '2024-10-01', 1499.00, 'Processing');

-- Insert Order Items
INSERT INTO Order_Item (item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1001, 102, 1, 17999.00),
(2, 1001, 101, 1, 1499.00),
(3, 1002, 105, 1, 1899.00),
(4, 1003, 109, 1, 299.00),
(5, 1003, 110, 1, 249.00),
(6, 1004, 103, 1, 3499.00),
(7, 1005, 106, 1, 2599.00),
(8, 1005, 108, 1, 1899.00),
(9, 1006, 107, 1, 799.00),
(10, 1007, 101, 2, 1499.00),
(11, 1008, 108, 1, 1899.00),
(12, 1009, 102, 1, 17999.00),
(13, 1010, 113, 1, 699.00),
(14, 1011, 110, 1, 249.00),
(15, 1012, 101, 1, 1499.00);

-- Insert Payments
INSERT INTO Payment (payment_id, order_id, payment_date, payment_method, amount, payment_status) VALUES
(1, 1001, '2024-06-10', 'UPI', 19498.00, 'Success'),
(2, 1002, '2024-06-15', 'Credit Card', 1899.00, 'Success'),
(3, 1003, '2024-07-01', 'Debit Card', 548.00, 'Success'),
(4, 1004, '2024-07-10', 'UPI', 3499.00, 'Success'),
(5, 1005, '2024-07-18', 'Net Banking', 4498.00, 'Success'),
(6, 1006, '2024-08-02', 'Cash on Delivery', 799.00, 'Success'),
(7, 1007, '2024-08-15', 'UPI', 2998.00, 'Success'),
(8, 1008, '2024-08-20', 'Credit Card', 1899.00, 'Success'),
(9, 1009, '2024-09-05', 'EMI', 17999.00, 'Success'),
(10, 1010, '2024-09-12', 'UPI', 699.00, 'Refunded'),
(11, 1011, '2024-09-20', 'UPI', 249.00, 'Success'),
(12, 1012, '2024-10-01', 'Debit Card', 1499.00, 'Pending');

-- Insert Reviews
INSERT INTO Review (review_id, product_id, customer_id, rating, review_text, review_date) VALUES
(1, 102, 1, 5, 'Excellent phone! Great camera and battery life.', '2024-06-20'),
(2, 101, 1, 4, 'Good sound quality for the price.', '2024-06-22'),
(3, 105, 2, 5, 'Beautiful kurti, perfect fitting!', '2024-06-25'),
(4, 109, 3, 5, 'Very inspiring book. Must read!', '2024-07-10'),
(5, 103, 4, 4, 'Nice smartwatch, good battery backup.', '2024-07-20'),
(6, 106, 5, 3, 'Decent cooktop but heats slowly.', '2024-08-01'),
(7, 107, 6, 5, 'Keeps water hot for 24 hours. Excellent!', '2024-08-10'),
(8, 108, 8, 4, 'Good quality pressure cooker, value for money.', '2024-08-30'),
(9, 102, 9, 4, 'Good phone overall, slightly heavy.', '2024-09-15'),
(10, 101, 7, 5, 'Best headphones under 2000 rupees.', '2024-08-25');

-- =========================================================================
-- CONSTRAINT & REFERENTIAL INTEGRITY VIOLATION DEMONSTRATIONS
-- =========================================================================

-- 1. FOREIGN KEY Violation: Insert order and product with non-existent customer/seller
INSERT INTO Orders (order_id, customer_id, order_date, total_amount, order_status)
VALUES (1099, 99, '2024-10-15', 2500.00, 'Processing');

INSERT INTO Product (product_id, product_name, price, stock_qty, seller_id, category_id)
VALUES (200, 'Fake Product', 999.00, 10, 50, 1);

-- 2. UNIQUE Constraint Violation: Duplicating customer email
INSERT INTO Customer (customer_id, name, email, phone, city, state, registration_date)
VALUES (11, 'Duplicate User', 'aarav.sharma@gmail.com', '9999999999', 'Delhi', 'Delhi', '2024-10-20');

-- 3. NOT NULL Constraint Violation: Seller without GST number
INSERT INTO Seller (seller_id, seller_name, email, phone, city, state, gst_number)
VALUES (6, 'NoGST Seller', 'nogst@seller.in', '9000000001', 'Patna', 'Bihar', NULL);

-- 4. ON DELETE CASCADE: Deleting a Seller removes their Products
SELECT product_id, product_name, seller_id FROM Product WHERE seller_id = 4;
DELETE FROM Seller WHERE seller_id = 4;
SELECT product_id, product_name, seller_id FROM Product WHERE seller_id = 4;

-- 5. ON DELETE SET NULL: Deleting a Category sets Product's category_id to NULL
SELECT product_id, product_name, category_id FROM Product WHERE category_id = 6;
DELETE FROM Category WHERE category_id = 6;
SELECT product_id, product_name, category_id FROM Product WHERE product_id IN (113, 114, 115);

-- 6. UNIQUE Constraint Violation: Duplicate Payment for Same Order
INSERT INTO Payment (payment_id, order_id, payment_date, payment_method, amount, payment_status)
VALUES (99, 1001, '2024-10-20', 'UPI', 19498.00, 'Success');
