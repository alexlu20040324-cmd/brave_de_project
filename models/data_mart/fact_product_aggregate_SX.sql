{{ config(
    materialized = 'table',
    unique_key = ['product_id', 'event_date']
) }}

SELECT
    uj.product_id,
    uj.event_date,
    count(uj.search_event_id) as search_count,
    count(case when uj.has_atc then 1 else null end) as atc_count,
    count(case when uj.has_purchase then 1 else null end) as amount_sold,
    count(case when uj.has_pdp then 1 else null end) as pdp_view_count,
    count(case when uj.has_qv then 1 else null end) as qv_view_count,
    count(CASE WHEN NOT uj.has_pdp and NOT uj.has_atc THEN 1 ELSE null END) as no_engagement_count,
    count(case when uj.has_purchase and uj.has_pdp then 1 else null end) as purchase_from_pdp_count

FROM {{ ref('stg_user_journey_SX') }} uj
GROUP BY
    uj.product_id,
    uj.event_date
