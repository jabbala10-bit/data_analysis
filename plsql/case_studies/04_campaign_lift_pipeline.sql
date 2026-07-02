-- Case Study 4: Marketing campaign lift pipeline
-- Step 1: Validate campaign exposure data
UPDATE campaign_activity
SET channel = COALESCE(channel, 'Unknown')
WHERE channel IS NULL;

-- Step 2: Report campaign results
SELECT channel, SUM(CASE WHEN converted_flag = 1 THEN 1 ELSE 0 END) AS conversions
FROM campaign_activity
GROUP BY channel
ORDER BY conversions DESC;
