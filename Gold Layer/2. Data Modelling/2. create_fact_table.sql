/*
i combined :
Orders
Order Items
Payments
Customers

Removing Duplicates: Payments aggregated first. (By using payments_agg, you ensure that if someone paid with 3 vouchers, they still only have 1 total value associated with that order_id.)
Uses surrogate keys: Matches dimension tables
Uses date_key:Proper star schema
Keeps all data: No unnecessary filtering
Referential Integrity: By joining on the DIM tables, you ensure that every sale in your Fact table has a corresponding customer, product, and seller in your dimensions. If a product ID was missing in DIM_PRODUCTS, that sale would be dropped (or you could use LEFT JOIN if you want to keep orphans).
*/


USE SCHEMA GOLD;



CREATE OR REPLACE TABLE FACT_SALES AS

WITH payments_agg AS (
    -- praggregating payments to prevent row multiplication (fan-out problem)
    SELECT 
        order_id, 
        SUM(payment_value) AS total_payment_value 
    FROM Retail_Brazilian_DB.SILVER.PAYMENTS_CLEAN
    GROUP BY order_id
)

SELECT
    oi.order_id,
    oi.order_item_id,
    -- using keys from our gold dimensions
    dc.customer_key,
    dp.product_key,
    ds.seller_key,
    dd.date_key,
    -- measures
    oi.price,
    oi.freight_value,
    -- i divided the total payment by the number of items in the order 
    -- 'payment per item', but usually, 
    -- i just keep price/freight for item-level and use total_payment for order-level.
    COALESCE(pa.total_payment_value, 0) AS total_order_payment_value,
    o.order_status
    
FROM Retail_Brazilian_DB.SILVER.ORDER_ITEMS_CLEAN oi

JOIN Retail_Brazilian_DB.SILVER.ORDERS_CLEAN o 
    ON oi.order_id = o.order_id
    
LEFT JOIN payments_agg pa 
    ON oi.order_id = pa.order_id
-- join with gold Dimensions to pull the Surrogate Keys
JOIN GOLD.DIM_CUSTOMERS dc ON dc.customer_id = o.customer_id
JOIN GOLD.DIM_PRODUCTS dp ON dp.product_id = oi.product_id
JOIN GOLD.DIM_SELLERS ds ON ds.seller_id = oi.seller_id
JOIN GOLD.DIM_DATE dd ON dd.date = DATE(o.order_purchase_ts);
-- filter for delivered here as per our project's 'Analysis of sales' scope
-- WHERE o.order_status = 'delivered';



/*
if i filter here based on the order_status (WHERE o.order_status = 'delivered') , i cannot analyze:
Cancellation rate or shiiping rate
Order lifecycle (approved → shipped → delivered)
Failed payments / abandoned orders
Customer drop-off behavior

Because your project requires:
Customer behavior insights 
Product performance 
Sales trends 
*/

-- validate
SELECT COUNT(*) FROM FACT_SALES;
SELECT * FROM FACT_SALES LIMIT 20;
