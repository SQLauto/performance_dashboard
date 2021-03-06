SELECT COUNT(aa.[ArtifactID])
FROM [EDDS].[eddsdbo].[Agent] as aa WITH(NOLOCK)
inner join [EDDS].[eddsdbo].[AgentType] as att on aa.AgentTypeArtifactID = att.ArtifactID
WHERE att.[Guid] in @agentGuids
AND (aa.[Enabled] = 1 and aa.[Updated] = 0)


--declare @unPausedAgents int = 0
--declare @enabledAgents int = 0
--
--
--insert into EDDSPerformance.eddsdbo.[PausedAgents]
--(AgentName, ShouldPause, IsPaused, PausedOn)
--select Name, 1, 0, GETUTCDATE() from [EDDS].[eddsdbo].[Agent] WITH(NOLOCK)
--where name like 'Performance Dashboard - QoS Manager%' and ([Enabled] = 1 and [Updated] = 0) and name not in (select AgentName from EDDSPerformance.eddsdbo.[PausedAgents])
--
--select @unPausedAgents = count(*) from EDDSPerformance.eddsdbo.[PausedAgents] as pa
--where pa.IsPaused = 0
--
--select @enabledAgents = count(*) from [EDDS].[eddsdbo].[Agent] WITH(NOLOCK)
--where name like 'Performance Dashboard - QoS Manager%' and ([Enabled] = 1 and [Updated] = 0) and name not in (select AgentName from EDDSPerformance.eddsdbo.[PausedAgents])
--
--delete from EDDSPerformance.eddsdbo.[PausedAgents]
--where DATEADD(ss, -10, getutcdate()) > PausedOn
--
--select @unPausedAgents + @enabledAgents
--
