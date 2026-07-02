-- =====================================================
-- ADVANCED SCENARIO: ANOMALY DETECTION
-- Purpose: Flag unusual transactions or revenue spikes
-- =====================================================

WITH daily_revenue AS (
    SELECT
        region_id,
        CAST(sales_date AS DATE) AS sales_day,
        SUM(sales_amount) AS revenue
    FROM sales_facts
    WHERE sales_date >= CURRENT_DATE - INTERVAL '180 days'
    GROUP BY region_id, CAST(sales_date AS DATE)
),
rolling_stats AS (
    SELECT
        region_id,
        sales_day,
        revenue,
        AVG(revenue) OVER (
            PARTITION BY region_id
            ORDER BY sales_day
            ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
        ) AS rolling_avg,
        STDDEV_POP(revenue) OVER (
            PARTITION BY region_id
            ORDER BY sales_day
            ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
        ) AS rolling_stddev
    FROM daily_revenue
)
SELECT
    region_id,
    sales_day,
    revenue,
    rolling_avg,
    rolling_stddev,
    CASE
        WHEN rolling_stddev > 0 THEN (revenue - rolling_avg) / rolling_stddev
        ELSE NULL
    END AS z_score
FROM rolling_stats
WHERE rolling_stddev > 0
  AND ABS((revenue - rolling_avg) / rolling_stddev) >= 3
ORDER BY region_id, sales_day;
