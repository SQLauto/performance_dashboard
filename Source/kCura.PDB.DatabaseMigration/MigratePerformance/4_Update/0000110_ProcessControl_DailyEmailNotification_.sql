USE EDDSPerformance
GO
 
IF NOT EXISTS (SELECT TOP 1 ProcessControlID FROM eddsdbo.ProcessControl WHERE ProcessControlID = 11)
BEGIN
	INSERT INTO [EDDSPerformance].[eddsdbo].[ProcessControl] (ProcessControlID, ProcessTypeDesc, LastProcessExecDateTime, Frequency)
	VALUES (11, 'Daily Email Notification', DATEADD(dd, -1, getutcdate()), 1440)
END