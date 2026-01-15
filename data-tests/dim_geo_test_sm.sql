WITH geo_data AS (
    SELECT *
    FROM {{ ref('dim_geo_sm') }}
),

-- Check for NULL or empty country, region, city, zipcode
invalid_location AS (
    SELECT *
    FROM geo_data
    WHERE
        country IS NULL OR TRIM(country) = ''
        OR region IS NULL OR TRIM(region) = ''
        OR city IS NULL OR TRIM(city) = ''
        OR zipcode IS NULL OR TRIM(zipcode) = ''
),

-- Validate latitude and longitude are numeric and not null
invalid_coordinates AS (
    SELECT *
    FROM geo_data
    WHERE
        latitude IS NULL
        OR longitude IS NULL
),

-- Check timezone is not null or empty
invalid_timezone AS (
    SELECT *
    FROM geo_data
    WHERE timezone IS NULL OR TRIM(timezone) = ''
)

SELECT *
FROM invalid_location
UNION ALL
SELECT *
FROM invalid_coordinates
UNION ALL
SELECT *
FROM invalid_timezone
