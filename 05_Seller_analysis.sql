-- ===========================================
-- File: 05_Seller_analysis.sql
-- Project: Brazilian E-Commerce SQL Project
-- Description: -- This file focuses on analyzing seller activity and performance.
-- It helps identify top sellers, their order volume, and shipping efficiency.
-- Key insights include:
-- - Total number of unique sellers.
-- - Sellers with the highest order counts.
-- - Sellers who deliver the fastest.
-- - Geographic distribution of sellers.
-- - Seller performance based on customer reviews.
-- ===========================================


Q1. How many unique sellers are in the dataset?

SELECT COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers;


Q2. How many sellers are associated with each state?

SELECT seller_state, COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_state
ORDER BY seller_count DESC;


Q3. Which seller has the highest number of orders?

SELECT 
    s.seller_id, 
    COUNT(oi.order_id) AS total_orders
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_orders DESC
LIMIT 1;


Q4. Which seller generated the highest total revenue?

SELECT 
    s.seller_id, 
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 1;


Q5. What is the average number of products sold per seller?

SELECT 
    ROUND(AVG(product_count), 2) AS avg_products_sold
FROM (
    SELECT seller_id, COUNT(order_id) AS product_count
    FROM order_items
    GROUP BY seller_id
) sub;


Q6. Which seller has the highest average product price?

SELECT 
    seller_id, 
    ROUND(AVG(price), 2) AS avg_price
FROM order_items
GROUP BY seller_id
ORDER BY avg_price DESC
LIMIT 1;


Q7. Distribution of sellers by number of products sold (buckets).

SELECT 
    CASE 
        WHEN product_count BETWEEN 1 AND 10 THEN '1-10'
        WHEN product_count BETWEEN 11 AND 50 THEN '11-50'
        WHEN product_count BETWEEN 51 AND 100 THEN '51-100'
        ELSE '100+'
    END AS sales_range,
    COUNT(*) AS seller_count
FROM (
    SELECT seller_id, COUNT(order_id) AS product_count
    FROM order_items
    GROUP BY seller_id
) sub
GROUP BY sales_range
ORDER BY sales_range;


 Q8. Top 5 sellers in terms of freight charges collected.

 SELECT 
    seller_id, 
    ROUND(SUM(freight_value), 2) AS total_freight
FROM order_items
GROUP BY seller_id
ORDER BY total_freight DESC
LIMIT 5;


Q9. How many sellers are active each month?

SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT oi.seller_id) AS active_sellers
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY month
ORDER BY month;


 Q10. Average delivery time per seller (in days).

 SELECT 
    s.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(EXTRACT(DAY FROM o.order_delivered_customer_date - o.order_purchase_timestamp)), 2) AS avg_delivery_days
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    sellers s ON oi.seller_id = s.seller_id
WHERE 
    o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    s.seller_id
ORDER BY 
    avg_delivery_days DESC;

