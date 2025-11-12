SELECT u.user_id from {{ref('fact_campaign_effect_SX')}} u
left join {{ref('dim_user_data_SX')}} d
    on u.user_id = d.user_id
where CAST(d.marketing_opt_in AS STRING) = 'false'