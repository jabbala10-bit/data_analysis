-- =====================================================
-- COMMON SQL: DDL - SCHEMA AND TABLE SETUP
-- Purpose: Create reusable structures for analytics workflows
-- =====================================================

CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS analytics.fact_sales (
    sale_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    product_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50),
    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS analytics.dim_customer (
    customer_id BIGINT PRIMARY KEY,
    customer_name VARCHAR(200),
    segment VARCHAR(50),
    signup_date DATE,
    region VARCHAR(100)
);

CREATE INDEX IF NOT EXISTS idx_fact_sales_date ON analytics.fact_sales(sale_date);
CREATE INDEX IF NOT EXISTS idx_fact_sales_customer ON analytics.fact_sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_fact_sales_region ON analytics.fact_sales(region);
