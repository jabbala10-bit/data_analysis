-- =====================================================
-- FILE TO SQL: SEMICOLON-DELIMITED TO TABLE
-- Problem: Load semicolon-separated files into SQL.
-- Solution: Use a staging table and specify the semicolon delimiter.
-- Why this fits: Semicolon-delimited formats appear frequently in European data exports and spreadsheets.
-- =====================================================

CREATE TABLE IF NOT EXISTS analytics.stg_sales_semicolon (
    sale_id BIGINT,
    customer_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50)
);

-- Typical pattern for semicolon-delimited import:
-- COPY analytics.stg_sales_semicolon FROM '/path/to/file.csv' WITH (FORMAT text, DELIMITER ';', HEADER true);
