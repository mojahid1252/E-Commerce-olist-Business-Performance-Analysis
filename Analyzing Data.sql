-- ================================================================
-- SECTION 1: BUSINESS OVERVIEW
-- ================================================================

-- Query 1: Overall Business Metrics
-- Purpose: Get the big picture numbers

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;


SELECT
COUNT(DISTINCT o.order_id) AS total_orders,
COUNT(DISTINCT o.customer_id) AS total_customer,
COUNT(DISTINCT oi.product_id) AS total_products,
COUNT(DISTINCT oi.seller_id) AS total_sellers,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC,2) AS total_revenue,
ROUND(AVG(oi.price + oi.freight_value)::NUMERIC,2) AS avg_order_value
FROM orders AS o
JOIN order_items AS oi
on o.order_id= oi.order_id;

-- 📌 Insight: 
-- Orders: 98k,
--Customers: 98k, 
--Products: 33k, 
--Sellers: 3k,
--Revenue: 15.8M, 
--Avg Order: 141



-- Query 2: Monthly Revenue Trend
-- Purpose: See how revenue changes over time

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;


SELECT 
TO_CHAR(o.order_purchase_timestamp,'YYYY-MM') AS order_month_year,
COUNT(DISTINCT o.order_id) AS total_orders,
SUM(oi.price + oi.freight_value) AS total_revenue,
ROUND(AVG(oi.price + oi.freight_value)::NUMERIC, 2) AS avg_order_value
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL AND o.order_status = 'delivered'
GROUP BY order_month_year
ORDER BY order_month_year ASC;

-- 📌 Insight: 
-- This query calculates total orders, total revenue, and average order value per month
-- Insights:
-- 1. Orders grew steadily from 2016 to 2018, showing business growth.
-- 2. Total revenue generally follows order volume, but some months have higher avg_order_value.
-- 3. Average Order Value (AOV) stays mostly between 130–150, indicating stable customer spending.
-- 4. Seasonal spikes occur in Nov–Dec each year, suggesting holiday/festival effects.
-- 5. Early months (Jan–Mar) often have slightly higher AOV, while mid-year months dip a bit.
-- 6. The business stabilizes at ~6–7k orders/month and ~1M revenue/month by 2018.




-- Query 3: Top 10 Product Categories by Revenue
-- Purpose: Which products bring the most money?

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

SELECT 
p.product_category_name,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC,0) AS total_revenue,
ROUND(AVG(oi.price)::NUMERIC, 2) AS avg_price
FROM orders o
JOIN order_items AS oi 
ON o.order_id = oi.order_id
JOIN products AS p
ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 3 desc
LIMIT 10;

-- 📌 Insight:
-- This query calculates total orders, total revenue, and average order value per product category
-- Insights:
-- 1. 'cama_mesa_banho' and 'beleza_saude' have the highest order volume → most popular categories.
-- 2. 'relogios_presentes' and 'cool_stuff' have high AOV → fewer orders but high revenue per order.
-- 3. 'moveis_decoracao', 'cama_mesa_banho', 'utilidades_domesticas' have low AOV → many small-value orders.
-- 4. Categories with medium volume but low AOV could benefit from bundling or upselling to increase revenue.


-- Query 4: Revenue by Customer State
-- Purpose: Geographic distribution of sales
SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;


SELECT 
c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders,
COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS total_revenue,
ROUND((SUM(oi.price + oi.freight_value) * 100.0 / (SELECT SUM(price + freight_value) FROM order_items))::NUMERIC, 2) AS revenue_percentage,
ROUND(AVG(oi.price)::NUMERIC, 2) AS avg_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
-- 📌 Insight: São Paulo (SP) dominates with ~36% revenue



-- Query 5: Payment Method Analysis
-- Purpose: How do customers prefer to pay?
SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;


