{{config(
    materialized='incremental',
    unique_key= ['user_id','session_id']
)}}

select
    user_id,
    session_id,
    device_class,
    dvce_screenwidth,
    dvce_screenheight,
    page_language,
    geo_country,
    geo_region,
    geo_city,
from {{ source('de_project', 'user_journey') }} uj

{% if is_incremental() %}
    WHERE NOT EXISTS (
        SELECT 1
        FROM {{ this }} t
        WHERE t.user_id = uj.user_id
          AND t.session_id = uj.session_id
    )
{% endif %}
