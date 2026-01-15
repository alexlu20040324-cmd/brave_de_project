WITH null_session_id AS (
    SELECT *
    FROM {{ ref('dim_session_sm') }}
    WHERE session_id IS NULL
       OR TRIM(session_id) = ''
),
null_user_id AS (
    SELECT *
    FROM {{ ref('dim_session_sm') }}
    WHERE user_id IS NULL
       OR TRIM(user_id) = ''
),
null_start_timestamp AS (
    SELECT *
    FROM {{ ref('dim_session_sm') }}
    WHERE session_start_timestamp IS NULL
),
null_end_timestamp AS (
    SELECT *
    FROM {{ ref('dim_session_sm') }}
    WHERE session_end_timestamp IS NULL
),
invalid_timestamp_order AS (
    SELECT *
    FROM {{ ref('dim_session_sm') }}
    WHERE session_start_timestamp > session_end_timestamp
),
null_text_columns AS (
    SELECT *
    FROM {{ ref('dim_session_sm') }}
    WHERE login_status IS NULL
       OR app_id IS NULL
       OR device_class IS NULL
       OR page_language IS NULL
       OR shopping_mode IS NULL
)

SELECT *
FROM null_session_id
UNION ALL
SELECT *
FROM null_user_id
UNION ALL
SELECT *
FROM null_start_timestamp
UNION ALL
SELECT *
FROM null_end_timestamp
UNION ALL
SELECT *
FROM invalid_timestamp_order
UNION ALL
SELECT *
FROM null_text_columns
