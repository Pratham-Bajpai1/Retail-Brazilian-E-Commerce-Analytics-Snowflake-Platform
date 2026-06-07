USE SCHEMA GOLD;

/*
Surrogate Keys -
Faster joins
Standard star schema practice
Needed for BI tools

I did not used surrogate keys as ROW_NUMBER because is not deterministic across reloads, so I used hash-based surrogate keys to ensure consistency and maintain referential integrity.
*/


-- creating DIM_CUSTOMERS

CREATE OR REPLACE TABLE DIM_CUSTOMERS AS
SELECT 
    MD5(customer_id) AS customer_key,
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix AS zip_code,
    customer_city AS city,
    customer_state AS state
FROM Retail_Brazilian_DB.SILVER.CUSTOMERS_CLEAN;


-- validate
SELECT COUNT(*) FROM dim_customers;
SELECT * FROM DIM_CUSTOMERS LIMIT 10;



-- creating DIM_PRODUCTS including english category (important for dashboard)

CREATE OR REPLACE TABLE DIM_PRODUCTS AS
SELECT
    MD5(p.product_id) AS product_key,
    p.product_id,
    COALESCE(ct.product_category_name_english, 'Other') AS category,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM Retail_Brazilian_DB.SILVER.PRODUCTS_CLEAN p
LEFT JOIN Retail_Brazilian_DB.SILVER.CATEGORY_TRANSLATION_CLEAN ct
    ON p.product_category_name = ct.product_category_name;


-- validate
SELECT COUNT(*) FROM dim_products;
SELECT * FROM DIM_PRODUCTS LIMIT 10;



-- creating DIM_SELLERS
CREATE OR REPLACE TABLE DIM_SELLERS AS
SELECT DISTINCT
    MD5(seller_id) AS seller_key,
    seller_id,
    seller_zip_code_prefix AS zip_code,
    seller_city,
    seller_state
FROM Retail_Brazilian_DB.SILVER.SELLERS_CLEAN;


-- validate
SELECT COUNT(*) FROM dim_sellers;
SELECT * FROM DIM_SELLERS LIMIT 10;



-- creating DIM_DATE

CREATE OR REPLACE TABLE DIM_DATE AS
SELECT
    TO_NUMBER(TO_CHAR(d, 'YYYYMMDD')) AS date_key,
    d AS date,
    YEAR(d) AS year,
    MONTH(d) AS month,
    DAY(d) AS day,
    QUARTER(d) AS quarter,
    DAYNAME(d) AS day_name
FROM (
    SELECT DATEADD(day, seq4(), '2016-01-01') AS d
    FROM TABLE(GENERATOR(ROWCOUNT => 2000))
);


-- validate
SELECT COUNT(*) FROM dim_date;
SELECT * FROM DIM_DATE LIMIT 10;
    