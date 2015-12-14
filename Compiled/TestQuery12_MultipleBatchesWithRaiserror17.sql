SELECT 1 AS [Batch 1];
SELECT 2 AS [Batch 1];

GO
SELECT 3 AS [Batch 2], CONVERT(VARCHAR(30), GETDATE(),121) AS [TheTime];
GO 3


SELECT 4 AS [Batch 3];

SELECT 'AA' AS [Ok];
PRINT 'BB';

RAISERROR(N'Sev 17', 17, 1);

SELECT 'wow' AS [no error];

GO

SELECT 5 AS [Batch 4];
