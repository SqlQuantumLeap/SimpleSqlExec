SELECT 1 AS [Batch 1];
SELECT 2 AS [Batch 1];

GO
SELECT 3 AS [Batch 2], CONVERT(VARCHAR(30), GETDATE(),121) AS [TheTime];
GO 3


SELECT 4 AS [Batch 3];

SELECT 'AA' AS [Ok];
PRINT 'BB';

THROW 50505, N'thrown -- won''t work in pre SQL Server 2012', 12;

SELECT 'wow' AS [no error];

GO

SELECT 5 AS [Batch 4];
