
-- customer segmentation
WITH user_activity AS
(
SELECT
    user_id,

    COUNT(*) AS total_events,
    SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS views,
    SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS carts,
    SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases

FROM cosmetic_view
GROUP BY user_id
),

segmented AS
(
SELECT
CASE
    WHEN purchases > 0 AND total_events >= 20 THEN 'Power User'
    WHEN purchases > 0 THEN 'Buyer'
    WHEN carts > 0 THEN 'Shopper'
    ELSE 'Browser'
END AS segment
FROM user_activity
)

SELECT
segment,
COUNT(*) AS users,
100.0 * COUNT(*) / SUM(COUNT(*)) OVER() AS percentage
FROM segmented
GROUP BY segment
ORDER BY users DESC;


--------------------
-- user segmentation with revenue


WITH user_activity AS
(
SELECT
    user_id,
    SUM(CASE WHEN event_type = 'purchase' THEN price ELSE 0 END) AS total_spent,
    COUNT(*) AS total_events,
    SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases
FROM cosmetic_view
GROUP BY user_id
),

segmented AS
(
SELECT
user_id,
total_spent,

CASE
    WHEN purchases > 0 AND total_events >= 20 THEN 'Power User'
    WHEN purchases > 0 THEN 'Buyer'
    WHEN total_events > 0 THEN 'Shopper'
    ELSE 'Browser'
END AS segment
FROM user_activity
)

SELECT
segment,
COUNT(*) AS users,
SUM(total_spent) AS revenue,
AVG(total_spent) AS avg_revenue_per_user
FROM segmented
GROUP BY segment
ORDER BY revenue DESC;