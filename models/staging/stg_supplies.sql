with source as (

    select * from {{ source('jaffle_shop', 'raw_supplies') }}

),

renamed as (

    select
        id                  as supply_id,
        sku                 as product_sku,
        name                as supply_name,
        cost::number(10,2)  as supply_cost,
        perishable::boolean as is_perishable

    from source

)

select * from renamed
