USE [EDDSPerformance];
GO

IF NOT EXISTS (SELECT TOP 1 * FROM [EDDSPerformance].[eddsdbo].[Configuration] WHERE Section = 'kCura.PDB' AND Name = 'PerformDBCCandBACKchecks')
  INSERT INTO [EDDSPerformance].[eddsdbo].[Configuration] ([Section],[Name],[Value],[MachineName],[Description]) 
  VALUES (N'kCura.PDB',N'PerformDBCCandBACKchecks',N'9',N'',N'This is the minimum value, in days, that PerformanceDashboard will use when checking for a good backup or DBCC check.  The default value is 9. A setting of -1 will cause this check to be skipped.')