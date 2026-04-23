-- ============================================================
-- MOST COMMON CHARGEBACK REASONS
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Identifies the most frequent chargeback reasons
--              along with total count and average resolution time
--              to support risk management and operational
--              improvements in the dispute handling process
-- ============================================================

SELECT
strftime('%Y-%m',ch.created_date) AS issued_date,
UPPER(TRIM(ch.reason)) AS reason,
COUNT(ch.chargeback_id) AS total_chargebacks,
ROUND(AVG(julianday(ch.resolved_date)-julianday(ch.created_date)),1) AS avg_resolution_time
FROM chargebacks ch
GROUP by issued_date, reason
ORDER BY total_chargebacks DESC;
