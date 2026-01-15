WITH warehouse_data AS (
    SELECT
        warehouse_id,
        storage_condition,
        last_restock_date,
        safety_stock,
        rating
    FROM {{ ref('dim_warehouse_sm') }}
),

invalid_warehouse AS (
    SELECT *
    FROM warehouse_data
    WHERE
        warehouse_id IS NULL
        OR TRIM(warehouse_id) = ''
        OR storage_condition IS NULL
        OR last_restock_date IS NULL
        OR safety_stock IS NULL
        OR rating IS NULL
        -- OR REGEXP_LIKE(rating, '[^0-9.]')  -- finds non-numeric characters
)

SELECT *
FROM invalid_warehouse
