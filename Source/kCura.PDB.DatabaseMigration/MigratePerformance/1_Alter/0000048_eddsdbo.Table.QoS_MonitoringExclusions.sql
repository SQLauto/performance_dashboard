USE EDDSPerformance
GO

IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'QoS_MonitoringExclusions' AND TABLE_SCHEMA = N'EDDSDBO') 
BEGIN
	CREATE TABLE eddsdbo.QoS_MonitoringExclusions
	(
		ExclusionId INT IDENTITY(1,1),
		PRIMARY KEY (ExclusionId),
		DBName NVARCHAR(255) NOT NULL,
		CONSTRAINT UC_MonitoringExclusions_DBName UNIQUE (DBName),
		SkipDBCC BIT NOT NULL,
		SkipBackups BIT NOT NULL
	)
END
GO