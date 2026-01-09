WITH null_product_id AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE product_id IS NULL
       OR TRIM(product_id) = ''
),
null_product_name AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE product_name IS NULL
       OR TRIM(product_name) = ''
),
null_product_category AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE product_category IS NULL
       OR TRIM(product_category) = ''
),
null_product_color AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE product_color IS NULL
       OR TRIM(product_color) = ''
),
invalid_price AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE price < 0
),
invalid_discount AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE discount_percentage < 0
       OR discount_percentage > 100
),
invalid_weight AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE weight_grams < 0
),
invalid_rating AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE rating < 0
       OR rating > 5
),
date_inconsistency AS (
    SELECT *
    FROM {{ ref('dimproduct_sm') }}
    WHERE expiration_date IS NOT NULL
      AND manufacturing_date > expiration_date
)

SELECT *
FROM null_product_id

UNION ALL
SELECT *
FROM null_product_name

UNION ALL
SELECT *
FROM null_product_category

UNION ALL
SELECT *
FROM null_product_color

UNION ALL
SELECT *
FROM invalid_price

UNION ALL
SELECT *
FROM invalid_discount

UNION ALL
SELECT *
FROM invalid_weight

UNION ALL
SELECT *
FROM invalid_rating

UNION ALL
SELECT *
FROM date_inconsistency
