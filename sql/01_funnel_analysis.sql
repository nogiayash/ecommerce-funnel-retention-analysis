create database Cosmetic_Shop

use Cosmetic_Shop

-- creating a copy of table cosmetic named shop
SELECT * INTO shop
FROM cosmetic
where 1=0;

-- inserting data into shop from cosmetic
INSERT INTO shop
SELECT *
FROM cosmetic;


create view cosmetic_view as
SELECT 
    event_time,
    event_type,
    product_id,
    ISNULL(category_code, 'Unknown') AS category_code,
    ISNULL(brand, 'Unknown') AS brand,
    price,
    user_id,
    user_session
FROM shop
WHERE event_type IN ('view', 'cart', 'purchase');  -- drop remove_from_cart here

select * from cosmetic_view;


-- Funnel Conversion Rates
SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_session END) AS views,
    COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_session END) AS carts,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) AS purchases,

    cast(round((100.0 * COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_session END) 
        / COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_session END) 
        ),2) as float) AS view_to_cart_conversion_productInterest,

    cast(round(100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) 
        / COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_session END),2) as float) 
        AS cart_to_purchase_conversion_BuyingIntent
FROM cosmetic_view;


--Which products get many views but few purchases
--Which products convert best
SELECT 
    product_id,

    COUNT(DISTINCT CASE WHEN event_type='view' THEN user_session END) AS views,

    COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_session END) AS carts,

    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_session END) AS purchases

FROM cosmetic_view
GROUP BY product_id
ORDER BY views DESC;

----------------------------


-- 1) products that users quickly add to cart
-- 2) products that need longer decision time

WITH funnel_time AS
(
SELECT 
    user_session,
    product_id,

    MIN(CASE 
        WHEN event_type='view' 
        THEN event_time 
    END) AS view_time,

    MIN(CASE 
        WHEN event_type='cart' 
        THEN event_time
    END) AS cart_time,

    MIN(CASE 
        WHEN event_type='purchase' 
        THEN event_time
    END) AS purchase_time

FROM shop1
GROUP BY user_session, product_id
)

SELECT
    product_id,
    AVG(DATEDIFF(second, view_time, cart_time)) AS avg_view_to_cart_time
FROM funnel_time
WHERE view_time IS NOT NULL
AND cart_time IS NOT NULL
GROUP BY product_id
ORDER BY avg_view_to_cart_time;

/*
| Insight            | Meaning               |
| ------------------ | --------------------- |
| very fast purchase | strong product demand |
| long cart time     | price hesitation      |
| long view time     | product research      |

*/