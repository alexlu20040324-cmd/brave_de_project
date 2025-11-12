{{config(
    materialized='table',
    unique_key='product_id'
)

}}

SELECT
    product_id,
    product_name,
    product_category,
    price,
    manufacturing_date,
    expiration_date,
    discount_percentage
FROM {{ source('de_project', 'product_data') }} 
