{{
    config
    (
        materialized = 'incremental',
        unique_key=['campaign_id','date_id']
    )
}}

with base as (
    SELECT
        uj.mkt_campaign as campaign_id,
        TO_NUMBER(TO_CHAR(uj.timestamp,'YYYYMMDD')) as date_id,
        count(*) as impressions,
        sum(case when uj.has_atc = TRUE then 1 else 0 END) as total_atc,
        sum(case when uj.has_purchase = TRUE then 1 else 0 END) as total_purchase
    from {{ ref('stg_user_journey_sm') }} uj

--
    GROUP BY
        uj.mkt_campaign,
        TO_NUMBER(TO_CHAR(uj.timestamp,'YYYYMMDD'))


)

select * from base








    -- {% if is_incremental() %}
    --   WHERE uj.timestamp >
    --     (
    --       SELECT MAX(TO_DATE(date_id::STRING, 'YYYYMMDD'))
    --       FROM {{ this }}
    --     )
    -- {% endif %}