use customer_behaviour;

#1
select gender, SUM(purchase_amount) as "revenue" from customer
group by gender;

#2
select customer_id, discount_applied from customer
where discount_applied = "Yes" and purchase_amount >= (select Avg(purchase_amount) from customer);

#3
select item_purchased, ROUND(avg(review_rating),2)from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;


#4
select shipping_type, ROUND(avg(purchase_amount)) from customer
where shipping_type in ('Express','standard')
group by shipping_type;


#5
select subscription_status, 
count(customer_id) as 'total customers',
round(Avg(purchase_amount),2) as 'average purchase amount',
round(sum(purchase_amount),2) as 'Total Revenue' from customer
group by subscription_status;



#6
SELECT 
    item_purchased,
    ROUND(
        100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


#7
SELECT *
FROM (
    SELECT 
        customer_id,
        previous_purchases,
        CASE 
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer
) AS customer_type;



#8
WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(*) AS total_orders,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;

#9
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;

#10
select age_group,
SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;

