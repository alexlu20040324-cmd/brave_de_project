-- A product's profit should never be negative (cost should not exceed price).
-- This test passes when zero rows are returned.
select
    product_sku,
    product_name,
    product_price,
    product_cost,
    product_profit
from {{ ref('dim_products') }}
where product_profit < 0
