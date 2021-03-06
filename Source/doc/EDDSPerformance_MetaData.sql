SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

USE [EDDSPerformance]

BEGIN TRANSACTION

ALTER TABLE [eddsdbo].[Measure] DROP CONSTRAINT [FK_Measure_MeasureType]
SET IDENTITY_INSERT [eddsdbo].[ServerType] ON
INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (1, N'Web', NULL)
INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (2, N'Agent', NULL)
INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (3, N'Database', NULL)
INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (4, N'Document', NULL)
INSERT INTO [eddsdbo].[ServerType] ([ServerTypeID], [ServerTypeName], [ArtifactID]) VALUES (5, N'Search', NULL)
SET IDENTITY_INSERT [eddsdbo].[ServerType] OFF
INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (1, N'AppHealth', N'Application Health Diagnostics', 1, 0, NULL)
INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (2, N'ServerHealth', N'Server Health Diagnostics', 1, 0, NULL)
INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (3, N'ServerDiskHealth', N'Server Disk Health Diagnostics', 1, 0, NULL)
INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (4, N'ServerProcessorHealth ', N'Server Processor Health Diagnostics', 1, 0, NULL)
INSERT INTO [eddsdbo].[MeasureType] ([MeasureTypeId], [MeasureTypeCd], [MeasureTypeDesc], [IsActive], [IsDeleted], [UpdatedOn]) VALUES (5, N'SQLServerHealth', N'SQL Server Health Diagnostics', 1, 0, NULL)
SET IDENTITY_INSERT [eddsdbo].[Measure] ON
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (1, N'LRQ', N'Long Running Queries', 1, 1, 0, NULL, 60)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (2, N'Errors', N'Critical Errors', 1, 1, 0, NULL, 60)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (3, N'Latency', N'Average Latency', 1, 1, 0, NULL, 60)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (4, N'Users', N'Active Users', 1, 1, 0, NULL, 5)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (5, N'RAMPagesPerSec', N'RAM Pages/Sec', 2, 1, 0, NULL, 5)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (6, N'RAMPageFaultsPerSec', N'RAM Page Faults/Sec', 2, 1, 0, NULL, 5)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (7, N'DiskAvgSecPerRead', N'Disk Avg Sec/Read', 3, 1, 0, NULL, 5)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (8, N'DiskAvgSecPerWrite', N'Disk Avg Sec/Write', 3, 1, 0, NULL, 5)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (10, N'CPUProcessorTimePct', N'CPU Processor Time (%)', 4, 1, 0, NULL, 5)
INSERT INTO [eddsdbo].[Measure] ([MeasureID], [MeasureCd], [MeasureDesc], [MeasureTypeId], [IsActive], [IsDeleted], [UpdatedOn], [Frequency]) VALUES (11, N'SQLPageLifeExpectancy', N'Page Life Expectancy', 5, 1, 0, NULL, 5)
SET IDENTITY_INSERT [eddsdbo].[Measure] OFF
INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (1, N'Application Metrics DW Load', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 60)
INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (2, N'Server Health Summary', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 60)
INSERT INTO [eddsdbo].[ProcessControl] ([ProcessControlID], [ProcessTypeDesc], [LastProcessExecDateTime], [Frequency]) VALUES (3, N'Server Info Refresh', DATEADD(HOUR, DATEDIFF(HH, 0, GETUTCDATE()), 0), 1440)
ALTER TABLE [eddsdbo].[Measure] ADD CONSTRAINT [FK_Measure_MeasureType] FOREIGN KEY ([MeasureTypeId]) REFERENCES [eddsdbo].[MeasureType] ([MeasureTypeId])

COMMIT TRANSACTION
