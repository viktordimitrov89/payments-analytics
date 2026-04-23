-- ============================================================
-- TIME TO COMPLETE ONBOARDING
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Measures the number of days merchants take to
--              complete the full onboarding process from account
--              creation to first transaction, identifying delays
--              and opportunities to accelerate merchant
--              activation and time to first value
-- ============================================================

SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
MIN(CASE WHEN os.step_name = 'account_created' THEN os.completed_date END) AS start_date,
MIN(CASE WHEN os.step_name = 'first_transaction_completed' THEN os.completed_date END) AS end_date,
ROUND(julianday(MIN(CASE WHEN os.step_name = 'first_transaction_completed' THEN os.completed_date END)) - 
julianday(MIN(CASE WHEN os.step_name = 'account_created' THEN os.completed_date END)), 1) AS days_to_complete
FROM onboarding_steps os
JOIN merchants m ON CAST(os.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
GROUP BY merchant_name