SELECT TOP 1 [Value] 
FROM [eddsdbo].[Configuration] with(nolock)
WHERE [Section] = @section AND [Name] = @name