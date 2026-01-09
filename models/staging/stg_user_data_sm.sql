{{ 
    config(
        materialized='table',
        cluster_by=['user_id']
    ) 
}}

WITH raw_data AS (
    SELECT
        TRIM(user_id) AS user_id,
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        CASE 
            WHEN email NOT LIKE '%_@__%.__%' THEN NULL 
            ELSE TRIM(email) 
        END AS email,
        TRY_CAST(dob AS DATE) AS dob,                       
        TRY_CAST(signup_date AS DATE) AS signup_date, 
        TRIM(account_status) AS account_status,
        COALESCE(
        CASE 
            WHEN LOWER(marketing_opt_in) = 'true' THEN TRUE
            WHEN LOWER(marketing_opt_in) = 'false' THEN FALSE
            ELSE NULL
        END,
        FALSE
        ) AS marketing_opt_in,    
        TRIM(preferred_language) AS preferred_language,
        TRY_CAST(loyalty_points_balance AS NUMBER(18,1)) AS loyalty_points_balance
    FROM {{ source('de_project','user_data') }}
),

cleaned AS (
    SELECT
        *,
        CURRENT_TIMESTAMP() AS load_timestamp
    FROM raw_data
    WHERE user_id IS NOT NULL
      AND first_name IS NOT NULL
      AND last_name IS NOT NULL
      AND dob IS NOT NULL
      AND signup_date IS NOT NULL
      AND loyalty_points_balance IS NOT NULL
    --   -- logical consistency
    --   AND TRY_CAST(dob AS DATE) <= TRY_CAST(signup_date AS DATE)
)

SELECT * FROM cleaned
