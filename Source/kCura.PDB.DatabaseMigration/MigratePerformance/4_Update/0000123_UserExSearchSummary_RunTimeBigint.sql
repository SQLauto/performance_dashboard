USE EDDSPerformance
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'QoS_UserExperienceSearchSummary' AND TABLE_SCHEMA = 'eddsdbo')
BEGIN
	ALTER TABLE eddsdbo.QoS_UserExperienceSearchSummary
	ALTER COLUMN TotalRunTime BIGINT
END