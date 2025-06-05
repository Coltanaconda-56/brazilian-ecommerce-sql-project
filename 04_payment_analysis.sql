-- ===========================================
-- File: 04_payment_analysis.sql
-- Project: Brazilian E-Commerce SQL Project
-- Description: -- This file focuses on customer payment behavior and preferences.
-- It helps identify trends in payment method usage.
-- Key insights include:
-- - All distinct payment methods used.
-- - Most commonly used payment types.
-- - Average number of payment installments.
-- - Distribution of payment values.
-- - Popularity of credit card and boleto methods.
-- ===========================================

Q1. List all unique payment types used in the dataset.

SELECT DISTINCT(order_payments.payment_type) 
FROM order_payments


Q2. Which payment type is used most frequently?

SELECT payment_type, COUNT(*) AS usage_count
FROM order_payments
GROUP BY payment_type
ORDER BY usage_count DESC
LIMIT 1;


 Q3. What is the total payment value by payment type?

SELECT 
    payment_type, 
    SUM(payment_value) AS total_payment
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment DESC;


Q4. What is the average number of installments by payment type?

SELECT 
    payment_type, 
    ROUND(AVG(payment_installments), 2) AS avg_installments
FROM order_payments
GROUP BY payment_type;


 Q5. What is the maximum number of installments a customer has chosen?

 SELECT 
    MAX(payment_installments) AS max_installments
FROM order_payments;


Q6. Which payment type has the highest average payment value per order?

SELECT 
    payment_type, 
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY avg_payment_value DESC
LIMIT 1;


 Q7. Find orders with payment values higher than 1000 BRL.

 SELECT 
    order_id, 
    payment_value
FROM order_payments
WHERE payment_value > 1000
ORDER BY payment_value DESC;


Q8. Top 5 customers who made the highest total payment value.

SELECT 
    o.customer_id, 
    ROUND(SUM(p.payment_value), 2) AS total_payment
FROM order_payments p
JOIN orders o ON p.order_id = o.order_id
GROUP BY o.customer_id
ORDER BY total_payment DESC
LIMIT 5;


Q9. Monthly trend of total payments received.

SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value), 2) AS total_payment
FROM order_payments p
JOIN orders o ON p.order_id = o.order_id
GROUP BY month
ORDER BY month;


 Q10. Is there any relationship between number of installments and payment value?

 SELECT 
    payment_installments, 
    ROUND(AVG(payment_value), 2) AS avg_payment_value,
    COUNT(*) AS order_count
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;