SELECT
payment_type,
COUNT(*) AS transaction_count,
ROUND(SUM(payment_value)::NUMERIC,2) AS total_value,
ROUND(AVG(payment_value)::NUMERIC,2) AS avg_value,
ROUND(AVG(payment_installments)::NUMERIC,2) AS avg_installments,
ROUND((SUM(payment_value)::NUMERIC)/(SELECT SUM(payment_value):: NUMERIC FROM order_payments)*100,2) AS percentage
FROM order_payments
GROUP BY payment_type
ORDER BY total_value DESC;
-- 📌 Insight: Credit card is dominant (~78%)



-- Query 6: Avg Order Value by Category (Top 10 Expensive)
-- Purpose: Which categories have highest priced products?

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

SELECT 
p.product_category_name,
COUNT(o.order_id) AS total_count,
ROUND(AVG(op.payment_value),2) AS avg_order_value,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS total_revenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id= oi.order_id
JOIN order_payments AS op
ON o.order_id= op.order_id
JOIN products as p
ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- OR
SELECT 
p.product_category_name,
COUNT(*) AS items_sold,
ROUND(AVG(oi.price)::NUMERIC, 2) AS avg_price,
ROUND(MIN(oi.price)::NUMERIC, 2) AS min_price,
ROUND(MAX(oi.price)::NUMERIC, 2) AS max_price
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING COUNT(*) > 50
ORDER BY avg_price DESC
LIMIT 10;


-- Query 7: Review Score Distribution
-- Purpose: Are customers happy overall?

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

SELECT 
review_score,
COUNT(*) AS total_reviews,
ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_reviews))::NUMERIC, 2) AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

-- 📌 Insight: Most reviews are 5 stars, but there's 
-- a significant number of 1-star reviews too.\



-- ================================================================
-- SECTION 2: DELIVERY PERFORMANCE ANALYSIS
-- ================================================================

-- Query 8: Average Delivery Time by State
-- Purpose: Which states get fastest/slowest delivery?
SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

SELECT 
c.customer_state,
ROUND(AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))),2) AS avg_delivery_days,
ROUND(MAX(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))),2) AS max_delivery_days,
ROUND(MIN(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))),2) AS min_delivery_days
FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 ASC;

-- 📌 Insight: Northern states (RR, AP, AM) have 
-- much longer delivery times than southern states

-- Query 9: Late Delivery Analysis (Monthly Trend)
-- Purpose: How many orders arrive late? What's the trend?

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

SELECT 
TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_deliveries,
ROUND((SUM(CASE WHEN o.order_delivered_customer_date >  o.order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*))::NUMERIC, 2) AS late_delivery_pct
FROM orders o
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
ORDER BY month ASC;
-- 📌 Insight: Late delivery percentage varies 
-- by month, spikes during peak seasons


-- Query 10: Late Delivery Impact on Review Score
-- Purpose: Do late deliveries cause bad reviews?
SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

SELECT 
CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late' ELSE 'On Time' END AS delivery_status,
COUNT(*) AS total_orders,
ROUND(AVG(r.review_score)::NUMERIC, 2) AS avg_review_score,
SUM(CASE WHEN r.review_score = 1 THEN 1 ELSE 0 END) AS one_star,
SUM(CASE WHEN r.review_score = 5 THEN 1 ELSE 0 END) AS five_star,
SUM(CASE WHEN r.review_score = 5 THEN 1 ELSE 0 END)*100/COUNT(*) AS five_star_parcentange
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1;

-- 📌 Insight: Late deliveries have avg score ~2.5 
-- vs on-time ~4.3 HUGE impact!



-- ================================================================
-- SECTION 3: CUSTOMER ANALYSIS
-- ================================================================

-- Query 11: One-Time vs Repeat Customers 
-- Purpose: How many customers buy again?

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

SELECT 
CASE WHEN order_count = 1 THEN 'One-Time'
WHEN order_count = 2 THEN '2 Orders'
WHEN order_count >= 3 THEN '3+ Orders'
END AS customer_type,
COUNT(*) AS customer_count
FROM
(SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1) AS customer_orders
GROUP BY customer_type
ORDER BY customer_count DESC;

-- 📌 Insight: ~97% are one-time buyers! 
-- Huge retention problem!


