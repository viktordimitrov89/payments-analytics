-- ============================================================
-- VIEW: VW_MERCHANT_KPIS
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Consolidated merchant KPI view combining revenue
--              in EUR, conversion rate, chargeback rate, last
--              activity, payment preferences, subscription plan
--              changes and risk profile for each merchant
-- ============================================================

CREATE VIEW vw_merchant_KPIs AS

WITH merchant_revenue_EUR AS(

SELECT
CAST (m.merchant_id AS TEXT) AS merchant_id,
UPPER(TRIM(m.merchant_name)) as merchant_name,
SUM(ROUND (vw_EUR.amount_EUR - vw_EUR.fee_EUR,2)) AS revenue_EUR
FROM vw_transactions_EUR vw_EUR
JOIN merchants m ON vw_EUR.merchant_id=CAST(m.merchant_id AS TEXT)
GROUP BY merchant_name
),

total_transactions AS (
SELECT 
CAST (m.merchant_id AS TEXT) AS merchant_id,
TRIM(UPPER(m.merchant_name)) AS merchant_name,
COUNT(vw_EUR.transaction_id) AS total_txns
FROM vw_transactions_EUR vw_EUR
JOIN merchants m ON vw_EUR.merchant_id=CAST(m.merchant_id AS TEXT)
GROUP BY m.merchant_name
),

completed_transactions AS (
SELECT
CAST (m.merchant_id AS TEXT) AS merchant_id,
TRIM(UPPER(m.merchant_name)) AS merchant_name,
COUNT(vw_EUR.transaction_id) AS completed_txns
FROM vw_transactions_EUR vw_EUR
JOIN merchants m ON vw_EUR.merchant_id=CAST(m.merchant_id AS TEXT)
WHERE UPPER(TRIM(vw_EUR.status)) LIKE 'COMPLET%'
GROUP BY m.merchant_name
),

conversion_rate_pct AS (

SELECT
tt.merchant_id,
TRIM(UPPER(tt.merchant_name)) AS merchant_name,
ROUND((ct.completed_txns*100.0 / tt.total_txns),2) AS conversion_rate_pcnt
FROM total_transactions tt
JOIN completed_transactions ct ON tt.merchant_name = ct.merchant_name
),

chargebacks_count AS (
SELECT
CAST (m.merchant_id AS TEXT) AS merchant_id,
UPPER(TRIM(m.merchant_name)) AS merchant_name,
COUNT(c.chargeback_id) AS total_chargebacks_count
FROM chargebacks c
JOIN merchants m ON c.merchant_id=m.merchant_id
GROUP BY merchant_name
),
transactions_count AS (
SELECT 
CAST (m.merchant_id AS TEXT) AS merchant_id,
UPPER(TRIM(m.merchant_name)) AS merchant_name,
COUNT(vw_EUR.transaction_id) AS total_transactions_count
FROM vw_transactions_EUR vw_EUR
JOIN merchants m ON vw_EUR.merchant_id=CAST(m.merchant_id AS TEXT)
GROUP BY merchant_name
),

chargeback_rate_pct AS (

SELECT
ch.merchant_id,
ch.merchant_name,
ch.total_chargebacks_count, 
tr.total_transactions_count,
ROUND((total_chargebacks_count*100.0/total_transactions_count),2) AS chargeback_rate_pct
FROM transactions_count tr
JOIN chargebacks_count ch ON tr.merchant_name=ch.merchant_name
)

SELECT
mru.merchant_name,
mru.revenue_EUR,
crp.conversion_rate_pcnt,
strftime('%Y-%m', MAX(vw_EUR.transaction_date)) AS last_transaction,
chrp.chargeback_rate_pct,
UPPER(TRIM(pm.method_name)) AS payment_type,
UPPER(TRIM(sc.previous_plan)) AS previous_plan,
UPPER(TRIM(sc.new_plan)) AS new_plan,
UPPER(TRIM(sc.change_type)) AS change_type,
UPPER(TRIM(mrs.risk_category)) AS risk_category,
CAST(mrs.risk_score AS REAL) AS risk_score
FROM vw_transactions_EUR vw_EUR
JOIN merchant_revenue_EUR mru ON vw_EUR.merchant_id=mru.merchant_id
JOIN conversion_rate_pct crp ON vw_EUR.merchant_id=crp.merchant_id
JOIN chargeback_rate_pct chrp ON vw_EUR.merchant_id=chrp.merchant_id
JOIN payment_methods pm ON vw_EUR.payment_method=pm.method_name
JOIN subscription_changes sc ON vw_EUR.merchant_id=sc.merchant_id
JOIN merchant_risk_scores mrs ON vw_EUR.merchant_id=mrs.merchant_id
GROUP BY mru.merchant_name, mru.revenue_EUR, crp.conversion_rate_pcnt, last_transaction, chrp.chargeback_rate_pct,
payment_type, previous_plan, new_plan, change_type, risk_category, risk_score

