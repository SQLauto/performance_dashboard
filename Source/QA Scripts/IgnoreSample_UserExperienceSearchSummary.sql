USE [EDDSPerformance]
GO
/****** Object:  StoredProcedure [eddsdbo].[QoS_UserExperienceSearchReport]    Script Date: 02/12/2015 12:09:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER PROCEDURE [eddsdbo].[QoS_UserExperienceSearchReport]
	@SortColumn VARCHAR(50) = 'PercentLongRunning',
	@SortDirection CHAR(4) = 'DESC',
	@TimezoneOffset INT = 0, --Offset to use (in minutes) for UTC dates
	@StartRow INT = 1,
	@EndRow INT = 25,
	@CaseArtifactId INT,
	@Search NVARCHAR(MAX) = NULL,
	@User NVARCHAR(200) = NULL,
	@TotalRunTime BIGINT = NULL,
	@AverageRunTime INT = NULL,
	@TotalRuns INT = NULL,
	@PercentLongRunning INT = NULL,
	@SummaryDayHour DATETIME = NULL,
	@QoSHourID BIGINT = NULL,
	@IsComplex BIT = NULL,
	@IsActiveWeeklySample BIT = NULL
AS
BEGIN
	--Support ArtifactID filtering
	DECLARE @SearchId INT = NULL,
		@UserId INT = NULL;
	IF (ISNUMERIC(@Search) = 1)
		SET @SearchId = CAST(@Search as int);
	IF (ISNUMERIC(@User) = 1)
		SET @UserId = CAST(@User as int);	

	--Prepare string filter inputs
	SET @Search = '%' + @Search + '%';
	SET @User = '%' + @User + '%';
	
	DECLARE @Data TABLE
	(
		[RowNumber] INT,
		[TotalRows] INT,
		[CaseArtifactID] INT,
		[SearchArtifactID] INT,
		[Search] NVARCHAR(150),
		[LastAuditID] INT,
		[UserArtifactID] INT,
		[User] NVARCHAR(150),
		[TotalRunTime] BIGINT,
		[AverageRunTime] INT,
		[TotalRuns] INT,
		[PercentLongRunning] INT,
		[IsComplex] BIT,
		[SummaryDayHour] DATETIME,
		[QoSHourID] BIGINT,
		[IsActiveWeeklySample] BIT
	);
	
	WITH Paging AS
	(
	SELECT
		ROW_NUMBER() OVER (
			ORDER BY
			/* BIGINT COLUMN ORDER BY */
			CASE @SortDirection WHEN 'ASC' THEN
				CASE @SortColumn
					WHEN 'QoSHourID' THEN SS.QoSHourID
					WHEN 'TotalRunTime' THEN SS.TotalRunTime
					WHEN 'AverageRunTime' THEN SS.AverageRunTime
				END
			END ASC,
			CASE @SortDirection WHEN 'DESC' THEN
				CASE @SortColumn
					WHEN 'QoSHourID' THEN SS.QoSHourID
					WHEN 'TotalRunTime' THEN SS.TotalRunTime
					WHEN 'AverageRunTime' THEN SS.AverageRunTime
				END
			END DESC,
			/* STRING COLUMN ORDER BY */
			CASE @SortDirection WHEN 'ASC' THEN
				CASE @SortColumn
					WHEN 'Search' THEN SS.[Search]
					WHEN 'User' THEN SS.[User]
				END
			END ASC,
			CASE @SortDirection WHEN 'DESC' THEN
				CASE @SortColumn
					WHEN 'Search' THEN SS.[Search]
					WHEN 'User' THEN SS.[User]
				END
			END DESC,
			/* NON-STRING ORDER BY */
			CASE @SortDirection WHEN 'ASC' THEN
				CASE @SortColumn
					WHEN 'TotalRuns' THEN SS.TotalRuns
					WHEN 'PercentLongRunning' THEN SS.PercentLongRunning
					WHEN 'SummaryDayHour' THEN SS.SummaryDayHour
					WHEN 'IsComplex' THEN IsComplex
				END
			END ASC,
			CASE @SortDirection WHEN 'DESC' THEN
				CASE @SortColumn
					WHEN 'TotalRuns' THEN SS.TotalRuns
					WHEN 'PercentLongRunning' THEN SS.PercentLongRunning
					WHEN 'SummaryDayHour' THEN SS.SummaryDayHour
					WHEN 'IsComplex' THEN IsComplex
				END
			END DESC
		) AS RowNumber,
		COUNT(*) OVER () AS TotalRows,
		[CaseArtifactID],
		[SearchArtifactID],
		[Search],
		[LastAuditID],
		[UserArtifactID],
		[User],
		[TotalRunTime],
		[AverageRunTime],
		TotalRuns,
		PercentLongRunning,
		[IsComplex],
		DATEADD(MINUTE, @TimezoneOffset, SS.SummaryDayHour) [SummaryDayHour],
		SS.QoSHourID,
		CAST(1 AS BIT) [IsActiveWeeklySample]
	FROM eddsdbo.QoS_UserExperienceSearchSummary SS
	WHERE CaseArtifactID = @CaseArtifactId
	--Filter options
	AND (@Search IS NULL OR Search LIKE @Search OR SearchArtifactID = @SearchId)
	AND (@User IS NULL OR [User] LIKE @User OR UserArtifactID = @UserId)
	AND (@TotalRunTime IS NULL OR TotalRunTime = @TotalRunTime)
	AND (@AverageRunTime IS NULL OR AverageRunTime = @AverageRunTime)
	AND (@TotalRuns IS NULL OR TotalRuns = @TotalRuns)
	AND (@PercentLongRunning IS NULL OR PercentLongRunning = @PercentLongRunning)
	AND (@SummaryDayHour IS NULL OR DATEADD(MINUTE, @TimezoneOffset, SS.[SummaryDayHour]) = @SummaryDayHour)
	AND (@QoSHourID IS NULL OR SS.QoSHourID = @QoSHourID)
	AND (@IsComplex IS NULL OR IsComplex = @IsComplex)
	)
	INSERT INTO @Data
	SELECT *
	FROM Paging
	WHERE RowNumber BETWEEN @StartRow AND @EndRow
	
	SELECT
		[RowNumber],
		[CaseArtifactID],
		[SearchArtifactID],
		[Search],
		[LastAuditID],
		[UserArtifactID],
		[User],
		[TotalRunTime],
		[AverageRunTime],
		[TotalRuns],
		[PercentLongRunning],
		[IsComplex],
		[SummaryDayHour],
		[QoSHourID],
		[IsActiveWeeklySample]
	FROM @Data
	
	SELECT TOP 1 @StartRow AS StartIndex,
		@StartRow + @@ROWCOUNT - 1 AS EndIndex,
		[TotalRows] AS FilteredCount
	FROM @Data
END