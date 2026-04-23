-- ============================================================
-- ONBOARDING FUNNEL
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Tracks merchant progression through each
--              onboarding step to identify drop-off points,
--              average completion time per step and overall
--              funnel performance to optimize the onboarding
--              experience and improve merchant activation rates
-- ============================================================

WITH funnel_steps AS (

SELECT
UPPER(TRIM(os.step_name)) AS step_name,
CAST(os.step_order AS REAL) AS step_order,
COUNT(DISTINCT os.merchant_id) as merchants_count
FROM onboarding_steps os
GROUP BY step_name, step_order
),

drop_off_rate AS (

SELECT
step_name,
step_order,
merchants_count,
LAG(merchants_count, 1, 0) OVER (ORDER BY step_order) AS previous_step_count,
ROUND((LAG(merchants_count, 1, 0) OVER (ORDER BY step_order) - merchants_count) * 100.0 / 
LAG(merchants_count, 1, 0) OVER (ORDER BY step_order), 1) AS dropoff_pct
FROM funnel_steps
),

avg_time_per_step AS(

SELECT
UPPER(TRIM(os.step_name)) AS step_name,
UPPER(TRIM(os.step_order)) AS step_order,
ROUND(AVG(CAST(os.time_to_complete_days AS REAL)), 1) AS avg_days_to_complete
FROM onboarding_steps os
GROUP BY step_name, step_order
)
SELECT
fs.step_name,
fs.step_order,
fs.merchants_count,
dr.previous_step_count,
dr.dropoff_pct,
atps.avg_days_to_complete
FROM funnel_steps fs
JOIN drop_off_rate dr ON fs.step_name = dr.step_name
LEFT JOIN avg_time_per_step atps ON fs.step_name = atps.step_name
ORDER BY fs.step_order;