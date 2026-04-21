-- ============================================================
-- REVENUE TREND OVER TIME - IS IT GROWING OR DECLINING
-- SumUp Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Measures month-over-month revenue changes using
--              LAG window function to calculate growth rates,
--              classify each month as Growing, Declining or
--              Stable and provide actionable insights for
--              executive decision making
-- ============================================================

WITH monthly_revenue_EUR AS (
SELECT strftime('%Y-%m', t.transaction_date) AS year_month,
SUM(ROUND((CAST(t.amount AS REAL) - CAST(t.fee AS REAL))*CAST(er.rate_to_eur AS REAL),2)) AS revenue_EUR
FROM transactions t 
JOIN exchange_rates er ON strftime('%Y-%m', t.transaction_date) = er.month
AND t.currency = er.currency
GROUP BY year_month
),
revenue_with_lag AS (
SELECT
year_month,
revenue_EUR,
LAG(revenue_EUR, 1, NULL) OVER (ORDER BY year_month) AS previous_revenue_EUR
FROM monthly_revenue_EUR
)
SELECT
year_month,
revenue_EUR,
previous_revenue_EUR,
ROUND(((revenue_EUR - previous_revenue_EUR) * 100.0 / previous_revenue_EUR), 2) AS mom_change_pct,
CASE 
    WHEN revenue_EUR > previous_revenue_EUR THEN 'Growing'
    WHEN revenue_EUR < previous_revenue_EUR THEN 'Declining'
    ELSE 'Stable'
END AS trend 
FROM revenue_with_lag
ORDER BY year_month DESC;