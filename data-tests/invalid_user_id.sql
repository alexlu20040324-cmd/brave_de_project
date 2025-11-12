-- Ensure all user id in fact table exist in user data dimension
WITH ALL_FACTS AS (
  SELECT user_id FROM {{ ref('fact_search_metric_SX') }}
  UNION ALL
  SELECT user_id FROM {{ ref('fact_campaign_effect_SX') }}
  UNION ALL
  SELECT user_id FROM {{ ref('fact_product_performance_SX') }}
)

SELECT f.*
FROM ALL_FACTS f
LEFT JOIN {{ref('dim_user_data_SX')}} u
  ON f.user_id = u.user_id
WHERE u.user_id IS NULL