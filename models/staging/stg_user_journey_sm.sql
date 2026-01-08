{{ 
    config(
        materialized = 'table',
        unique_key = 'user_id'  
    ) 
}}


WITH raw_data AS (
    SELECT
        uj.user_id,
        uj.product_id,
        uj.session_id,
        uj.timestamp,
        uj.has_qv,
        uj.has_atc,
        uj.has_pdp,
        uj.has_purchase,
        uj.cart_id,
        uj.mkt_campaign,
        uj.mkt_medium,
        uj.mkt_source,
        uj.mkt_content,
        uj.banner,
        uj.login_status,
        uj.app_id,
        uj.device_class,
        uj.page_language,
        uj.shopping_mode,
        uj.geo_country,
        uj.geo_region,
        uj.geo_city,
        uj.geo_zipcode,
        uj.geo_timezone,
        uj.geo_latitude,
        uj.geo_longitude
    FROM {{ source('de_project', 'user_journey') }} uj
    WHERE uj.timestamp IS NOT NULL
),


cleaned AS (
    SELECT
        user_id,
        product_id,
        session_id,
        timestamp,
        has_qv,
        has_atc,
        has_pdp,
        has_purchase,
        cart_id,
        INITCAP(LOWER(mkt_campaign)) AS mkt_campaign,
        INITCAP(LOWER(mkt_medium)) AS mkt_medium,
        INITCAP(LOWER(mkt_source)) AS mkt_source,
        INITCAP(LOWER(mkt_content)) AS mkt_content,
        banner,
        INITCAP(LOWER(login_status)) AS login_status,
        app_id,
        INITCAP(LOWER(device_class)) AS device_class,
        INITCAP(LOWER(page_language)) AS page_language,
        INITCAP(LOWER(shopping_mode)) AS shopping_mode,
        INITCAP(LOWER(geo_country)) AS geo_country,
        INITCAP(LOWER(geo_region)) AS geo_region,
        INITCAP(LOWER(geo_city)) AS geo_city,
        geo_zipcode,
        geo_timezone,
        geo_latitude,
        geo_longitude,
        CURRENT_TIMESTAMP() AS load_timestamp
    FROM raw_data
)

SELECT * 
FROM cleaned
