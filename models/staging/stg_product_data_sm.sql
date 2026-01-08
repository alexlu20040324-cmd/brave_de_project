{{ 
    config(
        materialized='table',
        schema='PROJECT_TEST'
    ) 
}}

WITH raw_product AS (
    SELECT
        TRIM(product_id) AS product_id,
        TRIM(product_name) AS product_name,
        TRIM(product_category) AS product_category,
        TRIM(product_color) AS product_color,
        price,
        discount_percentage,
        TRIM(supplier_id) AS supplier_id,
        warranty_period,
        weight_grams,
        expiration_date,
        manufacturing_date,
        rating
    FROM {{ source('de_project', 'product_data') }}
    WHERE product_id IS NOT NULL
)

SELECT *
FROM raw_product
