-- ============================================================
-- FEATURE ADOPTION BY MERCHANT & CITY
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Tracks which features have been adopted by each
--              merchant broken down by city to identify geographic
--              patterns in product engagement and adoption trends
-- ============================================================

SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(fa.feature_name)) AS feature_name,
UPPER(TRIM(m.country)) as country,
UPPER(TRIM(m.city)) as city,
fa.adoption_date,
fa.last_used_date,
fa.usage_count,
fa.is_active,
ROUND(julianday(fa.adoption_date) - julianday(m.onboarding_date), 1) AS days_to_adopt
FROM feature_adoption fa
JOIN merchants m ON CAST(fa.merchant_id AS TEXT) = CAST(m.merchant_id AS TEXT)
ORDER BY m.merchant_name, days_to_adopt;