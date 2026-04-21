-- ============================================================
-- TOP MERCHANTS BY CHARGEBACK RATE
-- SumUp Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Ranks merchants by their chargeback rate to
--              identify high risk merchants, support fraud
--              prevention efforts and enable proactive risk
--              management interventions before issues escalate
-- ============================================================

WITH chargebacks_count AS (
SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
COUNT(c.chargeback_id) AS total_chargebacks_count
FROM chargebacks c
JOIN merchants m ON c.merchant_id=m.merchant_id
GROUP BY merchant_name
),
transactions_count AS (
SELECT 
UPPER(TRIM(m.merchant_name)) AS merchant_name,
COUNT(t.transaction_id) AS total_transactions_count
FROM transactions t
JOIN merchants m ON t.merchant_id=m.merchant_id
GROUP BY merchant_name
)
SELECT
ch.merchant_name,
ch.total_chargebacks_count, 
tr.total_transactions_count,
ROUND((total_chargebacks_count*100.0/total_transactions_count),2) AS chargeback_rate_pct
FROM transactions_count tr
JOIN chargebacks_count ch ON tr.merchant_name=ch.merchant_name
ORDER BY ROUND((total_chargebacks_count*100.0/total_transactions_count),2) DESC;
 