select * from customer;

SELECT gender, SUM(purchase_amount_usd) AS revenue
FROM customer
GROUP BY gender;

select customer_id,purchase_amount_usd from customer where discount_applied='Yes' and purchase_amount_usd >=(select AVG(purchase_amount_usd) from customer)

SELECT item_purchased, AVG(review_rating::numeric) AS "Average Product Rating"
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating::numeric) DESC
LIMIT 5;

SELECT shipping_type,
ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount_usd),2) as avg_spend,
ROUND(SUM(purchase_amount_usd),2) as total_revenue
from customer
group by subscription_status
order by total_revenue,avg_spend desc;

SELECT item_purchased,
ROUND(
    SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 
    / COUNT(*), 2
) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

WITH customer_type AS (
    SELECT customer_id,
           previous_purchases,
           CASE
               WHEN previous_purchases = 1 THEN 'New'
               WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS customer_segment
    FROM customer
)
SELECT customer_segment,
       COUNT(*) AS "Number of Customers"
FROM customer_type
GROUP BY customer_segment;


WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY category 
               ORDER BY COUNT(customer_id) DESC
           ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)

SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
where item_rank <=3;


select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases>5
group by subscription_status

select age,
SUM(purchase_amount_usd) as total_revenue
from customer
group by age
order by total_revenue desc;


