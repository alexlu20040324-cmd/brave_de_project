WITH user_data AS (
    SELECT *
    FROM {{ ref('dimuser_sm') }}
),

-- 1. Check for NULL user_id
check_user_id AS (
    SELECT *
    FROM user_data
    WHERE user_id IS NULL
),

-- 2. Check for missing first or last names
check_names AS (
    SELECT *
    FROM user_data
    WHERE first_name IS NULL OR TRIM(first_name) = ''
       OR last_name IS NULL OR TRIM(last_name) = ''
),

-- 3. Check invalid email format
check_email AS (
    SELECT *
    FROM user_data
    WHERE email IS NOT NULL
      AND email NOT LIKE '%_@__%.__%'
),

-- 4. Check dob <= signup_date
check_dates AS (
    SELECT *
    FROM user_data
    WHERE dob IS NOT NULL
      AND signup_date IS NOT NULL
      AND dob > signup_date
),

-- 5. Check account status values
check_account_status AS (
    SELECT *
    FROM user_data
    WHERE account_status NOT IN ('active', 'inactive', 'suspended', 'closed')
),

-- 6. Marketing opt-in boolean
check_marketing_opt_in AS (
    SELECT *
    FROM user_data
    WHERE marketing_opt_in NOT IN (TRUE, FALSE)
),

-- 7. Loyalty points sanity
check_loyalty_points AS (
    SELECT *
    FROM user_data
    WHERE loyalty_points_balance < 0
)

-- Final: union all failures
SELECT 'NULL user_id' AS issue, * FROM check_user_id
UNION ALL
SELECT 'Invalid names', * FROM check_names
UNION ALL
SELECT 'Invalid email', * FROM check_email
UNION ALL
SELECT 'DOB after signup', * FROM check_dates
UNION ALL
SELECT 'Invalid account status', * FROM check_account_status
UNION ALL
SELECT 'Invalid marketing opt-in', * FROM check_marketing_opt_in
UNION ALL
SELECT 'Negative loyalty points', * FROM check_loyalty_points
