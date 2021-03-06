/********************************************************************************************************
 *
 * INSERT entries into the Case statistics table
 * Pre-configured to insert one entry for the past 90 days
 * Will skip days that already have an entry
 * 
 * Before running the script you must update the caseArtifactIDs and values in the insert statement
 *
 * Written by: Ryan Flint
 * 2013
 ********************************************************************************************************/

 DECLARE @startTime datetime
 DECLARE @endTime datetime

 
 SET @startTime = DATEADD(DD, -90, DATEADD(DD, 0, DATEDIFF(DD, 0, GETDATE())))
 SET @endTime = DATEADD(HH, 23, DATEADD(DD, 0, DATEDIFF(DD, 0, GETDATE())))
 
 
 WHILE @startTime <= @endTime
 BEGIN
	if not exists(SELECT 1 FROM edds.eddsdbo.CaseStatistics 
		WHERE CaseArtifactID = 1015377 and timestamp >= @startTime and timestamp < DATEADD(DAY, 1, @startTime))
		BEGIN
			 INSERT INTO EDDS.eddsdbo.CaseStatistics (
				[CaseArtifactID]
				  ,[timestamp]
				  ,[FileCount]
				  ,[TotalFileSize]
				  ,[MDFFileSize]
				  ,[FullTextDataFileSize]
				  ,[LDFFileSize]
				  ,[EditAuditCount]
				  ,[ViewAuditCount]
				  ,[CreateAuditCount]
				  ,[DeleteAuditCount]
				  ,[ActiveUserCount]
				  ,[ActiveUserNameList]
				  ,[CABuildNativeFileSize]
				  ,[CABuildNativeFileCount]
				  ,[CABuildTotalFileCount]
				  ,[DocumentCount]
				  ,[DateKey]
				  ,[CaseName]
				  )
			VALUES(1015377, @startTime, 73501, 953589531, 544384, 78, 2687488, 0, 0, 76022, 0, 4, 
				'relativity.admin@kcura.com; relativity.serviceaccount@kcura.com; rflint@kcura.com; smoke@kcura.com',
				0, 0, 0, 73501, 201307, 'Salt vs. Pepper (Large)')

		END
		SET @startTime = DATEADD(DAY, 1, @startTime)
END  
 
