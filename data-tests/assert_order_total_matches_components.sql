-- order_total should equal subtotal + tax_paid (allowing tiny rounding differences).
-- This test passes when zero rows are returned.
select
    order_id,
    subtotal,
    tax_paid,
    order_total,
    subtotal + tax_paid as expected_total
from {{ ref('fct_orders') }}
where abs(order_total - (subtotal + tax_paid)) > 1
