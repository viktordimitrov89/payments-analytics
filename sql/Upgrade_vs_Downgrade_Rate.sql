-- ============================================================
-- UPGRADE VS DOWNGRADE RATE
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Analyzes subscription plan changes across all
--              merchants to measure upgrade and downgrade rates,
--              track plan transition patterns and identify
--              opportunities to improve retention and reduce
--              revenue churn through targeted interventions
-- ============================================================

SELECT
UPPER(TRIM(sc.previous_plan)) AS previous_plan,
UPPER(TRIM(sc.new_plan)) AS new_plan,
UPPER(TRIM(sc.change_type)) AS change_type,
COUNT(*) AS total_changes,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT merchant_id) FROM subscription_changes), 1) AS pct_of_total
FROM subscription_changes sc
GROUP BY previous_plan, new_plan, change_type
ORDER BY total_changes DESC;