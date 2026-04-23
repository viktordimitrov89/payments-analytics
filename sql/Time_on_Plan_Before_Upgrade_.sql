-- ============================================================
-- TIME ON PLAN BEFORE UPGRADE
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Analyzes how many days merchants spend on their
--              current plan before upgrading to a higher tier,
--              providing insights into upgrade triggers and
--              optimal timing for upsell campaigns to drive
--              revenue growth
-- ============================================================

SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(sc.previous_plan)) AS previous_plan,
UPPER(TRIM(sc.new_plan)) AS new_plan,
UPPER(TRIM(sc.change_type)) AS change_type,
ROUND(julianday(sc.change_date) - julianday(LAG(sc.change_date, 1) OVER (PARTITION BY sc.merchant_id ORDER BY sc.change_date)),1) AS days_on_previous_plan
FROM subscription_changes sc
JOIN merchants m ON CAST(sc.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
WHERE UPPER(TRIM(sc.change_type)) LIKE 'UPGRADE%'
GROUP BY merchant_name, previous_plan, new_plan, change_type
ORDER BY days_on_previous_plan DESC;