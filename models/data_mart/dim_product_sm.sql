{{
    config
    (
        materialized = 'incremental',
        unique_key='product_id'
    )
}}

with product_data as(

    SELECT
    p.product_id,
    p.product_name,
    p.product_category,
    p.product_color,
    p.price,
    p.discount_percentage,
    p.supplier_id,
    p.warranty_period,
    p.weight_grams,
    p.expiration_date,
    p.manufacturing_date,
    p.rating
    

    from {{ ref('stg_product_data_sm') }} p


)

select * from product_data