USE EDDSQoS;
GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'eddsdbo' AND TABLE_NAME = 'kIE_RunningQueries') DROP TABLE EDDSDBO.kIE_RunningQueries
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'eddsdbo' AND TABLE_NAME = 'EulerSource') DROP TABLE eddsdbo.EulerSource
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'eddsdbo' AND TABLE_NAME = 'QoS_ConcurrencyItemsSeconds') DROP TABLE eddsdbo.QoS_ConcurrencyItemsSeconds