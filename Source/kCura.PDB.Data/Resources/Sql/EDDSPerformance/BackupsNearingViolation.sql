USE EDDSPerformance

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[eddsdbo].[QoS_BackResults]') AND type in (N'U'))
BEGIN
	SELECT [DBName]
		  ,[DaysSinceLast]
	FROM [eddsdbo].[QoS_BackResults]
	WHERE LoggedDate = (SELECT MAX(LoggedDate) FROM [eddsdbo].[QoS_BackResults])
	AND DaysSinceLast >= 7
END