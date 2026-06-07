-- creating bronze schema

USE DATABASE Retail_Brazilian_DB;

CREATE OR REPLACE SCHEMA BRONZE;

USE SCHEMA BRONZE;






-- creating raw tables

CREATE OR REPLACE TABLE CUSTOMERS_RAW (
    customer_id STRING,
    customer_unique_id STRING,
    customer_zip_code_prefix STRING,
    customer_city STRING,
    customer_state STRING
);


CREATE OR REPLACE TABLE ORDERS_RAW (
    order_id STRING,
    customer_id STRING,
    order_status STRING,
    order_purchase_timestamp STRING,
    order_approved_at STRING,
    order_delivered_carrier_date STRING,
    order_delivered_customer_date STRING,
    order_estimated_delivery_date STRING
);


CREATE OR REPLACE TABLE ORDER_ITEMS_RAW (
    order_id STRING,
    order_item_id STRING,
    product_id STRING,
    seller_id STRING,
    shipping_limit_date STRING,
    price STRING,
    freight_value STRING
);


CREATE OR REPLACE TABLE ORDER_PAYMENTS_RAW (
    order_id STRING,
    payment_sequential STRING,
    payment_type STRING,
    payment_installments STRING,
    payment_value STRING
);


CREATE OR REPLACE TABLE ORDER_REVIEWS_RAW (
    review_id STRING,
    order_id STRING,
    review_score STRING,
    review_comment_title STRING,
    review_comment_message STRING,
    review_creation_date STRING,
    review_answer_timestamp STRING
);


CREATE OR REPLACE TABLE PRODUCTS_RAW (
    product_id STRING,
    product_category_name STRING,
    product_name_lenght STRING,
    product_description_lenght STRING,
    product_photos_qty STRING,
    product_weight_g STRING,
    product_length_cm STRING,
    product_height_cm STRING,
    product_width_cm STRING
);


CREATE OR REPLACE TABLE GEOLOCATION_RAW (
    geolocation_zip_code_prefix STRING,
    geolocation_lat STRING,
    geolocation_lng STRING,
    geolocation_city STRING,
    geolocation_state STRING
);


CREATE OR REPLACE TABLE SELLERS_RAW(
    seller_id STRING,
    seller_zip_code_prefix STRING,
    seller_city STRING,
    seller_state STRING
);


CREATE OR REPLACE TABLE CATEGORY_TRANSLATION_RAW (
    product_category_name STRING,
    product_category_name_english STRING
);





-- loading data from S3

COPY INTO CUSTOMERS_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/olist_customers_dataset.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';


COPY INTO ORDERS_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/olist_orders_dataset.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';


COPY INTO ORDER_ITEMS_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/olist_order_items_dataset.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';


COPY INTO ORDER_PAYMENTS_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/olist_order_payments_dataset.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';


COPY INTO ORDER_REVIEWS_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/olist_order_reviews_dataset.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';


COPY INTO PRODUCTS_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/olist_products_dataset.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';


COPY INTO GEOLOCATION_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/olist_geolocation_dataset.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';


COPY INTO SELLERS_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/olist_sellers_dataset.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';


COPY INTO CATEGORY_TRANSLATION_RAW
FROM @Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_external_stage/csv_data/product_category_name_translation.csv
FILE_FORMAT = Retail_Brazilian_DB.Retail_Brazilian_SCHEMA.retail_brazilian_csv_format
ON_ERROR = 'CONTINUE';





-- validating all loads

SELECT 'customers' AS table_name, COUNT(*) FROM customers_raw
UNION ALL
SELECT 'orders', COUNT(*) FROM orders_raw
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items_raw
UNION ALL
SELECT 'payments', COUNT(*) FROM order_payments_raw
UNION ALL
SELECT 'reviews', COUNT(*) FROM order_reviews_raw
UNION ALL
SELECT 'products', COUNT(*) FROM products_raw
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation_raw
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers_raw
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation_raw;