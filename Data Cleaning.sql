--SECTION 0: DATA CLEANING & EXPLORATION

-- 0.1: CHECK TABLE STRUCTURES & SAMPLE DATA
-- Customers table
SELECT * FROM customers LIMIT 5;
-- Orders table  
SELECT * FROM orders LIMIT 5;
-- Order Items table
SELECT * FROM order_items LIMIT 5;
-- Products table
SELECT * FROM products LIMIT 5;
-- Payments table
SELECT * FROM order_payments LIMIT 5;
-- Reviews table
SELECT * FROM order_reviews LIMIT 5;
-- Sellers table
SELECT * FROM sellers LIMIT 5


-- 0.2: CHECK MISSING (NULL) VALUES IN EACH TABLE

--Customers — Missing Values
-- No Missing value
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(customer_id) AS missing_customer_id,
    COUNT(*) - COUNT(customer_unique_id) AS missing_unique_id,
    COUNT(*) - COUNT(customer_zip_code_prefix) AS missing_zip,
    COUNT(*) - COUNT(customer_city) AS missing_city,
    COUNT(*) - COUNT(customer_state) AS missing_state
FROM customers;


-- Orders — Missing Values (এখানে সবচেয়ে বেশি missing থাকবে)
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(customer_id) AS missing_customer_id,
    COUNT(*) - COUNT(order_status) AS missing_status,
    COUNT(*) - COUNT(order_purchase_timestamp) AS missing_purchase_date,
    COUNT(*) - COUNT(order_approved_at) AS missing_approved,
    COUNT(*) - COUNT(order_delivered_carrier_date) AS missing_carrier_date,
    COUNT(*) - COUNT(order_delivered_customer_date) AS missing_delivered_date,
    COUNT(*) - COUNT(order_estimated_delivery_date) AS missing_estimated_date
FROM orders;
-- 📌 Insight: order_delivered_customer_date has ~2,965 NULLs
-- because some orders are not yet delivered (canceled/shipped)
-- some column like order_approved_at and order_delivered_customer_date has null value as well

-- Products — Missing Values
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(product_id) AS missing_product_id,
    COUNT(*) - COUNT(product_category_name) AS missing_category,
    COUNT(*) - COUNT(product_weight_g) AS missing_weight,
    COUNT(*) - COUNT(product_length_cm) AS missing_length,
    COUNT(*) - COUNT(product_height_cm) AS missing_height,
    COUNT(*) - COUNT(product_width_cm) AS missing_width,
    COUNT(*) - COUNT(product_photos_qty) AS missing_photos,
    COUNT(*) - COUNT(product_name_length) AS missing_name_len,
    COUNT(*) - COUNT(product_description_length) AS missing_desc_len
FROM products;

-- 📌 Insight: product_category_name has ~610 NULLs
-- product dimensions also have some NULLs

-- 🔍 Order Items — Missing Values
-- No Missing value
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(product_id) AS missing_product_id,
    COUNT(*) - COUNT(seller_id) AS missing_seller_id,
    COUNT(*) - COUNT(price) AS missing_price,
    COUNT(*) - COUNT(freight_value) AS missing_freight
FROM order_items;


-- 🔍 Order Payments — Missing Values
-- No Missing value
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(payment_type) AS missing_type,
    COUNT(*) - COUNT(payment_value) AS missing_value,
    COUNT(*) - COUNT(payment_installments) AS missing_installments
FROM order_payments;


-- 🔍 Order Reviews — Missing Values
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(review_id) AS missing_review_id,
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(review_score) AS missing_score,
    COUNT(*) - COUNT(review_comment_title) AS missing_title,
    COUNT(*) - COUNT(review_comment_message) AS missing_message
FROM order_reviews;

-- 📌 Insight: review_comment_title and review_comment_message
-- have many NULLs — customers don't always write comments


-- 🔍 Sellers — Missing Values
-- No Missing value
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(seller_id) AS missing_seller_id,
    COUNT(*) - COUNT(seller_city) AS missing_city,
    COUNT(*) - COUNT(seller_state) AS missing_state
FROM sellers;


-- 📋 MISSING VALUES SUMMARY TABLE
SELECT 'customers' AS table_name, 'customer_id' AS column_name, 
    COUNT(*) - COUNT(customer_id) AS missing_count,
    ROUND(((COUNT(*) - COUNT(customer_id)) * 100.0 / COUNT(*))::NUMERIC, 2) AS missing_pct
