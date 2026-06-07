# 📊 Brazilian E-Commerce Analytics Platform

An end-to-end cloud-based Data Warehouse and Analytics solution built using **Snowflake, AWS S3, SQL, Streamlit, and Plotly**. This project implements a modern **Medallion Architecture (Bronze → Silver → Gold)** to ingest, transform, model, and analyze over **1M+ e-commerce records**, enabling actionable business insights through an interactive analytics dashboard.

---

## 📌 Project Overview

This project was developed to design and implement a scalable cloud-native analytics platform capable of:

* Analyzing sales performance and revenue trends
* Understanding customer behavior and segmentation
* Tracking product and category performance
* Evaluating logistics and delivery efficiency
* Monitoring payment preferences and customer satisfaction
* Providing interactive dashboards for business stakeholders

---

## 🏗️ Architecture Overview

The solution follows a layered Medallion Architecture:

```text
Brazilian E-Commerce Dataset
            │
            ▼
       AWS S3 Bucket
            │
            ▼
 Snowflake External Stage
            │
            ▼
     Bronze Layer (Raw)
            │
            ▼
  Silver Layer (Cleaned)
            │
            ▼
 Gold Layer (Star Schema)
            │
            ▼
 Streamlit Analytics Dashboard
```

### 📸 Architecture Workflow

