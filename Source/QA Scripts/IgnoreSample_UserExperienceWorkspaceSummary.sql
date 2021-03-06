USE [EDDSPerformance]
GO
/****** Object:  StoredProcedure [eddsdbo].[QoS_UserExperienceWorkspaceReport]    Script Date: 02/12/2015 12:08:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER PROCEDURE [eddsdbo].[QoS_UserExperienceWorkspaceReport]
	@SortColumn VARCHAR(50) = 'PercentLongRunning',
	@SortDirection CHAR(4) = 'DESC',
	@TimeZoneOffset INT = 0, --Offset to use (in minutes) for UTC dates
	@StartRow INT = 1,
	@EndRow INT = 25,
	@Server INT, --ArtifactID of the server we want data for
	@Workspace NVARCHAR(150) = NULL,
	@Search NVARCHAR(MAX) = NULL,
	@TotalRunTime BIGINT = NULL,
	@AverageRunTime INT = NULL,
	@TotalRuns INT = NULL,
	@PercentLongRunning INT = NULL,
	@IsComplex BIT = NULL,
	@SummaryDayHour DATETIME = NULL,
	@IsActiveWeeklySample BIT = NULL
AS
BEGIN
	--Support ArtifactID filtering
	DECLARE @SearchId INT = NULL,
		@WorkspaceId INT = NULL;
	IF (ISNUMERIC(@Search) = 1)
		SET @SearchId = CAST(@Search as int);
	IF (ISNUMERIC(@Workspace) = 1)
		SET @WorkspaceId = CAST(@Workspace as int);	

	--Prepare string filter inputs
	SET @Workspace = '%' + @Workspace + '%';
	SET @Search = '%' + @Search + '%';
	
	DECLARE @ServerName NVARCHAR(150);
	SELECT TOP 1
		@ServerName = ServerName
	FROM eddsdbo.[Server] WITH(NOLOCK)
	WHERE ArtifactID = @Server
	AND (IgnoreServer IS NULL OR IgnoreServer = 0)
	AND DeletedOn IS NULL;
	
	DECLARE @Data TABLE
	(
		[RowNumber] INT,
		[TotalRows] INT,
		[CaseArtifactID] INT,
		[Workspace] NVARCHAR(150),
		[SearchArtifactID] INT,
		[Search] NVARCHAR(150),
		[TotalRunTime] BIGINT,
		[AverageRunTime] INT,
		[TotalRuns] INT,
		[PercentLongRunning] INT,
		[IsComplex] BIT,
		[SummaryDayHour] DATETIME,
		[IsActiveWeeklySample] BIT
	);

	WITH Paging AS
	(
	SELECT
		ROW_NUMBER() OVER (
			ORDER BY
			/* STRING COLUMN ORDER BY */
			CASE @SortDirection WHEN 'ASC' THEN
				CASE @SortColumn
					WHEN 'Workspace' THEN [Workspace]
					WHEN 'Search' THEN [Search]
				END
			END ASC,
			CASE @SortDirection WHEN 'DESC' THEN
				CASE @SortColumn
					WHEN 'Workspace' THEN [Workspace]
					WHEN 'Search' THEN [Search]
				END
			END DESC,
			/* BIGINT ORDER BY */
			CASE @SortDirection WHEN 'ASC' THEN
				CASE @SortColumn
					WHEN 'TotalRunTime' THEN TotalRunTime
					WHEN 'AverageRunTime' THEN AverageRunTime
				END
			END ASC,
			CASE @SortDirection WHEN 'DESC' THEN
				CASE @SortColumn
					WHEN 'TotalRunTime' THEN TotalRunTime
					WHEN 'AverageRunTime' THEN AverageRunTime
				END
			END DESC,
			/* NON-STRING ORDER BY */
			CASE @SortDirection WHEN 'ASC' THEN
				CASE @SortColumn
					WHEN 'TotalRuns' THEN TotalRuns
					WHEN 'PercentLongRunning' THEN PercentLongRunning
					WHEN 'IsComplex' THEN IsComplex
					WHEN 'SummaryDayHour' THEN WS.SummaryDayHour
				END
			END ASC,
			CASE @SortDirection WHEN 'DESC' THEN
				CASE @SortColumn
					WHEN 'TotalRuns' THEN TotalRuns
					WHEN 'PercentLongRunning' THEN PercentLongRunning
					WHEN 'IsComplex' THEN IsComplex
					WHEN 'SummaryDayHour' THEN WS.SummaryDayHour
				END
			END DESC
		) AS RowNumber,
		COUNT(*) OVER () TotalRows,
		[CaseArtifactID],
		[Workspace],
		[SearchArtifactID],
		[Search],
		[TotalRunTime],
		[AverageRunTime],
		[TotalRuns],
		[PercentLongRunning],
		[IsComplex],
		DATEADD(MINUTE, @TimezoneOffset, WS.[SummaryDayHour]) [SummaryDayHour],
		CAST(1 as bit) [IsActiveWeeklySample]
	FROM eddsdbo.QoS_UserExperienceWorkspaceSummary WS WITH(NOLOCK)
	LEFT JOIN EDDS.EDDSDBO.[Case] C WITH(NOLOCK)
		ON WS.CaseArtifactID = C.ArtifactID
	WHERE WS.[ServerArtifactID] = @Server
	--Filter options
	AND (@Workspace IS NULL OR Workspace LIKE @Workspace OR CaseArtifactID = @WorkspaceId)
	AND (@Search IS NULL OR Search LIKE @Search OR SearchArtifactID = @SearchId)
	AND (@TotalRunTime IS NULL OR TotalRunTime = @TotalRunTime)
	AND (@AverageRunTime IS NULL OR AverageRunTime = @AverageRunTime)
	AND (@TotalRuns IS NULL OR TotalRuns = @TotalRuns)
	AND (@PercentLongRunning IS NULL OR PercentLongRunning = @PercentLongRunning)
	AND (@IsComplex IS NULL OR IsComplex = @IsComplex)
	AND (@SummaryDayHour IS NULL OR DATEADD(MINUTE, @TimezoneOffset, WS.[SummaryDayHour]) = @SummaryDayHour)
	)
	INSERT INTO @Data
	SELECT *
	FROM Paging
	WHERE RowNumber BETWEEN @StartRow AND @EndRow;
	
	SELECT
		[RowNumber],
		[CaseArtifactID],
		[Workspace],
		[SearchArtifactID],
		[Search],
		[TotalRunTime],
		[AverageRunTime],
		[TotalRuns],
		[PercentLongRunning],
		[IsComplex],
		[SummaryDayHour],
		[IsActiveWeeklySample]
	FROM @Data;
	
	SELECT TOP 1 @StartRow AS StartIndex,
		@StartRow + @@ROWCOUNT - 1 AS EndIndex,
		TotalRows AS FilteredCount
	FROM @Data;
END