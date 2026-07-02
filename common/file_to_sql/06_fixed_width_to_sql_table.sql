-- =====================================================
-- FILE TO SQL: FIXED-WIDTH TEXT TO TABLE
-- Problem: Load fixed-width text files where fields have defined lengths.
-- Solution: Create a staging table and load the file with fixed-width parsing rules.
-- Why this fits: Fixed-width files are still common in legacy reporting and mainframe exports.
-- =====================================================

CREATE TABLE IF NOT EXISTS analytics.stg_sales_fixed (
    sale_id BIGINT,
    customer_id BIGINT,
    region VARCHAR(100),
    sale_date DATE,
    amount NUMERIC(12,2),
    channel VARCHAR(50)
);

-- Typical pattern for fixed-width import depends on the database platform and parser support.
