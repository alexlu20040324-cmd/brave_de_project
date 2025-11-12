{{config(
    materialized='table',
    unique_key='user_id'
)

}}
SELECT
    user_id,
    first_name,
    last_name,
    email,
    signup_date,
    preferred_language,
    DOB,
    marketing_opt_in,
    account_status,
    loyalty_points_balance
from {{ source('de_project', 'user_data') }}
