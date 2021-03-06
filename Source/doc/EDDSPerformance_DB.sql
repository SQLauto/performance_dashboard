USE [master]
GO
/****** Object:  Login [DOMAIN\RelativityAccount]    Script Date: 10/11/2011 13:44:06 ******/
CREATE LOGIN [DOMAIN\RelativityAccount] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
EXEC master..sp_addsrvrolemember @loginame = N'DOMAIN\RelativityAccount', @rolename = N'sysadmin'
GO

/****** Object:  Database [EDDSPerformance]    Script Date: 10/11/2011 13:32:06 ******/
CREATE DATABASE [EDDSPerformance] ON  PRIMARY 
( NAME = N'EDDSPerformance', FILENAME = N'D:\EDDSPerformance.mdf' , SIZE = 101376KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'EDDSPerformance_log', FILENAME = N'E:\EDDSPerformance_log.ldf' , SIZE = 1219712KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [EDDSPerformance] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EDDSPerformance].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EDDSPerformance] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [EDDSPerformance] SET ANSI_NULLS OFF
GO
ALTER DATABASE [EDDSPerformance] SET ANSI_PADDING OFF
GO
ALTER DATABASE [EDDSPerformance] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [EDDSPerformance] SET ARITHABORT OFF
GO
ALTER DATABASE [EDDSPerformance] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [EDDSPerformance] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [EDDSPerformance] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [EDDSPerformance] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [EDDSPerformance] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [EDDSPerformance] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [EDDSPerformance] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [EDDSPerformance] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [EDDSPerformance] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [EDDSPerformance] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [EDDSPerformance] SET  DISABLE_BROKER
GO
ALTER DATABASE [EDDSPerformance] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [EDDSPerformance] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [EDDSPerformance] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [EDDSPerformance] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [EDDSPerformance] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [EDDSPerformance] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [EDDSPerformance] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [EDDSPerformance] SET  READ_WRITE
GO
ALTER DATABASE [EDDSPerformance] SET RECOVERY FULL
GO
ALTER DATABASE [EDDSPerformance] SET  MULTI_USER
GO
ALTER DATABASE [EDDSPerformance] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [EDDSPerformance] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'EDDSPerformance', N'ON'
GO
USE [EDDSPerformance]
GO
/****** Object:  Schema [eddsdbo]    Script Date: 10/11/2011 13:32:07 ******/
CREATE SCHEMA [eddsdbo] AUTHORIZATION [dbo]
GO
/****** Object:  Table [eddsdbo].[Server]    Script Date: 10/11/2011 13:32:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [eddsdbo].[Server](
	[ServerID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[DeletedOn] [datetime] NULL,
	[ServerTypeID] [int] NOT NULL,
	[ServerIPAddress] [varchar](100) NULL,
 CONSTRAINT [PK_Server] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [eddsdbo].[ProcessControl]    Script Date: 10/11/2011 13:32:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ProcessControl](
	[ProcessControlID] [int] NOT NULL,
	[ProcessTypeDesc] [nvarchar](200) NOT NULL,
	[LastProcessExecDateTime] [datetime] NOT NULL,
	[Frequency] [int] NULL,
 CONSTRAINT [PK_ProcessControl] PRIMARY KEY CLUSTERED 
(
	[ProcessControlID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [eddsdbo].[GetDateRange]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [eddsdbo].[GetDateRange]
(@StartDate datetime,@EndDate datetime)				
RETURNS @DateRangeTable Table (DateRange datetime)			
as
Begin
	declare @blEqual bit =0	
	declare @HourDifference int = 0	
	if (@StartDate = @EndDate)
	begin				
		set  @EndDate = DateAdd(S,-1,@EndDate) +1 ;        
		set  @blEqual = 1;
	end
	      
	while (@StartDate <= @EndDate)
	begin                
		insert into @DateRangeTable select(@StartDate)	    
		if (@blEqual = 1)
		begin
			set @StartDate =  DateAdd(HH,1,@StartDate);
		end
		else
		begin
			set @StartDate = @StartDate + 1;
		end
	end	
	return 
End
GO
/****** Object:  Table [eddsdbo].[LRQCountDW]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[LRQCountDW](
	[LRQCountDWID] [int] IDENTITY(1,1) NOT NULL,
	[MeasureDate] [date] NOT NULL,
	[MeasureHour] [int] NOT NULL,
	[CaseArtifactID] [int] NOT NULL,
	[LRQCount] [int] NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_LRQCountDW] PRIMARY KEY CLUSTERED 
(
	[LRQCountDWID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[MeasureType]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [eddsdbo].[MeasureType](
	[MeasureTypeId] [int] NOT NULL,
	[MeasureTypeCd] [varchar](50) NOT NULL,
	[MeasureTypeDesc] [varchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_MeasureType] PRIMARY KEY CLUSTERED 
(
	[MeasureTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [eddsdbo].[LatencyDW]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[LatencyDW](
	[LatencyDWID] [int] IDENTITY(1,1) NOT NULL,
	[MeasureDate] [date] NOT NULL,
	[MeasureHour] [int] NOT NULL,
	[CaseArtifactID] [int] NOT NULL,
	[AverageLatency] [int] NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_LatencyDW] PRIMARY KEY CLUSTERED 
(
	[LatencyDWID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [eddsdbo].[DateTable]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [eddsdbo].[DateTable]
(
	@FirstDate	datetime,
	@LastDate	datetime
)
RETURNS @datetable TABLE (
	[date]		datetime
)
AS
BEGIN

  SELECT @FirstDate = DATEADD(dd, 0, DATEDIFF(dd, 0, @FirstDate));   SELECT @LastDate = DATEADD(dd, 0, DATEDIFF(dd, 0, @LastDate)); 
  WITH CTE_DatesTable
  AS 
  (
    SELECT @FirstDate AS [date]
    UNION ALL
    SELECT DATEADD(dd, 1, [date])
    FROM CTE_DatesTable
    WHERE DATEADD(dd, 1, [date]) <= @LastDate
  )
  INSERT INTO @datetable ([date])
  SELECT [date] FROM CTE_DatesTable
  OPTION (MAXRECURSION 0)

  RETURN
END
GO
/****** Object:  UserDefinedFunction [eddsdbo].[DateHourTable]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [eddsdbo].[DateHourTable]
(
	@FirstDate	datetime,
	@LastDate	datetime
)
RETURNS @datetable TABLE (
	[date]		datetime
)
AS
BEGIN

  SELECT @FirstDate = DATEADD(dd, 0, DATEDIFF(dd, 0, @FirstDate));   SELECT @LastDate = DATEADD(dd, 0, DATEDIFF(dd, 0, @LastDate)); 
  WITH CTE_DatesTable
  AS 
  (
    SELECT @FirstDate AS [date]
    UNION ALL
    SELECT DATEADD(HH, 1, [date])
    FROM CTE_DatesTable
    WHERE DATEADD(HH, 1, [date]) <= @LastDate
  )
  INSERT INTO @datetable ([date])
  SELECT [date] FROM CTE_DatesTable
  OPTION (MAXRECURSION 0)

  RETURN
END
GO
/****** Object:  Table [eddsdbo].[ErrorCountDW]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ErrorCountDW](
	[ErrorCountDWID] [int] IDENTITY(1,1) NOT NULL,
	[MeasureDate] [date] NOT NULL,
	[MeasureHour] [int] NOT NULL,
	[CaseArtifactID] [int] NOT NULL,
	[ErrorCount] [int] NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ErrorCountDW] PRIMARY KEY CLUSTERED 
(
	[ErrorCountDWID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[ServerType]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ServerType](
	[ServerTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ServerTypeName] [nvarchar](50) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ArtifactID] [int] NULL,
 CONSTRAINT [PK_ServerType] PRIMARY KEY CLUSTERED 
(
	[ServerTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[PerformanceSummary]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[PerformanceSummary](
	[PerformanceSummaryID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CaseArtifactID] [int] NOT NULL,
	[MeasureDate] [datetime] NOT NULL,
	[UserCount] [int] NULL,
	[ErrorCount] [int] NULL,
	[LRQCount] [int] NULL,
	[AverageLatency] [int] NULL,
 CONSTRAINT [PK_PerformanceSummary] PRIMARY KEY CLUSTERED 
(
	[PerformanceSummaryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[UserCountDW]    Script Date: 10/11/2011 13:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[UserCountDW](
	[UserCountDWID] [int] IDENTITY(1,1) NOT NULL,
	[MeasureDate] [date] NOT NULL,
	[MeasureHour] [int] NOT NULL,
	[CaseArtifactID] [int] NOT NULL,
	[UserCount] [int] NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_UserCountDW] PRIMARY KEY CLUSTERED 
(
	[UserCountDWID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [eddsdbo].[LoadApplicationHealthSummary]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Murali Shesham
-- Create date: 08/31/2011
-- Description:	
-- =============================================
CREATE PROCEDURE [eddsdbo].[LoadApplicationHealthSummary]
	@ProcessExecDate DateTime 
AS
BEGIN
	SET NOCOUNT ON;


	Declare @SummaryMeasureDate DateTime
	Declare @MeasureDate Date
	Declare @MeasureHour Int
	Select @MeasureDate = Cast(@ProcessExecDate as Date) , @MeasureHour = DatePart(HH,@ProcessExecDate) 
	Select @SummaryMeasureDate = DATEADD(HH,@MeasureHour, CAST(@MeasureDate as Varchar(20)))

	IF EXISTS(Select 1 From eddsdbo.PerformanceSummary Where MeasureDate = @SummaryMeasureDate)
	BEGIN 
	  PRINT 'Cannot load data more than once in an hour'
	END
	ELSE
	BEGIN
		BEGIN TRAN
 			Insert PerformanceSummary
			Select GetUTCDate() CreatedOn, C.ArtifactID CaseArtifactID, 	
			@SummaryMeasureDate MeasureDate, COALESCE(UC.UserCount,0) 
			UserCount, COALESCE(EC.ErrorCount,0) ErrorCount, 
			COALESCE(LC.LRQCount,0) LRQCount, 
			COALESCE(AL.AverageLatency,0) AverageLatency
			From  EDDS.eddsdbo.[Case] C
			Left Join 
			(Select CaseArtifactID, AVG(UserCount) UserCount   
			From eddsdbo.UserCountDW 
			Where MeasureDate = @MeasureDate AND MeasureHour = @MeasureHour Group By CaseArtifactID) UC
			On C.ArtifactID = UC.CaseArtifactID
			Left Join (Select CaseArtifactID, SUM(ErrorCount) ErrorCount    
			From eddsdbo.ErrorCountDW 
			Where MeasureDate = @MeasureDate AND MeasureHour = @MeasureHour  Group By CaseArtifactID) EC
			On C.ArtifactID = EC.CaseArtifactID
			Left Join (Select CaseArtifactID, SUM(LRQCount) LRQCount   
			From eddsdbo.LRQCountDW 
			Where MeasureDate = @MeasureDate AND MeasureHour = @MeasureHour  Group By CaseArtifactID) LC
			On C.ArtifactID = LC.CaseArtifactID
			Left Join (Select CaseArtifactID, AVG(AverageLatency) AverageLatency
			From eddsdbo.LatencyDW 
			Where MeasureDate = @MeasureDate AND MeasureHour = @MeasureHour  Group By CaseArtifactID) AL
			On C.ArtifactID = AL.CaseArtifactID
		COMMIT TRAN
	END

END
GO
/****** Object:  Table [eddsdbo].[SQLServerSummary]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[SQLServerSummary](
	[SQLServerSummaryID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[MeasureDate] [datetime] NOT NULL,
	[ServerID] [int] NOT NULL,
	[SQLPageLifeExpectancy] [decimal](10, 2) NULL,
 CONSTRAINT [PK_SQLServerSummary] PRIMARY KEY CLUSTERED 
(
	[SQLServerSummaryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[SQLServerDW]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[SQLServerDW](
	[SQLServerDWID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ServerID] [int] NOT NULL,
	[SQLPageLifeExpectancy] [decimal](10, 2) NULL,
 CONSTRAINT [PK_SQLServerDW] PRIMARY KEY CLUSTERED 
(
	[SQLServerDWID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [eddsdbo].[MergeServerInformation]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [eddsdbo].[MergeServerInformation] 
(
	@XMLServerList XML = ''
)
 
AS  
BEGIN

	DECLARE @Server TABLE( ServerName nvarchar(255), ServerIPAddress nvarchar(100), ServerTypeID INT)

	INSERT INTO @Server 
			--VALUES( ServerName, ServerIPAddress, ServerTypeID )
			SELECT DISTINCT
				item.value('@Name','nvarchar(255)') AS ServerName
				, item.value('@IP','nvarchar(100)') AS ServerIPAddress
				, item.value('@TypeID','INT') AS ServerTypeID
			FROM 
				@XMLServerList.nodes('/ServerList/Server') d(item)


	UPDATE [eddsdbo].[Server] SET DeletedOn = NULL 

	UPDATE [eddsdbo].[Server] set deletedon = GETUTCDATE()
	WHERE serverid not in(
	SELECT serverid FROM [eddsdbo].[Server]
	WHERE ServerName + '_' + ServerIPAddress + '_' + CAST(ServerTypeID as VARCHAR)
	IN (SELECT ServerName + '_' + ServerIPAddress + '_' + CAST(ServerTypeID as VARCHAR) from @server))

	INSERT INTO [eddsdbo].[Server]
	select ServerName , GETUTCDATE(), null, ServerTypeID , ServerIPAddress from @Server
	where ServerName + '_' + ServerIPAddress + '_' + CAST(ServerTypeID as VARCHAR)
	NOT IN (select ServerName + '_' + ServerIPAddress + '_' + CAST(ServerTypeID as VARCHAR) from [eddsdbo].[Server])

	
END
GO
/****** Object:  Table [eddsdbo].[ServerSummary]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ServerSummary](
	[ServerSummaryID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[MeasureDate] [datetime] NOT NULL,
	[ServerID] [int] NOT NULL,
	[RAMPagesPerSec] [decimal](10, 2) NULL,
	[RAMPageFaultsPerSec] [decimal](10, 2) NULL,
 CONSTRAINT [PK_ServerSummary] PRIMARY KEY CLUSTERED 
(
	[ServerSummaryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[ServerProcessorSummary]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ServerProcessorSummary](
	[ServerProcessorSummaryID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[MeasureDate] [datetime] NOT NULL,
	[ServerID] [int] NOT NULL,
	[CoreNumber] [int] NOT NULL,
	[CPUProcessorTimePct] [decimal](10, 0) NULL,
 CONSTRAINT [PK_ServerProcessorSummary] PRIMARY KEY CLUSTERED 
(
	[ServerProcessorSummaryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[ServerProcessorDW]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ServerProcessorDW](
	[ServerProcessorDWID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ServerID] [int] NOT NULL,
	[CoreNumber] [int] NOT NULL,
	[CPUProcessorTimePct] [decimal](10, 0) NULL,
 CONSTRAINT [PK_ServerProcessorDW] PRIMARY KEY CLUSTERED 
(
	[ServerProcessorDWID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[ServerDW]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ServerDW](
	[ServerDWID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ServerID] [int] NOT NULL,
	[RAMPagesPerSec] [decimal](10, 2) NULL,
	[RAMPageFaultsPerSec] [decimal](10, 2) NULL,
 CONSTRAINT [PK_ServerDW] PRIMARY KEY CLUSTERED 
(
	[ServerDWID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[ServerDiskSummary]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ServerDiskSummary](
	[ServerDiskSummaryID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[MeasureDate] [datetime] NOT NULL,
	[ServerID] [int] NOT NULL,
	[DiskNumber] [int] NOT NULL,
	[DiskAvgSecPerRead] [decimal](10, 2) NULL,
	[DiskAvgSecPerWrite] [decimal](10, 2) NULL,
 CONSTRAINT [PK_ServerDiskSummary] PRIMARY KEY CLUSTERED 
(
	[ServerDiskSummaryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [eddsdbo].[ServerDiskDW]    Script Date: 10/11/2011 13:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [eddsdbo].[ServerDiskDW](
	[ServerDiskDWID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ServerID] [int] NOT NULL,
	[DiskNumber] [int] NOT NULL,
	[DiskAvgSecPerRead] [decimal](10, 2) NULL,
	[DiskAvgSecPerWrite] [decimal](10, 2) NULL,
 CONSTRAINT [PK_ServerDiskDW] PRIMARY KEY CLUSTERED 
(
	[ServerDiskDWID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [eddsdbo].[EDDSWorkspace]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [eddsdbo].[EDDSWorkspace]
AS
SELECT  
	[Case].ArtifactID		AS CaseArtifactID
	, [Case].[Name]			AS WorkspaceName
	, (
		CASE 
			WHEN CHARINDEX('\', [ResourceServer].Name) > 0 
				THEN SUBSTRING( [ResourceServer].Name, CHARINDEX('\', [ResourceServer].Name) + 1, LEN( [ResourceServer].Name ) )
			ELSE [ResourceServer].Name
		END		
	  ) AS [DatabaseLocation]
FROM [EDDS].[eddsdbo].[Case] AS [Case] WITH (NOLOCK)
	INNER JOIN [EDDS].[eddsdbo].[ResourceServer] [ResourceServer] WITH (NOLOCK)
		ON [ResourceServer].artifactId = [Case].ServerId
GO
/****** Object:  Table [eddsdbo].[Measure]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [eddsdbo].[Measure](
	[MeasureID] [int] IDENTITY(1,1) NOT NULL,
	[MeasureCd] [varchar](100) NOT NULL,
	[MeasureDesc] [varchar](500) NOT NULL,
	[MeasureTypeId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[Frequency] [int] NOT NULL,
	[LastDataLoadDateTime] [datetime] NULL,
 CONSTRAINT [PK_Measure] PRIMARY KEY CLUSTERED 
(
	[MeasureID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of minutes between 2 consecutive measurements (Default: 60)' , @level0type=N'SCHEMA',@level0name=N'eddsdbo', @level1type=N'TABLE',@level1name=N'Measure', @level2type=N'COLUMN',@level2name=N'Frequency'
GO
/****** Object:  StoredProcedure [eddsdbo].[PopulateFactTableData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jayesh Dhobi
-- Create date: 13th Sep 2011
-- Description:	Populate Fact Table data
-- =============================================
CREATE PROCEDURE [eddsdbo].[PopulateFactTableData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN --- Declaration
		DECLARE @IsRunsuccessfully BIT = 0
		
		DECLARE @MeasureDate datetime = GETUTCDATE()
		DECLARE @MeasureHour datetime = DATEADD(hour, DATEDIFF(hour, 0, @MeasureDate), 0)	-- truncated to the last hour

	END
	PRINT ' Start '
	BEGIN TRY
		BEGIN TRAN
		
		BEGIN --- Populate ServerSummary table
			MERGE [eddsdbo].[ServerSummary]
			USING
			(
				SELECT
					  ServerID
					, @MeasureHour MeasureDate
					, AVG(RAMPagesPerSec) AS RAMPagesPerSec
					, AVG(RAMPageFaultsPerSec) AS RAMPageFaultsPerSec
				FROM [eddsdbo].[ServerDW]
				WHERE CreatedOn BETWEEN DATEADD(HH, -1, @MeasureDate) AND @MeasureDate
				GROUP BY ServerID
			) AS Data ON Data.ServerID = [ServerSummary].ServerID
				AND Data.MeasureDate = [ServerSummary].MeasureDate
			WHEN MATCHED THEN UPDATE
                SET RAMPagesPerSec = Data.RAMPagesPerSec
				, RAMPageFaultsPerSec = Data.RAMPageFaultsPerSec
			WHEN NOT MATCHED THEN
				INSERT (
                            ServerID
							, MeasureDate
							, RAMPagesPerSec
							, RAMPageFaultsPerSec
							, CreatedOn
                        )
                VALUES ( 
                            Data.ServerID
							, Data.MeasureDate
							, Data.RAMPagesPerSec
							, Data.RAMPageFaultsPerSec
							, @MeasureDate
                        );
		END
		
		BEGIN --- Populate ServerDiskSummary table
			MERGE [eddsdbo].[ServerDiskSummary]
			USING
			(	
				SELECT
					  ServerID
					, DiskNumber
					, @MeasureHour MeasureDate
					, AVG( DiskAvgSecPerRead ) AS DiskAvgSecPerRead
					, AVG( DiskAvgSecPerWrite ) AS DiskAvgSecPerWrite
				FROM [eddsdbo].[ServerDiskDW]
				WHERE CreatedOn BETWEEN DATEADD(HH, -1, @MeasureDate) AND @MeasureDate
				GROUP BY ServerID, DiskNumber
			) AS Data ON Data.ServerID = [ServerDiskSummary].ServerID
				AND Data.MeasureDate = [ServerDiskSummary].MeasureDate
				AND Data.DiskNumber = [ServerDiskSummary].DiskNumber
			WHEN MATCHED THEN UPDATE 
                SET DiskAvgSecPerRead = Data.DiskAvgSecPerRead
					, DiskAvgSecPerWrite = Data.DiskAvgSecPerWrite
			WHEN NOT MATCHED THEN
				INSERT
				(
					ServerID
					, MeasureDate
					, DiskNumber
					, DiskAvgSecPerRead
					, DiskAvgSecPerWrite
					, CreatedOn
				)
				VALUES 
				(
					Data.ServerID
					, Data.MeasureDate
					, Data.DiskNumber
					, Data.DiskAvgSecPerRead
					, Data.DiskAvgSecPerWrite
					, @MeasureDate
				);
		END		
		
		BEGIN --- Populate ServerProcessorSummary table
			MERGE [eddsdbo].[ServerProcessorSummary]
			USING
			(	
				SELECT
					  ServerID
					, CoreNumber
					, @MeasureHour MeasureDate
					, AVG( CPUProcessorTimePct ) AS CPUProcessorTimePct
				FROM [eddsdbo].[ServerProcessorDW]
				WHERE CreatedOn BETWEEN DATEADD(HH, -1, @MeasureDate) AND @MeasureDate
				GROUP BY ServerID, CoreNumber
			) AS Data ON Data.ServerID = [ServerProcessorSummary].ServerID
				AND Data.MeasureDate = [ServerProcessorSummary].MeasureDate
				AND Data.CoreNumber = [ServerProcessorSummary].CoreNumber
			
			WHEN MATCHED THEN UPDATE 
                SET CPUProcessorTimePct = Data.CPUProcessorTimePct
			
			WHEN NOT MATCHED THEN
				INSERT
				(
					ServerID
					, MeasureDate
					, CoreNumber
					, CPUProcessorTimePct
					, CreatedOn
				)
				VALUES 
				(
					Data.ServerID
					, Data.MeasureDate
					, Data.CoreNumber
					, Data.CPUProcessorTimePct
					, @MeasureDate
				);
		END
		
		BEGIN --- Populate SQLServerSummary table
			MERGE [eddsdbo].[SQLServerSummary]
			USING
			(	
				SELECT
					ServerID
					, @MeasureHour MeasureDate
					, AVG( SQLPageLifeExpectancy ) AS SQLPageLifeExpectancy
				FROM [eddsdbo].[SQLServerDW]
				WHERE( CreatedOn BETWEEN DATEADD(HH, -1, @MeasureDate) AND @MeasureDate )
				GROUP BY ServerID
			) AS Data ON Data.ServerID = [SQLServerSummary].ServerID
				AND Data.MeasureDate = [SQLServerSummary].MeasureDate
			WHEN MATCHED THEN UPDATE 
				SET SQLPageLifeExpectancy = Data.SQLPageLifeExpectancy
			WHEN NOT MATCHED THEN
				INSERT
				(
					ServerID
					, MeasureDate
					, SQLPageLifeExpectancy
					, CreatedOn
				)
				VALUES 
				(
					Data.ServerID
					, Data.MeasureDate
					, Data.SQLPageLifeExpectancy
					, @MeasureDate
				);
		END
			
		COMMIT TRAN
		
		SET @IsRunsuccessfully = 1
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
		
	IF (@IsRunsuccessfully = 1)
		BEGIN
			SELECT @IsRunsuccessfully AS IsRunsuccessfully, ''	AS ErrorMessage
		END
	ELSE
		BEGIN
			SELECT @IsRunsuccessfully AS IsRunsuccessfully, ERROR_MESSAGE()	AS ErrorMessage
		END
END
GO
/****** Object:  StoredProcedure [eddsdbo].[LoadUserHealthDWData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Murali Shesham
-- Create date: 08/31/2011
-- Description:	
-- =============================================
CREATE PROCEDURE [eddsdbo].[LoadUserHealthDWData] 
	@ProcessExecDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @MeasureDate Date
	Declare @MeasureHour Int
	Declare @Frequency int
	Select @MeasureDate = Cast(@ProcessExecDate as Date) , @MeasureHour = DatePart(HH,@ProcessExecDate) 
	Select @Frequency= COALESCE(Frequency,0) From eddsdbo.Measure Where MeasureID = 4
 
	IF @Frequency > 0 
	BEGIN
		Insert eddsdbo.UserCountDW (MeasureDate, MeasureHour, CaseArtifactID, UserCount, CreatedOn)
		SELECT  @MeasureDate MeasureDate, @MeasureHour MeasureHour,   C.ArtifactID AS CaseArtifactID, COALESCE(UC.UserCount,0) UserCount, GETUTCDATE() as [CreatedOn]
		FROM         EDDS.eddsdbo.[Case] C
		Left Join (SELECT
			CaseArtifactID,
			COUNT(UserID) as UserCount	
		FROM
			EDDS.eddsdbo.UserStatus (NOLOCK)
		WHERE
			CaseArtifactID <> -1
			-- value of -1 indicates they're not currently in any workspace
		GROUP BY
			CaseArtifactID) UC
			On C.ArtifactID = UC.CaseArtifactID
	END
END
GO
/****** Object:  StoredProcedure [eddsdbo].[LoadLatencyHealthDWData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[LoadLatencyHealthDWData] 
	@ProcessExecDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @MeasureDate Date
	Declare @MeasureHour Int
	Declare @Frequency int
	Select @MeasureDate = Cast(@ProcessExecDate as Date) , @MeasureHour = DatePart(HH,@ProcessExecDate) 
	Select @Frequency= COALESCE(Frequency,0) From eddsdbo.Measure Where MeasureID = 3

	IF @Frequency > 0 
	BEGIN
		--this will give us the avg latency for the past five minutes for each workspace
		--relativity adds a row to this table every 15min for each logged in user

		Insert eddsdbo.LatencyDW (MeasureDate, MeasureHour, CaseArtifactID, AverageLatency, CreatedOn)
		SELECT  @MeasureDate MeasureDate, @MeasureHour MeasureHour,  C.ArtifactID AS CaseArtifactID, COALESCE(AL.AvgLatency,0) AvgLatency, GetUTCDate() as [CreatedOn]
		FROM         EDDS.eddsdbo.[Case] C
		Left Join (SELECT
			CaseArtifactID,
			AVG(Latency) as AvgLatency
		FROM
			EDDS.eddsdbo.WebClientPerformance (NOLOCK)
		WHERE
			StartTime >= @ProcessExecDate AND StartTime <= DateAdd(Minute, @Frequency, @ProcessExecDate)
		GROUP BY
			CaseArtifactID) AL
			 On C.ArtifactID = AL.CaseArtifactID
	END				
END
GO
/****** Object:  StoredProcedure [eddsdbo].[LoadErrorHealthDWData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[LoadErrorHealthDWData] 
	@ProcessExecDate DateTime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @MeasureDate Date
	Declare @MeasureHour Int
	Declare @Frequency int
	Select @MeasureDate = Cast(@ProcessExecDate as Date) , @MeasureHour = DatePart(HH,@ProcessExecDate) 
	Select @Frequency= COALESCE(Frequency,0) From eddsdbo.Measure Where MeasureID = 2

	IF @Frequency > 0 
	BEGIN
		--this will give us the error count for the past five minutes for each workspace
		--we'll later need to update this script to filter for only "kickout" errors
		Insert eddsdbo.ErrorCountDW (MeasureDate, MeasureHour, CaseArtifactID, ErrorCount, CreatedOn)
		SELECT    @MeasureDate MeasureDate, @MeasureHour MeasureHour,  C.ArtifactID AS CaseArtifactID, COALESCE(EC.ErrorCount,0) ErrorCount, GetUTCDate() as [CreatedOn]
		FROM         EDDS.eddsdbo.[Case] C
		Left Join (SELECT
			CaseArtifactID,
			COUNT(ArtifactID) as ErrorCount
		FROM
			EDDS.eddsdbo.ExtendedError (NOLOCK)
		WHERE
			CreatedOn >= @ProcessExecDate AND CreatedOn <= DateAdd(Minute, @Frequency, @ProcessExecDate)
		 AND ((FullError Like '%Read Failed%'   
			OR FullError LIKE '%Delete Failed%'
			OR FullError LIKE '%Create Failed%'
			OR FullError LIKE '%Update Failed%'
			OR FullError LIKE '%object reference not set to an instance of an object%'
			OR FullError LIKE '%SQL Statement Failed%'
			OR FullError LIKE '%Unable to connect to the remote server%')
			AND Source <> 'Native Document Viewer')
		 AND
			CaseArtifactID IS NOT NULL
		GROUP BY
			CaseArtifactID) EC
			On C.ArtifactID = EC.CaseArtifactID		
	END		
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetApplicationHealthDataHourly]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Konstantin Kekhaev
-- Create date: 19th September 2011
-- Description:	Getting Hourly Application Health data 
-- =============================================
CREATE PROCEDURE [eddsdbo].[GetApplicationHealthDataHourly]
(
	@StartDate	DATETIME,	-- local start date
	@EndDate	DATETIME,	-- local end date
	@TimeZoneOffset INT		-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		ROW_NUMBER() OVER(ORDER BY PC.CaseArtifactID, WS.WorkspaceName, DATEADD(MI, @TimeZoneOffset, PC.MeasureDate)) AS Id
		, PC.CaseArtifactID
		, WS.WorkspaceName
		, DATEADD(MI, @TimeZoneOffset, PC.MeasureDate) MeasureDate
		, PC.UserCount AS UserCount
		, PC.ErrorCount AS ErrorCount
		, PC.LRQCount AS LRQCount
		, PC.AverageLatency AS AverageLatency
	FROM eddsdbo.PerformanceSummary AS PC 
		INNER JOIN eddsdbo.EDDSWorkspace AS WS ON PC.CaseArtifactID = WS.CaseArtifactID
	WHERE( DATEADD(MI, @TimeZoneOffset, PC.MeasureDate) >= @StartDate AND DATEADD(MI, @TimeZoneOffset, PC.MeasureDate) < @EndDate)

END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetApplicationHealthDataDaily]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Konstantin Kekhaev
-- Create date: 19th September 2011
-- Description:	Getting Daily Application Health data 
-- =============================================
CREATE PROCEDURE [eddsdbo].[GetApplicationHealthDataDaily]
(
	@StartDate	DATETIME,	-- local start date
	@EndDate	DATETIME,	-- local end date
	@TimeZoneOffset INT		-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		ROW_NUMBER() OVER(ORDER BY PC.CaseArtifactID, WS.WorkspaceName, CONVERT(VARCHAR(10), dateadd(MI, @TimeZoneOffset, PC.MeasureDate), 101)) AS Id
		, PC.CaseArtifactID
		, WS.WorkspaceName
		, CAST(CONVERT(VARCHAR(10), dateadd(MI, @TimeZoneOffset, PC.MeasureDate), 101) AS DATETIME) AS MeasureDate
		, AVG(PC.UserCount) AS UserCount
		, SUM(PC.ErrorCount) AS ErrorCount
		, SUM(PC.LRQCount) AS LRQCount
		, AVG(PC.AverageLatency) AS AverageLatency
	FROM eddsdbo.PerformanceSummary AS PC 
		INNER JOIN eddsdbo.EDDSWorkspace AS WS ON PC.CaseArtifactID = WS.CaseArtifactID
	WHERE ( CAST( CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, PC.MeasureDate), 101) AS DATETIME) >= @StartDate 
		AND CAST( CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, PC.MeasureDate), 101) AS DATETIME) < (@EndDate+1) )
	GROUP BY PC.CaseArtifactID, WS.WorkspaceName, CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, PC.MeasureDate), 101)

END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetApplicationHealthData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jayesh Dhobi
-- Create date: 25th August 2011
-- Description:	Getting Health data 
-- =============================================
-- exec [eddsdbo].[GetApplicationHealthData] '2011-09-16 11:39:25.570', '2011-09-16 11:39:25.570' , -150
CREATE PROCEDURE [eddsdbo].[GetApplicationHealthData]
(
	@StartDate	DATETIME = NULL,
	@EndDate	DATETIME = NULL,
	@TimeZoneOffset int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF (@StartDate IS NULL AND @EndDate IS NULL)
		BEGIN
			--SELECT @StartDate = DATEADD(HH, - 23, GETUTCDATE())
			SELECT @StartDate = DATEADD(HH,-23,DATEADD(HOUR, DATEDIFF(HH, 0, DATEADD(MINUTE, @TimeZoneOffset, GETUTCDATE())) ,0))				
			SET @EndDate = @StartDate			
		END
	
	-- Insert statements for procedure here
	 IF (@StartDate = @EndDate)		
		 BEGIN		 
			SELECT
				ROW_NUMBER() OVER(ORDER BY WS.CaseArtifactID, DateRange) AS Id				
				, ISNULL(WS.CaseArtifactID,0) as CaseArtifactID
				, ISNULL(WS.WorkspaceName,'') as WorkspaceName				
				, ISNULL(WS.[DatabaseLocation],'') as [DatabaseLocation]
				, dr.DateRange as MeasureDate
				, ISNULL(PS.UserCount, -1) AS UserCount
				, ISNULL(PS.ErrorCount, -1) AS ErrorCount
				, ISNULL(PS.LRQCount, -1) AS LRQCount
				, ISNULL(PS.AverageLatency,-1) AS AverageLatency
			FROM [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
				CROSS JOIN 
				(
					SELECT DISTINCT 
						w.CaseArtifactID
						, w.WorkspaceName
						, w.[DatabaseLocation]
					FROM eddsdbo.EDDSWorkspace w				
						JOIN eddsdbo.PerformanceSummary PC on PC.CaseArtifactID = w.CaseArtifactID 				
							AND DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate 
							AND DATEADD(MI, @TimeZoneOffset, MeasureDate) < @EndDate + 1
				) as WS
				LEFT JOIN eddsdbo.PerformanceSummary PS
					ON DATEADD(MI, @TimeZoneOffset, DATEADD(HOUR, DATEPART(HOUR,MeasureDate), CONVERT(varchar(10), MeasureDate ,101))) = DATEADD(HOUR, DATEPART(HOUR,dr.DateRange), CONVERT(varchar(10), dr.DateRange,101))				    			  
						AND WS.CaseArtifactID = PS.CaseArtifactID				  
		END
	ELSE
		BEGIN	
			SELECT
				ROW_NUMBER() OVER(ORDER BY WS.CaseArtifactID, DateRange) AS Id								
				, WS.CaseArtifactID as CaseArtifactID
				, WS.WorkspaceName as WorkspaceName						
				, ISNULL(WS.[DatabaseLocation],'') as [DatabaseLocation]
				, dr.DateRange as MeasureDate
				, ISNULL(PS.UserCount, -1) AS UserCount
				, ISNULL(PS.ErrorCount, -1) AS ErrorCount
				, ISNULL(PS.LRQCount, -1) AS LRQCount
				, ISNULL(PS.AverageLatency,-1) AS AverageLatency
			FROM [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
				CROSS JOIN 
				(
					SELECT DISTINCT 
						w.CaseArtifactID
						, w.WorkspaceName
						, w.[DatabaseLocation]
					FROM eddsdbo.EDDSWorkspace w				
						JOIN eddsdbo.PerformanceSummary PS on PS.CaseArtifactID = w.CaseArtifactID 
							AND DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate 
							AND DATEADD(MI, @TimeZoneOffset, MeasureDate) < (@EndDate + 1)
				) as WS
				LEFT JOIN 
				(
					SELECT 
						PS.CaseArtifactID
						, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate))) [MeasureDate]
						, AVG(PS.UserCount) AS UserCount
						, SUM(PS.ErrorCount) AS ErrorCount
						, SUM(PS.LRQCount) AS LRQCount
						, AVG(PS.AverageLatency)  AS AverageLatency
					FROM eddsdbo.PerformanceSummary PS
					WHERE DATEADD(MI, @TimeZoneOffset,MeasureDate) >=  @StartDate 
						AND DATEADD(MI, @TimeZoneOffset,MeasureDate) < (@EndDate + 1)
					GROUP BY PS.CaseArtifactID
						, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate)))
				) as PS on PS.MeasureDate = dr.DateRange 
					AND WS.CaseArtifactID = PS.CaseArtifactID
		END	
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetSQLServerSummaryDataHourly]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[GetSQLServerSummaryDataHourly]
(
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER(ORDER BY [SQLServerSummary].ServerID, 
		DATEADD(MI, @TimeZoneOffset, [SQLServerSummary].MeasureDate)
		) AS Id
		, [SQLServerSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, DATEADD(MI, @TimeZoneOffset, SQLServerSummary.MeasureDate) MeasureDate		
		, SQLServerSummary.SQLPageLifeExpectancy AS SQLPageLifeExpectancy
	FROM eddsdbo.SQLServerSummary AS [SQLServerSummary]
		INNER JOIN eddsdbo.Server AS [Server] ON SQLServerSummary.ServerID = [Server].ServerID
		INNER JOIN eddsdbo.ServerType AS [ServerType] ON [Server].ServerTypeID = [ServerType].ServerTypeID
	WHERE( DATEADD(MI, @TimeZoneOffset, [SQLServerSummary].MeasureDate) >= @StartDate 
	AND DATEADD(MI, @TimeZoneOffset, [SQLServerSummary].MeasureDate) < @EndDate)
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetSQLServerSummaryDataDaily]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[GetSQLServerSummaryDataDaily]
(
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER(ORDER BY [SQLServerSummary].ServerID, [Server].ServerName, [ServerType].ServerTypeName, 
		CONVERT(VARCHAR(10), dateadd(MI, @TimeZoneOffset, [SQLServerSummary].MeasureDate), 101)
		) AS Id
		, [SQLServerSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, CAST( CONVERT(VARCHAR(10), dateadd(MI, @TimeZoneOffset, [SQLServerSummary].MeasureDate), 101) AS DATETIME) AS MeasureDate			
		, AVG( SQLServerSummary.SQLPageLifeExpectancy ) AS SQLPageLifeExpectancy
	FROM eddsdbo.SQLServerSummary AS [SQLServerSummary]
		INNER JOIN eddsdbo.Server AS [Server] ON SQLServerSummary.ServerID = [Server].ServerID
		INNER JOIN eddsdbo.ServerType AS [ServerType] ON [Server].ServerTypeID = [ServerType].ServerTypeID
	WHERE
	( CAST( CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [SQLServerSummary].MeasureDate), 101) AS DATETIME) >= @StartDate 
		AND CAST( CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [SQLServerSummary].MeasureDate), 101) AS DATETIME) < (@EndDate + 1) )
	GROUP BY [SQLServerSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [SQLServerSummary].MeasureDate), 101)
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetSQLServerSummaryData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jayesh Dhobi
-- Create date: 25th August 2011
-- Description:	Getting SQLServerSummary data 
-- =============================================
CREATE PROCEDURE [eddsdbo].[GetSQLServerSummaryData]
(
	@StartDate	DATETIME = NULL,
	@EndDate	DATETIME = NULL,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @DatabaseServerTypeId INT = 3	
	
	IF (@StartDate IS NULL AND @EndDate IS NULL)
	BEGIN
		--SELECT @StartDate = DATEADD(HH, - 23, GETUTCDATE())
		SELECT @StartDate = DATEADD(HH,-23,DATEADD(HOUR, DATEDIFF(HH, 0, DATEADD(MINUTE, @TimeZoneOffset, GETUTCDATE())) ,0))
		SET @EndDate = @StartDate			
	END
	
	 -- Insert statements for procedure here
	 IF (@StartDate = @EndDate)		
		 BEGIN		 
			SELECT
				ROW_NUMBER() OVER(ORDER BY [ServerInfo].ServerID, DateRange) AS Id				
				, [ServerInfo].ServerID
				, [ServerInfo].ServerName
				, [ServerInfo].ServerTypeName
				, dr.DateRange as MeasureDate
				, ISNULL(sss.SQLPageLifeExpectancy, -1) AS SQLPageLifeExpectancy
			from [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
			cross join (
				select distinct s.ServerID, s.ServerName, st.ServerTypeName
				from eddsdbo.Server s
				join eddsdbo.ServerType st on st.ServerTypeID = s.ServerTypeID
				join eddsdbo.SQLServerSummary sss on sss.ServerID = s.ServerID 				
				AND DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate and DATEADD(MI, @TimeZoneOffset, MeasureDate) < @EndDate + 1
			) as [ServerInfo]
			  left join eddsdbo.SQLServerSummary sss
			  on  DATEADD(MI, @TimeZoneOffset, DATEADD(HOUR, DATEPART(HOUR,MeasureDate), CONVERT(varchar(10), MeasureDate ,101))) = DATEADD(HOUR, DATEPART(HOUR,dr.DateRange), CONVERT(varchar(10), dr.DateRange,101))
			  and [ServerInfo].ServerID = sss.ServerID				  
		END
	ELSE
		BEGIN	
			SELECT
				ROW_NUMBER() OVER(ORDER BY [ServerInfo].ServerID, DateRange) AS Id								
				, [ServerInfo].ServerID
				, [ServerInfo].ServerName
				, [ServerInfo].ServerTypeName
				, dr.DateRange as MeasureDate
				, ISNULL(sss.SQLPageLifeExpectancy, -1) AS SQLPageLifeExpectancy								
			from [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
			cross join (
				select distinct s.ServerID, s.ServerName, st.ServerTypeName
				from eddsdbo.Server s
				join eddsdbo.ServerType st on st.ServerTypeID = s.ServerTypeID
				join eddsdbo.SQLServerSummary sss on sss.ServerID = s.ServerID 
				AND DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate and DATEADD(MI, @TimeZoneOffset, MeasureDate) < (@EndDate + 1)
			) as [ServerInfo]
			left join (
				select sss.ServerID, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate))) [MeasureDate],
				 AVG(sss.SQLPageLifeExpectancy) AS SQLPageLifeExpectancy
				from eddsdbo.SQLServerSummary sss
				where DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate and DATEADD(MI, @TimeZoneOffset, MeasureDate) < (@EndDate + 1)
				group by sss.ServerID, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate)))
			) as sss on sss.MeasureDate = dr.DateRange and [ServerInfo].ServerID = sss.ServerID 
		END	
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetServerProcessorSummaryDataHourly]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[GetServerProcessorSummaryDataHourly]
(
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER(ORDER BY [ServerProcessorSummary].ServerID, DATEADD(MI, @TimeZoneOffset, ServerProcessorSummary.MeasureDate)) AS Id
		,convert(integer, convert(varchar, [ServerProcessorSummary].serverID)+convert(varchar,ServerProcessorSummary.CoreNumber)) as ServerCoreId
		, [ServerProcessorSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, DATEADD(MI, @TimeZoneOffset, ServerProcessorSummary.MeasureDate) MeasureDate
		, ServerProcessorSummary.CoreNumber AS CoreNumber
		, ServerProcessorSummary.CPUProcessorTimePct AS CPUProcessorTimePct
	FROM eddsdbo.ServerProcessorSummary AS [ServerProcessorSummary]
		INNER JOIN eddsdbo.Server AS [Server] ON ServerProcessorSummary.ServerID = [Server].ServerID
		INNER JOIN eddsdbo.ServerType AS [ServerType] ON [Server].ServerTypeID = [ServerType].ServerTypeID
	WHERE( DATEADD(MI, @TimeZoneOffset, [ServerProcessorSummary].MeasureDate) >= @StartDate 
		AND DATEADD(MI, @TimeZoneOffset, [ServerProcessorSummary].MeasureDate) < @EndDate)
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetServerProcessorSummaryDataDaily]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[GetServerProcessorSummaryDataDaily]
(
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER(ORDER BY [ServerProcessorSummary].ServerID, [Server].ServerName, [ServerType].ServerTypeName, 		
		  CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerProcessorSummary].MeasureDate), 101) ,ServerProcessorSummary.CoreNumber	
		) AS Id
		,convert(integer, convert(varchar, [ServerProcessorSummary].serverID)+convert(varchar,ServerProcessorSummary.CoreNumber)) as ServerCoreId
		, [ServerProcessorSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, CAST(CONVERT(VARCHAR(10), dateadd(MI, @TimeZoneOffset, [ServerProcessorSummary].MeasureDate), 101) AS DATETIME) AS MeasureDate
		, ServerProcessorSummary.CoreNumber 
		, AVG( ServerProcessorSummary.CPUProcessorTimePct ) AS CPUProcessorTimePct
	FROM eddsdbo.ServerProcessorSummary AS [ServerProcessorSummary]
		INNER JOIN eddsdbo.Server AS [Server] ON ServerProcessorSummary.ServerID = [Server].ServerID
		INNER JOIN eddsdbo.ServerType AS [ServerType] ON [Server].ServerTypeID = [ServerType].ServerTypeID
	WHERE ( CAST( CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerProcessorSummary].MeasureDate), 101) AS DATETIME) >= @StartDate 
		AND CAST( CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerProcessorSummary].MeasureDate), 101) AS DATETIME) < (@EndDate + 1) )
	GROUP BY [ServerProcessorSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		,ServerProcessorSummary.CoreNumber
		,CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerProcessorSummary].MeasureDate), 101)
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetServerProcessorSummaryData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jayesh Dhobi
-- Create date: 25th August 2011
-- Description:	Getting ServerProcessorSummary data 
-- =============================================
-- exec [eddsdbo].[GetServerProcessorSummaryData] '9/22/2011 12:00:00 AM','9/22/2011 12:00:00 AM',0
-- exec [eddsdbo].[GetServerProcessorSummaryData] null, null,0
CREATE PROCEDURE [eddsdbo].[GetServerProcessorSummaryData]
(
	@StartDate	DATETIME = NULL,
	@EndDate	DATETIME = NULL,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	IF (@StartDate IS NULL AND @EndDate IS NULL)
	BEGIN
		-- hourly
		--SELECT @StartDate = DATEADD(HH, - 23, GETUTCDATE())
		SELECT @StartDate = DATEADD(HH,-23,DATEADD(HOUR, DATEDIFF(HH, 0, DATEADD(MINUTE, @TimeZoneOffset, GETUTCDATE())) ,0))
		SET @EndDate = @StartDate		
	END
	
    -- Insert statements for procedure here
     IF (@StartDate = @EndDate)		
		BEGIN
			SELECT
				ROW_NUMBER() OVER(ORDER BY [ServerInfo].ServerID, DateRange) AS Id				
				, [ServerInfo].ServerID * 10 as ServerCoreId
				, [ServerInfo].ServerID
				, [ServerInfo].ServerName
				, [ServerInfo].ServerTypeName
				, dr.DateRange as MeasureDate
				, ISNULL(sps.CPUProcessorTimePct, -1) AS CPUProcessorTimePct
			FROM [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
				CROSS JOIN 
				(
					SELECT DISTINCT 
						s.ServerID
						, sps.CoreNumber
						, s.ServerName
						, st.ServerTypeName
					FROM eddsdbo.Server s
						JOIN eddsdbo.ServerType st on st.ServerTypeID = s.ServerTypeID
						JOIN eddsdbo.ServerProcessorSummary sps on sps.ServerID = s.ServerID 
							AND DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate 
							AND DATEADD(MI, @TimeZoneOffset, MeasureDate) < @EndDate + 1
					WHERE sps.CoreNumber = -1
				) as [ServerInfo]
				LEFT JOIN eddsdbo.ServerProcessorSummary sps
				  on  DATEADD(MI, @TimeZoneOffset,DATEADD(HOUR, DATEPART(HOUR, MeasureDate), CONVERT(varchar(10), MeasureDate ,101))) = DATEADD(HOUR, DATEPART(HOUR,dr.DateRange), CONVERT(varchar(10), dr.DateRange,101))
				  AND [ServerInfo].ServerID = sps.ServerID
				  AND [ServerInfo].CoreNumber = sps.CoreNumber
		END
	ELSE
		BEGIN
			SELECT
				ROW_NUMBER() OVER(ORDER BY [ServerInfo].ServerID, DateRange) AS Id				
				, [ServerInfo].ServerID * 10 as ServerCoreId
				, [ServerInfo].ServerID
				, [ServerInfo].ServerName
				, [ServerInfo].ServerTypeName
				, dr.DateRange as MeasureDate
				, ISNULL(sps.CPUProcessorTimePct, -1) AS CPUProcessorTimePct
			FROM [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
				CROSS JOIN 
				(
					SELECT DISTINCT 
						s.ServerID
						, sps.CoreNumber
						, s.ServerName
						, st.ServerTypeName
					FROM eddsdbo.Server s
						JOIN eddsdbo.ServerType st on st.ServerTypeID = s.ServerTypeID
						JOIN eddsdbo.ServerProcessorSummary sps on sps.ServerID = s.ServerID 
							AND DATEADD(MI, @TimeZoneOffset,MeasureDate) >= @StartDate 
							AND DATEADD(MI, @TimeZoneOffset, MeasureDate) < (@EndDate + 1)
					WHERE sps.CoreNumber = -1
				) as [ServerInfo]
				LEFT JOIN 
				(
					SELECT 
						sps.ServerID
						, sps.CoreNumber
						, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate))) [MeasureDate]
						, AVG(sps.CPUProcessorTimePct) [CPUProcessorTimePct]
					FROM eddsdbo.ServerProcessorSummary sps
					WHERE DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate 
						AND DATEADD(MI, @TimeZoneOffset, MeasureDate) < (@EndDate + 1)
					GROUP BY sps.ServerID
						, sps.CoreNumber
						, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate)))
				) as sps on sps.MeasureDate = dr.DateRange 
					AND [ServerInfo].ServerID = sps.ServerID 
					AND [ServerInfo].CoreNumber = sps.CoreNumber
		END
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetServerDiskSummaryDataHourly]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[GetServerDiskSummaryDataHourly]
(
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER(ORDER BY [ServerDiskSummary].ServerID, 
		 DATEADD(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate)		
		) AS Id
		,convert(integer, convert(varchar, [ServerDiskSummary].ServerID)+convert(varchar,ServerDiskSummary.DiskNumber)) as ServerDiskId
		, [ServerDiskSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, DATEADD(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate) as MeasureDate
		, ServerDiskSummary.DiskNumber AS DiskNumber
		, ServerDiskSummary.DiskAvgSecPerRead AS DiskAvgSecPerRead
		, ServerDiskSummary.DiskAvgSecPerWrite AS DiskAvgSecPerWrite
	FROM eddsdbo.ServerDiskSummary AS [ServerDiskSummary]
		INNER JOIN eddsdbo.Server AS [Server] ON ServerDiskSummary.ServerID = [Server].ServerID
		INNER JOIN eddsdbo.ServerType AS [ServerType] ON [Server].ServerTypeID = [ServerType].ServerTypeID
	WHERE( DATEADD(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate) >= @StartDate 
	AND DATEADD(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate) < @EndDate)
	
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetServerDiskSummaryDataDaily]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[GetServerDiskSummaryDataDaily]
(
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER(ORDER BY [ServerDiskSummary].ServerID, [Server].ServerName, [ServerType].ServerTypeName, 
		CONVERT(VARCHAR(10), dateadd(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate), 101)
		,ServerDiskSummary.DiskNumber) AS Id
		,convert(integer, convert(varchar, [ServerDiskSummary].ServerID)+convert(varchar,ServerDiskSummary.DiskNumber)) as ServerDiskId
		, [ServerDiskSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, CAST( CONVERT(VARCHAR(10), dateadd(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate), 101) AS DATETIME) AS MeasureDate			
		, ServerDiskSummary.DiskNumber 
		, AVG( ServerDiskSummary.DiskAvgSecPerRead ) AS DiskAvgSecPerRead
		, AVG( ServerDiskSummary.DiskAvgSecPerWrite ) AS DiskAvgSecPerWrite
	FROM eddsdbo.ServerDiskSummary AS [ServerDiskSummary]
		INNER JOIN eddsdbo.Server AS [Server] ON ServerDiskSummary.ServerID = [Server].ServerID
		INNER JOIN eddsdbo.ServerType AS [ServerType] ON [Server].ServerTypeID = [ServerType].ServerTypeID
	WHERE
	( CAST( CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate), 101) AS DATETIME) >= @StartDate 
		AND CAST( CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate), 101) AS DATETIME) < (@EndDate + 1) )
	
	GROUP BY [ServerDiskSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, ServerDiskSummary.DiskNumber 
		, CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerDiskSummary].MeasureDate), 101)
	
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetServerDiskSummaryData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Konstantin Kekhaev
-- Create date: 06 October 2011
-- Description:	Getting ServerDiskSummary data 
-- =============================================
-- exec [eddsdbo].[GetServerDiskSummaryData] '2011-09-15','2011-10-04' ,330
CREATE PROCEDURE [eddsdbo].[GetServerDiskSummaryData]
(
	@StartDate	DATETIME = NULL,
	@EndDate	DATETIME = NULL,
	@TimeZoneOffset int 
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	IF (@StartDate IS NULL AND @EndDate IS NULL)
	BEGIN
		-- hourly
		--SELECT @StartDate = DATEADD(HH, - 23, GETUTCDATE())
		SELECT @StartDate = DATEADD(HH,-23,DATEADD(HOUR, DATEDIFF(HH, 0, DATEADD(MINUTE, @TimeZoneOffset, GETUTCDATE())) ,0))				
		SET @EndDate = @StartDate			
	END
	
    -- Insert statements for procedure here
     IF (@StartDate = @EndDate)		
		BEGIN
			SELECT
				ROW_NUMBER() OVER(ORDER BY [ServerInfo].ServerID, DateRange) AS Id				
				, [ServerInfo].ServerID * 10 + [ServerInfo].DiskNumber as ServerDiskId
				, [ServerInfo].ServerID
				, [ServerInfo].ServerName
				, [ServerInfo].ServerTypeName
				, dr.DateRange as MeasureDate
				, [ServerInfo].DiskNumber
				, ISNULL(sds.DiskAvgSecPerRead, -1) AS DiskAvgSecPerRead
				, ISNULL(sds.DiskAvgSecPerWrite, -1) AS DiskAvgSecPerWrite
				from [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
				cross join (
					select distinct s.ServerID, sds.DiskNumber, s.ServerName, st.ServerTypeName
					from eddsdbo.Server s
					join eddsdbo.ServerType st on st.ServerTypeID = s.ServerTypeID
					join eddsdbo.ServerDiskSummary sds on sds.ServerID = s.ServerID 
					AND DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate and DATEADD(MI, @TimeZoneOffset, MeasureDate) < @EndDate + 1
				) as [ServerInfo]
				left join eddsdbo.ServerDiskSummary sds
				  on  DATEADD(MI, @TimeZoneOffset, DATEADD(HOUR, DATEPART(HOUR,MeasureDate), CONVERT(varchar(10), MeasureDate ,101))) = DATEADD(HOUR, DATEPART(HOUR,dr.DateRange), CONVERT(varchar(10), dr.DateRange,101))
				  and [ServerInfo].ServerID = sds.ServerID
				  and [ServerInfo].DiskNumber = sds.DiskNumber
		END
	ELSE
		BEGIN
			SELECT
				ROW_NUMBER() OVER(ORDER BY [ServerInfo].ServerID, DateRange, [ServerInfo].DiskNumber) AS Id				
				, [ServerInfo].ServerID * 10 + [ServerInfo].DiskNumber as ServerDiskId
				, [ServerInfo].ServerID
				, [ServerInfo].ServerName
				, [ServerInfo].ServerTypeName
				, dr.DateRange as MeasureDate
				, [ServerInfo].DiskNumber
				, ISNULL(sds.DiskAvgSecPerRead, -1) AS DiskAvgSecPerRead
				, ISNULL(sds.DiskAvgSecPerWrite, -1) AS DiskAvgSecPerWrite
			from [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
			cross join (
				select distinct s.ServerID, sds.DiskNumber, s.ServerName, st.ServerTypeName
				from eddsdbo.Server s
				join eddsdbo.ServerType st on st.ServerTypeID = s.ServerTypeID
				join eddsdbo.ServerDiskSummary sds on sds.ServerID = s.ServerID 
				AND DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate and DATEADD(MI, @TimeZoneOffset, MeasureDate) < (@EndDate + 1)
			) as [ServerInfo]
			left join (
				select sds.ServerID, sds.DiskNumber, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate))) [MeasureDate],
					   AVG(sds.DiskAvgSecPerRead) [DiskAvgSecPerRead], AVG(sds.DiskAvgSecPerWrite) [DiskAvgSecPerWrite]
				from eddsdbo.ServerDiskSummary sds
				where DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate and DATEADD(MI, @TimeZoneOffset, MeasureDate) < (@EndDate + 1)
				group by sds.ServerID, sds.DiskNumber, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate)))
			) as sds on sds.MeasureDate = dr.DateRange and [ServerInfo].ServerID = sds.ServerID and [ServerInfo].DiskNumber = sds.DiskNumber

		END
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetRAMHealthDataHourly]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[GetRAMHealthDataHourly]
(
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER(ORDER BY [ServerSummary].ServerID, DATEADD(MI, @TimeZoneOffset, [ServerSummary].MeasureDate)) AS Id
		, [ServerSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, DATEADD(MI, @TimeZoneOffset, [ServerSummary].MeasureDate) as MeasureDate
		, ServerSummary.RAMPagesPerSec AS RAMPagesPerSec
		, ServerSummary.RAMPageFaultsPerSec AS RAMPageFaultsPerSec
	FROM eddsdbo.ServerSummary AS [ServerSummary]
		INNER JOIN eddsdbo.Server AS [Server] ON ServerSummary.ServerID = [Server].ServerID
		INNER JOIN eddsdbo.ServerType AS [ServerType] ON [Server].ServerTypeID = [ServerType].ServerTypeID
	WHERE( DATEADD(MI, @TimeZoneOffset, [ServerSummary].MeasureDate) >= @StartDate 
	AND DATEADD(MI, @TimeZoneOffset, [ServerSummary].MeasureDate) < @EndDate)
	
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetRAMHealthDataDaily]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [eddsdbo].[GetRAMHealthDataDaily]
(
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER(ORDER BY [ServerSummary].ServerID, [Server].ServerName, [ServerType].ServerTypeName,  
		CAST(CONVERT(VARCHAR(10), dateadd(MI, @TimeZoneOffset, [ServerSummary].MeasureDate), 101) AS DATETIME)) AS Id
		, [ServerSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, CAST(CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerSummary].MeasureDate), 101) AS DATETIME) AS MeasureDate
		, AVG( ServerSummary.RAMPagesPerSec ) AS RAMPagesPerSec
		, AVG( ServerSummary.RAMPageFaultsPerSec ) AS RAMPageFaultsPerSec
	FROM eddsdbo.ServerSummary AS [ServerSummary]
		INNER JOIN eddsdbo.Server AS [Server] ON ServerSummary.ServerID = [Server].ServerID
		INNER JOIN eddsdbo.ServerType AS [ServerType] ON [Server].ServerTypeID = [ServerType].ServerTypeID
	WHERE( 
		CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerSummary].MeasureDate), 101) >= @StartDate
		AND CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerSummary].MeasureDate), 101) < (@EndDate + 1)
		)
	GROUP BY [ServerSummary].ServerID
		, [Server].ServerName
		, [ServerType].ServerTypeName
		, CONVERT(VARCHAR(10), DATEADD(MI, @TimeZoneOffset, [ServerSummary].MeasureDate), 101)		
	
END
GO
/****** Object:  StoredProcedure [eddsdbo].[GetRAMHealthData]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jayesh Dhobi
-- Create date: 25th August 2011
-- Description:	Getting ServerSummary data 
-- =============================================
-- exec [eddsdbo].[GetRAMHealthData] null, null , -300
-- exec [eddsdbo].[GetRAMHealthData] '2011-09-01', '2011-10-01' , -300
CREATE PROCEDURE [eddsdbo].[GetRAMHealthData]
(
	@StartDate	DATETIME = NULL,
	@EndDate	DATETIME = NULL,
	@TimeZoneOffset INT	-- the difference between local time at the client and GMT (in minutes)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF (@StartDate IS NULL AND @EndDate IS NULL)
	BEGIN
		 SELECT @StartDate = DATEADD(HH,-23,DATEADD(HOUR, DATEDIFF(HH, 0, DATEADD(MINUTE, @TimeZoneOffset, GETUTCDATE())) ,0))		
		 SET @EndDate = @StartDate
	END	
	 --select @StartDate
    -- Insert statements for procedure here
	 IF (@StartDate = @EndDate)		
		 BEGIN		 
			SELECT
				ROW_NUMBER() OVER(ORDER BY [ServerInfo].ServerID, DateRange) AS Id				
				, [ServerInfo].ServerID
				, [ServerInfo].ServerName
				, [ServerInfo].ServerTypeName
				, dr.DateRange as MeasureDate
				, ISNULL(ss.RAMPagesPerSec,-1) as RAMPagesPerSec 
				, ISNULL(ss.RAMPageFaultsPerSec,-1) as RAMPageFaultsPerSec	
			from [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
			cross join (
				select distinct s.ServerID, s.ServerName, st.ServerTypeName
				from eddsdbo.Server s
				join eddsdbo.ServerType st on st.ServerTypeID = s.ServerTypeID
				join eddsdbo.ServerSummary ss on ss.ServerID = s.ServerID 								
				AND DATEADD(MI, @TimeZoneOffset, MeasureDate) >= @StartDate and DATEADD(MI, @TimeZoneOffset, MeasureDate) < @EndDate + 1				
			) as [ServerInfo]
			  left join eddsdbo.ServerSummary ss
			  on  DATEADD(MI, @TimeZoneOffset, DATEADD(HOUR, DATEPART(HOUR,MeasureDate), CONVERT(varchar(10), ss.MeasureDate ,101))) = DATEADD(HOUR, DATEPART(HOUR,dr.DateRange), CONVERT(varchar(10), dr.DateRange,101))				    			  
			  and [ServerInfo].ServerID = ss.ServerID				  
			  
		END
	ELSE
		BEGIN	
			SELECT
				ROW_NUMBER() OVER(ORDER BY [ServerInfo].ServerID, DateRange) AS Id								
				, [ServerInfo].ServerID
				, [ServerInfo].ServerName
				, [ServerInfo].ServerTypeName
				, dr.DateRange as MeasureDate
				, ISNULL(SS.RAMPagesPerSec,-1) AS RAMPagesPerSec
				, ISNULL(SS.RAMPageFaultsPerSec,-1) AS RAMPageFaultsPerSec
			from [eddsdbo].GetDateRange(@StartDate, @EndDate) dr
			cross join (
				select distinct s.ServerID, s.ServerName, st.ServerTypeName
				from eddsdbo.Server s
				join eddsdbo.ServerType st on st.ServerTypeID = s.ServerTypeID
				join eddsdbo.ServerSummary SS on SS.ServerID = s.ServerID 
				AND DATEADD(MI, @TimeZoneOffset,MeasureDate) >=  @StartDate and DATEADD(MI, @TimeZoneOffset,MeasureDate)  < (@EndDate + 1)
			) as [ServerInfo]
			left join (
				select SS.ServerID, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate))) [MeasureDate],
				 AVG(SS.RAMPagesPerSec) AS RAMPagesPerSec , AVG(SS.RAMPageFaultsPerSec) AS RAMPageFaultsPerSec
				from eddsdbo.ServerSummary SS
				where DATEADD(MI, @TimeZoneOffset,MeasureDate) >=  @StartDate and DATEADD(MI, @TimeZoneOffset,MeasureDate)  < (@EndDate + 1)
				group by SS.ServerID, DATEADD(DD, 0, DATEDIFF(DD, 0, DATEADD(MI, @TimeZoneOffset, MeasureDate)))
			) as SS on SS.MeasureDate = dr.DateRange and [ServerInfo].ServerID = SS.ServerID 
		END	
END
GO
/****** Object:  UserDefinedFunction [eddsdbo].[GETLRQHealthQry]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Murali Shesham
-- Create date: 2011-09-12
-- Description:	Returns Query list for LRQs
-- =============================================
CREATE FUNCTION [eddsdbo].[GETLRQHealthQry] 
(	
	@ProcessExecDate DateTime
)
RETURNS 
@LRQHealthQry TABLE 
(
	LRQQry varchar(2000)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set

	Declare @MeasureDate Date
	Declare @MeasureHour Int
	Declare @Frequency varchar(10)
	Select @MeasureDate = Cast(@ProcessExecDate as Date) , @MeasureHour = DatePart(HH,@ProcessExecDate) 
	Select @Frequency= CAST(COALESCE(Frequency,0) as Varchar(10)) From eddsdbo.Measure Where MeasureID = 1

	IF @Frequency != '0' 
	BEGIN
		Insert @LRQHealthQry (LRQQry)
		SELECT	 
			'Insert eddsdbo.LRQCountDW (MeasureDate, MeasureHour,  CaseArtifactID, LRQCount, CreatedOn)
			SELECT ''' + CAST(@MeasureDate as Varchar(50)) + ''' MeasureDate, ' + CAST(@MeasureHour as Varchar(10)) +'  MeasureHour,  ' + CAST(ArtifactID AS Varchar(50))+ ' CaseArtifactID, 
				COUNT(ID) LRQCount, 
				GetUTCDate() as [CreatedOn]
			FROM [' + cast(dblocation as varchar(50)) +'].EDDS' + CAST(ArtifactID AS Varchar(50))+ '.EDDSDBO.AuditRecord WITH (NOLOCK)
			WHERE
				[Action] IN (28, 29) AND
				[ExecutionTime] >= 2000 AND
				[TimeStamp] >= ''' + cast(@ProcessExecDate as varchar(50)) + ''' AND 
				[TimeStamp] < DATEADD(MINUTE, ' + @Frequency + ', ''' + cast(@ProcessExecDate as varchar(50)) + ''');'
		FROM	EDDS.eddsdbo.ExtendedCase WITH (NOLOCK)	
	END
	RETURN 
END
GO
/****** Object:  View [eddsdbo].[CurrentDayPerformanceSummaryByHour]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [eddsdbo].[CurrentDayPerformanceSummaryByHour]
AS
SELECT 
       PC.[CaseArtifactID]
      ,WS.[WorkspaceName]
      ,PC.MeasureDate
      ,SUM([UserCount]) [UserCount]
      ,SUM([ErrorCount]) [ErrorCount]
      ,SUM([LRQCount]) [LRQCount]
      ,AVG([AverageLatency]) [AverageLatency]
  FROM [eddsdbo].[PerformanceSummary] PC
	Inner Join [eddsdbo].EDDSWorkspace WS
	On PC.CaseArtifactID = WS.CaseArtifactID
	Where [MeasureDate] between DATEADD(HH,-24,GETUTCDATE()) and GETUTCDATE()
Group By          PC.[CaseArtifactID]
      ,WS.[WorkspaceName],PC.MeasureDate
GO
/****** Object:  View [eddsdbo].[CurrentDayPerformanceSummary]    Script Date: 10/11/2011 13:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [eddsdbo].[CurrentDayPerformanceSummary]
AS
SELECT 
       PC.[CaseArtifactID]
      ,WS.[WorkspaceName]
      ,SUM([UserCount]) [UserCount]
      ,SUM([ErrorCount]) [ErrorCount]
      ,SUM([LRQCount]) [LRQCount]
      ,AVG([AverageLatency]) [AverageLatency]
  FROM [eddsdbo].[PerformanceSummary] PC
	Inner Join [eddsdbo].EDDSWorkspace WS
	On PC.CaseArtifactID = WS.CaseArtifactID
	Where [MeasureDate] between DATEADD(HH,-24,GETUTCDATE()) and GETUTCDATE()
Group By          PC.[CaseArtifactID]
      ,WS.[WorkspaceName]
GO
/****** Object:  Default [DF_Server_CreatedOn]    Script Date: 10/11/2011 13:32:09 ******/
ALTER TABLE [eddsdbo].[Server] ADD  CONSTRAINT [DF_Server_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_LRQCountDW_CreatedOn]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[LRQCountDW] ADD  CONSTRAINT [DF_LRQCountDW_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_MeasureType_IsActive]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[MeasureType] ADD  CONSTRAINT [DF_MeasureType_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
/****** Object:  Default [DF_MeasureType_IsDeleted]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[MeasureType] ADD  CONSTRAINT [DF_MeasureType_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF_MeasureType_CreatedOn]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[MeasureType] ADD  CONSTRAINT [DF_MeasureType_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_LatencyDW_CreatedOn]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[LatencyDW] ADD  CONSTRAINT [DF_LatencyDW_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ErrorCountDW_CreatedOn]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[ErrorCountDW] ADD  CONSTRAINT [DF_ErrorCountDW_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ServerType_CreatedOn]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[ServerType] ADD  CONSTRAINT [DF_ServerType_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_PerformanceSummary_CreatedOn]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[PerformanceSummary] ADD  CONSTRAINT [DF_PerformanceSummary_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_UserCountDW_CreatedOn]    Script Date: 10/11/2011 13:32:10 ******/
ALTER TABLE [eddsdbo].[UserCountDW] ADD  CONSTRAINT [DF_UserCountDW_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_SQLServerSummary_CreatedOn]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[SQLServerSummary] ADD  CONSTRAINT [DF_SQLServerSummary_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_SQLServerDW_CreatedOn]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[SQLServerDW] ADD  CONSTRAINT [DF_SQLServerDW_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ServerSummary_CreatedOn]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerSummary] ADD  CONSTRAINT [DF_ServerSummary_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ServerProcessorSummary_CreatedOn]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerProcessorSummary] ADD  CONSTRAINT [DF_ServerProcessorSummary_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ServerProcessorDW_CreatedOn]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerProcessorDW] ADD  CONSTRAINT [DF_ServerProcessorDW_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ServerDW_CreatedOn]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerDW] ADD  CONSTRAINT [DF_ServerDW_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ServerDiskSummary_CreatedOn]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerDiskSummary] ADD  CONSTRAINT [DF_ServerDiskSummary_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_ServerDiskDW_CreatedOn]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerDiskDW] ADD  CONSTRAINT [DF_ServerDiskDW_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Measure_IsActive]    Script Date: 10/11/2011 13:32:15 ******/
ALTER TABLE [eddsdbo].[Measure] ADD  CONSTRAINT [DF_Measure_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
/****** Object:  Default [DF_Measure_IsDeleted]    Script Date: 10/11/2011 13:32:15 ******/
ALTER TABLE [eddsdbo].[Measure] ADD  CONSTRAINT [DF_Measure_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF_Measure_CreatedOn]    Script Date: 10/11/2011 13:32:15 ******/
ALTER TABLE [eddsdbo].[Measure] ADD  CONSTRAINT [DF_Measure_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Measure_Frequency]    Script Date: 10/11/2011 13:32:15 ******/
ALTER TABLE [eddsdbo].[Measure] ADD  CONSTRAINT [DF_Measure_Frequency]  DEFAULT ((60)) FOR [Frequency]
GO
/****** Object:  ForeignKey [FK_SQLServerSummary_Server]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[SQLServerSummary]  WITH CHECK ADD  CONSTRAINT [FK_SQLServerSummary_Server] FOREIGN KEY([ServerID])
REFERENCES [eddsdbo].[Server] ([ServerID])
GO
ALTER TABLE [eddsdbo].[SQLServerSummary] CHECK CONSTRAINT [FK_SQLServerSummary_Server]
GO
/****** Object:  ForeignKey [FK_SQLServerDW_Server]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[SQLServerDW]  WITH CHECK ADD  CONSTRAINT [FK_SQLServerDW_Server] FOREIGN KEY([ServerID])
REFERENCES [eddsdbo].[Server] ([ServerID])
GO
ALTER TABLE [eddsdbo].[SQLServerDW] CHECK CONSTRAINT [FK_SQLServerDW_Server]
GO
/****** Object:  ForeignKey [FK_ServerSummary_Server]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerSummary]  WITH CHECK ADD  CONSTRAINT [FK_ServerSummary_Server] FOREIGN KEY([ServerID])
REFERENCES [eddsdbo].[Server] ([ServerID])
GO
ALTER TABLE [eddsdbo].[ServerSummary] CHECK CONSTRAINT [FK_ServerSummary_Server]
GO
/****** Object:  ForeignKey [FK_ServerProcessorSummary_Server]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerProcessorSummary]  WITH CHECK ADD  CONSTRAINT [FK_ServerProcessorSummary_Server] FOREIGN KEY([ServerID])
REFERENCES [eddsdbo].[Server] ([ServerID])
GO
ALTER TABLE [eddsdbo].[ServerProcessorSummary] CHECK CONSTRAINT [FK_ServerProcessorSummary_Server]
GO
/****** Object:  ForeignKey [FK_ServerProcessorDW_Server]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerProcessorDW]  WITH CHECK ADD  CONSTRAINT [FK_ServerProcessorDW_Server] FOREIGN KEY([ServerID])
REFERENCES [eddsdbo].[Server] ([ServerID])
GO
ALTER TABLE [eddsdbo].[ServerProcessorDW] CHECK CONSTRAINT [FK_ServerProcessorDW_Server]
GO
/****** Object:  ForeignKey [FK_ServerDW_Server]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerDW]  WITH CHECK ADD  CONSTRAINT [FK_ServerDW_Server] FOREIGN KEY([ServerID])
REFERENCES [eddsdbo].[Server] ([ServerID])
GO
ALTER TABLE [eddsdbo].[ServerDW] CHECK CONSTRAINT [FK_ServerDW_Server]
GO
/****** Object:  ForeignKey [FK_ServerDiskSummary_Server]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerDiskSummary]  WITH CHECK ADD  CONSTRAINT [FK_ServerDiskSummary_Server] FOREIGN KEY([ServerID])
REFERENCES [eddsdbo].[Server] ([ServerID])
GO
ALTER TABLE [eddsdbo].[ServerDiskSummary] CHECK CONSTRAINT [FK_ServerDiskSummary_Server]
GO
/****** Object:  ForeignKey [FK_ServerDiskDW_Server]    Script Date: 10/11/2011 13:32:13 ******/
ALTER TABLE [eddsdbo].[ServerDiskDW]  WITH CHECK ADD  CONSTRAINT [FK_ServerDiskDW_Server] FOREIGN KEY([ServerID])
REFERENCES [eddsdbo].[Server] ([ServerID])
GO
ALTER TABLE [eddsdbo].[ServerDiskDW] CHECK CONSTRAINT [FK_ServerDiskDW_Server]
GO
/****** Object:  ForeignKey [FK_Measure_MeasureType]    Script Date: 10/11/2011 13:32:15 ******/
ALTER TABLE [eddsdbo].[Measure]  WITH CHECK ADD  CONSTRAINT [FK_Measure_MeasureType] FOREIGN KEY([MeasureTypeId])
REFERENCES [eddsdbo].[MeasureType] ([MeasureTypeId])
GO
ALTER TABLE [eddsdbo].[Measure] CHECK CONSTRAINT [FK_Measure_MeasureType]
GO
