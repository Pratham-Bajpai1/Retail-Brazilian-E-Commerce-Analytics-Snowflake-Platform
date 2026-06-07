
USE SCHEMA GOLD; 




-- Group A: Executive KPIs for dashboard tiles


-- KPI Metrics: The pulse of the business

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(price + freight_value) AS total_revenue,
    ROUND(AVG(price + freight_value), 2) AS avg_order_value
FROM GOLD.FACT_SALES
WHERE order_status = 'delivered';


SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(price + freight_value) AS total_revenue,
    ROUND(SUM(price + freight_value) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM GOLD.FACT_SALES
WHERE order_status = 'delivered';







-- Group B: Sales & Product Performance




-- Top 10 Product Categories by Total Revenue

SELECT
    dp.category,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    SUM(fs.price) AS total_sales,
    SUM(fs.price + fs.freight_value) AS total_revenue
FROM GOLD.FACT_SALES fs
JOIN GOLD.DIM_PRODUCTS dp
    ON fs.product_key = dp.product_key
WHERE fs.order_status = 'delivered'
GROUP BY dp.category
ORDER BY total_revenue DESC
LIMIT 10;






-- Under-Performing Categories (Shipping Cost Drain). Which products cost too much to ship.

SELECT 
    p.category, 
    ROUND(SUM(f.price), 2) AS merchandise_revenue,
    ROUND(SUM(f.freight_value), 2) AS shipping_costs,
    ROUND((SUM(f.freight_value) / NULLIF(SUM(f.price), 0)) * 100, 2) AS shipping_ratio_pct
FROM GOLD.FACT_SALES f
JOIN GOLD.DIM_PRODUCTS p ON f.product_key = p.product_key
WHERE f.order_status = 'delivered'
GROUP BY p.category
HAVING merchandise_revenue > 1000 
ORDER BY shipping_ratio_pct DESC
LIMIT 10;








-- Group C: Customer & Market Analysis





-- CUSTOMER SEGMENTATION (HIGH / MEDIUM / LOW) Value Customers
SELECT
    customer_key,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(price + freight_value) AS total_spent,
    CASE
        WHEN SUM(price + freight_value) > 1000 THEN 'High Value'
        WHEN SUM(price + freight_value) > 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS segment
FROM GOLD.FACT_SALES
WHERE order_status = 'delivered'
GROUP BY customer_key;



-- Grouping customers based on segemntation (HIGH / MEDIUM / LOW)

SELECT
    CASE
        WHEN total_spent > 1000 THEN '1. High Value (>1000)'
        WHEN total_spent > 500 THEN '2. Medium Value (500-1000)'
        ELSE '3. Low Value (<500)'
    END AS segment,
    COUNT(customer_key) AS customer_count,
    ROUND(SUM(total_spent), 2) AS total_revenue
FROM (
    SELECT 
        customer_key, 
        SUM(price + freight_value) AS total_spent 
    FROM GOLD.FACT_SALES 
    WHERE order_status = 'delivered' 
    GROUP BY 1
)
GROUP BY 1
ORDER BY 1;





-- Regional Performance: Top States by Sales volume

SELECT 
    c.state, 
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.price + f.freight_value) AS total_revenue,
    ROUND(SUM(f.price + f.freight_value) / COUNT(DISTINCT f.order_id), 2) AS avg_order_value
FROM GOLD.FACT_SALES f
JOIN GOLD.DIM_CUSTOMERS c 
    ON f.customer_key = c.customer_key
WHERE f.order_status = 'delivered'
GROUP BY c.state
ORDER BY total_revenue DESC;





-- MONTHLY REVENUE TREND

SELECT
    dd.year,
    dd.month,
    SUM(fs.price + fs.freight_value) AS monthly_revenue,
    COUNT(DISTINCT fs.order_id) AS total_orders
FROM GOLD.FACT_SALES fs
JOIN GOLD.DIM_DATE dd
    ON fs.date_key = dd.date_key
WHERE fs.order_status = 'delivered'
GROUP BY dd.year, dd.month
ORDER BY dd.year, dd.month;





-- CUSTOMER SATISFACTION (WITH REVIEWS)

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM SILVER.REVIEWS_CLEAN
GROUP BY review_score
ORDER BY review_score;






-- Group D: Operations & Logistics (Actionable Insights)




-- Order Status Distribution. Shows operational health (Canceled vs Delivered)

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders
FROM GOLD.FACT_SALES
GROUP BY order_status
ORDER BY total_orders DESC;





-- Delivery Efficiency (Avg days to reach customer)

SELECT
    AVG(DATEDIFF(day, order_purchase_ts, order_delivered_customer_ts)) AS avg_delivery_days
FROM SILVER.ORDERS_CLEAN
WHERE order_status = 'delivered';





-- Top 10 Cities with most active Sellers

SELECT
    ds.seller_city,
    ds.seller_state,
    COUNT(DISTINCT fs.seller_key) AS active_sellers,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    SUM(fs.price) AS total_sales
FROM GOLD.FACT_SALES fs
JOIN GOLD.DIM_SELLERS ds
    ON fs.seller_key = ds.seller_key
WHERE fs.order_status = 'delivered'
GROUP BY ds.seller_city, ds.seller_state
ORDER BY total_sales DESC
LIMIT 10;