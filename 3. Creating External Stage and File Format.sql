CREATE OR REPLACE FILE FORMAT retail_brazilian_csv_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null', '');


CREATE OR REPLACE STAGE retail_brazilian_external_stage
    URL = 's3://snowflake-capstone-retail-data/'
    STORAGE_INTEGRATION = s3_retail_brazilian_integration
    FILE_FORMAT = retail_brazilian_csv_format;


LIST @retail_brazilian_external_stage;    


-- Compute the total number of rows 
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/olist_customers_dataset.csv; // 99441
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/olist_geolocation_dataset.csv; // 1000163
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/olist_order_items_dataset.csv; // 112650
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/olist_order_payments_dataset.csv; // 103886
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/olist_orders_dataset.csv; // 99441
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/olist_order_reviews_dataset.csv; // 99224
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/olist_products_dataset.csv; // 32951
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/product_category_name_translation.csv; // 71
SELECT COUNT(*) FROM @retail_brazilian_external_stage/csv_data/olist_sellers_dataset.csv; // 3095
