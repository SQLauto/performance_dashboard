SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

USE [EDDSPerformance]

BEGIN TRANSACTION

IF OBJECT_ID('eddsdbo.FK_Measure_MeasureType', 'F') is not null
	ALTER TABLE [eddsdbo].[Measure] DROP CONSTRAINT [FK_Measure_MeasureType]

SET IDENTITY_INSERT [eddsdbo].[ServerType] ON
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 1)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (1, N'Web', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 2)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (2, N'Agent', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 3)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (3, N'Database', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 4)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (4, N'Document', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 5)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (5, N'Search', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 11)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (11, N'WebAPI', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 12)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (12, N'Services', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 20)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (20, N'WebBackground', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 21)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (21, N'Processing', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 22)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (22, N'Analytics', NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ServerType] WHERE [ServerTypeID] = 99)
	INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (99, N'Unrecognized', NULL)
SET IDENTITY_INSERT [eddsdbo].[ServerType] OFF

IF NOT EXISTS(SELECT * FROM [eddsdbo].[MeasureType] WHERE [MeasureTypeId] = 1)
	INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (1, N'AppHealth', N'Application Health Diagnostics', 1, 0, NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[MeasureType] WHERE [MeasureTypeId] = 2)
	INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (2, N'ServerHealth', N'Server Health Diagnostics', 1, 0, NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[MeasureType] WHERE [MeasureTypeId] = 3)
	INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (3, N'ServerDiskHealth', N'Server Disk Health Diagnostics', 1, 0, NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[MeasureType] WHERE [MeasureTypeId] = 4)
	INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (4, N'ServerProcessorHealth ', N'Server Processor Health Diagnostics', 1, 0, NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[MeasureType] WHERE [MeasureTypeId] = 5)
	INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (5, N'SQLServerHealth', N'SQL Server Health Diagnostics', 1, 0, NULL)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[MeasureType] WHERE [MeasureTypeId] = 6)
	INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (6, N'BISHealth', N'BIS Health Diagnostics' ,1,0, NULL)

SET IDENTITY_INSERT [eddsdbo].[Measure] ON
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 1)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (1, N'LRQ', N'Long Running Queries', 1, 1, 0, NULL, 60)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 2)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (2, N'Errors', N'Critical Errors', 1, 1, 0, NULL, 60)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 3)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (3, N'Latency', N'Average Latency', 1, 0, 1, NULL, 60)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 4)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (4, N'Users', N'Active Users', 1, 1, 0, NULL, 5)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 5)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (5, N'RAMPagesPerSec', N'RAM Pages/Sec', 2, 1, 0, NULL, 5)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 6)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (6, N'RAMPageFaultsPerSec', N'RAM Page Faults/Sec', 2, 1, 0, NULL, 5)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 7)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (7, N'DiskAvgSecPerRead', N'Disk Avg Sec/Read', 3, 1, 0, NULL, 5)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 8)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (8, N'DiskAvgSecPerWrite', N'Disk Avg Sec/Write', 3, 1, 0, NULL, 5)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 10)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (10, N'CPUProcessorTimePct', N'CPU Processor Time (%)', 4, 1, 0, NULL, 5)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Measure] WHERE [MeasureID] = 11)
	INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (11, N'SQLPageLifeExpectancy', N'Page Life Expectancy', 5, 1, 0, NULL, 5)
SET IDENTITY_INSERT [eddsdbo].[Measure] OFF

IF NOT EXISTS(SELECT * FROM [eddsdbo].[ProcessControl] WHERE [ProcessControlID] = 1)
	INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (1, N'Application Metrics DW Load', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 60)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ProcessControl] WHERE [ProcessControlID] = 2)
	INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (2, N'Server Health Summary', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 60)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ProcessControl] WHERE [ProcessControlID] = 3)
	INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (3, N'Server Info Refresh', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 1440)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ProcessControl] WHERE [ProcessControlID] = 4)
	INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (4, N'BISSummary Refresh', DATEADD(d, -91, DATEADD(hour, DATEDIFF(hh, 0, GETUTCDATE()), 0)), 1440)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ProcessControl] WHERE [ProcessControlID] = 5)
	INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (5, N'Install Server Scripts', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 60)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ProcessControl] WHERE [ProcessControlID] = 6)
	INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (6, N'Install Workspace Scripts', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 60)
IF NOT EXISTS(SELECT * FROM [eddsdbo].[ProcessControl] WHERE [ProcessControlID] = 7)
	INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (7, N'Run Looking Glass', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 60)

IF OBJECT_ID('eddsdbo.FK_Measure_MeasureType', 'F') is null
	ALTER TABLE [eddsdbo].[Measure] ADD CONSTRAINT [FK_Measure_MeasureType] FOREIGN KEY ([MeasureTypeId]) REFERENCES [eddsdbo].[MeasureType] ([MeasureTypeId])

	-- Is this really defensible?
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Version] WHERE [ApplicationVersion] = '7.5.0.1')
	INSERT INTO [eddsdbo].[Version] ([ApplicationVersion]) VALUES ('7.5.0.1')
	-- END Is this really defensible?

IF NOT EXISTS(SELECT * FROM [eddsdbo].[Configuration] WHERE [Name] = N'ShowVersion')
	INSERT INTO [eddsdbo].[Configuration] ([Section],[Name],[Value],[MachineName],[Description]) VALUES (N'kCura.PDB',N'ShowVersion',N'true',N'',N'')
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Configuration] WHERE [Name] = N'ShowCustomErrorPage')
	INSERT INTO [eddsdbo].[Configuration] ([Section],[Name],[Value],[MachineName],[Description]) VALUES (N'kCura.PDB',N'ShowCustomErrorPage',N'false',N'',N'')
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Configuration] WHERE [Name] = N'AssemblyName')
	INSERT INTO [eddsdbo].[Configuration] ([Section],[Name],[Value],[MachineName],[Description]) VALUES (N'kCura.PDB',N'AssemblyName',N'kCura.PDD.Service.Task',N'',N'')
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Configuration] WHERE [Name] = N'HealthTask')	
	INSERT INTO [eddsdbo].[Configuration] ([Section],[Name],[Value],[MachineName],[Description]) VALUES (N'kCura.PDB',N'HealthTask',N'kCura.PDD.Service.Task.Impl.HealthTask',N'',N'')
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Configuration] WHERE [Name] = N'PerformanceTaskFactory')	
	INSERT INTO [eddsdbo].[Configuration] ([Section],[Name],[Value],[MachineName],[Description]) VALUES (N'kCura.PDB',N'PerformanceTaskFactory',N'kCura.PDD.WindowsService.Task.Implementation.PerformanceTaskFactory',N'',N'')
IF NOT EXISTS(SELECT * FROM [eddsdbo].[Configuration] WHERE [Name] = N'DiagnosticAnalysisTask')	
	INSERT INTO [eddsdbo].[Configuration] ([Section],[Name],[Value],[MachineName],[Description]) VALUES (N'kCura.PDB',N'DiagnosticAnalysisTask',N'kCura.DFG.Task.Implementation.DiagnosticAnalysisTask',N'',N'')

COMMIT TRANSACTION
