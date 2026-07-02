-- =====================================================
-- FILE TO SQL: TSV TO TABLE
-- Problem: Load tab-separated data into a SQL table.
-- Solution: Create a staging table and use a delimiter-aware import pattern.
-- Why this fits: TSV files are common in exports from analytics tools and spreadsheets.
-- =====================================================

CREATE TABLE IF NOT EXISTS analytics.stg_sales_tsv (
    sale_id BIGINT,
    customer_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50)
);

-- Typical pattern for TSV import in many databases:
-- COPY analytics.stg_sales_tsv FROM '/path/to/file.tsv' WITH (FORMAT text, DELIMITER E'\t', HEADER true);
