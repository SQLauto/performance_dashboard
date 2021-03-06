--This script will give you 90 days of system load data. Some things in here are hard-coded for K12-R82-1 currently,
-- but we could improve it to automatically insert data for the appropriate number of servers given time.

DECLARE @endHour datetime = DATEADD(hh, DATEDIFF(hh, 0, getutcdate()), 0);
DECLARE @hour datetime = DATEADD(dd, -90, @endHour);
DECLARE @totalMemory int = 7339572;
DECLARE @maxRamPages int = 100;
DECLARE @maxPageFaults int = 10000;
DECLARE @maxCpuPct int = 100;
 
WHILE (@hour < @endHour)
BEGIN
	IF NOT EXISTS (SELECT TOP 1 * FROM EDDSPerformance.eddsdbo.ServerSummary WHERE MeasureDate = @hour)
	BEGIN
		INSERT INTO [EDDSPerformance].[eddsdbo].[ServerSummary]
		(CreatedOn, MeasureDate, ServerID, RAMPagesPerSec, RAMPageFaultsPerSec, TotalPhysicalMemory, AvailableMemory)
		SELECT GETUTCDATE(), @hour, ServerID, RAND() * 100, RAND() * 10000, @totalMemory, RAND() * @totalMemory
		FROM EDDSPerformance.eddsdbo.[Server]
	END

	IF NOT EXISTS (SELECT TOP 1 * FROM EDDSPerformance.eddsdbo.ServerProcessorSummary WHERE MeasureDate = @hour)
	BEGIN
		INSERT INTO EDDSPerformance.eddsdbo.ServerProcessorSummary
		(CreatedOn, MeasureDate, ServerID, CoreNumber, CPUProcessorTimePct)
		SELECT getutcdate(), @hour, ServerID, -1, RAND() * @maxCpuPct
		FROM EDDSPerformance.eddsdbo.[Server]
	END

	SET @hour = DATEADD(hh, 1, @hour);
END

UPDATE EDDSPerformance.eddsdbo.ServerSummary
SET RAMPct = (TotalPhysicalMemory - AvailableMemory)/TotalPhysicalMemory * 100.0
WHERE RAMPct IS NULL