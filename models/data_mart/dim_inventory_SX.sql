{{config(
    materialized='table',
    unique_key='inventory_id'
)

}}

SELECT
    inventory_id,
    product_id,
    warehouse_id,
    stock_level,
    restock_date,
    last_restock_date,
    next_restock_date,
    inventory_status,
    quantity_in_stock,
    average_monthly_demand
FROM {{ source('de_project', 'inventory_data') }}

    