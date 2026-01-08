{{
    config
    (
        materialized = 'incremental',
        unique_key=['warehouse_id','product_id','snapshot_date']
    )
}}

with base as (
    SELECT
        inv.warehouse_id,
        inv.product_id,
        inv.last_audit_date as snapshop_date,
        CAST(TO_CHAR(inv.last_audit_date,'YYYYMMDD')as INTEGER) as date_id,
        inv.stock_level,
        inv.quantity_in_stock,
        inv.reorder_level,
        inv.average_monthly_demand,
        inv.inventory_status,
        inv.next_restock_date_id
       
       
        
    from {{ ref('stg_inventory_sm') }} inv

    -- {% if is_incremental() %}
    --   -- Only process new inventory snapshots
    --   WHERE inv.last_audit_date > (
    --       SELECT MAX(snapshot_date)
    --       FROM {{ this }}
    --   )
    -- {% endif %}
)

select * from base