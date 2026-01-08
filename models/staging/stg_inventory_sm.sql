{{ 
    config(
        materialized='table', 
        schema='PROJECT_TEST', 
        cluster_by=['warehouse_id'] 
    ) 
}}

WITH raw_inventory AS (
    SELECT
        TRIM(warehouse_id) AS warehouse_id,
        TRIM(product_id) AS product_id,
        last_audit_date,
        stock_level,
        quantity_in_stock,
        reorder_level,
        average_monthly_demand,
        inventory_status,
        next_restock_date,
        storage_condition,
        last_restock_date,
        safety_stock,
        rating,
        supplier_id
    FROM {{ source('de_project', 'inventory_data') }}
    WHERE warehouse_id IS NOT NULL
      AND product_id IS NOT NULL
),

cleaned_inventory AS (
    SELECT
        warehouse_id,
        product_id,
        last_audit_date,
        CAST(TO_CHAR(last_audit_date,'YYYYMMDD') AS INTEGER) AS date_id,
        stock_level,
        quantity_in_stock,
        reorder_level,
        last_restock_date,
        average_monthly_demand,
        INITCAP(LOWER(inventory_status)) AS inventory_status,
        next_restock_date AS next_restock_date_id,
        INITCAP(LOWER(storage_condition)) AS storage_condition,
        safety_stock,
        rating,
        supplier_id,
        CURRENT_TIMESTAMP() AS load_timestamp
    FROM raw_inventory
)

SELECT *
FROM cleaned_inventory