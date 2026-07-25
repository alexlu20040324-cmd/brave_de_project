with source as (

    select * from {{ source('jaffle_shop', 'raw_products') }}

),

renamed as (

    select
        sku                as product_sku,
        name               as product_name,
        type               as product_type,
        price::number(10,2) as product_price,
        description        as product_description

    from source

)

select * from renamed
