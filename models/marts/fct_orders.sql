with orders as (

    select * from {{ ref('stg_orders') }}

)

select
    order_id,
    customer_id,
    store_id,
    ordered_at,
    date(ordered_at)                        as order_date,
    subtotal,
    tax_paid,
    order_total,
    -- 标记之前发现的零金额订单,保留但可追溯
    case when order_total = 0 then false else true end as is_valid_order

from orders
