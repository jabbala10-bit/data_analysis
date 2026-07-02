-- =====================================================
-- COMMON SQL: DCL - PERMISSIONS AND SECURITY
-- Purpose: Grant and manage access for analysts and reporting roles
-- =====================================================

GRANT SELECT ON analytics.fact_sales TO analytics_reader;
GRANT SELECT ON analytics.dim_customer TO analytics_reader;

REVOKE INSERT ON analytics.fact_sales FROM analytics_reader;

ALTER TABLE analytics.fact_sales OWNER TO analytics_owner;
