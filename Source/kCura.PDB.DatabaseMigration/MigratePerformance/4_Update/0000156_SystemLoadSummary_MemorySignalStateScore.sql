USE EDDSPerformance
GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'eddsdbo' AND TABLE_NAME = 'QoS_SystemLoadSummary') 
AND NOT EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'QoS_SystemLoadSummary' AND COLUMN_NAME = 'MemorySignalStateScore')
BEGIN
	ALTER TABLE eddsdbo.QoS_SystemLoadSummary
	ADD MemorySignalStateScore DECIMAL(5, 2) NULL
END