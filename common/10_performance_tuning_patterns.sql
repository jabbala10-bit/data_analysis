-- =====================================================
-- COMMON SQL: PERFORMANCE TUNING PATTERNS
-- Purpose: Useful patterns for faster, more scalable analytics queries
-- =====================================================

SELECT
    region,
    COUNT(*) AS order_count,
    SUM(amount) AS revenue
FROM analytics.fact_sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '90 days'
  AND status = 'Completed'
GROUP BY region
ORDER BY revenue DESC;

-- Recommended practice:
-- 1. Filter early in WHERE
-- 2. Avoid functions on indexed columns in predicates
-- 3. Aggregate before joining large tables when possible
