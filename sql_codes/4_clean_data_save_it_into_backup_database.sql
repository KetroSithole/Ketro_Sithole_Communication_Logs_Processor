-- Step 1: Insert current data into backup table
INSERT INTO [dbo].[OLE DB Destination_backup] (
    [CustomerID],
    [Timestamp],
    [Channel],
    [Direction],
    [Status],
    [Duration]
)
SELECT 
    [CustomerID],
    [Timestamp],
    [Channel],
    [Direction],
    [Status],
    [Duration]
FROM [dbo].[OLE DB Destination];

-- Step 2: Truncate the original table
TRUNCATE TABLE [dbo].[OLE DB Destination];
