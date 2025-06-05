-- ===========================================
-- File: 03 product_analysis.sql
-- Project: Brazilian E-Commerce SQL Project
-- Description:-- This file provides insights into product categories and availability.
-- It identifies popular products and customer preferences.
-- Key insights include:
-- - Number of distinct product categories.
-- - Most common product categories.
-- - Product availability by category.
-- - Distribution of products per order.
-- - Product trends over time.
-- ===========================================

Q1. List all unique product categories.

SELECT distinct(products.product_category_name) 
as product_categories FROM products


Q2. Find the top 10 most reviewed products.

SELECT 
    oi.product_id,
    COUNT(r.review_id) AS total_reviews
FROM order_items oi
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY oi.product_id
ORDER BY total_reviews DESC
LIMIT 10;


Q3. Average product description length by category

SELECT 
    product_category_name,
    ROUND(AVG(products.product_description_length), 2) AS avg_description_length
FROM products
GROUP BY product_category_name
ORDER BY avg_description_length DESC;


 Q4. Top 5 categories with highest average review score

 
SELECT 
    p.product_category_name,
    ROUND(AVG(r.review_score), 2) AS avg_score
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY p.product_category_name
ORDER BY avg_score DESC
LIMIT 5;


 Q5. Product categories with most number of sales

 SELECT 
    p.product_category_name,
    COUNT(oi.product_id) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sales DESC;


 Q6. Number of products that were never sold

 SELECT COUNT(*) AS unsold_products
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM order_items
);


 Q7. Products with average review score below 3

 SELECT 
    oi.product_id,
    ROUND(AVG(r.review_score), 2) AS avg_score
FROM order_items oi
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY oi.product_id
HAVING AVG(r.review_score) < 3
ORDER BY avg_score ASC;


 Q8. Product with the longest product name

 SELECT product_id, products.product_name_length
FROM products
ORDER BY products.product_name_length DESC
LIMIT 1;


Q9. Products sold per category per month

SELECT 
    p.product_category_name,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(oi.product_id) AS total_sold
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name, month
ORDER BY month, total_sold DESC;


Q10. Top 5 products with highest delivery delay (actual vs estimated)

SELECT 
    oi.product_id,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date)) / 86400), 2) AS avg_delay_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY oi.product_id
ORDER BY avg_delay_days DESC
LIMIT 5;
