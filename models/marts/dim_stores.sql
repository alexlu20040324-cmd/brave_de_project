with stores as (

    select * from {{ ref('stg_stores') }}

)

select
    store_id,
    store_name,
    opened_at,
    tax_rate

from stores
