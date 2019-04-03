USE EDDSPerformance
GO

IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'QoS_Waits' AND TABLE_SCHEMA = N'EDDSDBO') 
BEGIN
	CREATE TABLE eddsdbo.QoS_Waits
	(
		 WaitTypeID INT IDENTITY (1, 1) PRIMARY KEY (WaitTypeID)
		,WaitType nvarchar(60)
		,IsPoisonWait BIT
	)
END
GO