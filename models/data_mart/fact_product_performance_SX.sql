{{ config(
    materialized = 'incremental',
    unique_key = ['product_id', 'user_id', 'search_event_id']
) }}

select 
    user_id,
    search_event_id,
    product_id,
    timestamp,
    has_qv,
    has_pdp,
    has_atc,
    has_purchase
from {{ ref('stg_user_journey_SX') }} s

{% if is_incremental() %}
    WHERE NOT EXISTS (
        SELECT 1
        FROM {{ this }} t
        WHERE t.product_id = s.product_id
          AND t.user_id = s.user_id
          AND t.search_event_id = s.search_event_id
    )
{% endif %}