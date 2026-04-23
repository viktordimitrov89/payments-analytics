-- ============================================================
-- PAYMENT METHOD DISTRIBUTION BY COUNTRY
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Analyzes the distribution of payment methods
--              across different countries to identify regional
--              preferences, support localization strategies
--              and optimize payment method availability
--              for merchants in each market
-- ============================================================

SELECT 
COUNT(pm.method_name) AS payment_method_count,
UPPER(TRIM(pm.method_name)) AS payment_name,
UPPER(TRIM(pm.method_type)) AS payment_type,
UPPER(TRIM(m.country)) as country
FROM payment_methods pm
JOIN transactions t ON UPPER(TRIM(pm.method_name))=UPPER(TRIM(t.payment_method))
JOIN merchants m ON CAST(t.merchant_id AS TEXT)=CASt(m.merchant_id AS TEXT)
GROUP BY payment_name, payment_type, country
ORDER BY COUNT(pm.method_name) DESC;
