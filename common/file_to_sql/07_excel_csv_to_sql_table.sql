-- =====================================================
-- FILE TO SQL: EXCEL-EXPORTED CSV TO TABLE
-- Problem: Load data exported from Excel into a SQL table.
-- Solution: Use staging table and standard CSV import behavior.
-- Why this fits: Excel exports are frequently used by analysts and business users.
-- =====================================================

CREATE TABLE IF NOT EXISTS analytics.stg_sales_excel (
    sale_id BIGINT,
    customer_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50)
);

-- Typical pattern:
-- COPY analytics.stg_sales_excel FROM '/path/to/excel_export.csv' WITH (FORMAT csv, HEADER true);
