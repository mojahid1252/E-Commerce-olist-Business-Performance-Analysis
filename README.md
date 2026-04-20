<div align="center">
  
# Olist Brazilian E-Commerce | 2017 – 2018 |
![Python](https://img.shields.io/badge/Python-3.10-blue?logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?logo=postgresql&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-Advanced-217346?logo=microsoft-excel&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
## End-to-end analytics project on 100,000+ real e-commerce orders
**spanning data cleaning, SQL querying, Python EDA, and interactive dashboarding.** 

[🔍 Key Findings](#-key-findings) •
[📊 Dashboard](#-power-bi-dashboard) •
[🛠 Tools Used](#-tools--skills) •
[💡 Recommendations](#-business-recommendations)
</div>

---

## 📌 Project Overview
This project performs a **complete business performance analysis** on Olist's
Brazilian e-commerce marketplace, one of the most popular real-world datasets
available publicly (Kaggle, 100 K+ rows, 9 CSV files).

The analysis answers real business questions a data analyst would face:

| Business Question | Tool Used |
|---|---|
| What is the overall revenue, order volume, and AOV? | Excel + SQL + Power BI |
| How does revenue trend month over month? | Excel + SQL + Python + Power BI |
| Which states & cities drive the most revenue? | Excel + SQL + Python + Power BI |
| How does delivery performance affect review scores? | SQL + Python + Power BI |
| Who are our best customers? (RFM) | SQL |
| Which products & sellers drive 80% of revenue? (Pareto) | Python + SQL |
| What does customer retention look like? (Cohort) | Python |

**Dataset:** [Olist Brazilian E-Commerce Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
```
olist_customers_dataset.csv
olist_orders_dataset.csv
olist_order_items_dataset.csv
olist_order_payments_dataset.csv
olist_order_reviews_dataset.csv
olist_products_dataset.csv
olist_sellers_dataset.csv
product_category_name_translation.csv   ← optional
```
**Period Covered:** January 2017 – August 2018  
**Scope:** Delivered orders only (for accurate revenue & delivery KPIs)

---

## 🔄 Project Workflow
Each tool independently loaded the **raw dataset** <br>
And performed its **own data cleaning and analysis**, demonstrating my proficiency in data cleaning <br>
While showcasing the **same business problem solved across four different environments.**<br>

📥 RAW DATA SOURCE → Kaggle (9 CSV Files)


📊 Excel    | 🗄 PostgreSQL | 🐍 Python      | 📈 Power BI
------------|--------------|----------------|-------------
Cleaning    | Cleaning     | Cleaning       | Modeling
Merging     | 22 Queries   | Deep EDA       | DAX
KPI Sheet   | CTEs         | Charts         | Dashboard
Pivot       | Window Fns   | Cohort         | Slicers


📤 BUSINESS INSIGHTS

---

## 🛠 Tools & Skills

| Tool | What I Did | Key Skills Demonstrated |
|---|---|---|
| **📊 Excel** | Merged tables, built KPI summary & pivot dashboard | VLOOKUP / INDEX-MATCH, Pivot Tables, Conditional Formatting, Dynamic Charts |
| **🗄 PostgreSQL** | Wrote 22 business queries covering revenue, delivery, customers, products, Pareto Analysis (80/20 Rule), RFM Scoring | JOINs, CTEs, Window Functions (RANK, LAG, ROW_NUMBER), Aggregations |
| **🐍 Python** | Full EDA, statistical analysis, advanced segmentation & visualizations | pandas, numpy, seaborn, matplotlib, Cohort Heatmap, Pareto Analysis |
| **📈 Power BI** | Built 3-page interactive dashboard with cross-filtering | Power Query, DAX Measures & KPI Cards, Data Modeling (Star Schema), Slicers |

---

## 📈 KPI Snapshot
> Based on **delivered orders only**

<div align="center">

| KPI | Value |
|---|---|
| 💰 Total Revenue | **R$ 13.59 M** |
| 📦 Total Orders | **96.48 K** |
| 👤 Unique Customers | **96.47 K** |
| 🧾 Avg Item Price (AIP) | **R$ 120.65** |
| 🚚 Avg Delivery Days | **12 days** |
| ⚠️ Late Delivery Rate | **~9%** |
| ⭐ Avg Review Score | **4.09 / 5** |

</div>

---

## 📊 Power BI Dashboard

### Page 1 - Executive Summary
> Revenue trend, order volume, AOV, top states, payment methods

![Executive Summary](https://github.com/mojahid1252/E-Commerce-Business-Performance-Analysis/blob/67149958a9afdf909a43412d13e134ec83cb9ebc/%F0%9F%93%8A%20Executive%20Summary.png)

---

### Page 2 - Customer & Delivery Analysis
> Late delivery trends, delivery days by state, review score impact

![Customer & Delivery](https://github.com/mojahid1252/E-Commerce-Business-Performance-Analysis/blob/cf72c7ef7964c1cda26284a2e44c730f7f3ebb1b/%F0%9F%91%A5%20Customer%20%26%20Delivery.png)

---

### Page 3 - Product & Seller Performance
> Top categories, revenue contribution, seller performance

![Product & Seller](https://github.com/mojahid1252/E-Commerce-Business-Performance-Analysis/blob/fa535df122d8bfdd90a9652de00ec81a0d3542aa/%F0%9F%93%A6%20PRODUCT%20%26%20SELLER%20PERFORMANCE.png)

---

## 🗂 Excel Analysis 
**Didn't filtered to delivered orders**

### KPI Summary Sheet
![Excel KPI](https://github.com/mojahid1252/E-Commerce-Business-Performance-Analysis/blob/bbc40975a09fb8f103df64553b39e06eaff49320/Ecommerce_Analysis%20KPI.png)

### Pivot Dashboard
![Excel Dashboard](https://github.com/mojahid1252/E-Commerce-Business-Performance-Analysis/blob/68476e00e1876356fbb8cbae320238c4666d659a/Ecommerce_Analysis%20Dashboad.png)

**What was done in Excel:**
- Merged 7+ CSV files As Master Data using VLOOKUP / INDEX-MATCH
- Removed nulls, fixed data types, Didn't filtered to delivered orders
- Built KPI summary with calculated fields
- Created pivot-based dashboard with slicers

---




---

## 🗄 SQL Analysis (PostgreSQL — 22 Queries)

All queries are in [`sql/ecommerce_analysis_postgres.sql`](sql/ecommerce_analysis_postgres.sql)

### Query Coverage Map

| # | Query | Category |
|---|---|---|
| Q1 | Overall metrics (revenue, orders, customers, AOV) | 📊 Overview |
| Q2 | Monthly revenue trend | 📊 Overview |
| Q3 | Revenue by payment type | 📊 Overview |
| Q4 | Revenue & orders by state | 🗺 Geographic |
| Q5 | Top 10 revenue cities | 🗺 Geographic |
| Q6 | Average delivery days by state | 🚚 Delivery |
| Q7 | Estimated vs actual delivery accuracy | 🚚 Delivery |
| Q8 | On-time vs late delivery count | 🚚 Delivery |
| Q9 | Monthly late delivery trend | 🚚 Delivery |
| Q10 | Late delivery vs review score | 🚚 Delivery |
| Q11 | Repeat vs one-time customers | 👥 Customer |
| Q12 | Top 10 customers by revenue | 👥 Customer |
| Q13 | Customer purchase frequency distribution | 👥 Customer |
| Q14 | Top 10 revenue-generating product categories | 🛍 Product |
| Q15 | Top 10 best-selling products | 🛍 Product |
| Q16 | Average product price by category | 🛍 Product |
| Q17 | Top 10 sellers by revenue | 🏪 Seller |
| Q18 | Seller performance (orders, revenue, avg score) | 🏪 Seller |
| Q19 | Review score distribution | ⭐ Review |
| Q20 | RFM base query (Recency, Frequency, Monetary) | 🎯 Advanced |
| Q21 | Revenue by weekday (order patterns) | 📅 Temporal |
| Q22 | Peak order hours analysis | 📅 Temporal |

### Sample Query Screenshots

**Q1 — Overall Business Metrics**
![Q1](sql/screenshots/q01_overall_metrics.png)

**Q9 — Monthly Late Delivery Trend**
![Q9](sql/screenshots/q09_late_delivery_trend.png)

**Q10 — Late Delivery Impact on Review Score**
![Q10](sql/screenshots/q10_late_vs_review.png)

---


## 🐍 Python Analysis (EDA + Advanced)

Notebook: [`python/Ecommerce_EDA.ipynb`](python/Ecommerce_EDA.ipynb)

### Analysis Sections

**Section 1 — Data Loading & Cleaning**
- Loaded & merged 7 datasets
- Handled nulls, fixed dtypes, filtered delivered orders

**Section 2 — Revenue & Order Trends**

![Monthly Revenue](python/charts/01_monthly_revenue.png)

**Section 3 — Geographic Analysis**

![State Revenue](python/charts/02_state_revenue.png)

**Section 4 — Delivery Performance**

![Delivery Distribution](python/charts/03_delivery_distribution.png)

**Section 5 — Review Score Analysis**

![Review vs Delivery](python/charts/04_review_vs_delivery.png)

**Section 6 — Product & Category Analysis**

![Top Categories](python/charts/05_top_categories.png)

**Section 7 — Pareto Analysis (80/20 Rule)**

![Pareto](python/charts/06_pareto_revenue.png)

> **Finding:** Top 20% of product categories contribute ~80% of total revenue — classic Pareto effect confirmed.

**Section 8 — RFM Customer Segmentation**

![RFM Segments](python/charts/07_rfm_segments.png)

| RFM Segment | Count | Description |
|---|---|---|
| Champions | ~8,200 | High value, recent, frequent |
| Loyal Customers | ~6,100 | Regular buyers |
| At Risk | ~4,300 | Used to buy, now inactive |
| Lost | ~3,900 | Long inactive, low value |

**Section 9 — Cohort Retention Analysis**

![Cohort Heatmap](python/charts/08_cohort_heatmap.png)

> **Finding:** Month-1 retention is extremely low (~2-3%), indicating a strong one-time buyer problem.

**Section 10 — Statistical Correlation**

![Correlation Heatmap](python/charts/09_correlation_heatmap.png)

---

## 🔍 Key Findings

### 1. 📈 Revenue & Growth
- Revenue grew consistently through 2017, peaking around **November 2017** (Black Friday effect)
- A sharp drop occurs in **September 2018** — likely data truncation (dataset ends mid-2018)
- **Top 3 states** (SP, RJ, MG) account for **~65%** of total revenue

### 2. 🚚 Delivery Performance
- Avg delivery time: **12 days** vs estimated **24 days** (most orders arrive early)
- **~9% of orders** are delivered late
- Late delivery strongly correlates with **lower review scores** (avg score drops from 4.3 → 2.5)

### 3. 👥 Customer Behavior
- **~97% of customers are one-time buyers** — major retention gap
- Top 5% of customers by revenue contribute disproportionately to total sales
- Purchase activity peaks on **Monday–Tuesday** and drops on weekends

### 4. 🛍 Product & Seller Insights
- **Top 3 categories**: bed_bath_table, health_beauty, sports_leisure
- **Pareto confirmed**: ~20% of categories drive ~80% of revenue
- Seller quality varies widely — top 10 sellers contribute significant share of revenue

### 5. ⭐ Review Score Drivers
- Delivery timeliness is the **#1 driver** of review score
- Products with freight cost > R$50 tend to receive lower scores
- 5-star reviews correlate strongly with early/on-time delivery

---

## 💡 Business Recommendations

| Priority | Recommendation | Expected Impact |
|---|---|---|
| 🔴 High | Improve delivery speed in low-performing states (RJ, PA, AM) | ↑ Review scores, ↑ repeat purchase |
| 🔴 High | Launch customer retention / loyalty program | ↓ One-time buyer %, ↑ LTV |
| 🟡 Medium | Optimize freight pricing for heavy/bulky product categories | ↑ Margin, ↓ cart abandonment |
| 🟡 Medium | Invest in Q4 marketing (Oct–Nov) — seasonality effect is strong | ↑ Peak revenue |
| 🟢 Low | Expand geographic presence beyond SP/RJ/MG | ↑ Market diversification |
| 🟢 Low | Create seller quality tiers — reward high performers | ↑ Overall platform quality |

---

📫 Connect With Me
<div align="center">
LinkedIn
GitHub
Email

</div>
<div align="center">
⭐ If this project helped you, consider giving it a star!

Built with ❤️ using real-world data | Tools: Excel · PostgreSQL · Python · Power BI

</div> ```
