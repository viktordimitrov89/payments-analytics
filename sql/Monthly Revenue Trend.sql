-- ============================================================
-- MONTHLY REVENUE TREND
-- SumUp Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Provides an overview of total monthly revenue
--              across all merchants converted to EUR, enabling
--              high-level business performance monitoring and
--              trend analysis for executive reporting
-- ============================================================

SELECT
strftime('%Y-%m', t.transaction_date) AS year_month,
SUM(ROUND((CAST(t.amount AS REAL) - CAST(t.fee AS REAL))*CAST(er.rate_to_eur AS REAL),2)) as monthly_revenu_EUR
FROM transactions t
JOIN merchants m ON CAST(t.merchant_id as TEXT)=CAST(m.merchant_id AS TEXT)
JOIN exchange_rates er ON UPPER(TRIM(t.currency)) = UPPER(TRIM(er.currency))
AND strftime('%Y-%m',t.transaction_date) = er.month
GROUP BY year_month
ORDER BY year_month DESC;