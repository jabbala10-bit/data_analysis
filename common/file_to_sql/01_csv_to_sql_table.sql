-- =====================================================
-- FILE TO SQL: CSV TO TABLE
-- Problem: Load a CSV-style flat file into a SQL table.
-- Solution: Create a staging table and insert rows from a delimited source.
-- Why this fits: CSV is one of the most common formats for data exchange and ingestion.
-- =====================================================

CREATE TABLE IF NOT EXISTS analytics.stg_sales_csv (
    sale_id BIGINT,
    customer_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50)
);

-- Typical pattern for CSV import in many databases:
-- COPY analytics.stg_sales_csv FROM '/path/to/file.csv' WITH (FORMAT csv, HEADER true);
