USE EDDSPerformance
GO

IF NOT EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TrustSendLog' AND COLUMN_NAME = 'Details')
BEGIN
	ALTER TABLE eddsdbo.TrustSendLog
	ADD Details varchar(max) NULL
END