/*
-- create clean customers table
transformations i applied :
keep only valid records
trim spaces
standardize text
*/

CREATE OR REPLACE TABLE CUSTOMERS_CLEAN AS
SELECT
    TRIM(customer_id) AS customer_id,
    TRIM(customer_unique_id) AS customer_unique_id,
    customer_zip_code_prefix,
    INITCAP(TRIM(customer_city)) AS customer_city,
    UPPER(TRIM(customer_state)) AS customer_state
FROM Retail_Brazilian_DB.BRONZE.customers_raw
WHERE customer_id IS NOT NULL;


-- validating

SELECT COUNT(*) FROM customers_clean;
SELECT * FROM customers_clean LIMIT 10;



/*
-- create clean orders table
transformations i applied :
convert timestamps
handle nulls
standardize values
*/

CREATE OR REPLACE TABLE ORDERS_CLEAN AS
SELECT
    TRIM(order_id) AS order_id,
    TRIM(customer_id) AS customer_id,
    LOWER(TRIM(order_status)) AS order_status,

    TO_TIMESTAMP(order_purchase_timestamp) AS order_purchase_ts,
    TO_TIMESTAMP(order_approved_at) AS order_approved_ts,
    TO_TIMESTAMP(order_delivered_carrier_date) AS order_delivered_carrier_ts,
    TO_TIMESTAMP(order_delivered_customer_date) AS order_delivered_customer_ts,
    TO_TIMESTAMP(order_estimated_delivery_date) AS order_estimated_delivery_ts

FROM Retail_Brazilian_DB.BRONZE.orders_raw
WHERE order_id IS NOT NULL;


-- validating

SELECT COUNT(*) FROM orders_clean;
SELECT * FROM orders_clean LIMIT 10;




/*
-- create clean order items table
transformations i applied :
convert numeric fields
convert date
remove invalid rows
*/

CREATE OR REPLACE TABLE ORDER_ITEMS_CLEAN AS
SELECT
    TRIM(order_id) AS order_id,
    TO_NUMBER(order_item_id) AS order_item_id,
    TRIM(product_id) AS product_id,
    TRIM(seller_id) AS seller_id,

    TO_TIMESTAMP(shipping_limit_date) AS shipping_limit_ts,

    TO_DECIMAL(price, 10, 2) AS price,
    TO_DECIMAL(freight_value, 10, 2) AS freight_value

FROM Retail_Brazilian_DB.BRONZE.order_items_raw
WHERE order_id IS NOT NULL;


-- validating

SELECT COUNT(*) FROM order_items_clean;
SELECT * FROM order_items_clean LIMIT 10;





/*
-- create clean payments table
transformations i applied :
convert numbers
standardize payment type
*/

CREATE OR REPLACE TABLE PAYMENTS_CLEAN AS
SELECT
    TRIM(order_id) AS order_id,
    TO_NUMBER(payment_sequential) AS payment_sequential,
    LOWER(TRIM(payment_type)) AS payment_type,
    TO_NUMBER(payment_installments) AS payment_installments,
    TO_DECIMAL(payment_value, 10, 2) AS payment_value

FROM Retail_Brazilian_DB.BRONZE.order_payments_raw
WHERE order_id IS NOT NULL;


-- validating

SELECT COUNT(*) FROM payments_clean;
SELECT * FROM payments_clean LIMIT 10;





/*
-- create clean products table
transformations i applied :
fix numeric columns
handle null category names
*/

CREATE OR REPLACE TABLE PRODUCTS_CLEAN AS
SELECT
    TRIM(product_id) AS product_id,
    TRIM(product_category_name) AS product_category_name,

    TO_NUMBER(product_name_lenght) AS product_name_length,
    TO_NUMBER(product_description_lenght) AS product_description_length,
    TO_NUMBER(product_photos_qty) AS product_photos_qty,

    TO_NUMBER(product_weight_g) AS product_weight_g,
    TO_NUMBER(product_length_cm) AS product_length_cm,
    TO_NUMBER(product_height_cm) AS product_height_cm,
    TO_NUMBER(product_width_cm) AS product_width_cm

FROM Retail_Brazilian_DB.BRONZE.products_raw
WHERE product_id IS NOT NULL;


-- validating

SELECT COUNT(*) FROM products_clean;
SELECT * FROM products_clean LIMIT 10;





/*
-- create clean sellers table
*/

CREATE OR REPLACE TABLE SELLERS_CLEAN AS
SELECT
    TRIM(seller_id) AS seller_id,
    seller_zip_code_prefix,
    INITCAP(TRIM(seller_city)) AS seller_city,
    UPPER(TRIM(seller_state)) AS seller_state
FROM Retail_Brazilian_DB.BRONZE.sellers_raw
WHERE seller_id IS NOT NULL;


-- validating

SELECT COUNT(*) FROM sellers_clean;
SELECT * FROM sellers_clean LIMIT 10;




/*
-- create clean category translation table
*/

CREATE OR REPLACE TABLE CATEGORY_TRANSLATION_CLEAN AS
SELECT
    TRIM(product_category_name) AS product_category_name,
    TRIM(product_category_name_english) AS product_category_name_english
FROM Retail_Brazilian_DB.BRONZE.category_translation_raw;


-- validating

SELECT COUNT(*) FROM category_translation_clean;





/*
-- create clean reviews table
*/

CREATE OR REPLACE TABLE REVIEWS_CLEAN AS
SELECT
    TRIM(review_id) AS review_id,
    TRIM(order_id) AS order_id,
    TO_NUMBER(review_score) AS review_score,
    TRIM(review_comment_title) AS review_comment_title,
    TRIM(review_comment_message) AS review_comment_message,
    TO_TIMESTAMP(review_creation_date) AS review_creation_ts,
    TO_TIMESTAMP(review_answer_timestamp) AS review_answer_ts
FROM Retail_Brazilian_DB.BRONZE.order_reviews_raw
WHERE review_id IS NOT NULL;


-- validating

SELECT COUNT(*) FROM reviews_clean;
SELECT * FROM reviews_clean LIMIT 10;





/*
-- create clean geolocation table
*/

CREATE OR REPLACE TABLE geolocation_clean AS
SELECT
    geolocation_zip_code_prefix,
    TO_DECIMAL(geolocation_lat, 10, 6) AS latitude,
    TO_DECIMAL(geolocation_lng, 10, 6) AS longitude,
    INITCAP(TRIM(geolocation_city)) AS city,
    UPPER(TRIM(geolocation_state)) AS state
FROM Retail_Brazilian_DB.BRONZE.geolocation_raw;


-- validation

SELECT COUNT(*) FROM geolocation_clean;
SELECT * FROM geolocation_clean LIMIT 10;