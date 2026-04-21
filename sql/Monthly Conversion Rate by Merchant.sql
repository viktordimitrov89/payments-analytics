-- ============================================================
-- MONTHLY CONVERSION RATE BY MERCHANT
-- SumUp Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Tracks monthly transaction conversion rates per
--              merchant to monitor performance trends, identify
--              underperforming merchants and support data-driven
--              decisions for merchant success initiatives
-- ============================================================

WITH total_transactions AS (
SELECT 
TRIM(UPPER(m.merchant_name)) AS merchant_name,
COUNT(t.transaction_id) AS total_txns
FROM transactions t
JOIN merchants m ON t.merchant_id=m.merchant_id
GROUP BY m.merchant_name
),

completed_transactions AS (
SELECT
TRIM(UPPER(m.merchant_name)) AS merchant_name,
COUNT(t.transaction_id) AS completed_txns
FROM transactions t
JOIN merchants m ON t.merchant_id=m.merchant_id
WHERE UPPER(TRIM(t.status)) LIKE "COMPLET%"
GROUP BY m.merchant_name
)


SELECT
TRIM(UPPER(tt.merchant_name)) AS merchant_name,
ROUND((ct.completed_txns*100.0 / tt.total_txns),2) AS conversion_rate_pcnt
FROM total_transactions tt
JOIN completed_transactions ct ON tt.merchant_name = ct.merchant_name
ORDER BY conversion_rate_pcnt ;

