-- ===========================================
-- File: 07_Review_analysis.sql
-- Project: Brazilian E-Commerce SQL Project
-- Description: -- This file contains SQL queries related to customer review analysis.
-- It focuses on understanding customer satisfaction and response efficiency.
-- Key insights include:
-- - Distribution of review scores.
-- - Top states with the highest number of 5-star reviews.
-- - Sellers receiving the most 1-star ratings.
-- - Average rating per seller.
-- - Time taken to respond to customer reviews.
-- ===========================================


Q1. What is the distribution of review scores?

SELECT review_score, COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


Q2. What is the average review score for each seller?

SELECT s.seller_id, ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items i ON o.order_id = i.order_id
JOIN sellers s ON i.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY avg_review_score DESC
LIMIT 10;


 Q3. How many 5-star reviews were given by customers per state?

 SELECT c.customer_state, COUNT(*) AS five_star_reviews
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE r.review_score = 5
GROUP BY c.customer_state
ORDER BY five_star_reviews DESC;


Q4. What’s the average time (in days) it took to respond to reviews?

SELECT AVG(review_answer_timestamp - review_creation_date) AS avg_response_time_days
FROM order_reviews;


Q5. Which orders received the lowest review score of 1, and who were the sellers?

SELECT r.order_id, s.seller_id, r.review_comment_title, r.review_comment_message
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items i ON o.order_id = i.order_id
JOIN sellers s ON i.seller_id = s.seller_id
WHERE r.review_score = 1;

