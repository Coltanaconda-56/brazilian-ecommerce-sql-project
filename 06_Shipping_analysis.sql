-- ===========================================
-- File: 06_Shipping_analysis.sql
-- Project: Brazilian E-Commerce SQL Project
-- Description:-- This file explores delivery logistics and shipping performance.
-- It reveals the effectiveness of order fulfillment.
-- Key insights include:
-- - Average shipping delay per order.
-- - Geographic distribution of deliveries.
-- - Comparison between estimated and actual delivery times.
-- - Fastest and slowest shipping states.
-- - Delivery patterns by city and state.
-- ===========================================


Q1. What is the average shipping delay (in days) for delivered orders?

SELECT 
    ROUND(AVG(EXTRACT(DAY FROM order_delivered_customer_date - order_estimated_delivery_date)), 2) AS avg_shipping_delay_days
FROM 
    orders
WHERE 
    order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL;


 Q2. Which states have the highest average shipping delay?

 SELECT 
    c.customer_state,
    ROUND(AVG(EXTRACT(DAY FROM o.order_delivered_customer_date - o.order_estimated_delivery_date)), 2) AS avg_delay
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
WHERE 
    o.order_delivered_customer_date IS NOT NULL 
    AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY 
    c.customer_state
ORDER BY 
    avg_delay DESC;


 Q3. Which states receive the fastest deliveries on average?

 SELECT 
    c.customer_state,
    ROUND(AVG(EXTRACT(DAY FROM o.order_delivered_customer_date - o.order_purchase_timestamp)), 2) AS avg_delivery_time
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
WHERE 
    o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    c.customer_state
ORDER BY 
    avg_delivery_time ASC;


 Q4. What is the average freight value per order?

 SELECT 
    ROUND(AVG(freight_value), 2) AS avg_freight_per_order
FROM 
    order_items;


Q5. Which product categories have the highest average shipping (freight) cost?

SELECT 
    p.product_category_name,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    p.product_category_name
ORDER BY 
    avg_freight DESC
LIMIT 10;
