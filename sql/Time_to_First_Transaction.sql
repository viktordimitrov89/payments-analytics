SELECT
UPPER(TRIM(m.merchant_name)) AS merchant_name,
ROUND(julianday(MIN(t.transaction_date))-julianday(m.onboarding_date),1) AS time_to_first_transaction,
UPPER(TRIM(t.payment_method)) AS first_payment_method
FROM transactions t
JOIN merchants m ON CAST(t.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
GROUP by merchant_name
ORDER BY time_to_first_transaction DESC;