![Architecture Workflow](https://github.com/user-attachments/assets/cb8e36d1-0bdf-421c-b71c-4104d7199970)

---

## 📂 Dataset

Dataset Source:

Brazilian E-Commerce Public Dataset (Olist)

Dataset Link:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

### Dataset Files Used

* olist_orders_dataset.csv
* olist_order_items_dataset.csv
* olist_order_payments_dataset.csv
* olist_order_reviews_dataset.csv
* olist_customers_dataset.csv
* olist_products_dataset.csv
* olist_sellers_dataset.csv
* olist_geolocation_dataset.csv
* product_category_name_translation.csv

---

## ☁️ AWS S3 Integration

Instead of using Snowflake Internal Stages, the project uses:

* AWS S3 Bucket
* IAM Role
* Storage Integration
* Snowflake External Stage

This approach follows industry best practices by separating storage from compute.

---

## 🥉 Bronze Layer

Raw data ingestion layer.

### Responsibilities

* Store source data exactly as received
* Preserve lineage and traceability
* Support reprocessing if required

Tables Loaded:

* CUSTOMERS_RAW
* GEOLOCATION_RAW
* ORDER_ITEMS_RAW
* PAYMENTS_RAW
* ORDERS_RAW
* REVIEWS_RAW
* PRODUCTS_RAW
* CATEGORY_TRANSLATION_RAW
* SELLERS_RAW

---

## 🥈 Silver Layer

Data cleansing and transformation layer.

### Transformations Performed

* Data type standardization
* Timestamp conversion
* Null handling
* Data quality validation
* ZIP code standardization
* Category mapping
* Business-friendly column naming

### Dataset Design & Profiling

![Dataset Profiling](https://github.com/user-attachments/assets/996cadc9-293b-4a18-8009-1cc09d4fb3f3)

---

## 🥇 Gold Layer

Business-ready analytical layer.

### Data Modeling Approach

A Star Schema was implemented to support efficient analytical querying.

### Fact Table

#### FACT_SALES

Contains transactional sales data.

Measures:

* price
* freight_value
* total_order_payment_value

Keys:

* customer_key
* product_key
* seller_key
* date_key

---

### Dimension Tables

#### DIM_CUSTOMERS

Customer demographics and location.

#### DIM_PRODUCTS

Product details and translated categories.

#### DIM_SELLERS

Seller information and regional attributes.

#### DIM_DATE

Time intelligence dimension.

---

## 📊 Entity Relationship Diagram (ERD)

![ER Diagram](https://github.com/user-attachments/assets/2fd45349-9f5b-430b-b9ce-cd1944627127)

---

## ⚡ Performance Optimization

Several Snowflake optimization techniques were implemented:

### Star Schema Design

* Reduced join complexity
* Improved dashboard performance

### Payment Aggregation

Resolved payment fan-out issue by aggregating payments before fact table creation.

### Clustering

```sql
ALTER TABLE GOLD.FACT_SALES
CLUSTER BY (date_key, order_status);
```

### Search Optimization

```sql
ALTER TABLE GOLD.FACT_SALES
ADD SEARCH OPTIMIZATION ON EQUALITY(order_id);
```

### Query Acceleration

```sql
ALTER WAREHOUSE RETAIL_BRAZILIAN_WH
SET ENABLE_QUERY_ACCELERATION = TRUE;
```

### Materialized View

Created KPI materialized view for faster dashboard queries.

---

## 📈 Analytical Queries

The project includes analytical SQL queries for:

### Executive KPIs

* Total Revenue
* Total Orders
* Total Customers
* Average Order Value

### Sales Performance

* Top Product Categories
* Revenue Trends

### Customer Analytics

* Customer Segmentation
* Repeat Purchase Analysis
* Regional Performance

### Operations & Logistics

* Delivery Efficiency
* Order Status Distribution
* Shipping Cost Analysis

### Customer Satisfaction

* Review Score Analysis

### Payment Insights

* Payment Method Distribution

---

# 📊 Interactive Dashboard

Built using:

* Streamlit
* Plotly
* Snowflake Snowpark

---

## Dashboard Features

### Executive Overview

* Revenue
* Orders
* Customers
* Average Order Value
* Delivery Time
* Satisfaction Score

![Executive Dashboard](images/dashboard_kpis.png)

---

### Sales & Revenue Trends

Monthly revenue growth visualization.

![Revenue Trend](images/dashboard_revenue_trend.png)

---

### Product Performance

Top performing categories by revenue.

![Product Performance](images/dashboard_product_performance.png)

---

### Operations & Logistics

Order status distribution and shipping ratio analysis.

![Operations Analytics](images/dashboard_operations.png)

---

### Customer Insights

Customer segmentation and regional performance.

![Customer Insights](images/dashboard_customer_insights.png)

---

### Customer Experience & Seller Performance

Review score distribution and seller analytics.

![Seller Performance](images/dashboard_seller_performance.png)

---

### Strategic Business Insights

Includes:

* Payment Method Analysis
* Repeat Purchase Analysis
* Revenue Distribution

![Strategic Insights](images/dashboard_strategic_insights.png)

---

## 🌍 Advanced Features

### Dynamic Currency Conversion

Users can dynamically switch between:

* USD
* INR
* EUR
* GBP
* JPY
* CAD
* BRL

All revenue-based metrics automatically update across the dashboard.

### Payment Analytics

Analyze customer payment preferences.

### Customer Loyalty Analysis

Track repeat purchase behavior.

### Revenue Distribution

Visualize spending patterns across orders.

---

## 💡 Key Business Insights

### Revenue Drivers

Total revenue is strictly reconciled against source parameters to **$15.42M** across **96,478** successful delivered transactions.

Health & Beauty, Watches & Gifts, and Bed & Bath categories generate the highest revenue.

### Customer Behavior

Most customers are one-time buyers, indicating opportunities for retention programs.

### Logistics Impact

Certain categories have high shipping-to-price ratios, affecting profitability.

### Regional Performance

São Paulo contributes the largest share of orders and revenue.

### Customer Satisfaction

The majority of reviews are rated 4 and 5 stars, indicating strong customer satisfaction.

---

## 🛠️ Tech Stack

### Cloud & Data Warehouse

* Snowflake
* AWS S3

### Data Engineering

* SQL
* Snowflake Snowpark

### Dashboard & Visualization

* Streamlit
* Plotly
* Pandas

### Data Modeling

* Star Schema
* Medallion Architecture

---

## 🚀 Future Enhancements

* Real-time ingestion using Snowpipe
* Live currency exchange API
* Machine learning-based recommendations
* Customer churn prediction
* Geo-spatial analytics
* Automated CI/CD deployment

---

## 👨‍💻 Author

**Pratham Bajpai**

Data Engineering | Analytics | Snowflake | AWS | SQL

---
