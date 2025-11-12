{{ config(
    materialized = 'incremental',
    unique_key = ['product_id', 'user_id', 'search_event_id']
) }}


SELECT
    user_id,
    search_event_id,
    product_id,
    event_hour,
    search_type,
    search_terms,
    search_terms_type,
    search_model,
    search_feature,
    search_results_count,
    has_atc,
    has_purchase
FROM {{ ref('stg_user_journey_SX') }} s

{% if is_incremental() %}
    WHERE NOT EXISTS (
        SELECT 1
        FROM {{ this }} t
        WHERE t.product_id = s.product_id
          AND t.user_id = s.user_id
          AND t.search_event_id = s.search_event_id
    )
{% endif %}
