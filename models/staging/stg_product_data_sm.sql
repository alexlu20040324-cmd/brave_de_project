{{ 
    config(
        materialized='table',
        schema='PROJECT_TEST'
    ) 
}}

WITH raw_product AS (
    SELECT
        TRIM(p.product_id) AS product_id,
        TRIM(p.product_name) AS product_name,
        TRIM(p.product_category) AS product_category,
        TRIM(p.product_color) AS product_color,
        p.price,
        p.discount_percentage,
        TRIM(p.supplier_id) AS supplier_id,
        p.warranty_period,
        p.weight_grams,
        p.expiration_date,
        p.manufacturing_date,
        TRY_CAST(rating AS NUMBER(38,1)) AS rating
    FROM {{ source('de_project', 'product_data') }} p
    WHERE product_id IS NOT NULL
)

SELECT *
FROM raw_product
