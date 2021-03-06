/* If you're looking at this script, you might really just want to do a backfill. See QoS_Backfill in EDDSPerformance. */

USE [EDDSPerformance]

DECLARE @start datetime, @end datetime, @stop datetime;
SET @start = '1/1/2014 00:00:00.000';
SET @end = DATEADD(hh, 1, @start);
SET @stop = '1/2/2014 00:00:00.000'; --GETUTCDATE();

WHILE (@start < @stop)
BEGIN
EXEC [eddsdbo].[QoS_LookingGlass]
		@beginDate = @start,
		@endDate = @end
		
SET @start = @end;
SET @end = DATEADD(hh, 1, @start);
END