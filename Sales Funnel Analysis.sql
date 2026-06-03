-- Creating funnel_stage CTE
WITH funnel_stages AS (

  SELECT
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
  COUNT(DISTINCT CASE WHEN event_type = "add_to_cart" THEN user_id END) AS stage_2_cart,
  COUNT(DISTINCT CASE WHEN event_type = "checkout_start" THEN user_id END) AS stage_3_checkout,
  COUNT(DISTINCT CASE WHEN event_type = "payment_info" THEN user_id END) AS stage_4_payment_info,
  COUNT(DISTINCT CASE WHEN event_type = "purchase" THEN user_id END) AS stage_5_purchase

  FROM `sql-project-498212.sql_practice.user_events`
)

SELECT * FROM funnel_stages

-- conversion rates through the funnel

WITH funnel_stages AS (

  SELECT
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
  COUNT(DISTINCT CASE WHEN event_type = "add_to_cart" THEN user_id END) AS stage_2_cart,
  COUNT(DISTINCT CASE WHEN event_type = "checkout_start" THEN user_id END) AS stage_3_checkout,
  COUNT(DISTINCT CASE WHEN event_type = "payment_info" THEN user_id END) AS stage_4_payment,
  COUNT(DISTINCT CASE WHEN event_type = "purchase" THEN user_id END) AS stage_5_purchase

  FROM `sql-project-498212.sql_practice.user_events`
)

SELECT 

    stage_1_views,
    stage_2_cart,
    ROUND(( stage_2_cart / stage_1_views) * 100) AS views_to_cart_rate,
    stage_3_checkout,
    ROUND((stage_3_checkout / stage_2_cart ) * 100) as cart_to_checkout_rate,
    stage_4_payment,
    ROUND((stage_4_payment /stage_3_checkout ) * 100) as checkout_to_payment_rate,
    stage_5_purchase,
    ROUND((stage_5_purchase / stage_4_payment) * 100) as payment_to_purchase_rate

FROM funnel_stages

-- funnel by source

WITH source_funnel AS (

  SELECT
  traffic_source,
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
  COUNT(DISTINCT CASE WHEN event_type = "add_to_cart" THEN user_id END) AS cart,
  COUNT(DISTINCT CASE WHEN event_type = "purchase" THEN user_id END) AS purchase

  FROM `sql-project-498212.sql_practice.user_events`
  GROUP BY traffic_source
)

SELECT 
traffic_source,
views,
cart,
purchase,
ROUND((cart / views) * 100) as view_to_cart_rate,
ROUND((purchase / cart) * 100) as cart_to_purchase_rate,
ROUND((purchase / views) * 100) as view_to_purchase_rate
FROM source_funnel
ORDER BY traffic_source

-- time to conversion analysis
-- how long it takes to go from viewing to purchasing.

WITH user_journey AS (
  SELECT
  user_id,
  MIN(CASE WHEN event_type = 'page_view' THEN event_date END) as view_time,
  MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) as cart_time,
  MIN(CASE WHEN event_type = 'purchase' THEN event_date END) as purchase_time
  FROM `sql-project-498212.sql_practice.user_events`
  GROUP BY user_id
  HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
)

SELECT
  COUNT(*) as converted_users,
  ROUND(AVG(TIMESTAMP_DIFF(cart_time,view_time,MINUTE)), 2) as avg_view_to_cart_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time,cart_time,MINUTE)), 2) as avg_cart_to_purchase_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time,view_time,MINUTE)), 2) as avg_view_to_purchase_minutes
FROM user_journey

-- revenue funnel analysis

WITH funnel_analysis AS (
  SELECT
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) as total_buyers,
  SUM(CASE WHEN event_type = 'purchase' then amount END) AS total_revenue,
  COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders
  FROM `sql-project-498212.sql_practice.user_events`
)

SELECT 
total_visitors,
total_buyers,
total_revenue,
total_orders,
ROUND(total_revenue / total_orders * 100) as avg_order_value,
ROUND(total_revenue / total_buyers  * 100) as revenue_per_buyer,
ROUND(total_revenue / total_visitors  * 100) as revenue_per_visitor
FROM funnel_analysis
