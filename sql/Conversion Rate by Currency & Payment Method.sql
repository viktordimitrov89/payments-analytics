-- ============================================================
-- CONVERSION RATE BY CURRENCY & PAYMENT METHOD
-- SumUp Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Analyzes transaction conversion rates segmented
--              by currency and payment method to identify
--              performance patterns and optimization opportunities
-- ============================================================

WITH total_transactions AS (
SELECT 
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(t.currency)) AS currency,
UPPER(TRIM(pm.method_name)) AS payment_method,
COUNT(t.transaction_id) AS total_txns
FROM transactions t
JOIN merchants m ON CAST(t.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
JOIN payment_methods pm ON UPPER(TRIM(t.payment_method))=UPPER(TRIM(pm.method_name))
GROUP BY merchant_name, currency, payment_method
),
completed_transactions AS (
SELECT 
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(t.currency)) AS currency,
UPPER(TRIM(pm.method_name)) AS payment_method,
COUNT(t.transaction_id) AS completed_txns
FROM transactions t
JOIN merchants m ON CAST(t.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
JOIN payment_methods pm ON UPPER(TRIM(t.payment_method))=UPPER(TRIM(pm.method_name))
WHERE UPPER(TRIM(t.status)) LIKE 'COMPLET%'
GROUP BY merchant_name, currency, payment_method
)
SELECT 
tt.merchant_name,
tt.currency,
tt.payment_method,
ROUND(((ct.completed_txns*100.0)/tt.total_txns),1) AS conversion_rate_pcnt
FROM total_transactions tt
JOIN completed_transactions ct ON tt.merchant_name=ct.merchant_name
AND tt.currency=ct.currency
AND tt.payment_method=ct.payment_method
ORDER BY conversion_rate_pcnt DESC;