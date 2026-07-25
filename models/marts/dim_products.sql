with products as (

    select * from {{ ref('stg_products') }}

),

supply_cost as (

    -- 每个商品可能用到多种原料,把它们的成本加总
    select
        product_sku,
        sum(supply_cost) as total_supply_cost

    from {{ ref('stg_supplies') }}
    group by product_sku

),

joined as (

    select
        p.product_sku,
        p.product_name,
        p.product_type,
        p.product_price,
        p.product_description,
        coalesce(s.total_supply_cost, 0)              as product_cost,
        p.product_price - coalesce(s.total_supply_cost, 0) as product_profit

    from products p
    left join supply_cost s on p.product_sku = s.product_sku

)

select * from joined
