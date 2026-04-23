-- ============================================================
-- MONTHLY REVENUE TREND BY CUSTOMERS
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Analyzes monthly revenue trends segmented by
--              customer demographics including age group, gender
--              and country to identify high-value customer
--              segments and support targeted growth strategies
-- ============================================================

SELECT
strftime('%Y-%m', t.transaction_date) AS year_month,
UPPER(TRIM(c.age_group)) AS age_group,
UPPER(TRIM(c.gender)) AS gender,
UPPER(TRIM(c.country)) AS country,
UPPER(TRIM(c.city)) AS city,
SUM(ROUND((CAST(t.amount AS REAL) - CAST(t.fee AS REAL))*CAST(er.rate_to_eur AS REAL),2)) as monthly_revenu_EUR
FROM transactions t
JOIN customers c ON CAST(t.customer_id as TEXT)=CAST(c.customer_id AS TEXT)
JOIN exchange_rates er ON UPPER(TRIM(t.currency)) = UPPER(TRIM(er.currency))
AND strftime('%Y-%m',t.transaction_date) = er.month
GROUP BY age_group, gender, country, city, year_month
ORDER BY year_month DESC;
