with source as (

    select * from {{ source('jaffle_shop', 'raw_orders') }}

),

renamed as (

    select
        id                      as order_id,
        customer                as customer_id,
        store_id,
        ordered_at::timestamp   as ordered_at,
        subtotal::number(10,2)  as subtotal,
        tax_paid::number(10,2)  as tax_paid,
        order_total::number(10,2) as order_total

    from source

)

select * from renamed
