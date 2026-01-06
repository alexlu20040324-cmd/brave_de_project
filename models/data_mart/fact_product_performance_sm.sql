{{
    config
    (
        materialized = 'incremental',
        unique_key=['product_id','date_id']
    )
}}

with base as (
    SELECT
        uj.product_id,
        CAST(TO_CHAR(uj.timestamp,'YYYYMMDD')as INTEGER) as date_id,
        sum(case when uj.has_qv = TRUE then 1 else 0) as total_views,
        sum(case when uj.has_atc = TRUE then 1 else 0) as total_atc,
        sum(case when uj.has_purchase = TRUE then 1 else 0) as total_purchase
       
       
        
    from {{ source('de_project', 'user_journey') }} uj
--

    GROUP BY
        uj.product_id,
        CAST(TO_CHAR(uj.timestamp, 'YYYYMMDD') AS INTEGER)


)

select * from base





    
    -- {% if is_incremental() %}
    --   WHERE uj.timestamp >
    --     (
    --       SELECT MAX(TO_DATE(date_id::STRING, 'YYYYMMDD'))
    --       FROM {{ this }}
    --     )
    -- {% endif %}