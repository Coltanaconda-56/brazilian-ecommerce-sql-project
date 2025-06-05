-- ===========================================
-- File: 01_customer_analysis.sql
-- Project: Brazilian E-Commerce SQL Project
-- Description: -- This file analyzes customer behavior and purchase patterns.
-- It helps understand customer engagement and order distribution.
-- Key insights include:
-- - Number of unique customers.
-- - Customers with the highest number of orders.
-- - Customers who spent the most.
-- - Repeat purchase behavior.
-- - Time gaps between customer purchases.
-- ===========================================


Q1. Count total unique customers

SELECT count(distinct customer_id) as total_customer 
FROM customers;

Q2. Top 10 States By No Of customers

SELECT customer_state, count(*) as customer_count
FROM customers
GROUP by customer_state
order by customer_count DESC
LIMIT 10;

Q3. Customers with Most Orders

SELECT customer_id, count(*) as total_orders
FROM orders
GROUP by customer_id
ORDER by total_orders DESC
LIMIT 10;

Q4. Average Number of Orders per Customer

SELECT ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT customer_id), 2) AS avg_orders_per_customer
FROM orders;

Q5. First and Last Order Date for Each Customer

SELECT customer_id,
       MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order
FROM orders
GROUP BY customer_id;

Q6. how many customers made more than one order

SELECT COUNT(*) AS returning_customers
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) AS sub;


Q7. Calculate the total amount spent by each customer. Return top 10.

SELECT 
    o.customer_id, 
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spent
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;

Q8. Find the average time (in days) between purchases for repeat customers


WITH order_diffs AS (
    SELECT 
        customer_id,
        order_purchase_timestamp,
        LEAD(order_purchase_timestamp) OVER (
            PARTITION BY customer_id 
            ORDER BY order_purchase_timestamp
        ) AS next_order_date
    FROM orders
)
SELECT 
    customer_id,
    ROUND(AVG(EXTRACT(DAY FROM next_order_date - order_purchase_timestamp)), 2) AS avg_days_between_orders
FROM order_diffs
WHERE next_order_date IS NOT NULL
GROUP BY customer_id
HAVING COUNT(*) > 1;

Q9. Find customers who only placed one order but gave a 5-star review.


SELECT o.customer_id
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE r.review_score = 5
GROUP BY o.customer_id
HAVING COUNT(o.order_id) = 1;

Q10. Identify the top 5 cities with the highest number of unique customers.


SELECT 
    c.customer_city,
    COUNT(DISTINCT c.customer_id) AS unique_customers
FROM customers c
GROUP BY c.customer_city
ORDER BY unique_customers DESC
LIMIT 5;
