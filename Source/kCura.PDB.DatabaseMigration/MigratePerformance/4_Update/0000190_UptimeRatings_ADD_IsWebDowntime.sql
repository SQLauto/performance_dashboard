USE EDDSPerformance
GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'eddsdbo' AND TABLE_NAME = 'QoS_UptimeRatings') 
AND NOT EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'QoS_UptimeRatings' AND COLUMN_NAME = 'IsWebDowntime')
BEGIN
	ALTER TABLE eddsdbo.QoS_UptimeRatings
	ADD IsWebDowntime BIT NULL
END