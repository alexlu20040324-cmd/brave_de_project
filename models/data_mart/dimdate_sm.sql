{{
    config
    (
        materialized = 'incremental',
        unique_key='date_id'
    )
}}

with date_data as (

 SELECT DATEADD(day, seq4(), '2020-01-01') AS full_date
    FROM TABLE(GENERATOR(ROWCOUNT => 365*5))  -- generating 5 years of dates

)


SELECT
    CAST(TO_CHAR(full_date,'YYYYMMDD') AS INTEGER) AS date_id,
    full_date,
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    EXTRACT(MONTH FROM full_date) AS month,
    EXTRACT(DAY FROM full_date) AS day,
    EXTRACT(DAYOFWEEK FROM full_date) AS day_of_week,   -- 1=Sunday, 7=Saturday
    EXTRACT(WEEK FROM full_date) AS week_of_year,
    CASE WHEN EXTRACT(DAYOFWEEK FROM full_date) IN (1,7) THEN TRUE ELSE FALSE END AS is_weekend
from date_data