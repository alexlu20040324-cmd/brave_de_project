{{ config(
    materialized = 'incremental',
    unique_key = ['product_id', 'user_id', 'session_id']
) }}

SELECT 
    s.user_id,
    s.search_event_id,
    s.session_id,
    s.product_id,
    s.event_hour,
    s.mkt_campaign,
    s.mkt_source,
    s.mkt_medium,
    s.mkt_content,
    s.has_atc,
    s.has_purchase
FROM {{ ref('stg_user_journey_SX') }} s
JOIN {{ source('de_project', 'user_data') }} ud
    ON s.user_id = ud.user_id
WHERE LOWER(CAST(ud.marketing_opt_in AS STRING)) = 'true'

{% if is_incremental() %}
    AND NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.product_id = s.product_id
        AND t.user_id = s.user_id
        AND t.session_id = s.session_id
    )
{% endif %}