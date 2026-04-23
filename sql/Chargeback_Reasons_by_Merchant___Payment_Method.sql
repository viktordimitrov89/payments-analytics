-- ============================================================
-- CHARGEBACK REASONS BY MERCHANT & PAYMENT METHOD
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Analysis of chargeback reasons broken down by
--              merchant and payment method to identify risk
--              patterns and operational issues
-- ============================================================

SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(pm.method_name)) AS method_name,
UPPER(TRIM(pm.method_type)) AS method_type,
UPPER(TRIM(ch.reason)) AS reason,
COUNT(ch.chargeback_id) AS total_chargebacks,
ROUND(AVG(julianday(ch.resolved_date)-julianday(ch.created_date)),1) AS avg_resolution_time
FROM chargebacks ch 
JOIN transactions t ON ch.transaction_id=t.transaction_id
JOIN payment_methods pm ON UPPER(TRIM((t.payment_method )))=UPPER(TRIM((pm.method_name)))
JOIN merchants m ON CAST(t.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
GROUP by merchant_name, method_name, method_type, reason
ORDER BY total_chargebacks DESC;
