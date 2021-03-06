USE EDDSResource
GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_BackSummary' AND TABLE_SCHEMA = 'dbo')
BEGIN
	IF COL_LENGTH('dbo.kIE_BackSummary', 'CaseArtifactID') IS NULL
	BEGIN
		ALTER TABLE dbo.kIE_BackSummary ADD CaseArtifactID INT NULL
	END
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_BackResults' AND TABLE_SCHEMA = 'dbo')
BEGIN
	IF COL_LENGTH('dbo.kIE_BackResults', 'CaseArtifactID') IS NULL
	BEGIN
		ALTER TABLE dbo.kIE_BackResults ADD CaseArtifactID INT NULL
	END
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_DBCCSummary' AND TABLE_SCHEMA = 'dbo')
BEGIN
	IF COL_LENGTH('dbo.kIE_DBCCSummary', 'CaseArtifactID') IS NULL
	BEGIN
		ALTER TABLE dbo.kIE_DBCCSummary ADD CaseArtifactID INT NULL
	END
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_DBCCResults' AND TABLE_SCHEMA = 'dbo')
BEGIN
	IF COL_LENGTH('dbo.kIE_DBCCResults', 'CaseArtifactID') IS NULL
	BEGIN
		ALTER TABLE dbo.kIE_DBCCResults ADD CaseArtifactID INT NULL
	END
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_BackSummary' AND TABLE_SCHEMA = 'dbo')
BEGIN
	UPDATE dbo.kIE_BackSummary
	SET CaseArtifactID =
		CASE WHEN ISNUMERIC(REPLACE(DBName, 'EDDS', '')) = 1 THEN CAST(REPLACE(DBName, 'EDDS', '') AS int)
			WHEN DBName = 'EDDS' THEN -1
			ELSE NULL
		END
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_BackResults' AND TABLE_SCHEMA = 'dbo')
BEGIN
	UPDATE dbo.kIE_BackResults
	SET CaseArtifactID =
		CASE WHEN ISNUMERIC(REPLACE(DBName, 'EDDS', '')) = 1 THEN CAST(REPLACE(DBName, 'EDDS', '') AS int)
			WHEN DBName = 'EDDS' THEN -1
			ELSE NULL
		END
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_DBCCSummary' AND TABLE_SCHEMA = 'dbo')
BEGIN
	UPDATE dbo.kIE_DBCCSummary
	SET CaseArtifactID =
		CASE WHEN ISNUMERIC(REPLACE(DBName, 'EDDS', '')) = 1 THEN CAST(REPLACE(DBName, 'EDDS', '') AS int)
			WHEN DBName = 'EDDS' THEN -1
			ELSE NULL
		END
END

GO

IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'kIE_DBCCResults' AND TABLE_SCHEMA = 'dbo')
BEGIN
	UPDATE dbo.kIE_DBCCResults
	SET CaseArtifactID =
		CASE WHEN ISNUMERIC(REPLACE(DBName, 'EDDS', '')) = 1 THEN CAST(REPLACE(DBName, 'EDDS', '') AS int)
			WHEN DBName = 'EDDS' THEN -1
			ELSE NULL
		END
END