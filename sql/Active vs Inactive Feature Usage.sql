-- ============================================================
-- ACTIVE VS INACTIVE FEATURE USAGE
-- SumUp Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Analysis of feature engagement across merchants
--              comparing active vs inactive usage patterns
-- ============================================================

SELECT
UPPER(TRIM(fa.feature_name)) as feature_name,
SUM(CASE WHEN fa.is_active = 1 THEN 1 ELSE 0 END) AS active,
SUM(CASE WHEN fa.is_active = 0 THEN 1 ELSE 0 END) AS inactive,
ROUND(SUM(CASE WHEN fa.is_active = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS active_rate_pct
FROM feature_adoption fa
GROUP BY feature_name;