-- ============================================================
-- TIME TO FIRST TRANSACTION
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Calculates the number of days between merchant
--              onboarding and their first completed transaction
--              to measure activation speed, identify slow
--              activating merchants and support targeted
--              interventions to reduce time to first value
-- ============================================================

SELECT
TRIM(UPPER(m.merchant_name)) AS merchant_name,
SUM(ROUND((CAST(t.amount AS REAL) - CAST(t.fee as REAL))*(CAST(er.rate_to_eur as REAL)),2)) AS total_revenue_EUR
FROM transactions t
JOIN merchants m ON CAST(t.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
JOIN exchange_rates er ON UPPER(TRIM(t.currency))=UPPER(TRIM(er.currency))
AND strftime('%Y-%m',t.transaction_date)=er.month
WHERE TRIM(UPPER(t.status)) LIKE "COMPLET%"
GROUP BY m.merchant_name
ORDER BY total_revenue_EUR DESC
LIMIT 10;