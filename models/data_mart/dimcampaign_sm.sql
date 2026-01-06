{{
    config
    (
        materialized = 'incremental',
        unique_key='campaign_id'
    )
}}

with campaign_data as (

    SELECT
        uj.mkt_campaign AS campaign_id,       
        uj.mkt_campaign AS campaign_name,     
        uj.mkt_medium AS marketing_medium,    
        uj.mkt_content AS marketing_content,  
        uj.mkt_source AS marketing_source,
        uj.banner     

    FROM {{ source('de_project','user_journey') }} uj
)

select * from campaign_data