-- Query 12: Top 10 Customers by Spending (CLV)
-- Purpose: Who are our most valuable customers?

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

SELECT 
c.customer_unique_id,
c.customer_city,
c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS total_spent,
ROUND(AVG(oi.price)::NUMERIC, 2) AS avg_item_price,
ROUND(AVG(r.review_score)::NUMERIC, 1) AS avg_review
FROM orders o
JOIN customers c 
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN order_reviews r
ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_city, c.customer_state
ORDER BY total_spent DESC
LIMIT 10;

-- Insights:
-- 1. Most top customers have only 1 order but very high spending → indicates high-value one-time buyers.
-- 2. A few customers (e.g., 2–4 orders) show repeat behavior but lower avg_item_price → likely regular but lower-value purchases.
-- 3. Extremely high avg_item_price (e.g., 6000+) suggests purchase of premium or bulk products in a single order.
-- 4. Some high spenders have low review scores (1.0) → potential dissatisfaction despite high revenue contribution.
-- 5. Missing review values indicate some orders were not reviewed → possible data gaps or low engagement.
-- 6. Cities like Rio de Janeiro and São Paulo appear multiple times → major markets contributing to top revenue customers.
-- 7. High revenue is not always driven by frequency (orders), but often by high-value transactions.
-- 8. Opportunity: Convert high-spending one-time buyers into repeat customers to increase long-term CLV.

'''🔥 Step-by-step Breakdown (প্রতিটা line কেন আছে)
🔹 1️⃣ SELECT অংশ
c.customer_unique_id,
c.customer_city,
c.customer_state,
👉 কেন customer_unique_id?
real customer ধরার জন্য
customer_id দিলে same person multiple customer হয়ে যেত ❌
✔️ তাই CLV (Customer Lifetime Value) এর জন্য এটা MUST
🔹 2️⃣ Total Orders
COUNT(DISTINCT o.order_id) AS total_orders
👉 কেন DISTINCT?
order_items join করার কারণে same order multiple row হয়ে যায়
তাই duplicate remove করতে DISTINCT
✔️ না দিলে order count ভুল হবে ❌
🔹 3️⃣ Total Spending (CLV)
SUM(oi.price + oi.freight_value) AS total_spent
👉 কেন এটা?
customer মোট কত টাকা খরচ করেছে
product price + delivery charge
✔️ এটাই আসল CLV
🔹 4️⃣ Average Item Price
AVG(oi.price) AS avg_item_price
👉 কেন?
customer সাধারণত কেমন দামের product কিনে
cheap না premium buyer বুঝা যায়
🔹 5️⃣ Average Review
AVG(r.review_score) AS avg_review
👉 কেন?
customer experience কেমন
happy না unhappy customer
🔥 JOIN গুলো কেন করা হয়েছে?
🔹 6️⃣ orders + customers
JOIN customers c ON o.customer_id = c.customer_id
👉 order কে customer এর সাথে link করার জন্য
🔹 7️⃣ orders + order_items
JOIN order_items oi ON o.order_id = oi.order_id
👉 revenue বের করার জন্য (price এখানে আছে)
🔹 8️⃣ LEFT JOIN reviews
LEFT JOIN order_reviews r ON o.order_id = r.order_id
👉 কেন LEFT JOIN?
সব order এ review নাও থাকতে পারে
তাই data বাদ না দিতে LEFT JOIN
✔️ INNER JOIN দিলে কিছু order হারিয়ে যেত ❌

🔹 9️⃣ WHERE condition
WHERE o.order_status = 'delivered'
👉 শুধু completed orders ধরার 
cancelled order নিলে revenue ভুল হবে ❌
🔹 🔟 GROUP BY
GROUP BY c.customer_unique_id, c.customer_city, c.customer_state
👉 প্রতিটা customer আলাদা group
✔️ তাই customer-wise calculation হচ্ছে

🔹 1️⃣1️⃣ ORDER BY
ORDER BY total_spent DESC
👉 সবচেয়ে বেশি খরচ করা customer উপরে
✔️ Top spender identify করার জন্য
🔥 Final Logic Flow (Mind Map)
Orders → filter delivered
Join customer → real person identify
Join items → money calculate
Join reviews → satisfaction measure
Group by customer → per customer stats
Sort by spending → top customers

💡 Very Important Concepts (মাথায় রাখো)
✅ কেন DISTINCT order_id?
👉 duplicate order remove
✅ কেন customer_unique_id?
👉 real customer ধরার জন্য
✅ কেন LEFT JOIN reviews?
👉 review না থাকলেও order রাখতে
🚀 One-line Summary:
👉 এই query real customer ধরে তার total spending (CLV), order behavior, এবং satisfaction বের করে top spenders identify করে '''


