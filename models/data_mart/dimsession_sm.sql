{{
    config
    (
        materialized = 'incremental',
        unique_key='session_id'
    )
}}

with session_data as (

    SELECT
        uj.session_id,                   
        uj.user_id,                      
        MIN(uj.timestamp) AS session_start_timestamp,
        MAX(uj.timestamp) AS session_end_timestamp,        
        uj.login_status,                 
        uj.app_id,                       
        uj.device_class,                 
        uj.page_language,                
        uj.shopping_mode                 

    FROM {{ source('de_project','user_journey') }} uj

    GROUP BY
        uj.session_id,
        uj.user_id,
        uj.login_status,
        uj.app_id,
        uj.device_class,
        uj.page_language,
        uj.shopping_mode
)
select * from session_data