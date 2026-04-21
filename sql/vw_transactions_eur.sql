-- ============================================================
-- VIEW: VW_TRANSACTIONS_EUR
-- SumUp Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Converts all transaction amounts to EUR using
--              monthly exchange rates for standardized analysis
-- ============================================================

CREATE VIEW vw_transactions_EUR AS
SELECT
t.transaction_id,
t.merchant_id,
t.customer_id,
strftime('%Y-%m', t.transaction_date) AS year_month,
t.transaction_date,
UPPER(TRIM(t.currency)) AS original_currency,
UPPER(TRIM(t.payment_method)) AS payment_method,
UPPER(TRIM(t.status)) AS status,
ROUND(CAST(t.amount AS REAL) * CAST(er.rate_to_eur AS REAL), 2) AS amount_EUR,
ROUND(CAST(t.fee AS REAL) * CAST(er.rate_to_eur AS REAL), 2) AS fee_EUR,
ROUND(CAST(t.net_amount AS REAL) * CAST(er.rate_to_eur AS REAL), 2) AS net_amount_EUR
FROM transactions t
JOIN exchange_rates er ON UPPER(TRIM(t.currency)) = UPPER(TRIM(er.currency))
AND strftime('%Y-%m', t.transaction_date) = er.month;