FROM customers
UNION ALL
SELECT 'orders', 'order_delivered_customer_date', 
    COUNT(*) - COUNT(order_delivered_customer_date),
    ROUND(((COUNT(*) - COUNT(order_delivered_customer_date)) * 100.0 / COUNT(*))::NUMERIC, 2)
FROM orders
UNION ALL
SELECT 'orders', 'order_approved_at', 
    COUNT(*) - COUNT(order_approved_at),
    ROUND(((COUNT(*) - COUNT(order_approved_at)) * 100.0 / COUNT(*))::NUMERIC, 2)
FROM orders
UNION ALL
SELECT 'products', 'product_category_name', 
    COUNT(*) - COUNT(product_category_name),
    ROUND(((COUNT(*) - COUNT(product_category_name)) * 100.0 / COUNT(*))::NUMERIC, 2)
FROM products
UNION ALL
SELECT 'products', 'product_weight_g', 
    COUNT(*) - COUNT(product_weight_g),
    ROUND(((COUNT(*) - COUNT(product_weight_g)) * 100.0 / COUNT(*))::NUMERIC, 2)
FROM products
UNION ALL
SELECT 'reviews', 'review_comment_title', 
    COUNT(*) - COUNT(review_comment_title),
    ROUND(((COUNT(*) - COUNT(review_comment_title)) * 100.0 / COUNT(*))::NUMERIC, 2)
FROM order_reviews
UNION ALL
SELECT 'reviews', 'review_comment_message', 
    COUNT(*) - COUNT(review_comment_message),
    ROUND(((COUNT(*) - COUNT(review_comment_message)) * 100.0 / COUNT(*))::NUMERIC, 2)
FROM order_reviews
ORDER BY missing_pct DESC;



-- 0.3: CHECK DUPLICATE RECORDS

-- Customers — Duplicate customer_id?
SELECT customer_id, COUNT(*) AS cnt
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
-- 📌 Expected: No duplicates (it's PRIMARY KEY)


-- Orders — Duplicate order_id?
SELECT order_id, COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- 📌 Expected: No duplicates


-- Order Items — Duplicate order_id + order_item_id?
SELECT order_id, order_item_id, COUNT(*) AS cnt
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;
-- 📌 Expected: No duplicates (composite primary key)


-- ⚠️ IMPORTANT CHECK: Duplicate customer_unique_id 
-- (same person, multiple customer_ids)
SELECT 
    customer_unique_id, 
    COUNT(*) AS appearances,
    COUNT(DISTINCT customer_id) AS different_customer_ids
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY appearances DESC
LIMIT 10;

-- 📌 Insight: Some customers appear multiple times with 
-- different customer_ids — this is NORMAL in this dataset.
-- customer_unique_id is the TRUE unique identifier!


-- Reviews — Duplicate reviews for same order?
SELECT order_id, COUNT(*) AS review_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_count DESC
LIMIT 10;

-- 📌 Insight: Some orders have multiple reviews — 
-- we may need to handle this in analysis


-- 0.4: DATA QUALITY CHECKS

 -- Check Order Status Distribution
SELECT 
    order_status, 
    COUNT(*) AS count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders))::NUMERIC, 2) AS pct
FROM orders
GROUP BY order_status
ORDER BY count DESC;
-- 📌 Insight: "delivered" is ~97%, rest are canceled/shipped etc.


--  Check Date Range — কোনো future date আছে কিনা?
SELECT 
    MIN(order_purchase_timestamp) AS earliest_order,
    MAX(order_purchase_timestamp) AS latest_order,
    MIN(order_delivered_customer_date) AS earliest_delivery,
    MAX(order_delivered_customer_date) AS latest_delivery
FROM orders;
-- 📌 Check: All dates should be between 2016-2018



-- 🔍 Check: Delivery BEFORE Purchase? (Impossible!)
SELECT COUNT(*) AS impossible_deliveries
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp
    AND order_delivered_customer_date IS NOT NULL;
-- 📌 If count > 0, these are DATA ERRORS!
-- Everything Is Right

--  Check: Negative or Zero Prices?
SELECT COUNT(*) AS zero_or_negative_prices
FROM order_items
WHERE price <= 0;

SELECT COUNT(*) AS zero_freight
FROM order_items
WHERE freight_value < 0;
-- 📌 There should be no negative prices


-- 🔍 Check: Price Outliers
SELECT 
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price)::NUMERIC, 2) AS avg_price,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price)::NUMERIC, 2) AS median_price,
    ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY price)::NUMERIC, 2) AS p95_price,
    ROUND(PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY price)::NUMERIC, 2) AS p99_price
FROM order_items;
-- 📌 Insight: Check if max_price is unreasonably high


