-- Case Study 1: Revenue recovery pipeline
-- Step 1: Clean data
CREATE OR REPLACE PROCEDURE clean_revenue_data IS
BEGIN
    UPDATE sales_orders
    SET order_amount = NVL(order_amount, 0)
    WHERE order_amount IS NULL;
END;
/

-- Step 2: Generate report
SELECT
    region,
    SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY region
ORDER BY revenue DESC;
