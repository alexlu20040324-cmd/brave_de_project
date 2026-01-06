{{
    config
    (
        materialized = 'incremental',
        unique_key=['user_id','product_id','session_id','event_timestamp']
    )
}}

with base as (
    SELECT
        uj.user_id,
        uj.product_id,
        uj.session_id,
        uj.timestamp as event_timestamp,
        CAST(TO_CHAR(uj.timestamp,'YYYYMMDD')as INTEGER) as date_id,
        uj.has_qv,
        uj.has_atc,
        uj.has_pdp,
        uj.has_purchase,
        uj.cart_id,
        uj.mkt_campaign as campaign_id,
        --below will be used to change as geo_id
        uj.geo_country,
        uj.geo_region,
        uj.geo_city
        dg.geo_id
    from {{ source('de_project', 'user_journey') }} uj

    LEFT JOIN {{ ref('dim_geo') }} dg
    ON  uj.geo_country   = dg.country
    AND uj.geo_region    = dg.region
    AND uj.geo_city      = dg.city
    AND uj.geo_zipcode   = dg.zipcode

    --


)

select * from base
















-- {% if is_incremental() %}
      
--       WHERE uj.timestamp > (SELECT MAX(event_timestamp) FROM {{ this }})
--     {% endif %}