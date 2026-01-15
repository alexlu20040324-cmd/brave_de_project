{{
    config
    (
        materialized = 'incremental',
        unique_key='warehouse_id'
    )
}}

with warehouse_data as (

    SELECT
        war.warehouse_id,
        war.storage_condition,
        war.last_restock_date,
        war.safety_stock,
        war.rating
    FROM {{ ref('stg_inventory_sm')}} war

)

select * from warehouse_data