-- Query 13: Customer Order Timing Analysis
-- Purpose: When do customers shop most?

-- Part A: By Hour of Day
SELECT 
EXTRACT(HOUR FROM o.order_purchase_timestamp)::INTEGER AS order_hour,
COUNT(*) AS total_orders,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY EXTRACT(HOUR FROM o.order_purchase_timestamp)
ORDER BY 2 DESC;

-- Part B: By Day of Week
SELECT 
TRIM(TO_CHAR(o.order_purchase_timestamp, 'Day')) AS day_of_week,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS revenue
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'Day')
ORDER BY 2 DESC
;

-- 📌 Insight: Peak shopping hours are 10 AM - 4 PM
-- Monday has most orders, Sunday least


-- ================================================================
-- SECTION 4: SELLER ANALYSIS
-- ================================================================

-- Query 14: Top 10 Sellers by Revenue

SELECT 
oi.seller_id,
s.seller_city,
s.seller_state,
COUNT(DISTINCT o.order_id) AS orders_fulfilled,
COUNT(DISTINCT oi.product_id) AS unique_products,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS total_revenue,
ROUND(AVG(r.review_score)::NUMERIC, 2) AS avg_review
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id, s.seller_city, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- Insights:
-- 1. Most top-performing sellers are from SP (São Paulo) → indicates this state is the main hub of seller activity and revenue.
-- 2. High revenue does not always mean highest order volume → some sellers generate more revenue with fewer but higher-value orders.
-- 3. Sellers with a large number of unique products (e.g., 300+) tend to have higher order volumes → product variety drives sales.
-- 4. Average review scores mostly range between 3.5 to 4.5 → overall customer satisfaction is moderate to good.
-- 5. Some high-revenue sellers have relatively low review scores (e.g., ~3.3) → potential quality or service issues despite strong sales.
-- 6. Sellers with fewer products but high revenue (e.g., 23 products, high revenue) indicate specialization in high-value items.
-- 7. Cities like São Paulo appear multiple times → strong concentration of top sellers in major urban areas.
-- 8. Opportunity: Improve service quality for low-review sellers and expand product variety to increase sales further.



-- Query 15: Seller State vs Customer State
-- Purpose: Where are sellers shipping TO and FROM?

SELECT 
s.seller_state,
c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue,
ROUND(AVG(oi.freight_value)::NUMERIC, 2) AS avg_freight
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
JOIN sellers s
ON oi.seller_id = s.seller_id
JOIN customers c 
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state, c.customer_state
ORDER BY total_orders DESC
LIMIT 20;

-- 📌 Insight: Most orders are SP seller → SP customer
-- Cross-state shipping has higher freight costs

-- Query 16: Product Weight vs Freight Analysis

SELECT 
p.product_category_name,
ROUND(AVG(p.product_weight_g)::NUMERIC, 0) AS avg_weight_g,
ROUND(AVG(oi.freight_value)::NUMERIC, 2) AS avg_freight,
ROUND(AVG(oi.price)::NUMERIC, 2) AS avg_price,
ROUND((AVG(oi.freight_value) / NULLIF(AVG(oi.price), 0) * 100)::NUMERIC, 2) AS freight_pct_of_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING COUNT(*) > 50
ORDER BY freight_pct_of_price DESC
LIMIT 15;

