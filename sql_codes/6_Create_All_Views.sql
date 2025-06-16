-- View: Total Valid Rows Processed
CREATE VIEW vw_total_valid_rows AS
SELECT 
    COUNT(*) AS Total_Valid_Rows
FROM [Sigma_Connected].[dbo].[formatted_logs_for_sql];

-- View: Counts per Channel
CREATE VIEW vw_channel_message_counts AS
SELECT 
    channel, 
    COUNT(*) AS Message_Count 
FROM [Sigma_Connected].[dbo].[formatted_logs_for_sql]
GROUP BY channel;

-- View: Average Duration per Channel
CREATE VIEW vw_avg_duration_per_channel AS
SELECT 
    channel, 
    CAST(AVG(CAST(duration AS FLOAT)) AS DECIMAL(10,0)) AS Avg_Duration_Seconds
FROM [Sigma_Connected].[dbo].[formatted_logs_for_sql]
GROUP BY channel;

-- View: Outbound Success Rate per Channel
CREATE VIEW vw_outbound_success_rate AS
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
GROUP BY channel;