-- 🔍 Check: Freight Outliers
SELECT 
    MIN(freight_value) AS min_freight,
    MAX(freight_value) AS max_freight,
    ROUND(AVG(freight_value)::NUMERIC, 2) AS avg_freight,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY freight_value)::NUMERIC, 2) AS median_freight,
    ROUND(PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY freight_value)::NUMERIC, 2) AS p99_freight
FROM order_items;


-- 🔍 Check: Review Score Range (should be 1-5 only)
SELECT 
    MIN(review_score) AS min_score,
    MAX(review_score) AS max_score
FROM order_reviews;

-- 📌 Expected: min=1, max=5. Anything else = data error


-- 🔍 Check: Payment Value Anomalies
SELECT 
    MIN(payment_value) AS min_payment,
    MAX(payment_value) AS max_payment,
    ROUND(AVG(payment_value)::NUMERIC, 2) AS avg_payment
FROM order_payments;

-- Check zero payments
SELECT COUNT(*) AS zero_payments
FROM order_payments
WHERE payment_value = 0;

-- 📌 Insight: Some voucher payments may have 0 value


-- 🔍 Check: Product Category — How many unique? Any weird ones?
SELECT 
    product_category_name, 
    COUNT(*) AS product_count
FROM products
GROUP BY product_category_name
ORDER BY product_count DESC;

-- Check NULL categories
SELECT COUNT(*) AS null_categories
FROM products
WHERE product_category_name IS NULL;
-- 📌 Insight: ~610 products have NULL category name


-- 🔍 Check: Delivery Days — Any unreasonable values?
SELECT 
    MIN(DATE_PART('day', order_delivered_customer_date - order_purchase_timestamp))::INTEGER 
        AS min_delivery_days,
    MAX(DATE_PART('day', order_delivered_customer_date - order_purchase_timestamp))::INTEGER 
        AS max_delivery_days,
    ROUND(AVG(DATE_PART('day', order_delivered_customer_date - order_purchase_timestamp))::NUMERIC, 1) 
        AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL;

-- 📌 If max > 200 days, those might be outliers


-- 0.5: DATA CLEANING — FIX ISSUES

-- CLEAN 1: Fix NULL Product Categories
-- Action: Replace NULL with 'unknown'

-- Check before cleaning
SELECT COUNT(*) AS null_categories_before
FROM products 
WHERE product_category_name IS NULL;

-- Fix it
UPDATE products
SET product_category_name = 'unknown'
WHERE product_category_name IS NULL;

-- Verify after cleaning
SELECT COUNT(*) AS null_categories_after
FROM products 
WHERE product_category_name IS NULL;
-- 📌 Should be 0 now ✅


-- CLEAN 2: Fix NULL Product Dimensions
-- Action: Replace with MEDIAN values

-- Check Null
SELECT 
    COUNT(*) - COUNT(product_weight_g) AS null_weight,
    COUNT(*) - COUNT(product_length_cm) AS null_length,
    COUNT(*) - COUNT(product_height_cm) AS null_height,
    COUNT(*) - COUNT(product_width_cm) AS null_width,
    COUNT(*) - COUNT(product_name_length) AS null_name_len,
    COUNT(*) - COUNT(product_description_length) AS null_desc_len,
    COUNT(*) - COUNT(product_photos_qty) AS null_photos
FROM products;

-- Fill weight with median
UPDATE products
SET product_weight_g = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_weight_g)
    FROM products
    WHERE product_weight_g IS NOT NULL )::INTEGER
WHERE product_weight_g IS NULL;

-- Fill length with median
UPDATE products
SET product_length_cm = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_length_cm)
    FROM products
    WHERE product_length_cm IS NOT NULL
)::INTEGER
WHERE product_length_cm IS NULL;

-- Fill height with median
UPDATE products
SET product_height_cm = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_height_cm)
    FROM products
    WHERE product_height_cm IS NOT NULL
)::INTEGER
WHERE product_height_cm IS NULL;

-- Fill width with median
UPDATE products
SET product_width_cm = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_width_cm)
    FROM products
    WHERE product_width_cm IS NOT NULL
)::INTEGER
WHERE product_width_cm IS NULL;

-- Fill photos_qty with median
UPDATE products
SET product_photos_qty = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_photos_qty)
    FROM products
    WHERE product_photos_qty IS NOT NULL
)::INTEGER
WHERE product_photos_qty IS NULL;

-- Fill name_length with median
UPDATE products
SET product_name_length = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_name_length)
    FROM products
    WHERE product_name_length IS NOT NULL
)::INTEGER
WHERE product_name_length IS NULL;

