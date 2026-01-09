WITH base AS (

    SELECT
        product_id,
        date_id,
        total_views,
        total_atc,
        total_purchase
    FROM {{ ref('fact_product_performance_sm') }}

),

invalid_rows AS (

    SELECT *
    FROM base
    WHERE
        product_id IS NULL
        OR date_id IS NULL
        OR total_views < 0
        OR total_atc < 0
        OR total_purchase < 0
),

duplicate_grain AS (

    SELECT
        product_id,
        date_id
    FROM base
    GROUP BY product_id, date_id
    HAVING COUNT(*) > 1
)

SELECT * FROM invalid_rows
UNION ALL
SELECT
    product_id,
    date_id,
    NULL AS total_views,
    NULL AS total_atc,
    NULL AS total_purchase
FROM duplicate_grain
