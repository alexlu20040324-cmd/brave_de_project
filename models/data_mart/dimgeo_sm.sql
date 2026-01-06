{{
    config
    (
        materialized = 'incremental',
        unique_key='geo_id'
    )
}}

with distinct_geo as (

    SELECT DISTINCT
        uj.geo_country   AS country,
        uj.geo_region    AS region,
        uj.geo_city      AS city,
        uj.geo_zipcode   AS zipcode,
        uj.geo_timezone  AS timezone,
        uj.geo_latitude  AS latitude,
        uj.geo_longitude AS longitude
    FROM {{ source('de_project','user_journey') }} uj

),

geo_data AS (

    SELECT
        ROW_NUMBER() OVER (
            ORDER BY
                country,
                region,
                city,
                zipcode,
                latitude,
                longitude
        ) AS geo_id,

        country,
        region,
        city,
        zipcode,
        timezone,
        latitude,
        longitude

    FROM distinct_geo

)

select * from geo_data