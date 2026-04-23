-- ============================================================
-- FEATURE ADOPTION RATE
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Measures the percentage of merchants who have
--              adopted each feature along with average days
--              to adopt, providing insights into product
--              engagement and feature popularity
-- ============================================================

WITH merchant_adopted_feature AS (

SELECT 
UPPER(TRIM(fa.feature_name)) AS feature_name,
COUNT(DISTINCT fa.merchant_id) AS merchants_adopted_features
FROM feature_adoption AS fa
GROUP BY fa.feature_name
),

total_merchants AS (

SELECT
UPPER(TRIM(fa.feature_name)) AS feature_name,
(SELECT COUNT(DISTINCT m.merchant_id) from merchants m) AS total_merchants,
ROUND(AVG(julianday(fa.adoption_date) - julianday(m.onboarding_date)), 1) AS avg_days_to_adopt
FROM merchants m
JOIN feature_adoption AS fa ON m.merchant_id=fa.merchant_id
GROUP BY fa.feature_name
)

SELECT 
maf.feature_name,
maf.merchants_adopted_features,
tm.total_merchants,
ROUND((merchants_adopted_features*100.0/total_merchants),1) AS adoption_feature_rate,
tm.avg_days_to_adopt
FROM total_merchants tm
JOIN merchant_adopted_feature maf ON tm.feature_name=maf.feature_name
ORDER BY ROUND(merchants_adopted_features*100.0/total_merchants) DESC;
