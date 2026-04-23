-- ============================================================
-- MONTHLY REVENUE TREND BY MERCHANT
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Tracks monthly revenue trends per merchant
--              converted to EUR using exchange rates to identify
--              top performing merchants, seasonal patterns and
--              revenue growth opportunities across all markets
-- ============================================================
SELECT
strftime('%Y-%m', t.transaction_date) AS year_month,
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(m.business_type)) AS business_type,
UPPER(TRIM(m.country)) AS country,
UPPER(TRIM(m.city)) AS city,
SUM(ROUND((CAST(t.amount AS REAL) - CAST(t.fee AS REAL))*CAST(er.rate_to_eur AS REAL),2)) as monthly_revenu_EUR
FROM transactions t
JOIN merchants m ON CAST(t.merchant_id as TEXT)=CAST(m.merchant_id AS TEXT)
JOIN exchange_rates er ON UPPER(TRIM(t.currency)) = UPPER(TRIM(er.currency))
AND strftime('%Y-%m',t.transaction_date) = er.month
GROUP BY merchant_name, business_type, country,city, year_month
ORDER BY year_month DESC;
