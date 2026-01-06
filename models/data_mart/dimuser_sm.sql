{{
    config
    (
        materialized = 'incremental',
        unique_key='user_id'
    )
}}

with user_data as(

    SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    CASE WHEN u.email not like '%_@__%.__%' THEN NULL ELSE u.email END AS email,
    u.dob,
    u.signup_date,
    u.account_status,
    u.marketing_opt_in,
    u.preferred_language,
    loyalty_points_balance

    from {{ source('de_project', 'user_data') }} u


)

select * from user_data