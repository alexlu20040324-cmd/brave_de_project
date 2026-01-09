WITH base AS (
    SELECT *
    FROM {{ ref('fact_inventory_sm') }}
),

invalid_data AS (
    SELECT *
    FROM base
    WHERE warehouse_id IS NULL
       OR product_id IS NULL
       OR stock_level IS NULL
       OR quantity_in_stock IS NULL
       OR reorder_level IS NULL
       OR average_monthly_demand IS NULL
       OR inventory_status IS NULL
)

SELECT *
FROM invalid_data
