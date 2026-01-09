WITH base AS (

    SELECT
        campaign_id,
        date_id,
        impressions,
        total_atc,
        total_purchase
    FROM {{ ref('fact_campaign_performance_sm') }}

),

invalid_rows AS (

    SELECT *
    FROM base
    WHERE
        campaign_id IS NULL
        OR TRIM(campaign_id) = ''
        OR date_id IS NULL
        OR impressions < 0
        OR total_atc < 0
        OR total_purchase < 0
),

duplicate_grain AS (

    SELECT
        campaign_id,
        date_id
    FROM base
    GROUP BY campaign_id, date_id
    HAVING COUNT(*) > 1
)

SELECT * FROM invalid_rows
UNION ALL
SELECT
    campaign_id,
    date_id,
    NULL AS impressions,
    NULL AS total_atc,
    NULL AS total_purchase
FROM duplicate_grain
