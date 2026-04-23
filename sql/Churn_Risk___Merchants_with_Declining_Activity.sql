-- ============================================================
-- CHURN RISK - MERCHANTS WITH DECLINING ACTIVITY
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Identifies merchants showing declining transaction
--              activity comparing Q1 2026 vs Q4 2025 to proactively
--              detect churn risk and support retention efforts
-- ============================================================

WITH Q1_2026 AS (
SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
COUNT(t.transaction_id) AS Q1_2026_transactions
FROM transactions t
JOIN merchants m ON t.merchant_id=m.merchant_id
WHERE strftime('%Y-%m', t.transaction_date) BETWEEN '2026-01' and '2026-03'
GROUP BY merchant_name
),
Q4_2025 AS (
SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
COUNT(t.transaction_id) AS Q4_2025_transactions
FROM transactions t
JOIN merchants m ON t.merchant_id=m.merchant_id
WHERE strftime('%Y-%m', t.transaction_date) BETWEEN '2025-10' and '2025-12'
GROUP BY merchant_name
)

SELECT
Q1_2026.merchant_name,
ROUND((Q1_2026.Q1_2026_transactions-Q4_2025.Q4_2025_transactions),1) AS declining_activity,
ROUND(((Q1_2026.Q1_2026_transactions-Q4_2025.Q4_2025_transactions)*100.0/Q4_2025.Q4_2025_transactions),1) AS declining_activity_pct
FROM Q1_2026 Q1_2026 
JOIN Q4_2025 Q4_2025 on Q1_2026.merchant_name=Q4_2025.merchant_name
WHERE declining_activity <0
ORDER BY declining_activity;
