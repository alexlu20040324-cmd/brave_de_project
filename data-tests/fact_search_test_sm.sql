SELECT *
FROM {{ ref('fact_search_effectiveness_sm') }}
WHERE
    user_id IS NULL
    OR product_id IS NULL
    OR session_id IS NULL
    OR event_timestamp IS NULL
    OR geo_id IS NULL
    OR has_qv NOT IN (TRUE, FALSE)
    OR has_pdp NOT IN (TRUE, FALSE)
    OR has_atc NOT IN (TRUE, FALSE)
    OR has_purchase NOT IN (TRUE, FALSE)
