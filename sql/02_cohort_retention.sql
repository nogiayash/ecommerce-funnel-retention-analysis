select * into shop1 from cosmetic_view where 1=0;
select * from shop1;
insert into shop1 select * from cosmetic_view;

UPDATE shop1
SET event_time = CAST(REPLACE(event_time,' UTC','') AS datetime);

-- Cohort Conversion Query
WITH events_clean AS
(
SELECT
    user_session,
    event_type,
    event_time
FROM shop1
),

first_visit AS
(
SELECT
    user_session,
    MIN(event_time) AS first_visit_time
FROM events_clean
GROUP BY user_session
),

cohort_data AS
(
SELECT
    e.user_session,
    f.first_visit_time,
    CAST(f.first_visit_time AS date) AS cohort_date,
    DATEDIFF(day, f.first_visit_time, e.event_time) AS day_number,
    e.event_type
FROM events_clean e
JOIN first_visit f
ON e.user_session = f.user_session
)

SELECT
    cohort_date,
    day_number,

    COUNT(DISTINCT user_session) AS users,

    COUNT(DISTINCT CASE 
        WHEN event_type = 'purchase' 
        THEN user_session END) AS purchases,

    100.0 *
    COUNT(DISTINCT CASE 
        WHEN event_type = 'purchase' 
        THEN user_session END)
    /
    NULLIF(COUNT(DISTINCT user_session),0) AS conversion_rate    -- if count is 0 then returns NULL to avoid divide by zero

FROM cohort_data
GROUP BY cohort_date, day_number
ORDER BY cohort_date, day_number;

/*
Meaning:
Day 0 = first visit day
Day 1 = next day
Shows how conversion grows over time
*/


-- Retention Rate Calculation
-- calculate no. of users return after days 0,1,2,3..
WITH events_clean AS
(
SELECT
    user_id,
    event_time
FROM shop1
),

first_visit AS
(
SELECT
    user_id,
    MIN(event_time) AS first_visit_time
FROM events_clean
GROUP BY user_id
),

retention_data AS
(
SELECT
    e.user_id,   -- users on new/latest event
    CAST(f.first_visit_time AS date) AS cohort_date,
    DATEDIFF(day, f.first_visit_time, e.event_time) AS day_number
FROM events_clean e
JOIN first_visit f
ON e.user_id = f.user_id
),

cohort_size AS
(
SELECT
    cohort_date,
    COUNT(DISTINCT user_id) AS total_users    -- using where cond total users are found
FROM retention_data
WHERE day_number = 0
GROUP BY cohort_date
)

SELECT
r.cohort_date,
r.day_number,
COUNT(DISTINCT r.user_id) AS retained_users,
100.0 * COUNT(DISTINCT r.user_id) / c.total_users AS retention_rate
FROM retention_data r
JOIN cohort_size c
ON r.cohort_date = c.cohort_date
GROUP BY r.cohort_date, r.day_number, c.total_users
ORDER BY r.cohort_date, r.day_number;

/*
| cohort_date | day | retained_users | retention_rate |
| ----------- | --- | -------------- | -------------- |
| Feb-01      | 0   | 12000          | 100%           |
| Feb-01      | 1   | 5200           | 43%            |
| Feb-01      | 2   | 3100           | 25%            |
| Feb-01      | 7   | 1500           | 12%            |

Meaning:

43% users returned next day
12% returned after a week

*/




/*
Behavioral Cohort Analysis groups users based on their first behavior (for example: first event = view, cart, or purchase) and then tracks how they behave afterward.


Users whose first action = view
Users whose first action = cart
Users whose first action = purchase

Then we analyze how many of them eventually purchase.
*/
WITH ordered_events AS
(
SELECT
    user_id,
    event_type,
    event_time,
    ROW_NUMBER() OVER(
        PARTITION BY user_id
        ORDER BY event_time
    ) AS rn
FROM shop1
),

first_behavior AS
(
SELECT
user_id,
event_type AS cohort_behavior
FROM ordered_events
WHERE rn = 1
)

SELECT
f.cohort_behavior,

COUNT(DISTINCT f.user_id) AS users,

COUNT(DISTINCT CASE
    WHEN c.event_type = 'purchase'
    THEN c.user_id
END) AS purchasers,

100.0 * COUNT(DISTINCT CASE
    WHEN c.event_type = 'purchase'
    THEN c.user_id
END)
/ COUNT(DISTINCT f.user_id) AS conversion_rate

FROM first_behavior f
LEFT JOIN cosmetic_view c
ON f.user_id = c.user_id

GROUP BY f.cohort_behavior
ORDER BY conversion_rate DESC;



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