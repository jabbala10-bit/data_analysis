-- =====================================================
-- FILE TO SQL: JSONL TO TABLE
-- Problem: Load line-delimited JSON files into a SQL table.
-- Solution: Create a staging table and parse JSON content into relational columns.
-- Why this fits: JSONL is common for event streams and lightweight data exchanges.
-- =====================================================

CREATE TABLE IF NOT EXISTS analytics.stg_sales_jsonl (
    sale_id BIGINT,
    customer_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50)
);

-- Typical pattern depends on the database's JSON functions.
-- Example idea: parse each JSON object into columns and insert into the staging table.
