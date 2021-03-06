How is Uptime Scored

Uptime score is displayed on the dashboard from QoS_UptimeRatings, which is generated by Hangfire Tasks to Gather and Score the metric data.

In UptimeScoringLogic
> Grab both WebUptime and AgentUptime
> If both are null, assume 100% score
> If Web is null, use AgentUptime
> If Agent is null, use WebUptime
> If both have actual values, use the lowest one.
> IsWebDowntime says the Web is actually up (very confusing atm)

InWebUptimeMetricLogic
> Iterate Through all Web servers and ping them.  If any are down, mark as down.
>> If there was no previous resource host or use https, it will order them (ServerIP HTTP, ServerIP HTTPS, ServerName HTTP, ServerName HTTPS)
>> If all of those fail for one server, it will log a ProcessServer Warning in GlassRunLog
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [GRLogID]
      ,[GlassRunID]
      ,[RunTimeUTC]
      ,[LogTimestampUTC]
      ,[LogIntervalDurationMS]
      ,[RunDurationMS]
      ,[Module]
      ,[TaskCompleted]
      ,[OtherVars]
      ,[NextTask]
      ,[AgentID]
  FROM [EDDSPerformance].[eddsdbo].[QoS_GlassRunLog]
  where TaskCompleted like '%ProcessServer%'
  

Info From Server Table
> Web server type = ServerTypeID == 1
> Check UptimeMonitoringResourceUseHttps and UptimeMonitoringResourceHost

*MetricsData SQL*
SELECT 
	md.[ID]
	,[MetricID]
	,h.HourTimeStamp
	,[Data]
	,md.[Score]
	,mt.Name
--	,mt.ID
FROM  [EDDSPerformance].[eddsdbo].[MetricData] md
JOIN [EDDSPerformance].eddsdbo.Metrics m ON m.ID = md.MetricID
JOIN [EDDSPerformance].eddsdbo.MetricTypes mt ON mt.ID = m.MetricTypeID
JOIN [EDDSPerformance].eddsdbo.[Hours] h on m.HourID = h.ID
--WHERE m.MetricTypeID == 1 -- Agent
--WHERE m.MetricTypeID == 2 -- Web