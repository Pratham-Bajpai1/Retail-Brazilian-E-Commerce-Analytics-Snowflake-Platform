USE SCHEMA GOLD;


/*
in a real world snowflake environment, as data grows into the millions or billions of rows, query speed becomes vital. I applied some techniques.

snowflake does NOT use traditional indexing like MySQL
it uses: Micro-partitions, Clustering, Caching
*/




-- clustering the fact table: most of our dashboard visuals will be based on time (Monthly Trends, Yearly Growth), i cluster the FACT_SALES table by date_key and order_status. This physically organizes the data in snowflake storage to make time-based filters lightning-fast.
-- i removed the WHERE clause in fact table earlier to keep all order statuses, our queries will now almost always filter by both time and status
-- improve performance for: Date filtering, Status filtering, Joins

ALTER TABLE GOLD.FACT_SALES CLUSTER BY (date_key, order_status);




-- clustering on dimension tables: i did not cluster small dimension tables. snowflake naturally handles tables under a few hundred MBs perfectly. This will actually waste credits.
/*
ALTER TABLE GOLD.DIM_CUSTOMERS CLUSTER BY (customer_key);
ALTER TABLE GOLD.DIM_PRODUCTS CLUSTER BY (product_key);
ALTER TABLE GOLD.DIM_DATE CLUSTER BY (date_key);
*/




-- search optimization: search for specific order_id values frequently, i enable search optimization. 

ALTER TABLE GOLD.FACT_SALES ADD SEARCH OPTIMIZATION ON EQUALITY(order_id);




-- materialized views for KPI  - dashboard becomes instant fast

CREATE OR REPLACE MATERIALIZED VIEW GOLD.MV_DAILY_REVENUE_KPI AS
SELECT
    date_key,
    order_status,
    SUM(price) AS total_sales,
    SUM(freight_value) AS total_freight,
    COUNT(order_id) AS order_count
FROM GOLD.FACT_SALES
GROUP BY date_key, order_status;





-- query acceleration service (QAS): this is a "set and forget" optimization for warehouses. It allows snowflake to temporarily use more compute for massive "outlier" queries without having to manually resize the warehouse.

ALTER WAREHOUSE RETAIL_BRAZILIAN_WH SET ENABLE_QUERY_ACCELERATION = TRUE;