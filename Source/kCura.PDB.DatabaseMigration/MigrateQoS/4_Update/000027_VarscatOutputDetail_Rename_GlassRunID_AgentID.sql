USE EDDSQoS
GO

IF EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'QoS_VarscatOutputDetail' AND COLUMN_NAME = 'GlassRunID')
BEGIN
	EXEC sp_rename 'eddsdbo.QoS_VarscatOutputDetail.GlassRunID', 'AgentID', 'COLUMN'
END