-- 📌 Insight: Some categories have freight cost 
-- that's 30-50% of product price!



-- ================================================================
-- SECTION 5: ADVANCED ANALYTICS (Window Functions + CTEs)
-- ================================================================

-- Query 17: Month-over-Month Revenue Growth
-- Using LAG() Window Function

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_payments LIMIT 10;
SELECT * FROM order_reviews LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sellers LIMIT 10;

WITH monthly_revenue AS
(SELECT 
TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS months,
SUM(oi.price + oi.freight_value) AS revenue
FROM orders AS o
JOIN order_items as oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1 ASC)
SElECT
months, revenue,
LAG(revenue) OVER (ORDER BY months) AS previous_month_revenue,
revenue-LAG(revenue) OVER (ORDER BY months) AS revenue_difference,
(revenue - LAG(revenue) OVER (ORDER BY months)) / NULLIF(LAG(revenue) OVER (ORDER BY months), 0) * 100 AS  growth_percentage
FROM monthly_revenue
ORDER BY 1 ASC;
-- 📌 Insight: Highest growth in [2017-11] The Growth Is 53%. 
-- decline started in [2016-12]



-- Query 18: Cumulative Revenue (Running Total)
-- Using SUM() OVER() Window Function
WITH monthly_revenue AS 
(SELECT 
TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS revenue
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1)
SELECT 
month,
revenue,
SUM(revenue) OVER (ORDER BY month) AS cumulative_revenue,
ROUND((revenue * 100.0 / SUM(revenue) OVER ())::NUMERIC, 2) AS pct_of_total
FROM monthly_revenue
ORDER BY month;
-- Insight 1: Revenue trend
-- Monthly revenue started very low in 2016-09 (143.46) and gradually increased, showing a strong growth trend over time.

-- Insight 2: Peak revenue months
-- Highest monthly revenues appear in 2017-11 (1,153,364.20), 2018-01 (1,077,887.46), and 2018-03-04 (~1,122,000),
-- indicating seasonal spikes or higher sales in these months.

-- Insight 3: Cumulative revenue growth
-- The cumulative revenue steadily increases, reflecting consistent order fulfillment and business growth over months.

-- Insight 4: Contribution to total revenue
-- The percentage of total revenue per month is small early on (<1% for 2016-2017 months),
-- but gradually rises to ~7% per month in early 2018, showing the business scaled up over time.

-- Insight 5: Volatility
-- Some months have low revenue (e.g., 2016-12: 19.62) indicating possible irregular orders or seasonality effects.



-- Query 19: Rank Products Within Each Category
-- Using RANK() Window Function

WITH 
product_sales AS 
(SELECT 
p.product_category_name AS category,
p.product_id,
COUNT(*) AS times_sold,
ROUND(SUM(oi.price)::NUMERIC, 2) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name, p.product_id),
ranked_products AS 
(SELECT 
category,
product_id,
times_sold,
total_revenue,
RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank_in_category
FROM product_sales)
SELECT *
FROM ranked_products
WHERE rank_in_category <= 3
ORDER BY 1,4 DESC;
-- 📌 Shows top 3 best-selling products in each category

-- Query 20: RFM Analysis (Customer Segmentation)
-- R = Recency (days since last purchase)
-- F = Frequency (number of orders)
-- M = Monetary (total spend)


