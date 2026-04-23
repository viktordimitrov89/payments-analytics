-- ============================================================
-- MERCHANTS WITH NO ACTIVITY IN LAST 90 DAYS
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Identifies merchants who have not processed any
--              transactions in the last 90 days, segmented by
--              business type, country and city to support
--              targeted re-engagement campaigns
-- ============================================================

SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(m.business_type)) AS business_type,
UPPER(TRIM(m.country)) AS country,
UPPER(TRIM(m.city)) AS city,
ROUND(julianday('now') - julianday(MAX(t.transaction_date)), 0) AS days_since_last_activity
FROM merchants m
JOIN transactions t ON CAST(m.merchant_id AS TEXT)=CAST(t.merchant_id AS TEXT)
GROUP BY merchant_name, business_type, country, city
HAVING julianday('now') - julianday(MAX(t.transaction_date)) > 90;
ORDER BY ROUND(julianday('now') - julianday(MAX(t.transaction_date)), 0) DESC;
