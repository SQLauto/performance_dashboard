SELECT COUNT(a.ArtifactID)
FROM [EDDS].[eddsdbo].[Agent] as a WITH(NOLOCK)
inner join [EDDS].[eddsdbo].[AgentType] as at on a.AgentTypeArtifactID = at.ArtifactID
WHERE at.[Guid] in @oldAgentGuid