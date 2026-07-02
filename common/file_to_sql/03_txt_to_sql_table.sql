-- =====================================================
-- FILE TO SQL: TXT TO TABLE
-- Problem: Load fixed-width or delimited text files into SQL.
-- Solution: Create a staging table and insert rows with explicit parsing rules.
-- Why this fits: TXT files are common in legacy systems and operational exports.
-- =====================================================

CREATE TABLE IF NOT EXISTS analytics.stg_sales_txt (
    sale_id BIGINT,
    customer_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50)
);

-- Typical pattern for delimited TXT import:
-- COPY analytics.stg_sales_txt FROM '/path/to/file.txt' WITH (FORMAT text, DELIMITER '|', HEADER true);
