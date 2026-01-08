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
        dob,                       
        signup_date,               
        TRIM(account_status) AS account_status,
        marketing_opt_in,           
        TRIM(preferred_language) AS preferred_language,
        loyalty_points_balance      
    FROM {{ source('de_project','user_data') }}
),

cleaned AS (
    SELECT
        *,
        CURRENT_TIMESTAMP() AS load_timestamp
    FROM raw_data
)

SELECT * FROM cleaned
