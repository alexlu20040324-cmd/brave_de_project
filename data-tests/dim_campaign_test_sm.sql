WITH campaign_data AS (

    SELECT
        campaign_id,
        marketing_medium,
        marketing_content,
        marketing_source,
        banner
    FROM {{ ref('dimcampaign_sm') }}

),

invalid_campaigns AS (

    SELECT *
    FROM campaign_data
    WHERE
        campaign_id IS NULL
        OR campaign_id = ''
)

SELECT *
FROM invalid_campaigns
