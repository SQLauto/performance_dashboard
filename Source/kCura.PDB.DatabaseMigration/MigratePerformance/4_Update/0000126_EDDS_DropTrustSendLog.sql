USE EDDS
GO

--Remove vestigial TrustSendLog in EDDS if it's present
IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'eddsdbo' AND TABLE_NAME = 'TrustSendLog') 
BEGIN
	DROP TABLE EDDS.eddsdbo.TrustSendLog
END