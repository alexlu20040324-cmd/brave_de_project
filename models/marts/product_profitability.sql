with order_items as (

    select * from {{ ref('fct_order_items') }}

),

final as (

    select
        product_sku,
        product_name,
        product_type,

        -- 销量指标
        count(*)                              as times_sold,

        -- 收入与成本
        round(sum(product_price), 0)          as total_revenue,
        round(sum(product_cost), 0)           as total_cost,
        round(sum(product_profit), 0)         as total_profit,

        -- 单位经济指标
        round(avg(product_price), 2)          as avg_price,
        round(avg(product_profit), 2)         as avg_profit_per_unit,

        -- 利润率(利润 / 收入),衡量赚钱效率
        round(sum(product_profit) * 100.0 / nullif(sum(product_price), 0), 1) as profit_margin_pct

    from order_items
    group by product_sku, product_name, product_type

)

select * from final
order by total_profit desc
