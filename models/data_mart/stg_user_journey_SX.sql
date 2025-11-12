{{ config(
    materialized='incremental',
    unique_key=['search_event_id', 'product_id', 'user_id']
)}}

    SELECT 
        uj.user_id,
        uj.product_id,
        uj.search_event_id,
        uj.session_id,
        uj.timestamp,
        DATE_TRUNC('hour', uj.timestamp) as event_hour,
        DATE_TRUNC('day', uj.timestamp) as event_date,
        uj.search_terms,
        uj.search_terms_type,
        uj.search_model,
        uj.search_type,
        uj.search_feature,
        uj.search_results_count,
        uj.has_qv,
        uj.has_pdp,
        uj.has_atc,
        uj.has_purchase,
        uj.mkt_campaign,
        uj.mkt_source,
        uj.mkt_medium,
        uj.mkt_content
    FROM {{ source('de_project', 'user_journey') }} uj

    {% if is_incremental() %}
        WHERE NOT EXISTS (
            SELECT 1
            FROM {{ this }} t
            WHERE t.search_event_id = uj.search_event_id
              AND t.product_id = uj.product_id
              AND t.user_id = uj.user_id
        )
    {% endif %}
