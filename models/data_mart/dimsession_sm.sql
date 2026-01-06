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
        uj.session_start_timestamp,      
        uj.session_end_timestamp,        
        uj.login_status,                 
        uj.app_id,                       
        uj.device_class,                 
        uj.page_language,                
        uj.shopping_mode                 

    FROM {{ source('de_project','user_journey') }} uj
)
select * from session_data