-- Although the same column is used, the first MAX() is calculated over the entire table
-- (overall latest order), while the second MAX() is calculated per group (e.g., per customer).
-- The difference gives the recency (in days) for each group.
WITH
rfm_calc AS (
SELECT 
c.customer_unique_id,
DATE_PART('day',(SELECT MAX(order_purchase_timestamp) FROM orders) - MAX(o.order_purchase_timestamp))::INTEGER AS recency,
COUNT(DISTINCT o.order_id) AS frequency,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS monetary
FROM orders o
JOIN customers c 
ON o.customer_id = c.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
),
rfm_scores AS (
SELECT *,
NTILE(4) OVER (ORDER BY recency DESC) AS r_score,
NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
FROM rfm_calc
)
SELECT 
CASE 
WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
WHEN r_score >= 3 AND f_score >= 2 THEN 'Loyal Customers'
WHEN r_score >= 3 AND m_score >= 2 THEN 'Potential Loyalists'
WHEN r_score >= 2 AND f_score <= 2 AND m_score <= 2 THEN 'New Customers'
WHEN r_score <= 2 AND f_score >= 2 THEN 'At Risk'
WHEN r_score <= 1 AND f_score <= 1 THEN 'Lost'
ELSE 'Others'
END AS customer_segment,
COUNT(*) AS customer_count,
ROUND(AVG(recency)::NUMERIC, 0) AS avg_recency,
ROUND(AVG(frequency)::NUMERIC, 1) AS avg_frequency,
ROUND(AVG(monetary)::NUMERIC, 2) AS avg_monetary
FROM rfm_scores
GROUP BY 1
ORDER BY avg_monetary DESC;
-- 📌 Insight: Shows how many customers are in each 
-- segment — helps prioritize marketing eff



-- Query 21: Pareto Analysis (80/20 Rule)
-- Purpose: Do 20% of products generate 80% of revenue?
WITH product_revenue AS (
SELECT 
p.product_category_name,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
),
cumulative AS (
SELECT 
product_category_name,
revenue,
SUM(revenue) OVER (ORDER BY revenue DESC) AS running_total,
SUM(revenue) OVER () AS grand_total,
ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rank_num,
COUNT(*) OVER () AS total_categories
FROM product_revenue
)
SELECT 
product_category_name,
revenue,
running_total,
grand_total,
rank_num,
total_categories,
ROUND((running_total / grand_total * 100)::NUMERIC, 2) AS cumulative_pct,
ROUND((rank_num * 100.0 / total_categories)::NUMERIC, 2) AS category_pct
FROM cumulative
ORDER BY rank_num;

-- PARETO ANALYSIS:
-- Top 20% of categories (15 out of 74) generate ~76% of total revenue.
-- This is close to the 80/20 rule, indicating a strong revenue concentration
-- in a small number of product categories.

-- INSIGHTS:
-- 1. Revenue is highly concentrated in a small number of categories.
--    The top 5 categories contribute ~39% of total revenue,
--    showing a strong skew toward high-performing segments.

-- 2. The top 10 categories generate ~62% of total revenue,
--    indicating a Pareto-like distribution (few categories drive most sales).

-- 3. After rank ~25, cumulative contribution reaches ~90%,
--    meaning the remaining ~50 categories contribute only ~10% revenue.

-- 4. Long-tail effect is clearly visible:
--    Many categories (bottom ~40+) individually contribute less than 1%,
--    with several contributing almost negligible revenue.

-- 5. Categories like 'beleza_saude', 'relogios_presentes', and 'cama_mesa_banho'
--    are the top revenue drivers and should be prioritized for business growth.

-- 6. Low-performing categories (e.g., 'seguros_e_servicos', 'fashion_roupa_infanto_juvenil')
--    may require re-evaluation, promotion, or possible removal.

-- 7. This distribution suggests opportunities for:
--    - Focusing marketing budget on top-performing categories
--    - Improving or optimizing mid-tier categories
--    - Reducing operational cost for low-impact categories

-- 8. Overall, the dataset follows a classic cumulative revenue curve,
--    where a small portion of categories dominates total sales.


-- Query 22: Seasonality Analysis
-- Purpose: Identify seasonal patterns

SELECT 
EXTRACT(MONTH FROM o.order_purchase_timestamp)::INTEGER AS month_num,
TRIM(TO_CHAR(o.order_purchase_timestamp, 'Month')) AS month_name,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS total_revenue,
ROUND(AVG(oi.price + oi.freight_value)::NUMERIC, 2) AS avg_order_value,
ROUND(AVG(r.review_score)::NUMERIC, 2) AS avg_review
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1,2
ORDER BY month_num;

-- 📌 Insight: November has highest revenue (Black Friday)
-- February might show dip
