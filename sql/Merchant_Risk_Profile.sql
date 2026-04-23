-- ============================================================
-- MERCHANT RISK PROFILE
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Validates merchant risk scores against actual
--              chargeback data to identify underestimated risk,
--              correlating risk categories with real transaction
--              and chargeback patterns
-- ============================================================

WITH chargebacks_rate AS (
SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
COUNT(c.chargeback_id) as total_chargebacks,
COUNT(t.transaction_id) as total_transactions
FROM transactions t
LEFT JOIN chargebacks c ON CAST(t.transaction_id AS TEXT)=CAST(c.transaction_id AS TEXT)
JOIN merchants m ON CAST(t.merchant_id AS TEXT) = CAST(m.merchant_id AS TEXT)
GROUP BY merchant_name
)
SELECT 
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(mrs.risk_category)) AS risk_category,
CAST(mrs.risk_score AS REAL) AS risk_score,
cr.total_chargebacks AS chargeback_count,
ROUND((cr.total_chargebacks*100.0/cr.total_transactions),1) as chargeback_rate
FROM merchant_risk_scores mrs
JOIN merchants m ON CAST(mrs.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
JOIN chargebacks_rate cr ON UPPER(TRIM(m.merchant_name)) = cr.merchant_name
GROUP BY  m.merchant_name, mrs.risk_category, mrs.risk_score;