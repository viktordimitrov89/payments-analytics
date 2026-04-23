-- ============================================================
-- REFUND ANALYSIS
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Examines refund patterns by merchant and reason
--              including average processing time to identify
--              operational inefficiencies, merchant quality
--              issues and opportunities to improve the overall
--              refund handling process
-- ============================================================

SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
UPPER(TRIM(r.reason)) AS reason,
COUNT(refund_id) AS refunt_count,
ROUND(AVG(julianday(r.processed_date)-julianday(r.created_date)),1) AS avg_time_to_refund
FROM refunds r
JOIN merchants m ON CAST(r.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
WHERE UPPER(TRIM(r.status)) LIKE 'PROCESSE%'
GROUP BY merchant_name, reason
ORDER BY avg_time_to_refund DESC;