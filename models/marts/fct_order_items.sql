{{
  config(
    materialized='incremental',
    unique_key='order_item_id',
    on_schema_change='append_new_columns'
  )
}}

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
{% if is_incremental() %}

  -- 只处理比"已有数据里最新时间"更新的记录
  -- 减 3 天是留缓冲窗口，防止迟到数据被漏掉
  where ordered_at >= (select dateadd(day, -3, max(ordered_at)) from {{ this }})

{% endif %}
