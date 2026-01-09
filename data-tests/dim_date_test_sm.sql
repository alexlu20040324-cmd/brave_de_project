WITH date_data AS (
    SELECT *
    FROM {{ ref('dimdate_sm') }}
),

-- Validate date_id matches full_date (YYYYMMDD)
invalid_date_id AS (
    SELECT *
    FROM date_data
    WHERE date_id <> TO_NUMBER(TO_CHAR(full_date, 'YYYYMMDD'))
),

-- Validate year, month, day, quarter
invalid_ymd AS (
    SELECT *
    FROM date_data
    WHERE 
        year <> EXTRACT(YEAR FROM full_date)
        OR month <> EXTRACT(MONTH FROM full_date)
        OR day <> EXTRACT(DAY FROM full_date)
        OR quarter <> EXTRACT(QUARTER FROM full_date)
),

-- Validate day_of_week (1=Sunday, 7=Saturday)
invalid_day_of_week AS (
    SELECT *
    FROM date_data
    WHERE day_of_week <> EXTRACT(DAYOFWEEK FROM full_date)
),

-- Validate week_of_year
invalid_week_of_year AS (
    SELECT *
    FROM date_data
    WHERE week_of_year <> EXTRACT(WEEK FROM full_date)
),

-- Validate is_weekend
invalid_is_weekend AS (
    SELECT *
    FROM date_data
    WHERE is_weekend <> CASE WHEN EXTRACT(DAYOFWEEK FROM full_date) IN (1,7) THEN TRUE ELSE FALSE END
)


SELECT *
FROM invalid_date_id
UNION ALL
SELECT *
FROM invalid_ymd
UNION ALL
SELECT *
FROM invalid_day_of_week
UNION ALL
SELECT *
FROM invalid_week_of_year
UNION ALL
SELECT *
FROM invalid_is_weekend
