with order_items as (

    select * from {{ ref('stg_items') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

products as (

    select * from {{ ref('dim_products') }}

),

joined as (

    select
        oi.order_item_id,
        oi.order_id,
        o.customer_id,
        o.store_id,
        o.ordered_at,
        date(o.ordered_at)          as order_date,
        oi.product_sku,
        p.product_name,
        p.product_type,
        p.product_price,
        p.product_cost,
        p.product_profit

    from order_items oi
    inner join orders   o on oi.order_id = o.order_id
    inner join products p on oi.product_sku = p.product_sku

)

select * from joined
