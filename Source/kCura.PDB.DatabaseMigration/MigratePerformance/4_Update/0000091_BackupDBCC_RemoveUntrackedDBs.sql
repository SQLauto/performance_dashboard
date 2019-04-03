USE EDDSResource
GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_BackSummary' AND TABLE_SCHEMA = 'dbo')
BEGIN
	DELETE FROM dbo.kIE_BackSummary
	WHERE CaseArtifactID IS NULL
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_BackResults' AND TABLE_SCHEMA = 'dbo')
BEGIN
	DELETE FROM dbo.kIE_BackResults
	WHERE CaseArtifactID IS NULL
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_DBCCSummary' AND TABLE_SCHEMA = 'dbo')
BEGIN
	DELETE FROM dbo.kIE_DBCCSummary
	WHERE CaseArtifactID IS NULL
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_DBCCResults' AND TABLE_SCHEMA = 'dbo')
BEGIN
	DELETE FROM dbo.kIE_DBCCResults
	WHERE CaseArtifactID IS NULL
END