-- ===========================================
-- File: 02_ORDER_ANALYSIS.SQL
-- Project: Brazilian E-Commerce SQL Project
-- Description: -- This file explores trends and metrics related to customer orders.
-- It provides insights into order volume and delivery efficiency.
-- Key insights include:
-- - Number of completed and cancelled orders.
-- - Monthly and yearly order distribution.
-- - Average delivery duration for orders.
-- - Trends in delivery delays and shipping performance.
-- - Time between order placement and customer receipt.
-- ===========================================

Q1. Total number of orders.

SELECT count(*) AS total_orders FROM orders


Q2. Number of orders per status(delivered, shipped, etc.)

SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


Q3. Number of orders per year

SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS year, COUNT(*) AS total_orders
FROM orders
GROUP BY year
ORDER BY year;


Q4. Number of orders per month

SELECT 
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS year_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY year_month
ORDER BY year_month;


Q5. Daily order trend(for a specific year like 2018)

SELECT 
    DATE(order_purchase_timestamp) AS order_date,
    COUNT(*) AS daily_orders
FROM orders
WHERE EXTRACT(YEAR FROM order_purchase_timestamp) = 2018
GROUP BY order_date
ORDER BY order_date;


Q6. Average time between order purchase and delivery (in days)

SELECT 
    ROUND(AVG(EXTRACT(EPOCH FROM order_delivered_customer_date - order_purchase_timestamp) / 86400.0), 2) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


Q7. Orders that took more than 15 days to deliver

SELECT *
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date - order_purchase_timestamp > INTERVAL '15 days';


Q8. Number of late deliveries (delivered after estimated date)

SELECT COUNT(*) AS late_deliveries
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;


Q9. Average delivery time by state

SELECT 
    c.customer_state,
    ROUND(AVG(EXTRACT(EPOCH FROM o.order_delivered_customer_date - o.order_purchase_timestamp) / 86400.0), 2) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;


Q10. Top 10 busiest days (most orders)

SELECT 
    DATE(order_purchase_timestamp) AS day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY day
ORDER BY total_orders DESC
LIMIT 10;
