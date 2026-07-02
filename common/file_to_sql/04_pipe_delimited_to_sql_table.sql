-- =====================================================
-- FILE TO SQL: PIPE-DELIMITED TO TABLE
-- Problem: Load pipe-separated files into a SQL table.
-- Solution: Use a staging table and a delimiter-aware import pattern.
-- Why this fits: Pipe-delimited files are common in enterprise batch systems and data exports.
-- =====================================================

CREATE TABLE IF NOT EXISTS analytics.stg_sales_pipe (
    sale_id BIGINT,
    customer_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50)
);

-- Typical pattern for pipe-delimited import:
-- COPY analytics.stg_sales_pipe FROM '/path/to/file.psv' WITH (FORMAT text, DELIMITER '|', HEADER true);