-- Fill description_length with median
UPDATE products
SET product_description_length = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_description_length)
    FROM products
    WHERE product_description_length IS NOT NULL
)::INTEGER
WHERE product_description_length IS NULL;

-- Verify — should all be 0 now
SELECT 
    COUNT(*) - COUNT(product_weight_g) AS null_weight,
    COUNT(*) - COUNT(product_length_cm) AS null_length,
    COUNT(*) - COUNT(product_height_cm) AS null_height,
    COUNT(*) - COUNT(product_width_cm) AS null_width
FROM products;
-- 📌 All should be 0 now ✅



-- CLEAN 3: Standardize City Names (Lowercase + Trim)
-- Action: Some city names might have extra spaces or inconsistent casing

-- Check messy city names
SELECT customer_city, COUNT(*) as unique_value
FROM customers
GROUP BY customer_city
ORDER BY customer_city
LIMIT 20;

-- Clean: lowercase + trim whitespace
UPDATE customers
SET customer_city = LOWER(TRIM(customer_city));

UPDATE sellers
SET seller_city = LOWER(TRIM(seller_city));

-- 📌 Now "São Paulo", "Sao Paulo", " São Paulo " 
-- will all become "são paulo"
    
-- CLEAN 4: Handle Impossible Delivery Dates
-- Action: If delivered BEFORE purchased → set to NULL

-- Check how many
SELECT COUNT(*) AS impossible_dates
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp
    AND order_delivered_customer_date IS NOT NULL;

-- Fix: Set impossible dates to NULL
UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date < order_purchase_timestamp;
-- 📌 These are clearly data entry errors


-- CLEAN 5: Remove Zero/Negative Payment Values (if any)
-- Check
SELECT COUNT(*) AS zero_payments
FROM order_payments
WHERE payment_value <= 0;

-- If exists, check what payment_type they are
SELECT payment_type, COUNT(*), SUM(payment_value)
FROM order_payments
WHERE payment_value <= 0
GROUP BY payment_type;

-- 📌 Vouchers with 0 value are OK — don't delete them
-- Only delete if negative:
DELETE FROM order_payments
WHERE payment_value < 0;



-- CLEAN 6: Handle Duplicate Reviews (Keep latest only)
-- Check duplicate reviews per order
SELECT order_id, COUNT(*) AS review_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1;

-- কতগুলো duplicate আছে?
SELECT COUNT(*) AS orders_with_multiple_reviews
FROM (
    SELECT order_id
    FROM order_reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS dupes;

-- 📌 Decision: Keep ALL reviews for now (some orders 
-- genuinely have multiple reviews). In analysis, 
-- we'll use AVG(review_score) per order.



-- 0.6: POST-CLEANING VERIFICATION
-- Purpose: Cleaning ঠিকমতো হয়েছে কিনা confirm করা

-- ✅ Final Row Counts
SELECT 'customers' AS tbl, COUNT(*) AS rows FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers;


-- ✅ No NULL categories anymore
SELECT COUNT(*) AS null_categories 
FROM products 
WHERE product_category_name IS NULL;
-- Expected: 0


-- ✅ No NULL product dimensions anymore
SELECT 
    COUNT(*) - COUNT(product_weight_g) AS null_weight,
    COUNT(*) - COUNT(product_length_cm) AS null_length
FROM products;
-- Expected: 0, 0


-- ✅ No impossible delivery dates
SELECT COUNT(*) 
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp
    AND order_delivered_customer_date IS NOT NULL;
-- Expected: 0


-- ✅ Date Range is reasonable
SELECT 
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders;
-- Expected: 2016 to 2018


-- ✅ Price range is reasonable
SELECT 
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price)::NUMERIC, 2) AS avg_price
FROM order_items;


-- ✅ Review scores are 1-5 only
SELECT MIN(review_score), MAX(review_score)
FROM order_reviews;
-- Expected: 1, 5


-- ════════════════════════════════════════════════
-- 📋 CLEANING SUMMARY
-- ════════════════════════════════════════════════
-- 
-- ✅ CLEAN 1: Filled 610 NULL product categories → 'unknown'
-- ✅ CLEAN 2: Filled NULL product dimensions → median values
-- ✅ CLEAN 3: Standardized city names → lowercase + trimmed
-- ✅ CLEAN 4: Fixed impossible delivery dates → set to NULL
-- ✅ CLEAN 5: Removed negative payment values (if any)
-- ✅ CLEAN 6: Identified duplicate reviews → decided to keep all
-- 
-- Data is now CLEAN and ready for analysis! 🎉


