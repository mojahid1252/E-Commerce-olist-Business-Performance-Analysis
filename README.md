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
[▶️ How to Reproduce](#️-how-to-reproduce) •
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
| Who are our best customers? (RFM) | SQL + Python |
| Which products & sellers drive 80% of revenue? (Pareto) | Python + SQL |
| What does customer retention look like? (Cohort) | Python |
```
The analysis answers real business questions a data analyst would face:

| Business Question | Tool Used |
| What is the overall revenue, order volume, and AOV? | Excel + SQL + Power BI |
| How does revenue trend month over month? | Excel + SQL +Python + Power BI |
| Which states & cities drive the most revenue? |Excel + SQL + Python + Power BI |
| How does delivery performance affect review scores? | SQL + Python + Power BI |
| Who are our best customers? (RFM) | SQL |
| Which products & sellers drive 80% of revenue? (Pareto) | Python+ SQL |
| What does customer retention look like? (Cohort) | Python |
ETC 
```
**Dataset:** [Olist Brazilian E-Commerce Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
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
```
| Tool       | What I Did | Key Skills Demonstrated |
| Excel      | Merged tables, built KPI summary & pivot dashboard | VLOOKUP / INDEX-MATCH, Pivot Tables, conditional formatting, dynamic charts |
| PostgreSQL | Wrote 22 business queries covering revenue, delivery, customers, products, Pareto Analysis (80/20 Rule), RFM scoring, | JOINs, CTEs, Window Functions (RANK, LAG, ROW_NUMBER), aggregations | 
| Python     | Full EDA, statistical analysis, advanced segmentation & visualizations | pandas, numpy, seaborn, matplotlib, Cohort heatmap, Pareto analysis |
| Power BI   | Built 3-page interactive dashboard with cross-filtering | Power Query, DAX measures & KPI cards, data modeling (star schema), slicers |
```
---

## 📈 KPI Snapshot
> Based on **delivered orders only**

<div align="center">

| KPI | Value |
|---|---|
| 💰 Total Revenue | **R$ 15.84 M** |
| 📦 Total Orders | **99,441** |
| 👤 Unique Customers | **96,478** |
| 🧾 Avg Order Value (AOV) | **R$ 159** |
| 🚚 Avg Delivery Days | **12 days** |
| ⚠️ Late Delivery Rate | **~9%** |
| ⭐ Avg Review Score | **4.09 / 5** |

</div>

---

