-- ============================================================
-- MOST USED FEATURES IN PRODUCT EVENTS
-- Payments Analytics Project
-- Author: Viktor Dimitrov
-- Description: Analyzes product event logs to identify the most
--              frequently used features by merchants, segmented
--              by platform and location to drive product
--              development priorities and feature optimization
-- ============================================================

SELECT 
UPPER(TRIM(pe.feature_name)) as feature_name,
UPPER(TRIM(m.merchant_name)) as merchant_name,
UPPER(TRIM(pe.platform)) as platform_activity,
UPPER(TRIM(m.country)) AS country,
UPPER(TRIM(m.city)) AS city,
COUNT(pe.event_type) AS feature_used_count
FROM product_events pe
JOIN merchants m ON CAST(pe.merchant_id AS TEXT)=CAST(m.merchant_id AS TEXT)
WHERE UPPER(TRIM(pe.event_type)) LIKE "FEATURE_USE%"
AND pe.feature_name IS NOT NULL
GROUP BY feature_name, merchant_name, country, city, platform_activity
ORDER BY feature_used_count DESC;
