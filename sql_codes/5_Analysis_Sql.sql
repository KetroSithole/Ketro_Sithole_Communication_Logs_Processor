-- Report query written by Ketro Sithole on 17 June 2025 at 10:00 AM

-- Total number of valid rows processed
SELECT COUNT(*) AS Total_Valid_Rows
FROM [Sigma_Connected].[dbo].[formatted_logs_for_sql];

-- Total number of rows dropped and reason (Assumed handled during ETL – log manually as 0 or trace from logs)
-- Optionally simulate this if you still store raw logs:
-- SELECT COUNT(*) AS Dropped_Rows_Estimate FROM [dbo].[raw_logs] 
-- WHERE customerid IS NULL OR TRY_CAST(timestamp AS DATETIME) IS NULL;

-- Counts per channel
SELECT 
    channel, 
    COUNT(*) AS Message_Count 
FROM [Sigma_Connected].[dbo].[formatted_logs_for_sql]
GROUP BY channel
ORDER BY Message_Count DESC;

-- Average duration per channel
SELECT 
    channel, 
    CAST(AVG(CAST(duration AS FLOAT)) AS DECIMAL(10,0)) AS Avg_Duration_Seconds
FROM [Sigma_Connected].[dbo].[formatted_logs_for_sql]
GROUP BY channel
ORDER BY Avg_Duration_Seconds;

-- Outbound success rate per channel
-- Outbound direction only, where success = status in ('delivered', 'sent', 'answered')
WITH Outbound AS (
    SELECT 
        channel,
        status,
        CASE 
            WHEN status IN ('delivered', 'sent', 'answered') THEN 1 
            ELSE 0 
        END AS is_success
    FROM [Sigma_Connected].[dbo].[formatted_logs_for_sql]
    WHERE direction = 'outbound'
)
SELECT 
    channel,
    COUNT(*) AS Total_Outbound_Attempts,
    SUM(is_success) AS Successful_Attempts,
    CAST(100.0 * SUM(is_success) / COUNT(*) AS DECIMAL(5,2)) AS Success_Rate_Percent
FROM Outbound
GROUP BY channel
ORDER BY Success_Rate_Percent DESC;
